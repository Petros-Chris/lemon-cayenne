import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';


import '../Theme/theme.dart';
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
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  bool _obscureText = true;

  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  Future<void> addUser() {
    var salt = generateSalt();
    String hashedPassword = hashPassword(_password.text, salt);
    return users.doc(_username.text).set({
      'Username': _username.text,
      'Password': hashedPassword,
      'Salt': salt,
      'EasyScore': 0,
      'MediumScore': 0,
      'HardScore': 0,
      'InsaneScore': 0,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 40, right: 40, top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {},
                icon: Image.asset(
                  'assets/lemon.png',
                  width: 160,
                ),
              ),
              // Text("Login", style: TextStyle(fontSize: 32),),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  gradient: isDarkMode ? null : inputColor,
                  color: isDarkMode ?  const Color(0xFF3A3A3A) : null,
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
                  controller: _username,
                  inputFormatters: [
                    // FilteringTextInputFormatter.allow(
                    //     RegExp(r'^[a-zA-Z0-9]+$')),
                    FilteringTextInputFormatter.deny(RegExp(r'\W')),
                  ],
                  decoration: const InputDecoration(
                    labelText: ("Username"),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  gradient: isDarkMode ? null : inputColor,
                  color: isDarkMode ?  const Color(0xFF3A3A3A) : null,
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width - 126,
                      child: TextField(
                        controller: _password,
                        obscureText: _obscureText,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        ],
                        decoration: const InputDecoration(
                            labelText: ("Password"), border: InputBorder.none),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: const Icon(Icons.search),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  gradient: isDarkMode ? null : inputColor,
                  color: isDarkMode ?  const Color(0xFF3A3A3A) : null,
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width - 126,
                      child: TextField(
                        controller: _confirmPassword,
                        obscureText: _obscureText,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        ],
                        decoration: const InputDecoration(
                            labelText: ("Confirm Password"),
                            border: InputBorder.none),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: const Icon(Icons.search),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width - 200,
                decoration: BoxDecoration(
                  gradient: isDarkMode ? null : inputColor,
                  color: isDarkMode ?  const Color(0xFF3A3A3A) : null,
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ElevatedButton(
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
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(Colors.transparent),
                    elevation: MaterialStateProperty.all(0),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    "Register",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),

              const SizedBox(
                height: 40,
              ),

              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
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
        ),
      ),
    );
  }

  bool confirmPassword() {
    if (_password.text == _confirmPassword.text) {
      return true;
    } else {
      return false;
    }
  }
}