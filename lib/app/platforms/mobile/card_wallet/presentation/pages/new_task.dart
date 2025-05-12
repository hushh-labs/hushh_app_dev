import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/agent_task_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/agent_text_field.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AgentNewTaskPage extends StatefulWidget {
  const AgentNewTaskPage({super.key});

  @override
  State<AgentNewTaskPage> createState() => _AgentNewTaskPageState();
}

class _AgentNewTaskPageState extends State<AgentNewTaskPage> {
  final controller = sl<AgentTaskBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('New Task'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AgentTextField(
                  title: "Task name",
                  controller: controller.taskNameController,
                  fieldType: CustomFormType.text,
                  hintText: "Name this task"),
              AgentTextField(
                  title: "Description",
                  controller: controller.descriptionController,
                  fieldType: CustomFormType.text,
                  hintText: "Add a description"),
              AgentTextField(
                  title: "Task type",
                  controller: controller.taskTypeController,
                  fieldType: CustomFormType.filter,
                  hintText: "Add a task type"),
              AgentTextField(
                  title: "Deadline",
                  controller: controller.deadlineController,
                  fieldType: CustomFormType.date,
                  hintText: "Choose date and time"),
              AgentTextField(
                title: "Assignee",
                controller: controller.assigneeController,
                fieldType: CustomFormType.text,
                hintText: "Assign to",
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  controller.add(CreateNewTaskEvent(context));
                },
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(100.w, 48),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: const Color(0xFF1C91F2)),
                child: const Text('Create task'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
