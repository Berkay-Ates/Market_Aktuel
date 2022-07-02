import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_aktuel/custom%20widgets/common%20func/common_functions.dart';

class CatalogItem extends StatelessWidget {
  final String name;
  final String image;
  final Timestamp startingDate;
  final Timestamp expiringDate;
  final VoidCallback onCatalogTapped;

  CatalogItem(
      {required this.name,
      required this.image,
      required this.startingDate,
      required this.expiringDate,
      required this.onCatalogTapped});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCatalogTapped,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.3,
            color: Color(0xffC1A3A3),
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        padding:
            const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),

        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: NetworkImage(
                    image,
                  ),
                  fit: BoxFit.fill,
                  height: 230,

                ),
                Container(
                  margin: const EdgeInsets.only(top: 6, left: 6, bottom: 3),
                  child: Text(
                    name,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff6d5c5c),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 140,
                      margin: const EdgeInsets.only(left: 6),
                      child: Text(
                        CommonFunctions().catalogLifeCycle(startingDate, expiringDate),
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.fade,
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 4),
                      child: FaIcon(
                        FontAwesomeIcons.solidCircle,
                        color:CommonFunctions().getValidityColor(startingDate, expiringDate),
                        size: 17.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
