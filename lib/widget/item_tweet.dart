import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../model/data_tweet.dart';

class TweetItem extends StatelessWidget {
  TweetItem(this.data);

  final TweetData data;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: CircleAvatar(
            radius: 30,
            backgroundImage:
                NetworkImage("https://via.placeholder.com/180x180"),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Row(
                          children: [
                            Text(
                              data.name,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Icon(CupertinoIcons.check_mark),
                            Text(
                              "@${data.accountName}",
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        )),
                        buildTimeAgoText(),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 4),
                  child: Text(
                    data.contents,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTimeAgoText() {
    return Text(
        timeago.format(DateTime.fromMillisecondsSinceEpoch(data.timestamp)));
  }
}
