class Account {
  final String accountId;
  final String name;
  final String type;
  final String? subtype;
  final String? institutionName;

  Account({
    required this.accountId,
    required this.name,
    required this.type,
    this.subtype,
    this.institutionName,
  });

  // Factory constructor to create an Account object from JSON
  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountId: json['account_id'],
      name: json['name'],
      type: json['type'],
      subtype: json['subtype'],
      institutionName: json['official_name'],
    );
  }

  // Method to convert the Account object to a map for RPC calls
  Map<String, dynamic> toRpcParams(String hushhId) {
    return {
      '_hushh_id': hushhId,
      '_account_id': accountId,
      '_name': name,
      '_type': type,
      '_subtype': subtype,
      '_institution_name': institutionName,
    };
  }
}
