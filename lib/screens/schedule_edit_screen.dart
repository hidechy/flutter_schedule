// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedule/state/schedule_state.dart';

import '../utility/utility.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../state/schedule_state.dart';

import '../view_model/login_view_model.dart';
import '../view_model/schedule_get_view_model.dart';
import '../view_model/schedule_input_view_model.dart';

import '../view_model/schedule_update_view_model.dart';
import 'home_screen.dart';

class ScheduleEditScreen extends ConsumerWidget {
  ScheduleEditScreen({Key? key, required this.state}) : super(key: key);

  final ScheduleState state;

  final TextEditingController _whereTextController = TextEditingController();
  final TextEditingController _whatTextController = TextEditingController();

  DateTime selectedDateTime = DateTime.now();
  DateTime selectedDateTime2 = DateTime.now();

  final Utility _utility = Utility();

  ///
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginProvider);

    selectedDateTime = DateTime.parse(state.date);

    final selectDateState = ref.watch(selectDateProvider);

    _whatTextController.text = state.what;
    _whereTextController.text = state.where;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Update'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _utility.getBackGround(),
          Column(
            children: [
              Container(
                width: double.infinity,
                height: 300,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              alignment: Alignment.topRight,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.pinkAccent.withOpacity(0.3),
                                ),
                                onPressed: () {
                                  DatePicker.showDateTimePicker(
                                    context,
                                    showTitleActions: true,
                                    onConfirm: (date) {
                                      selectedDateTime2 = date;

                                      ref
                                          .watch(selectDateProvider.notifier)
                                          .setSelectDate(date: date.toString());
                                    },
                                    currentTime: DateTime.parse(state.date),
                                  );
                                },
                                child: const Text('When do you do ?'),
                              ),
                            ),
                            Text(selectDateState),
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 2,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        icon: const Icon(Icons.question_mark),
                        fillColor: Colors.grey.withOpacity(0.3),
                        filled: true,
                        border: const OutlineInputBorder(),
                        hintText: 'What do you do ?',
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 4,
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                      ),
                      controller: _whatTextController,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        icon: const Icon(Icons.map),
                        fillColor: Colors.grey.withOpacity(0.3),
                        filled: true,
                        border: const OutlineInputBorder(),
                        hintText: 'Where do you do ?',
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 4,
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                      ),
                      controller: _whereTextController,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.pinkAccent.withOpacity(0.3),
                        ),
                        onPressed: () {
                          //-------------------------------------------//

                          var exDate = selectedDateTime2.toString().split(' ');
                          var exDate0 = exDate[0].split('-');
                          var exDate1 = exDate[1].split(':');

                          var param = ScheduleState(
                            id: state.id,
                            userUid: loginState,
                            date: selectedDateTime2.toString(),
                            year: exDate0[0],
                            month: exDate0[1],
                            day: exDate0[2],
                            hour: exDate1[0],
                            minute: exDate1[1],
                            second: exDate1[2],
                            what: _whatTextController.text,
                            where: _whereTextController.text,
                          );

                          ref
                              .watch(scheduleUpdateProvider.notifier)
                              .update(param: param);
                          //-------------------------------------------//

                          //-------------------------------------------//
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 3000),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return HomeScreen();
                              },
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                    opacity: animation, child: child);
                              },
                            ),
                          );
                          //-------------------------------------------//

                          ref.watch(scheduleGetAllProvider.notifier).getAll();
                        },
                        child: const Text('input'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
