import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_twitter/main.dart';
import 'package:my_twitter/model/account_manager.dart';
import 'package:my_twitter/widget/page_sign_up.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<StatefulWidget> {
  final mailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isProgressing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Center(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: mailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<AccountManager>()
                        .login(mailController.text, passwordController.text)
                        .onError((error, stackTrace) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Login failed, error: $error")));
                    }).then((user) {
                      if (user != null) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => MyHomePage()));
                      } else {
                        setState(() {
                          isProgressing = false;
                        });
                      }
                    });
                    setState(() {
                      isProgressing = true;
                    });
                  },
                  child: Text('Login'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        CupertinoPageRoute(builder: (context) => SignUpPage()));
                  },
                  child: Text('Sign Up'),
                ),
              ],
            ),
            Center(
              child: isProgressing ? CircularProgressIndicator() : null,
            ),
          ],
        ),
      ),
    );
  }
}
