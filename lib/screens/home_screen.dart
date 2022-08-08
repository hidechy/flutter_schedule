// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_model/login_view_model.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({Key? key}) : super(key: key);

  late WidgetRef _ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _ref = ref;

    final loginState = ref.watch(loginProvider);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () async {
            await FirebaseAuth.instance.signOut();

            final loginViewModel = _ref.watch(loginProvider.notifier);
            loginViewModel.setLoginUid(uid: '');

            Navigator.pop(context);
          },
          child: const Icon(Icons.close),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('HomeScreen'),
          Text(loginState),
        ],
      ),
    );
  }
}
