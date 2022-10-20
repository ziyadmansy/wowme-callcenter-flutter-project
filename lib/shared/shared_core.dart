import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wowme/controllers/auth_controller.dart';
import 'package:wowme/shared/constants.dart';

class SharedCore {
  static Rx<String> getAccessToken() {
    final accessToken = Get.find<AuthController>().accessToken;
    print('Access Token: ${accessToken.value}');
    return accessToken;
  }

  static Widget buildLoaderIndicator() {
    return const CircularProgressIndicator.adaptive();
  }

  static Widget networkImageError(context, e, st) {
    return Center(
      child: Icon(Icons.error),
    );
  }

  static AppBar buildAppBar({
    required String title,
  }) {
    return AppBar(
      title: Text(title),
    );
  }

  static Widget buildRoundedOutlinedButton({
    required String btnText,
    required VoidCallback onPress,
    bool isEnabled = true,
    Color? btnColor,
  }) =>
      SizedBox(
        height: 48,
        child: OutlinedButton(
          child: Text(btnText),
          style: ElevatedButton.styleFrom(
            foregroundColor: btnColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kBorderRadius),
            ),
          ),
          onPressed: isEnabled ? onPress : null,
        ),
      );

  static Widget buildTextButton({
    required String btnText,
    required VoidCallback onPress,
    bool isEnabled = true,
    Color? btnColor,
  }) =>
      SizedBox(
        height: 40,
        child: TextButton(
          child: Text(btnText),
          style: ElevatedButton.styleFrom(
            backgroundColor: btnColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kBorderRadius),
            ),
          ),
          onPressed: isEnabled ? onPress : null,
        ),
      );

  static Widget buildRoundedElevatedButton({
    required Widget btnChild,
    required VoidCallback? onPress,
    Color? btnColor,
    bool isEnabled = true,
  }) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        child: btnChild,
        style: ElevatedButton.styleFrom(
          backgroundColor: btnColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
        ),
        onPressed: isEnabled ? onPress : null,
      ),
    );
  }

  static Widget buildRoundedIconElevatedButton({
    required String btnText,
    required IconData icon,
    required VoidCallback? onPress,
    Color? btnColor,
    bool isEnabled = true,
  }) {
    return SizedBox(
      height: 48,
      child: ElevatedButton.icon(
        label: Text(btnText),
        style: ElevatedButton.styleFrom(
          backgroundColor: btnColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
        ),
        onPressed: isEnabled ? onPress : null,
        icon: Icon(icon),
      ),
    );
  }

  static Widget buildClickableTextForm({
    TextEditingController? controller,
    VoidCallback? onClick,
    String? Function(String? val)? onValidate,
    Function(String? val)? onSaved,
    Function(String? val)? onSubmitted,
    void Function(String? val)? onChanged,
    String? hint,
    String? label,
    bool isIgnoringTextInput = false,
    bool isEnabled = true,
    bool isObscure = false,
    String? initialText,
    TextInputType? inputType,
    TextInputAction? textInputAction,
    Widget? prefix,
    Widget? prefixIcon,
    Widget? suffix,
    Widget? suffixIcon,
    FocusNode? focusNode,
    AutovalidateMode validateMode = AutovalidateMode.disabled,
    int maxLines = 1,
    int? minLines,
  }) {
    return InkWell(
      onTap: onClick,
      borderRadius: BorderRadius.circular(4),
      child: IgnorePointer(
        ignoring: isIgnoringTextInput,
        child: TextFormField(
          controller: controller,
          initialValue: initialText,
          validator: onValidate,
          enabled: isEnabled,
          onChanged: onChanged,
          decoration: InputDecoration(
            enabledBorder: kEnabledBorder,
            focusedBorder: kFocusedBorder,
            disabledBorder: kDisabledBorder,
            errorBorder: kErrorBorder,
            hintText: hint,
            labelText: label ?? hint,
            prefix: prefix,
            suffix: suffix,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
          ),
          obscureText: isObscure,
          focusNode: focusNode,
          autovalidateMode: validateMode,
          keyboardType: inputType,
          textInputAction: textInputAction,
          onSaved: onSaved,
          onFieldSubmitted: onSubmitted,
          maxLines: maxLines,
          minLines: minLines,
        ),
      ),
    );
  }
}
