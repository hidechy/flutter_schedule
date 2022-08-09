// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../view_model/login_view_model.dart';
import '../view_model/schedule_delete_view_model.dart';
import '../view_model/schedule_get_view_model.dart';

import '../utility/utility.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({Key? key}) : super(key: key);

  late WidgetRef _ref;

  Utility _utility = Utility();

  ///
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _ref = ref;

    final loginState = ref.watch(loginProvider);

    final scheduleGetAllState = ref.watch(scheduleGetAllProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule'),
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
                    var exDate = scheduleGetAllState[index].date.split(' ');
                    var exDate1 = exDate[1].split(':');
                    var hour = exDate1[0];
                    var minute = exDate1[1];
                    var dispDate = '${exDate[0]} $hour:$minute';

                    return Slidable(
                      endActionPane: ActionPane(
                        extentRatio: 0.2,
                        motion: const ScrollMotion(),
                        children: [
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
                        color: Colors.black.withOpacity(0.3),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(dispDate),
                              Text(scheduleGetAllState[index].what),
                              Text(scheduleGetAllState[index].where),
                            ],
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
