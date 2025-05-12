import 'dart:typed_data';

import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/receipt_model.dart';

class SharedAsset {
  final int? id;
  final String hushhId;
  final int cardId;
  final String? type;
  final String? fileType;
  final String? thumbnail;
  final String? path;
  final String? name;
  final DateTime? createdTime;
  final ReceiptModel? data;

  SharedAsset({
    this.id,
    this.data,
    required this.hushhId,
    required this.cardId,
    this.type,
    this.fileType,
    this.thumbnail,
    this.path,
    this.name,
    this.createdTime,
  });

  factory SharedAsset.fromJson(Map<String, dynamic> json) {
    return SharedAsset(
      cardId: json['cardId'],
      hushhId: json['hushhId'],
      id: json['id'],
      type: json['type'],
      fileType: json['fileType'],
      thumbnail: json['thumbnail'],
      path: json['path'],
      name: json['name'],
      createdTime: json['createdTime'] != null
          ? DateTime.parse(json['createdTime'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cardId': cardId,
      'hushhId': hushhId,
      'id': id,
      'type': type,
      'fileType': fileType,
      'thumbnail': thumbnail,
      'path': path,
      'name': name,
      'createdTime': createdTime?.toIso8601String(),
    };
  }
}
