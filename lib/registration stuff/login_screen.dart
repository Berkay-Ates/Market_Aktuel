import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:market_aktuel/registration%20stuff/registration_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'forgotten_password.dart';

var auth = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email, password;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          child: Container(
            color: const Color(0xff747171),
            child: Container(
              padding: const EdgeInsets.only(top: 5, bottom: 20),
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
                      "Giriş yap",
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 20.0, bottom: 15.0, left: 30.0, right: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const Text(
                            'Email',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 17.0,
                              color: Colors.black87,
                            ),
                          ),
                          TextField(
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (mailText) {
                              email = mailText;
                            },
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          const Text(
                            'Password',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 17.0,
                              color: Colors.black87,
                            ),
                          ),
                          TextField(
                            obscureText: true,
                            onChanged: (passwordText) {
                              password = passwordText;
                            },
                          ),
                        ],
                      ),
                    ),
                    MaterialButton(
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          var user = await auth.signInWithEmailAndPassword(
                              email: email, password: password);
                          if (user != null) {
                            setState(() {
                              showSpinner = false;
                            });
                            Navigator.popUntil(context, (route) => route.isFirst);
                          }
                        } catch (e) {
                          print(e);
                          setState(() {
                            showSpinner = false;
                          });
                        }
                      },
                      child: const Text(
                        'Giriş yap',
                        style: TextStyle(color: Colors.blue, fontSize: 18.0),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              enableDrag: true,
                              builder: (context) => RegistrationScreen(),
                            );
                          },
                          child: const Text(
                            'Hesabım yok ',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text('/',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold)),
                        MaterialButton(
                          onPressed: () {
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              enableDrag: true,
                              builder: (context) => ForgottenPasswordScreen(),
                            );
                          },
                          child: const Text(
                            ' Şifremi unuttum',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Broşürlere ulaşmak için giriş yapmalısınız!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xff757575),
                        fontSize: 12.0,
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
