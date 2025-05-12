class ReceiptRadarHistory {
  final int? id;
  final DateTime? createdAt;
  final String email;
  final String hushhId;
  final String? accessToken;

  ReceiptRadarHistory({
    this.id,
    this.createdAt,
    required this.email,
    required this.hushhId,
    this.accessToken,
  });

  factory ReceiptRadarHistory.fromJson(Map<String, dynamic> json) {
    return ReceiptRadarHistory(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      email: json['access_token'] as String,
      hushhId: json['user_id'] as String,
      accessToken: json['access_token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'user_id': hushhId
    };
  }
}
