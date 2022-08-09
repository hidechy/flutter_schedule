import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/schedule_state.dart';

final scheduleDeleteProvider =
    StateNotifierProvider.autoDispose<ScheduleDeleteStateNotifier, int>((ref) {
  return ScheduleDeleteStateNotifier(0);
});

class ScheduleDeleteStateNotifier extends StateNotifier<int> {
  ScheduleDeleteStateNotifier(int state) : super(state);

  void delete({required ScheduleState param}) async {
    return FirebaseFirestore.instance
        .collection('schedules')
        .doc(param.id)
        .delete();
  }
}
