import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import 'hash.dart';
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
  TextEditingController _confirmPassword = TextEditingController();
  bool _obsurceText = true;

  //TODO: a textfield for confrim password?

  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  Future<void> addUser() {
    var salt = generateSalt();
    String hashedPassword = hashPassword(_password.text, salt);
    return users.doc(_username.text).set({
      'Username': _username.text,
      'Password': hashedPassword,
      'Salt': salt,
      'Score': 0,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Center(
          child: Text("User has been created"),
        ),
        duration: Duration(seconds: 2),
      ));
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Center(
          child: Text("Something went wrong, please try again later"),
        ),
        duration: Duration(seconds: 2),
      ));
    });
  }

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
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'[^\w\d]')),
                    ],
                    decoration: const InputDecoration(
                      labelText: ("Username"),
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  height: 100,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 170,
                        child: TextField(
                          controller: _password,
                          obscureText: _obsurceText,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                          ],
                          decoration: const InputDecoration(
                            labelText: ("Password"),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _obsurceText = !_obsurceText;
                          });
                        },
                        child: Icon(Icons.search),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 200,
                  height: 100,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 170,
                        child: TextField(
                          controller: _confirmPassword,
                          obscureText: _obsurceText,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                          ],
                          decoration: const InputDecoration(
                            labelText: ("Confirm Password"),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _obsurceText = !_obsurceText;
                          });
                        },
                        child: Icon(Icons.search),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (confirmPassword()) {
                      await addUser();
                      _username.clear();
                      _password.clear();
                      _confirmPassword.clear();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Center(
                          child: Text("Your Password Does Not Match"),
                        ),
                        duration: Duration(seconds: 2),
                      ));
                      _password.clear();
                      _confirmPassword.clear();
                    }
                  },
                  child: const Text("Register"),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                  child: const SizedBox(
                    width: 200,
                    height: 100,
                    child: Text("Already Have An Account? Click Here"),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool confirmPassword() {
    if (_password == _confirmPassword) {
      return true;
    } else {
      return false;
    }
  }
}
