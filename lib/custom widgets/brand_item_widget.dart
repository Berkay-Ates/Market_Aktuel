import 'package:flutter/material.dart';

class BrandItemWidget extends StatelessWidget {
  const BrandItemWidget(
      {required this.name, required this.image,required this.onTap});

  final String name;
  final String image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.3,
            color: Color(0xffC1A3A3),
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 25, bottom: 6),
              child: Image(
                height: 45,
                width: 80,
                image: NetworkImage(
                  image,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 0, bottom: 15),
              child: Text(
                name,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
