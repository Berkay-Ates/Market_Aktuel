import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DividerItemWidgets extends StatelessWidget {
  const DividerItemWidgets({
    required this.text,
    required this.icon,
    required this.onTapItem,
  });

  final String text;
  final FaIcon icon;
  final VoidCallback onTapItem;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(
        text,
        style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: Color(0xffC1A3A3)),
      ),
      onTap: onTapItem,
    );
  }
}