import 'dart:async';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../custom widgets/drawer_item_widget.dart';
import '../tabbar widgets/brand_page_categories_widget.dart';
import '../tabbar widgets/categories_widget.dart';
import '../tabbar widgets/main_page_categories_widget.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);
  static const id = 'main_view';

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  AdmobBannerSize? bannerSize;
  ConnectivityResult _connectionStatus = ConnectivityResult.wifi;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    setState(() {
      initConnectivity();
    });
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    bannerSize = AdmobBannerSize.FULL_BANNER;
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _connectionStatus == ConnectivityResult.none
        ? Scaffold(
            body: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: FaIcon(
                        FontAwesomeIcons.cat,
                        size: 100,
                        color: Color(0xffC1A3A3),
                      ),
                    ),
                    Text(
                      'internet Bağlantınızı kontrol ediniz!',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Color(0xff757575), fontSize: 14.0),
                    ),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            initConnectivity();
                          });
                        },
                        child: Text('Tekrar dene'))
                  ],
                ),
              ),
            ),
          )
        : DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 45,
                leadingWidth: 40,
                centerTitle: true,
                elevation: 0,
                leading: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: const FaIcon(
                        FontAwesomeIcons.bars,
                        size: 22.0,
                        color: Colors.white,
                      ),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    );
                  },
                ),
                title: const Text(
                  'Market Aktüel',
                  style: TextStyle(color: Color(0xffFBE5E5), fontSize: 21.0),
                ),
                flexibleSpace: Container(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.pink, Color(0xffFF9F45)],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                    ),
                  ),
                ),
                bottom: TabBar(
                  padding: EdgeInsets.zero,
                  indicatorColor: Color(0xffF5F2E7),
                  indicatorWeight: 3.0,
                  tabs: [
                    Tab(text: 'Kategori'),
                    Tab(text: 'Ana Sayfa'),
                    Tab(text: 'Markalar'),
                  ],
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      children: [
                        CategoriesWidget(),
                        MainPageCategoriesWidget(),
                        BrandPageCategoriesWidget(),
                      ],
                    ),
                  ),
                  Container(
                    child: AdmobBanner(
                      adUnitId: getBannerAdUnitId()!,
                      adSize: bannerSize!,
                      onBannerCreated: (AdmobBannerController controller) {},
                    ),
                  ),
                ],
              ),
              drawer: Drawer(
                child: Scrollbar(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DividerItemWidgets(
                        text: 'Uygulamayı Puanla',
                        icon: const FaIcon(
                          FontAwesomeIcons.star,
                          color: Colors.red,
                          size: 20.0,
                        ),
                        onTapItem: () async {
                          await openMyLink('https://play.google.com/store/apps/details?id=com.atesberkay.market_aktuel');
                        },
                      ),
                      DividerItemWidgets(
                        text: 'Bildirim Ayarları',
                        icon: const FaIcon(
                          FontAwesomeIcons.bell,
                          color: Colors.red,
                          size: 20.0,
                        ),
                        onTapItem: () {},
                      ),
                      DividerItemWidgets(
                        text: 'Geri Bildirim',
                        icon: const FaIcon(
                          FontAwesomeIcons.envelope,
                          color: Colors.red,
                          size: 20.0,
                        ),
                        onTapItem: () async{
                          await openMyLink('https://play.google.com/store/apps/details?id=com.atesberkay.market_aktuel');
                        },
                      ),
                      DividerItemWidgets(
                        text: 'Paylaş',
                        icon: const FaIcon(
                          FontAwesomeIcons.shareSquare,
                          color: Colors.red,
                          size: 20.0,
                        ),
                        onTapItem: ()  async{
                          await openMyLink('https://play.google.com/store/apps/details?id=com.atesberkay.market_aktuel');
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Divider(
                          thickness: 0.75,
                          color: Color(0xffC1A3A3),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                            },
                            icon: FaIcon(
                              FontAwesomeIcons.twitter,
                              color: Color(0xffC1A3A3),
                            ),
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          IconButton(
                            onPressed: () {
                            },
                            icon: FaIcon(
                              FontAwesomeIcons.instagram,
                              color: Color(0xffC1A3A3),
                            ),
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          IconButton(
                            onPressed: ()  {},
                            icon: FaIcon(
                              FontAwesomeIcons.facebook,
                              color: Color(0xffC1A3A3),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Future<void> openMyLink(String link) async {
    if (await canLaunch(link)) {
      await launch(
        link,
        enableJavaScript: true,
        forceWebView: true,
        forceSafariVC: true,
      );
    }
  }

  String? getBannerAdUnitId() {
    return 'ca-app-pub-3940256099942544/6300978111';
  }
}
