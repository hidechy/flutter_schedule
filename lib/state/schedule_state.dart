import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_state.freezed.dart';

@freezed
class ScheduleState with _$ScheduleState {
  const factory ScheduleState({
    required String id,
    required String userUid,
    required String date,
    required String year,
    required String month,
    required String day,
    required String hour,
    required String minute,
    required String second,
    required String what,
    required String where,
  }) = _ScheduleState;
}
