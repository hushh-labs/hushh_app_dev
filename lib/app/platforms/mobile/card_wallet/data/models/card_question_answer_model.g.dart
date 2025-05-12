// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_question_answer_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CardQuestionAnswerModelAdapter
    extends TypeAdapter<CardQuestionAnswerModel> {
  @override
  final int typeId = 7;

  @override
  CardQuestionAnswerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CardQuestionAnswerModel(
      id: fields[0] as String,
      question: fields[1] as String,
      answer: fields[2] as String?,
      dateTime: fields[6] as DateTime?,
      choices: (fields[5] as List?)?.cast<String>(),
      editable: fields[3] as bool,
      type: fields[4] as CustomCardAnswerType,
    );
  }

  @override
  void write(BinaryWriter writer, CardQuestionAnswerModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.question)
      ..writeByte(2)
      ..write(obj.answer)
      ..writeByte(3)
      ..write(obj.editable)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.choices)
      ..writeByte(6)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardQuestionAnswerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
