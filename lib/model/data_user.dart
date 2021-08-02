import 'package:flutter/foundation.dart';

@immutable
class UserData {
  UserData({
    required this.mail,
    required this.displayName,
  });

  final String mail;
  final String displayName;

  String get accountName => mail.substring(0, mail.indexOf('@'));

  UserData.fromJson(Map<String, Object?> json)
      : this(
          mail: json['mail']! as String,
          displayName: json['name']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'mail': mail,
      'name': displayName,
    };
  }
}
