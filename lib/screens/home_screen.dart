// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:schedule/screens/schedule_edit_screen.dart';

import '../view_model/login_view_model.dart';
import '../view_model/schedule_delete_view_model.dart';
import '../view_model/schedule_get_view_model.dart';

import '../utility/utility.dart';
import '../view_model/schedule_input_view_model.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({Key? key}) : super(key: key);

  late WidgetRef _ref;

  final Utility _utility = Utility();

  ///
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _ref = ref;

    final loginState = ref.watch(loginProvider);

    final scheduleGetAllState = ref.watch(scheduleGetAllProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        leading: GestureDetector(
          onTap: () async {
            await FirebaseAuth.instance.signOut();

            _ref.watch(loginProvider.notifier).setLoginUid(uid: '');

            Navigator.pop(context);
          },
          child: const Icon(Icons.close),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ref.watch(scheduleGetAllProvider.notifier).getAll();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _utility.getBackGround(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                alignment: Alignment.topRight,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withOpacity(0.3),
                ),
                child: Text('Now: ${DateTime.now().toString().split('.')[0]}'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/input');
                    },
                    icon: const Icon(Icons.input),
                  ),
                  Text(loginState),
                ],
              ),
              const Divider(color: Colors.white),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    final exDate = scheduleGetAllState[index].date.split(' ');

                    final exDate0 = exDate[0].split('-');
                    final year = exDate0[0];
                    final month = exDate0[1];
                    final day = exDate0[2];

                    final exDate1 = exDate[1].split(':');
                    final hour = exDate1[0];
                    final minute = exDate1[1];

                    final exNow = DateTime.now().toString().split(' ');

                    final cardColor = (DateTime.parse(exNow[0])
                            .isAfter(DateTime.parse(exDate[0])))
                        ? Colors.redAccent.withOpacity(0.3)
                        : Colors.black.withOpacity(0.3);

                    return Slidable(
                      endActionPane: ActionPane(
                        extentRatio: 0.4,
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              ref
                                  .watch(selectDateProvider.notifier)
                                  .setSelectDate(
                                    date: scheduleGetAllState[index].date,
                                  );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ScheduleEditScreen(
                                    state: scheduleGetAllState[index],
                                  ),
                                ),
                              );
                            },
                            backgroundColor: const Color(0xFF7BC043),
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'edit',
                          ),
                          SlidableAction(
                            onPressed: (context) {
                              ref
                                  .watch(scheduleDeleteProvider.notifier)
                                  .delete(param: scheduleGetAllState[index]);

                              ref
                                  .watch(scheduleGetAllProvider.notifier)
                                  .getAll();
                            },
                            backgroundColor: const Color(0xFF0392CF),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'delete',
                          ),
                        ],
                      ),
                      child: Card(
                        color: cardColor,
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.only(
                              top: 5,
                              right: 5,
                              left: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.greenAccent.withOpacity(0.3),
                            ),
                            child: DefaultTextStyle(
                              style: const TextStyle(fontSize: 12),
                              child: Column(
                                children: [
                                  Text(year),
                                  Text('$month-$day'),
                                  Text('$hour:$minute'),
                                ],
                              ),
                            ),
                          ),
                          title: DefaultTextStyle(
                            style: const TextStyle(fontSize: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(scheduleGetAllState[index].what),
                                Text(scheduleGetAllState[index].where),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Container(),
                  itemCount: scheduleGetAllState.length,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
