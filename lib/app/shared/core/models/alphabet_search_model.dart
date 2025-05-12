import 'dart:convert';

import 'package:azlistview/azlistview.dart';

class AlphabetSearch extends AlphabetSearchModel with ISuspensionBean {
  String? tagIndex;

  AlphabetSearch.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = super.toJson();
    return map;
  }

  @override
  String getSuspensionTag() {
    return tagIndex!;
  }

  @override
  String toString() {
    return json.encode(this);
  }
}

class AlphabetSearchModel {
  String name;
  String contactName;
  String avatar;
  String uid;
  String contactPhoneNumber;
  String phonenumber;

  AlphabetSearchModel.fromJson(json)
      : name = json['name'],
        contactName = json['contactName'],
        avatar = json['avatar'],
        contactPhoneNumber = json['contactPhoneNumber'],
        phonenumber = json['phoneNumber'],
        uid = json['uid'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    void addIfNonNull(String fieldName, dynamic value) {
      if (value != null) {
        map[fieldName] = value;
      }
    }

    addIfNonNull('name', name);
    addIfNonNull('contactName', contactName);
    addIfNonNull('avatar', avatar);
    addIfNonNull('contactPhoneNumber', contactPhoneNumber);
    addIfNonNull('phoneNumber', phonenumber);
    addIfNonNull('uid', uid);
    return map;
  }

  @override
  String toString() {
    return json.encode(this);
  }
}
