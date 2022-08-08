import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () async {
            await FirebaseAuth.instance.signOut();

            Navigator.pop(context);
          },
          child: Icon(Icons.close),
        ),
      ),
      body: Column(
        children: [
          Text('HomeScreen'),
        ],
      ),
    );
  }
}
