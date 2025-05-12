import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'agent_category.g.dart';

@JsonSerializable()
@HiveType(typeId: 5)
class AgentCategory extends Equatable {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final int id;
  @HiveField(2)
  final String type;
  @HiveField(3)
  final String? image;

  const AgentCategory(this.name, this.id, this.type, this.image);

  factory AgentCategory.fromJson(Map<String, dynamic> json) => _$AgentCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$AgentCategoryToJson(this);

  @override
  List<Object?> get props => [name, id];
}
