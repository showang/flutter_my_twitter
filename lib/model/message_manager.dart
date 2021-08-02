import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_twitter/model/account_manager.dart';
import 'package:my_twitter/model/data_tweet.dart';

class MessageManager with ChangeNotifier {
  MessageManager({required this.accountManager});

  AccountManager accountManager;

  CollectionReference<TweetData> get tweetDataRef => FirebaseFirestore.instance
      .collection(accountManager.currentUser!.mail)
      .withConverter<TweetData>(
        fromFirestore: (snapshots, _) =>
            TweetData.fromJson(snapshots.id, snapshots.data()!),
        toFirestore: (data, _) => data.toJson(),
      );

  Stream<QuerySnapshot<TweetData>> get dataStream {
    return tweetDataRef.orderBy('timestamp', descending: true).snapshots();
  }

  void sendData(String contents) {
    var user = accountManager.currentUser!;
    TweetData data = TweetData(
        name: user.displayName,
        accountName: user.accountName,
        contents: contents,
        timestamp: DateTime.now().millisecondsSinceEpoch);
    tweetDataRef.add(data);
  }

  void delete(String? id) {
    if (id != null) {
      tweetDataRef.doc(id).delete();
    }
  }

  void update(String newMessage, TweetData oldData) {
    tweetDataRef.doc(oldData.id).update({'contents': newMessage});
  }
}
