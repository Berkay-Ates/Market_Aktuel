import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

var auth = FirebaseAuth.instance;

class ForgottenPasswordScreen extends StatefulWidget {
  const ForgottenPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgottenPasswordScreenState createState() =>
      _ForgottenPasswordScreenState();
}

class _ForgottenPasswordScreenState extends State<ForgottenPasswordScreen> {
  late String email;
  bool showProgress = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showProgress,
      child: Padding(
        padding:MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          child: Container(
            color: Color(0xff747171),
            child: Container(
              padding: const EdgeInsets.only(top: 5.0,bottom: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0)),
              ),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                        width: 40,
                        child: Divider(
                          color: Colors.black26,
                          thickness: 3.5,
                        )),
                    Text(
                      "Şifre sıfırla",
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.only(
                          top: 25.0, bottom: 25.0, left: 30.0, right: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const Text(
                            'Kayıtlı olduğunuz e posta adresinizi aşağıya girerek bu e postaya gelecek olan şifre sıfırlma linki ile şifrenizi sıfırlayabilirsiniz.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 16.0),
                          ),
                          TextField(
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (emailText) {
                              email = emailText;
                            },
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                        ],
                      ),
                    ),
                    MaterialButton(
                      onPressed: () async {
                        setState(() {
                          showProgress = true;
                        });
                        try {
                          auth.sendPasswordResetEmail(email: email);
                          setState(() {
                            showProgress = false;
                          });
                         Navigator.popUntil(context, (route) => route.isFirst);
                        } catch (e) {
                          print(e);
                          setState(() {
                            showProgress = false;
                          });
                        }
                      },
                      child: const Text(
                        'Sıfırlama maili gönder',
                        style: TextStyle(color: Colors.blue, fontSize: 18.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
