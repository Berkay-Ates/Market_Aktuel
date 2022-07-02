import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_aktuel/enums/enums_main_page.dart';
import 'package:provider/provider.dart';
import '../provider/will_be_required.dart';

class MainPageCategoryItem extends StatelessWidget {
  final String categoryTitle;
  final MainPageCategoryEnum mainPageCategoryEnum;
  final VoidCallback onSelected;

  const MainPageCategoryItem(
      {required this.categoryTitle,
        required this.mainPageCategoryEnum,
        required this.onSelected});

  @override
  Widget build(BuildContext context) {
    if (Provider.of<WillBeRequired>(context).getMainPageCategory() ==
        mainPageCategoryEnum) {
      return GestureDetector(
        onTap: onSelected,
        child: Card(
         color: Colors.white,
          elevation: 0.75,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 0.4,
                color: Colors.pink,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const SizedBox(width: 8.0),
                const FaIcon(
                  FontAwesomeIcons.check,
                  color: Colors.pink,
                  size: 15.0,
                ),
                const SizedBox(width: 8.0),
                Text(
                  categoryTitle,
                  style: const TextStyle(
                    fontSize: 12.0,
                  ),
                ),
                const SizedBox(width: 8.0),
              ],
            ),
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
                SizedBox(width: 20.0),
              ],
            ),
          ),
        ),
      );
    }
  }
}


