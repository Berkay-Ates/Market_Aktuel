import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:market_aktuel/custom%20widgets/main_page_category_item_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import '../custom widgets/catalog_item_widget.dart';
import '../enum sets/enum_sets.dart';
import '../firebase stuff/firebase_my_api.dart';
import '../modals/catalog_modal.dart';
import '../pdf widget/pdf api/pdf_api.dart';
import '../pdf widget/pdf_view_my_implement.dart';
import '../provider/will_be_required.dart';
import '../registration stuff/login_screen.dart';

class MainPageCategoriesWidget extends StatefulWidget {
  const MainPageCategoriesWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<MainPageCategoriesWidget> createState() =>
      _MainPageCategoriesWidgetState();
}

class _MainPageCategoriesWidgetState extends State<MainPageCategoriesWidget> {
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

  GlobalKey _scaffold = GlobalKey();
  bool isPDFPathReady = false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isPDFPathReady,
      child: Scaffold(
        key: _scaffold,
        body: Container(
          padding: const EdgeInsets.only(top: 3.5, left: 4.0, right: 4.0),
          color: const Color(0xfff5f5f5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 40.0,
                child: Container(
                  padding: EdgeInsets.only(bottom: 3.5),
                  color: const Color(0xfff5f5f5),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: EnumSets().mainPageEnums.length,
                    itemBuilder: (context, index) {
                      return MainPageCategoryItem(
                        categoryTitle: EnumSets().mainPageEnumNames[index],
                        mainPageCategoryEnum: EnumSets().mainPageEnums[index],
                        onSelected: () {
                          Provider.of<WillBeRequired>(context, listen: false)
                              .setMainPageCategory(
                                  EnumSets().mainPageEnums[index]);
                        },
                      );
                    },
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseMyApi().getStreamMainCategoryData(context),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                  for (var mainPageCatalog in data) {
                    final name = mainPageCatalog.get('name');
                    final image = mainPageCatalog.get('image');
                    final expiringDate = mainPageCatalog.get('expiring date');
                    final staringDate = mainPageCatalog.get('starting date');
                    final brosurURL = mainPageCatalog.get('brosur id');
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
                            Provider.of<WillBeRequired>(context, listen: false)
                                .setPdfCurrentPage(1);
                            if (FirebaseAuth.instance.currentUser != null) {
                              if (isLoaded == true) {
                                interstitialAd.show();
                              }
                              setState(() {
                                isPDFPathReady = true;
                              });
                              await PDFApiMINE()
                                  .createFileOfPdfUrl(_scaffold.currentContext!)
                                  .then((value) {
                                setState(() {
                                  isPDFPathReady = false;
                                });
                                Navigator.of(_scaffold.currentContext!).push(
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
