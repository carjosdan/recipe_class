import 'package:flutter/material.dart';
import '../styles/app_styles.dart' show AppStyles;

class IconText extends StatelessWidget {
  const IconText({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
       // SizedBox(width: 8.0),
        AppStyles.sectionSpacing,
        Text(text),
      ],
    );
  }
}