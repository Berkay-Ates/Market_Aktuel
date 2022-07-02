import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:market_aktuel/custom%20widgets/catalog_item_widget.dart';
import 'package:market_aktuel/enum%20sets/enum_sets.dart';
import 'package:market_aktuel/firebase%20stuff/firebase_my_api.dart';
import 'package:market_aktuel/modals/catalog_modal.dart';
import 'package:market_aktuel/pdf%20widget/pdf%20api/pdf_api.dart';
import 'package:market_aktuel/pdf%20widget/pdf_view_my_implement.dart';
import 'package:market_aktuel/provider/will_be_required.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import '../custom widgets/category_item_widget.dart';
import '../registration stuff/login_screen.dart';

class CategoriesWidget extends StatefulWidget {
  CategoriesWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  List<CatalogModal> catalogLists = [];
  late AdmobInterstitial interstitialAd;

  @override
  void initState() {
    super.initState();
    interstitialAd = AdmobInterstitial(
      adUnitId: getInterstitialAdUnitId()!,
    );
    interstitialAd.load();
  }

  bool isPDFPathReady = false;

  @override
  Widget build(BuildContext buildcntxt) {
    return ModalProgressHUD(
      inAsyncCall: isPDFPathReady,
      child: Container(
        padding: EdgeInsets.only(top: 3.5, left: 4.0, right: 4.0),
        color: Color(0xfff5f5f5),
        child: Column(
          children: [
            SizedBox(
              height: 40.0,
              child: Container(
                padding: EdgeInsets.only(bottom: 3.5),
                color: const Color(0xfff5f5f5),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: EnumSets().categoryEnums.length,
                  itemBuilder: (context, index) {
                    return CategoryItems(
                      categoryTitle: EnumSets().categoryEnumNames[index],
                      categoryEnum: EnumSets().categoryEnums[index],
                      onSelected: () {
                        Provider.of<WillBeRequired>(context, listen: false)
                            .setCategory(EnumSets().categoryEnums[index]);
                      },
                    );
                  },
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseMyApi().getStreamCategoryData(context),
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
                catalogLists.clear();
                var data = snapshot.data?.docs;
                for (var catalog in data! ) {
                  final name = catalog.get('name');
                  final image = catalog.get('image');
                  final expiringDate = catalog.get('expiring date');
                  final staringDate = catalog.get('starting date');
                  final brosurURL = catalog.get('brosur id');
                  CatalogModal currentCatalog = CatalogModal(
                      name: name,
                      image: image,
                      startingDate: staringDate,
                      expiringDate: expiringDate,
                      catalogPdfURL: brosurURL);
                  catalogLists.add(currentCatalog);
                }
                return Expanded(
                  child: StaggeredGridView.countBuilder(
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                    itemCount: catalogLists.length,
                    crossAxisCount: 2,
                    itemBuilder: (context, index) {
                      return CatalogItem(
                        name: catalogLists[index].name!,
                        image: catalogLists[index].image!,
                        startingDate: catalogLists[index].startingDate!,
                        expiringDate: catalogLists[index].expiringDate!,
                        onCatalogTapped: () async {
                          final isLoaded = await interstitialAd.isLoaded;
                          Provider.of<WillBeRequired>(context, listen: false)
                              .setPdfName(catalogLists[index].name!);
                          Provider.of<WillBeRequired>(context, listen: false)
                              .setPdfUrl(catalogLists[index].catalogPdfURL!);
                          if (FirebaseAuth.instance.currentUser != null) {
                            if (isLoaded == true) {
                              interstitialAd.show();
                            }
                            setState(() {
                              isPDFPathReady = true;
                            });
                            await PDFApiMINE()
                                .createFileOfPdfUrl(context)
                                .then((value) {
                              setState(() {
                                isPDFPathReady = false;
                              });
                              Navigator.of(buildcntxt).push(
                                MaterialPageRoute(
                                  builder: (buildContext) =>
                                      PdfViewMyImplementation(path: value.path),
                                ),
                              );
                            });
                          } else {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              enableDrag: true,
                              builder: (context) => LoginScreen(),
                            );
                          }
                        },
                      );
                    },
                    staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    interstitialAd.dispose();
    super.dispose();
  }

  String? getInterstitialAdUnitId() {
    return 'ca-app-pub-7247024202228373/6550670711';
  }
}
