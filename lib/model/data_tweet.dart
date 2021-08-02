import 'package:flutter/foundation.dart';

@immutable
class TweetData {
  TweetData({
    required this.name,
    required this.accountName,
    required this.contents,
    required this.timestamp,
    this.id,
  });

  final String name;
  final String accountName;
  final String contents;
  final int timestamp;
  final String? id;

  TweetData.fromJson(String id, Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          accountName: json['accountName']! as String,
          contents: json['contents']! as String,
          timestamp: json['timestamp']! as int,
          id: id,
        );

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'accountName': accountName,
      'contents': contents,
      'timestamp': timestamp,
    };
  }
}
