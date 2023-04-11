import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screen/home.dart';

class IndexScreen extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ya!"),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              auth.currentUser!.email!,
              style: const TextStyle(fontSize: 25),
            ),
            ElevatedButton(
              child: const Text("log out?"),
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return const HomeScreen();
                  }));
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
