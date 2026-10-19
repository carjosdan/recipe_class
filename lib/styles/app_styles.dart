import 'package:flutter/material.dart';

class AppStyles {

  static final Color primary = Colors.deepOrange;
  static final Color onPrimary = Colors.white;
  static final Color secondary = Colors.lightGreen;

  static final sectionTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static final Widget sectionSpacing = SizedBox(height: 4.0, width: 4.0,);
  static final Widget sectionSpacingLarge = SizedBox(height: 8.0, width: 8.0,);
  static final Widget sectionSpacingExtraLarge = SizedBox(height: 16.0, width: 16.0,);

}