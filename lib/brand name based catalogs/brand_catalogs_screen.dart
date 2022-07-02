import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:market_aktuel/firebase%20stuff/firebase_my_api.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import '../custom widgets/catalog_item_widget.dart';
import '../modals/catalog_modal.dart';
import '../pdf widget/pdf api/pdf_api.dart';
import '../pdf widget/pdf_view_my_implement.dart';
import '../provider/will_be_required.dart';
import '../registration stuff/login_screen.dart';

class BrandNameBasedCatalogs extends StatefulWidget {
  BrandNameBasedCatalogs({required this.name});

  final String name;

  @override
  _BrandNameBasedCatalogsState createState() => _BrandNameBasedCatalogsState();
}

class _BrandNameBasedCatalogsState extends State<BrandNameBasedCatalogs> {
  List<CatalogModal> catalogLists = [];
  late AdmobInterstitial interstitialAd;

  @override
  void initState() {
    interstitialAd = AdmobInterstitial(
      adUnitId: getInterstitialAdUnitId()!,
    );
    interstitialAd.load();
    super.initState();
  }

  GlobalKey _scaffold = GlobalKey();
  bool isPDFPathReady = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isPDFPathReady,
      child: Scaffold(
        key: _scaffold,
        backgroundColor: Color(0xfff5f5f5),
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Color(0xfff5f5f5),
          foregroundColor: Colors.pink,
          centerTitle: true,
          title: Text(
            widget.name == '' ? 'Market Aktüel' : widget.name,
            style: TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 8, right: 6, left: 6),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseMyApi()
                    .getStreamBrandCatalogData(context, widget.name),
                builder:
                    (context,snapshot) {
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
                  for (var brandNameCat in data!) {
                    final name = brandNameCat.get('name');
                    final image = brandNameCat.get('image');
                    final expiringDate =
                    brandNameCat.get('expiring date');
                    final staringDate =
                    brandNameCat.get('starting date');
                    final brosurURL = brandNameCat.get('brosur id');
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
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
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
                                        PdfViewMyImplementation(
                                            path: value.path),
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
                      staggeredTileBuilder: (index) =>
                          const StaggeredTile.fit(1),
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
