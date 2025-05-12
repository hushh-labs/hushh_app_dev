// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeetingModel _$MeetingModelFromJson(Map<String, dynamic> json) => MeetingModel(
      id: json['id'] as String,
      title: json['title'] as String,
      desc: json['desc'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      organizerId: json['organizerId'] as String,
      duration: json['duration'] == null
          ? null
          : Duration(microseconds: (json['duration'] as num).toInt()),
      lat: (json['lat'] as num?)?.toDouble(),
      long: (json['long'] as num?)?.toDouble(),
      participantsIds: (json['participantsIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      meetingType: $enumDecode(_$MeetingTypeEnumMap, json['meetingType']),
      gMeetLink: json['gMeetLink'] as String?,
      gEventId: json['gEventId'] as String?,
    );

Map<String, dynamic> _$MeetingModelToJson(MeetingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'desc': instance.desc,
      'dateTime': instance.dateTime.toIso8601String(),
      'duration': instance.duration?.inMicroseconds,
      'lat': instance.lat,
      'long': instance.long,
      'organizerId': instance.organizerId,
      'participantsIds': instance.participantsIds,
      'meetingType': _$MeetingTypeEnumMap[instance.meetingType]!,
      'gMeetLink': instance.gMeetLink,
      'gEventId': instance.gEventId,
    };

const _$MeetingTypeEnumMap = {
  MeetingType.online: 'online',
  MeetingType.walkIn: 'walkIn',
};
