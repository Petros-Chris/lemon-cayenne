import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:lemon_cayenne/Theme/color_theme.dart';
import 'package:lemon_cayenne/account/hash.dart';
import 'package:lemon_cayenne/account/register.dart';
import 'package:lemon_cayenne/Theme/theme_provider.dart';
import 'package:lemon_cayenne/const.dart';
import 'package:provider/provider.dart';
import '../home.dart';
import '../Theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ColorProvider(colorOption),
      builder: (context, snapshot) {
        return ChangeNotifierProvider(
          create: (context) => ThemeProvider(isDark),
          builder: (context, snapshot) {
            return MaterialApp(
              //navigatorKey: navigatorKey,
              //title: 'Awesome Notification Demo',
              theme: Provider.of<ThemeProvider>(context).themeData.copyWith(
                    appBarTheme: AppBarTheme(
                        color: Provider.of<ColorProvider>(context).appColor),
                  ),
              home: const LoginPage(),
            );
          },
        );
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _obsurceText = true;

  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  Future<void> viewUser() async {
    QuerySnapshot querySnapshot =
        await users.where('Username', isEqualTo: _username.text).get();

    if (querySnapshot.docs.isNotEmpty) {
      var userDoc = querySnapshot.docs.first.data() as Map<String, dynamic>;
      String userHash = userDoc['Password'];
      String userSalt = userDoc['Salt'];

      String password = hashPassword(_password.text, userSalt);
      if (password == userHash) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(
              child: Text("Login Successful!"),
            ),
            duration: Duration(seconds: 1),
          ),
        );
        username = _username.text;
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        });
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(
              child: Text("Your Username Or Password Is Incorrect"),
            ),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(
            child: Text("Your Username Or Password Is Incorrect"),
          ),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 40, right: 40, top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              IconButton(
                onPressed: () {},
                icon: Image.asset(
                  'assets/lemon.png',
                  width: 160,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF3A3A3A) : null,
                  gradient: isDarkMode ? null : inputColor,
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
                    FilteringTextInputFormatter.deny(RegExp(r'[^\w\d]')),
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
                  color: isDarkMode ? const Color(0xFF3A3A3A) : null,
                  gradient: isDarkMode ? null : inputColor,
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 126,
                      child: TextField(
                        controller: _password,
                        obscureText: _obsurceText,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        ],
                        decoration: const InputDecoration(
                            labelText: ("Password"), border: InputBorder.none),
                        onSubmitted: (value) async {
                          FocusScope.of(context).unfocus();
                          await viewUser();
                          _username.clear();
                          _password.clear();
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _obsurceText = !_obsurceText;
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
                width: MediaQuery.of(context).size.width - 200,
                decoration: BoxDecoration(
                  gradient: isDarkMode ? null : inputColor,
                  color: isDarkMode ? const Color(0xFF3A3A3A) : null,
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    await viewUser();
                    _username.clear();
                    _password.clear();
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
                    "Login",
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
                    MaterialPageRoute(
                        builder: (context) => const RegisterPage()),
                  );
                },
                child: const SizedBox(
                  width: 200,
                  height: 100,
                  child: Text("Dont Have An Account? Click Here"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
