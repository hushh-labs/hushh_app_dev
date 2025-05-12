import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meeting_model.g.dart';

@JsonSerializable()
class MeetingModel {
  final String id;
  final String title;
  final String desc;
  final DateTime dateTime;
  final Duration? duration;
  final double? lat;
  final double? long;
  final String organizerId;
  final List<String> participantsIds;
  final MeetingType meetingType;
  final String? gMeetLink;
  final String? gEventId;

  MeetingModel({
    required this.id,
    required this.title,
    required this.desc,
    required this.dateTime,
    required this.organizerId,
    this.duration,
    this.lat,
    this.long,
    required this.participantsIds,
    required this.meetingType,
    this.gMeetLink,
    this.gEventId,
  });

  factory MeetingModel.fromJson(Map<String, dynamic> json) =>
      _$MeetingModelFromJson(json);

  Map<String, dynamic> toJson() => _$MeetingModelToJson(this);
}
