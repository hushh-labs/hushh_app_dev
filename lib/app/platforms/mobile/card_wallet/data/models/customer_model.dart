import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/user.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';

class CustomerModel {
  final UserModel user;
  final CardModel brand;

  CustomerModel({
    required this.user,
    required this.brand,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      user: UserModel.fromJson(json['user']),
      brand: CardModel.fromJson(json['brand']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'brand': brand.toJson(),
    };
  }

  CustomerModel copyWith({
    UserModel? user,
    CardModel? brand,
  }) {
    return CustomerModel(
      user: user ?? this.user,
      brand: brand ?? this.brand,
    );
  }
}
