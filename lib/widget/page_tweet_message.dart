import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_twitter/model/data_tweet.dart';
import 'package:my_twitter/model/message_manager.dart';
import 'package:provider/provider.dart';

class TweetMessagePage extends StatefulWidget {
  TweetMessagePage({this.tweetData}) : editMode = tweetData != null;

  final TweetData? tweetData;
  final bool editMode;

  @override
  State<StatefulWidget> createState() {
    return TweetMessagePageState();
  }
}

class TweetMessagePageState extends State<TweetMessagePage> {
  final editingController = TextEditingController();
  String? lastText;
  late MessageManager manager;
  static const int maxContentSize = 280;

  @override
  void initState() {
    super.initState();
    manager = context.read<MessageManager>();
    if (widget.editMode) {
      editingController.text = widget.tweetData!.contents;
    }
    editingController.addListener(() {
      var currentText = editingController.text;
      if (currentText.length > maxContentSize) {
        if (lastText != null) {
          editingController.text = lastText!;
        } else {
          editingController.text = currentText.substring(0, maxContentSize);
        }
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Limit $maxContentSize chars")));
      }
      lastText = editingController.text;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        leading: IconButton(
          icon: Icon(CupertinoIcons.xmark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("${widget.editMode ? "Edit" : "Input"} your tweet"),
        actions: widget.editMode
            ? [
                IconButton(
                  onPressed: () {
                    context.read<MessageManager>().delete(widget.tweetData!.id);
                    Navigator.of(context).pop();
                  },
                  icon: Icon(CupertinoIcons.delete),
                )
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
        child: buildMessageBox(context),
      ),
    );
  }

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  Widget buildMessageBox(BuildContext context) {
    var buttonText = (widget.editMode) ? Text('UPDATE') : Text('SEND');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Content:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: editingController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(border: OutlineInputBorder()),
        ),
        Row(
          children: [
            Text("${editingController.text.length}/$maxContentSize"),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    if (widget.editMode) {
                      manager.update(editingController.text, widget.tweetData!);
                    } else {
                      manager.sendData(editingController.text);
                    }
                    Navigator.of(context).pop();
                  },
                  child: buttonText,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
