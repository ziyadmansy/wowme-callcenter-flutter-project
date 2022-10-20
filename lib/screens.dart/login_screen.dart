import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wowme/controllers/auth_controller.dart';
import 'package:wowme/shared/constants.dart';
import 'package:wowme/shared/shared_core.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen();
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  bool _isLoading = false;
  bool _isObscure = false;

  void _loginMember() async {
    final isValid = _formKey.currentState?.validate();

    if (isValid ?? false) {
      _formKey.currentState?.save();
      FocusScope.of(context).unfocus();

      try {
        setState(() {
          _isLoading = true;
        });
        final authController = Get.find<AuthController>();

        // Login User to get access token
        await authController.loginUser(email: email, password: password);
      } catch (error) {
        Get.snackbar('Error', 'Check your internet connection then try again');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 32,
                ),
                ClipOval(
                  child: Image.asset(
                    appLogoPath,
                    width: MediaQuery.of(context).size.width / 2,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                SharedCore.buildClickableTextForm(
                  hint: 'test@test.com',
                  label: 'E-mail',
                  inputType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onValidate: (text) {
                    if (text == null || text.isEmpty) {
                      return 'E-mail address missing';
                    } else if (!GetUtils.isEmail(text)) {
                      return 'Enter a valid E-mail address';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (text) {
                    email = text!;
                  },
                ),
                SizedBox(
                  height: 8.0,
                ),
                SharedCore.buildClickableTextForm(
                  hint: 'Password',
                  inputType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  isObscure: _isObscure,
                  onValidate: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Password missing';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (text) {
                    password = text!;
                  },
                ),
                SizedBox(
                  height: 32.0,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: SharedCore.buildRoundedElevatedButton(
                    btnChild: _isLoading
                        ? SharedCore.buildLoaderIndicator()
                        : const Text('Login'),
                    onPress: _isLoading ? null : _loginMember,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
