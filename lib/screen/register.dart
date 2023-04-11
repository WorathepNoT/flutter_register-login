import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/profile.dart';
import 'package:flutter_app/screen/home.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Error"),
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("สร้างบัญชีผู้ใช้"),
              ),
              body: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("e-mail", style: TextStyle(fontSize: 20)),
                        TextFormField(
                          validator: MultiValidator([
                            EmailValidator(errorText: "check e-mail format!"),
                            RequiredValidator(errorText: "e-mail is null!")
                          ]),
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (String? email) {
                            profile.email = email;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text("password", style: TextStyle(fontSize: 20)),
                        TextFormField(
                          validator:
                              RequiredValidator(errorText: "password is null!"),
                          obscureText: true,
                          onSaved: (String? password) {
                            profile.password = password;
                          },
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            child: const Text("submit",
                                style: TextStyle(fontSize: 20)),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState?.save();
                                try {
                                  await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                          email: profile.email!,
                                          password: profile.password!)
                                      .then((value) {
                                    formKey.currentState?.reset();
                                    Fluttertoast.showToast(
                                        msg:
                                            "สร้างบัญชีผู้ใช้งานเรียบร้อยแล้ว!",
                                        gravity: ToastGravity.TOP);
                                    if (mounted) {
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) {
                                        return const HomeScreen();
                                      }));
                                    }
                                  });
                                } on FirebaseAuthException catch (e) {
                                  String message;
                                  if (e.code == 'email-already-in-use') {
                                    message = "email is already in used!";
                                  } else if (e.code == 'weak-password') {
                                    message = "password < 6 length";
                                  } else {
                                    message = e.message!;
                                  }
                                  Fluttertoast.showToast(
                                      msg: message,
                                      gravity: ToastGravity.CENTER);
                                }
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
