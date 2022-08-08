import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginProvider =
    StateNotifierProvider.autoDispose<LoginStateNotifier, String>((ref) {
  return LoginStateNotifier('');
});

class LoginStateNotifier extends StateNotifier<String> {
  LoginStateNotifier(String state) : super(state);

  ///
  void setLoginUid({required String uid}) {
    state = uid;
  }
}
