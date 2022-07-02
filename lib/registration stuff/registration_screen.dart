import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

var auth = FirebaseAuth.instance;
var firestore = FirebaseFirestore.instance;

class RegistrationScreen extends StatefulWidget {
  static const id = 'registration_screen';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late String name, email, password;
  bool showSpinner = false;

  void registerUser() async {
    var referance = firestore.collection('zzmembers');
    await referance.doc(email).set({
      'User Name': name,
      'User Email': email,
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          child: Container(
            color: const Color(0xff343327),
            child: Container(
              padding: const EdgeInsets.only(top: 5,bottom: 20),
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
                      "Kayıt ol",
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
                            'İsim-Soyisim',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 17.0),
                          ),
                          TextField(
                            keyboardType: TextInputType.text,
                            onChanged: (nameText) {
                              name = nameText;
                            },
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          const Text(
                            'Email',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 17.0),
                          ),
                          TextField(
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (emailText) {
                              email = emailText;
                            },
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          const Text(
                            'Password',
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 17.0),
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
                          var user = await auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                          if (user != null) {
                            setState(() {
                              showSpinner = false;
                              registerUser();
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
                        'Kayıt ol',
                        style: TextStyle(color: Colors.blue, fontSize: 18.0),
                      ),
                    ),
                    SizedBox(height: 20,),
                    const Text(
                      'Kayıt olarak kullanıcı sözleşmesini kabul etmiş sayılırsınız!',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Color(0xff757575), fontSize: 12.0),
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
