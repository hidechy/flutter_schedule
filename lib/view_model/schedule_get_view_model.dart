import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/schedule_state.dart';

final scheduleGetAllProvider = StateNotifierProvider.autoDispose<
    ScheduleGetAllStateNotifier, List<ScheduleState>>((ref) {
  return ScheduleGetAllStateNotifier([])..getAll();
});

class ScheduleGetAllStateNotifier extends StateNotifier<List<ScheduleState>> {
  ScheduleGetAllStateNotifier(List<ScheduleState> state) : super(state);

  void getAll() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('schedules')
        .orderBy('date')
        .get();

    final List<ScheduleState> list =
        snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

      return ScheduleState(
        userUid: data['userUid'],
        date: data['date'],
        year: data['year'],
        month: data['month'],
        day: data['day'],
        hour: data['hour'],
        minute: data['minute'],
        second: data['second'],
        what: data['what'],
        where: data['where'],
      );
    }).toList();

    state = list;
  }
}
