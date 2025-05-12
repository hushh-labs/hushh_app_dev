import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable(explicitToJson: true)
class Event {
  int id;
  @JsonKey(name: 'uuid')
  String uuid;
  @JsonKey(name: 'agent_uuid')
  String agentUuid;
  String title;
  DateTime date;
  String description;
  @JsonKey(name: 'end_date')
  DateTime? endDate;

  Event({
    required this.id,
    required this.uuid,
    required this.agentUuid,
    required this.title,
    required this.date,
    required this.description,
    this.endDate,
  });

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);
}
