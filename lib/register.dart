import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHt5432`omePageState extends State<MyHomePage> {
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

  //TODO: Id look pretty instead of random numbers in firebase?
  //TODO: Also unsure how to add a field of id
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
        })
        .then((value) => print("User added"))
        .catchError((error) => print("Failed to add the user"));
  }

  // String setId() {
  //   user_id = users.count();
  //   return"$user_id";
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
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
                    decoration: InputDecoration(
                      labelText: ("Username"),
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  child: TextField(
                    controller: _password,
                    decoration: InputDecoration(
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
                  child: Text("Register"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
