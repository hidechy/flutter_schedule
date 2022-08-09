import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/schedule_state.dart';

final scheduleUpdateProvider =
    StateNotifierProvider.autoDispose<ScheduleUpdateStateNotifier, int>((ref) {
  return ScheduleUpdateStateNotifier(0);
});

class ScheduleUpdateStateNotifier extends StateNotifier<int> {
  ScheduleUpdateStateNotifier(int state) : super(state);

  void update({required ScheduleState param}) async {
    await FirebaseFirestore.instance
        .collection('schedules')
        .doc(param.id)
        .update({
      'userUid': param.userUid,
      'date': param.date,
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
