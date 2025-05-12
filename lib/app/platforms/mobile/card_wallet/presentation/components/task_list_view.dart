import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/task.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/agent_card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/agent_task_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/delete_task_bottom_sheet.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/components/help_button.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TaskListView extends StatelessWidget {
  final List<TaskModel>? tasks;
  final int? length;

  const TaskListView({super.key, this.tasks, this.length});

  @override
  Widget build(BuildContext context) {
    return tasks?.isEmpty ?? true
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10.h),
                Text(
                  'No Services Found!',
                  style: context.titleMedium,
                ),
                if (length != null)
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.agentNewTask);
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          foregroundColor: const Color(0xFFE51A5E)),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add),
                          SizedBox(width: 4),
                          Text('Add new')
                        ],
                      ),
                    ),
                  )
              ],
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemCount: length ?? tasks?.length ?? 0,
            physics:
                length != null ? const NeverScrollableScrollPhysics() : null,
            itemBuilder: (context, index) => TaskListTile(task: tasks![index]),
          );
  }
}

class TaskListTile extends StatelessWidget {
  final TaskModel task;

  const TaskListTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      background: Container(
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.delete_outline,
              color: Colors.white,
            ),
          ),
        ),
      ),
      confirmDismiss: (direction) async {
        Completer<bool> completer = Completer();
        if (direction == DismissDirection.endToStart) {
          final value = await showModalBottomSheet(
            isDismissible: true,
            enableDrag: true,
            backgroundColor: Colors.transparent,
            constraints: BoxConstraints(maxHeight: 30.h),
            context: context,
            builder: (_) {
              return DeleteTaskBottomSheet(onCancel: () {
                Navigator.pop(context, false);
              }, onDelete: () {
                completer.complete(true);
                Navigator.pop(context, true);
              });
            },
          );
          if (value != true) completer.complete(false);
        } else {
          completer.complete(false);
        }
        return completer.future;
      },
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        sl<AgentTaskBloc>().add(DeleteTaskEvent(task, context));
      },
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: const Color(0xFFF2E8EB),
              borderRadius: BorderRadius.circular(8)),
          child: Image.asset(leadingIcon(), width: 20),
        ),
        title: Text(task.title),
        subtitle: Text(task.desc,
            style:
                context.titleMedium?.copyWith(color: const Color(0xFF964F66))),
        trailing: task.status == 'approved' ||
                task.hushhId == task.registeredByHushhId
            ? Text(DateFormat("dd MMM, yy").format(task.dateTime))
            : AcceptButton(onAccept: () {
                if (task.cardId != null) {
                  sl<AgentCardWalletPageBloc>().add(
                    FetchCardInfoEvent(
                      task.registeredByHushhId,
                      task.cardId!,
                      context,
                      replace: false,
                    ),
                  );
                }
              }),
      ),
    );
  }

  String leadingIcon() {
    switch (task.taskType) {
      case TaskType.phone:
        return "assets/call_icon.png";
      case TaskType.email:
        return "assets/email_icon.png";
      case TaskType.meeting:
        return "assets/meeting_icon.png";
    }
  }
}
