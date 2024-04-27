import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lemon_cayenne/register.dart';

import 'main.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
    );
  }
}

//TODO: Are usernames going to be unique?
//TODO: We should probably hash passwords

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  Future<void> viewUser() async {
    QuerySnapshot querySnapshot =
        await users.where('Username', isEqualTo: _username.text).get();

    if (querySnapshot.docs.isNotEmpty) {
      //TODO: Is this even possible to do?

      var userDoc = querySnapshot.docs.first.data() as Map<String, dynamic>;
      String userPassword = userDoc['Password'];

      if (userPassword == _password.text) {
        //ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login in Successful!"),
            duration: Duration(seconds: 2),
          ),
        );
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        });
        //TODO: This part might be useless not 100 though
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Your Username Or Password Is Incorrect"),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Your Username Or Password Is Incorrect"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _username,
                    decoration: const InputDecoration(
                      labelText: ("Username"),
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _password,
                    decoration: const InputDecoration(
                      labelText: ("Password"),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await viewUser();
                    _username.clear();
                    _password.clear();
                  },
                  child: const Text("Login"),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()),
                    );
                  },
                  child: Container(
                    width: 200,
                    height: 100,
                    child: const Text("Dont Have An Account? Click Here"),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
