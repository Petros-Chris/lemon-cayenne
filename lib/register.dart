import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

  //TODO: Id look pretty instead of random numbers in firebase?
  //TODO: Also unsure how to add a field of id
  //TODO: find a way to stop user from writing anything he wants or submitting ''
  //TODO: a textfield for confrim password?
  // int user_id = 0;

  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  Future<void> addUser() {
    return users
        // .doc("$user_id")
        // .set({
        //   'Username': _username.text,
        //   'Password': _password.text,
        // })
        .add({
      'Username': _username.text,
      'Password': _password.text,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("User has been created"),
        duration: Duration(seconds: 2),
      ));
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something went wrong, please try again later"),
        duration: Duration(seconds: 2),
      ));
    });
  }

// String setId() {
//   user_id = users.count();
//   return"$user_id";
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                  width: 200,
                  child: TextField(
                    controller: _username,
                    decoration: const InputDecoration(
                      labelText: ("Username"),
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  child: TextField(
                    controller: _password,
                    decoration: const InputDecoration(
                      labelText: ("Password"),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    addUser();
                    _username.clear();
                    _password.clear();
                  },
                  child: const Text("Register"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
