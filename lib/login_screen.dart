// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'view_model/login_view_model.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({Key? key}) : super(key: key);

  TextEditingController emailController = TextEditingController(
    text: 'hide.toyoda@gmail.com',
  );
  TextEditingController passwordController = TextEditingController(
    text: 'hidechy4819',
  );

  late BuildContext _context;
  late WidgetRef _ref;

  ///
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _context = context;
    _ref = ref;

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(hintText: 'enter email'),
              onChanged: (text) {},
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(hintText: 'enter password'),
              onChanged: (text) {},
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                login();
              },
              child: const Text('LOGIN'),
            ),
          ],
        ),
      ),
    );
  }

  ///
  void login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (FirebaseAuth.instance.currentUser != null) {
        _ref
            .watch(loginProvider.notifier)
            .setLoginUid(uid: FirebaseAuth.instance.currentUser!.uid);

        Navigator.pushNamed(_context, '/home');
      }
    } catch (e) {
//      print(e);
    }
  }
}
