import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../enums/enums_category.dart';
import '../provider/will_be_required.dart';

class CategoryItems extends StatelessWidget {

  final String categoryTitle;
  final CategoryEnum categoryEnum;
  final VoidCallback onSelected;

  const CategoryItems(
      {required this.categoryTitle,
        required this.categoryEnum,
        required this.onSelected});

  @override
  Widget build(BuildContext context) {
    if (Provider.of<WillBeRequired>(context).getCategory() == categoryEnum) {
      return GestureDetector(
        onTap: onSelected,
        child: Card(
          elevation: 0.75,
          color: Colors.pink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const SizedBox(width: 8.0),
              const FaIcon(
                FontAwesomeIcons.check,
                color: Colors.white,
                size: 15.0,
              ),
              const SizedBox(width: 8.0),
              Text(
                categoryTitle,
                style: const TextStyle(
                  color: Color(0xffFBE5E5),
                  fontSize: 12.0,
                ),
              ),
              const SizedBox(width: 8.0),
            ],
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: onSelected,
        child: Card(
          color: Colors.white,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 0.4,
                color: Color(0xffC1A3A3),
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const SizedBox(width: 20.0),
                Text(
                  categoryTitle,
                  style: const TextStyle(fontSize: 12.0),
                ),
                const SizedBox(width: 20.0),
              ],
            ),
          ),
        ),
      );
    }
  }
}