import 'package:flutter/material.dart';
import 'package:my_twitter/model/account_manager.dart';
import 'package:my_twitter/model/data_user.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatelessWidget {
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final displayNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up Page'),
      ),
      body: Column(
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              obscureText: true,
              controller: displayNameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Display Name',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context
                  .read<AccountManager>()
                  .register(
                    UserData(
                      mail: mailController.text,
                      displayName: displayNameController.text,
                    ),
                    passwordController.text,
                  )
                  .onError((error, stackTrace) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Sign up failed, error: $error")));
                return false;
              }).then((value) {
                if (value) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Sign up success!!")));
                }
              });
              // Navigator.of(context).pushReplacement(
              //       MaterialPageRoute(builder: (context) => MyHomePage()));
            },
            child: Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}
