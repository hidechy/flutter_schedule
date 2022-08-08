import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/schedule_input_state.dart';

///////////////////////////////////////////////////////////////

final selectDateProvider =
    StateNotifierProvider.autoDispose<SelectDateStateNotifier, String>((ref) {
  return SelectDateStateNotifier('');
});

class SelectDateStateNotifier extends StateNotifier<String> {
  SelectDateStateNotifier(String state) : super(state);

  ///
  void setSelectDate({required String date}) {
    state = date;
  }
}

///////////////////////////////////////////////////////////////

final scheduleInputProvider =
    StateNotifierProvider.autoDispose<ScheduleInputStateNotifier, int>((ref) {
  return ScheduleInputStateNotifier(0);
});

class ScheduleInputStateNotifier extends StateNotifier<int> {
  ScheduleInputStateNotifier(int state) : super(state);

  void input({required ScheduleInputState param}) async {
    await FirebaseFirestore.instance.collection('schedules').add({
      'userUid': param.userUid,
      'year': param.year,
      'month': param.month,
      'day': param.day,
      'hour': param.hour,
      'minute': param.minute,
      'second': param.second,
      'what': param.what,
      'where': param.where,
    });
  }
}
