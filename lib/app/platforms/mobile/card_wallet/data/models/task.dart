import 'package:hushh_app/app/shared/config/constants/enums.dart';

class TaskModel {
  final String id;
  final String title;
  final String desc;
  final TaskType taskType;
  final DateTime dateTime;
  final String hushhId;
  final String registeredByHushhId;
  final String status;
  final int? cardId;
  final bool isCardSharedWithService;

  TaskModel({
    required this.id,
    required this.title,
    required this.desc,
    required this.taskType,
    required this.dateTime,
    required this.hushhId,
    required this.registeredByHushhId,
    this.status = 'pending',
    this.cardId,
    this.isCardSharedWithService = false,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      status: json['status'],
      desc: json['desc'],
      taskType: _parseTaskType(json['task_type']),
      hushhId: json['hushh_id'],
      dateTime: DateTime.parse(json['date_time']),
      registeredByHushhId: json['registered_by_hushh_id'],
      cardId: json['card_id'],
      isCardSharedWithService: json['is_card_shared_with_service'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'desc': desc,
        'hushh_id': hushhId,
        'registered_by_hushh_id': registeredByHushhId,
        'status': status,
        'task_type':
            taskType.toString().split('.').last, // Convert enum to string
        'date_time': dateTime.toIso8601String(),
        'is_card_shared_with_service': isCardSharedWithService,
        'card_id': cardId
      };

  static TaskType _parseTaskType(String taskTypeString) {
    switch (taskTypeString) {
      case 'phone':
        return TaskType.phone;
      case 'email':
        return TaskType.email;
      case 'meeting':
        return TaskType.meeting;
      default:
        throw ArgumentError('Invalid task type: $taskTypeString');
    }
  }
}
