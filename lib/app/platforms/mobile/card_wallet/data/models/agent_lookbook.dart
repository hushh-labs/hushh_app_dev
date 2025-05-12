import 'package:equatable/equatable.dart';

class AgentLookBook extends Equatable {
  final String name;
  final String createdAt;
  final String id;
  final String hushhId;
  final int numberOfProducts;
  final List<String> images;

  const AgentLookBook({
    required this.name,
    required this.createdAt,
    required this.id,
    required this.hushhId,
    required this.numberOfProducts,
    required this.images,
  });

  factory AgentLookBook.fromJson(Map<String, dynamic> json) {
    return AgentLookBook(
      name: json['name'],
      hushhId: json['hushhId'],
      createdAt: json['createdAt'],
      id: json['id'],
      numberOfProducts: json['numberOfProducts'],
      images: List<String>.from(json['images']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'createdAt': createdAt,
      'id': id,
      'hushhId': hushhId,
      'numberOfProducts': numberOfProducts,
      'images': images,
    };
  }

  @override
  List<Object?> get props => [id];
}
