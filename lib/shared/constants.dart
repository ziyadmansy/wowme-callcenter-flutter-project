import 'package:flutter/material.dart';

const double kBorderRadius = 12.0;
const double kSearchFieldBorderRadius = 24.0;
const double kCardElevation = 8.0;

const String playStoreAppUrl = '';
const String privacyPolicyUrl = '';

const String androidOSText = 'Android';
const String iosOSText = 'IOS';

const String errorMsg = 'Something went wrong, please try again';

const String accessTokenPrefsKey = 'accessTokenPrefs';

Color mainColor = Colors.lightBlue[900]!;
Color redColor = Colors.red[600]!;
Color greenColor = Colors.greenAccent[700]!;

const String appLogoPath = 'assets/imgs/logo.jpeg';

const int unauthenticatedStatusCode = 422;

final kEnabledBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(4),
  borderSide: const BorderSide(
    width: 1,
    color: Colors.grey,
  ),
);

final kDisabledBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(4),
  borderSide: BorderSide(
    width: 1,
    color: Colors.grey.shade300,
  ),
);

final kFocusedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(4),
  borderSide: BorderSide(
    width: 2,
    color: mainColor,
  ),
);

final kErrorBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(4),
  borderSide: BorderSide(
    width: 1,
    color: redColor,
  ),
);
