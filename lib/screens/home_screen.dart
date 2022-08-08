// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_model/login_view_model.dart';
import '../view_model/schedule_get_view_model.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({Key? key}) : super(key: key);

  late WidgetRef _ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _ref = ref;

    final loginState = ref.watch(loginProvider);

    final scheduleGetAllState = ref.watch(scheduleGetAllProvider);

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
        children: [
          Text(loginState),
          GestureDetector(
            onTap: () {
              final scheduleGetAllViewModel =
                  ref.watch(scheduleGetAllProvider.notifier);
              scheduleGetAllViewModel.getAll();
            },
            child: const Icon(Icons.refresh),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/input');
            },
            child: const Text('input'),
          ),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                return Text(scheduleGetAllState[index].date);
              },
              separatorBuilder: (context, index) => Container(),
              itemCount: scheduleGetAllState.length,
            ),
          ),
        ],
      ),
    );
  }
}
