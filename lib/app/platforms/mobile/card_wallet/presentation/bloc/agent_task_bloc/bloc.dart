import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/task.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/delete_task_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/fetch_tasks_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/insert_task_use_case.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';

part 'events.dart';

part 'states.dart';

class AgentTaskBloc extends Bloc<AgentTaskEvent, AgentTaskState> {
  final InsertTaskUseCase insertTaskUseCase;
  final FetchTasksUseCase fetchTasksUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;

  AgentTaskBloc(
    this.insertTaskUseCase,
    this.fetchTasksUseCase,
    this.deleteTaskUseCase,
  ) : super(AgentTaskInitialState()) {
    on<FetchTasksEvent>(fetchTasksEvent);
    on<CreateNewTaskEvent>(createNewTaskEvent);
    on<DeleteTaskEvent>(deleteTaskEvent);
    on<UpdateTaskTypeEvent>(updateTaskTypeEvent);
    on<SelectDateAndTimeEvent>(selectDateAndTimeEvent);
    on<UpdateDateEvent>(updateDateEvent);
  }

  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController taskTypeController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController assigneeController = TextEditingController();
  late DateTime taskDate;

  List<TaskModel>? tasks;

  FutureOr<void> createNewTaskEvent(
      CreateNewTaskEvent event, Emitter<AgentTaskState> emit) async {
    showToast(String message) {
      ToastManager(Toast(title: message, type: ToastificationType.error))
          .show(event.context);
    }

    emit(CreateTaskState());

    final String taskName = taskNameController.text;
    final String description = descriptionController.text;
    final String taskDateString = deadlineController.text;
    final String assignedTo = assigneeController.text;
    final String taskType = taskTypeController.text.toLowerCase();

    if (taskName.isEmpty) {
      emit(CreateTaskErrorState());
      showToast("Please enter your task name");
      return;
    }
    if (description.isEmpty) {
      emit(CreateTaskErrorState());
      showToast("Please enter your description");
      return;
    }
    if (taskDateString.isEmpty) {
      emit(CreateTaskErrorState());
      showToast("Please enter your task date");
      return;
    }
    if (assignedTo.isEmpty) {
      emit(CreateTaskErrorState());
      showToast("Please enter assignee name");
      return;
    }
    if (taskType.isEmpty) {
      emit(CreateTaskErrorState());
      showToast("Please enter task type");
      return;
    }
    final task = TaskModel(
      id: const Uuid().v4(),
      hushhId: AppLocalStorage.hushhId!,
      title: taskName,
      desc: description,
      registeredByHushhId: AppLocalStorage.hushhId!,
      status: 'approved',
      taskType: TaskType.values.firstWhere(
        (e) => e.toString().split('.').last == taskType,
      ),
      dateTime: taskDate,
    );
    final result = await insertTaskUseCase(task: task);
    result.fold((l) => null, (r) {
      taskNameController.clear();
      descriptionController.clear();
      deadlineController.clear();
      assigneeController.clear();
      add(FetchTasksEvent());
      ToastManager(Toast(
              title: "Task created successfully",
              type: ToastificationType.success))
          .show(event.context);
      Navigator.pop(event.context);
    });
  }

  FutureOr<void> fetchTasksEvent(
      FetchTasksEvent event, Emitter<AgentTaskState> emit) async {
    if(AppLocalStorage.hushhId == null) {
      return;
    }
    emit(FetchingTasksState());
    final result = await fetchTasksUseCase(uid: AppLocalStorage.hushhId!);
    result.fold((l) => null, (r) {
      tasks = r;
      emit(FetchedTaskState());
    });
  }

  FutureOr<void> deleteTaskEvent(
      DeleteTaskEvent event, Emitter<AgentTaskState> emit) async {
    try {
      final result = await deleteTaskUseCase(task: event.task);
      result.fold((l) => null, (r) {
        tasks?.removeWhere((element) => element.id == event.task.id);
        emit(TaskUpdatedState());
        ToastManager(Toast(
          title: 'Task removed successfully!.',
          type: ToastificationType.success,
        )).show(event.context);
      });
    } catch (e) {
      print("Error deleting document: $e");
    }
  }

  FutureOr<void> updateTaskTypeEvent(
      UpdateTaskTypeEvent event, Emitter<AgentTaskState> emit) {
    emit(SelectTaskTypeState());
    List taskList = ['Phone', 'Email', 'Meeting'];
    showModalBottomSheet(
        context: event.context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                color: const Color(0xffFBFBFB),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20))),
                      onTap: () {
                        taskTypeController.text = taskList[0];
                        Navigator.pop(context);
                      },
                      title: Center(
                          child: Text(
                        taskList[0],
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff454567)),
                      )),
                    ),
                    const Divider(
                      // thickness: 0.0,
                      height: 0,
                    ),
                    ListTile(
                      onTap: () {
                        taskTypeController.text = taskList[1];
                        Navigator.pop(context);
                      },
                      title: Center(
                          child: Text(
                        taskList[1],
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff454567)),
                      )),
                    ),
                    const Divider(
                      // thickness: 0.0,
                      height: 0,
                    ),
                    ListTile(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(20))),
                      onTap: () {
                        taskTypeController.text = taskList[2];
                        Navigator.pop(context);
                      },
                      title: Center(
                          child: Text(
                        taskList[2],
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff454567)),
                      )),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 33.83,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C91F2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const Center(
                      child: Text(
                    "Cancel",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xffFFFFFF)),
                  )),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 23.88,
              ),
              // Container(
              //   padding: EdgeInsets.only(
              //     bottom: MediaQuery.of(context).padding.bottom
              //   ),
              // )
            ],
          );
        });
  }

  FutureOr<void> selectDateAndTimeEvent(
      SelectDateAndTimeEvent event, Emitter<AgentTaskState> emit) {
    showDatePicker(
            context: event.context,
            builder: (BuildContext context, Widget? child) => Theme(
                data: ThemeData(
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white, // button text color
                      ),
                    ),
                    colorScheme: const ColorScheme.dark(
                        onSurface: Colors.white, primary: Colors.grey),
                    datePickerTheme: const DatePickerThemeData(
                      headerBackgroundColor: Colors.black87,
                      backgroundColor: Colors.black87,
                      headerHeadlineStyle: TextStyle(color: Colors.white),
                      headerHelpStyle: TextStyle(color: Colors.white),
                      dayStyle: TextStyle(color: Colors.white),
                      weekdayStyle: TextStyle(color: Colors.white),
                      yearStyle: TextStyle(color: Colors.white),
                      surfaceTintColor: Colors.white,
                      dayForegroundColor:
                          MaterialStatePropertyAll(Colors.white),
                    )),
                child: child!),
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 30)))
        .then((selectedDate) {
      if (selectedDate == null) return null;
      add(UpdateDateEvent(selectedDate));
    });
  }

  FutureOr<void> updateDateEvent(
      UpdateDateEvent event, Emitter<AgentTaskState> emit) {
    taskDate = event.dateTime;
    deadlineController.text = DateFormat('dd/MM/yyyy').format(event.dateTime);
  }
}
