import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_twitter/model/account_manager.dart';
import 'package:my_twitter/widget/page_login.dart';
import 'package:my_twitter/widget/page_tweet_message.dart';
import 'package:my_twitter/widget/item_tweet.dart';
import 'package:my_twitter/model/message_manager.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

Future<void> main() async {
  timeago.setLocaleMessages('en_short', timeago.EnShortMessages());
  await initFirebase();
  var accountManager = AccountManager();
  await accountManager.checkLogin();
  var messageManager = MessageManager(accountManager: accountManager);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => accountManager),
    ChangeNotifierProvider(create: (_) => messageManager),
  ], child: MyApp()));
}

Future<void> initFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var accountManager = context.read<AccountManager>();
    return MaterialApp(
      title: 'MyTwitter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: accountManager.isLogin ? MyHomePage() : LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title = 'MyTwitter Home'}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {
    Navigator.of(context).push(CupertinoPageRoute(
      fullscreenDialog: true,
      builder: (context) => TweetMessagePage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                context.read<AccountManager>().logout().then((value) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginPage()));
                });
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: buildTweetList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buildTweetList() {
    return StreamBuilder(
        stream: context.read<MessageManager>().dataStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.requireData;
          return ListView.separated(
            itemCount: data.size,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              return InkWell(
                child: TweetItem(data.docs[index].data()),
                onLongPress: () {
                  Navigator.of(context).push(CupertinoPageRoute(
                    fullscreenDialog: true,
                    builder: (context) =>
                        TweetMessagePage(tweetData: data.docs[index].data()),
                  ));
                },
              );
            },
          );
        });
  }
}
