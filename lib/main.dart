// @dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:market_aktuel/provider/will_be_required.dart';
import 'package:market_aktuel/view%20stuff/main_view.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:admob_flutter/admob_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Admob.initialize();
  OneSignal.shared.setAppId('0ba4b949-2bba-4660-b5c0-04537fa34422');
  runApp(
    ChangeNotifierProvider(
      create: (context) => WillBeRequired(),
      child: MarketAktuel(),
    ),
  );
}

class MarketAktuel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  MainView(),
      routes: {
        MainView.id: (context) => const MainView(),

      },
    );
  }
}