import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:market_aktuel/brand%20name%20based%20catalogs/brand_catalogs_screen.dart';
import 'package:market_aktuel/custom%20widgets/brand_item_widget.dart';
import 'package:market_aktuel/modals/brand_modal.dart';
import '../firebase stuff/firebase_my_api.dart';

class BrandPageCategoriesWidget extends StatefulWidget {
  const BrandPageCategoriesWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<BrandPageCategoriesWidget> createState() =>
      _BrandPageCategoriesWidgetState();
}

class _BrandPageCategoriesWidgetState extends State<BrandPageCategoriesWidget> {
  String selectedBrandCategory = 'populer_markalar';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 3.5, left: 25.0, right: 25.0),
      color: const Color(0xfff5f5f5),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedBrandCategory = 'populer_markalar';
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedBrandCategory == 'populer_markalar'
                          ? Colors.pink
                          : Color(0xffE0E0E0),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    height: 50,
                    child: Center(
                      child: Text(
                        'Popüler Markalar',
                        style: TextStyle(
                          color: selectedBrandCategory == 'populer_markalar'
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedBrandCategory = 'tum_markalar';
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedBrandCategory == 'tum_markalar'
                            ? Colors.pink
                            : Color(0xffE0E0E0),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      height: 50,
                      child: Center(
                        child: Text(
                          'Tüm Markalar',
                          style: TextStyle(
                            color: selectedBrandCategory == 'tum_markalar'
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          BrandStreamWidget(collectionName: selectedBrandCategory),
        ],
      ),
    );
  }
}

class BrandStreamWidget extends StatefulWidget {
  final String collectionName;

  BrandStreamWidget({required this.collectionName});

  @override
  State<BrandStreamWidget> createState() => _BrandStreamWidgetState();
}

class _BrandStreamWidgetState extends State<BrandStreamWidget> {
  List<BrandModal> brandLists = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseMyApi().getStreamBrandData(context, widget.collectionName),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return const Expanded(
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            ),
          );
        }

        brandLists.clear();
        var data = snapshot.data?.docs;
        for (var brand in data!) {
          final name = brand.get('marka id');
          final image = brand.get('image');

          BrandModal currentBrand = BrandModal(
            name: name,
            image: image,
          );
          brandLists.add(currentBrand);
        }
        //#F0F3F5
        return Expanded(
          child: StaggeredGridView.countBuilder(
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            itemCount: brandLists.length,
            crossAxisCount: 2,
            itemBuilder: (context, index) {
              return BrandItemWidget(
                name: brandLists[index].name!,
                image: brandLists[index].image!,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (buildContext) =>
                          BrandNameBasedCatalogs(name: brandLists[index].name!),
                    ),
                  );
                },
              );
            },
            staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
          ),
        );
      },
    );
  }
}
