import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:lemon_cayenne/Theme/colorTheme.dart';
import 'package:lemon_cayenne/account/hash.dart';
import 'package:lemon_cayenne/account/register.dart';
import 'package:lemon_cayenne/Theme/theme_provider.dart';
import 'package:lemon_cayenne/const.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../Theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  isDark = sharedPreferences.getInt('is_dark') ?? 1;
  colorOption = sharedPreferences.getString('app_bar_color') ?? 'default';
  hjel = intToString[sharedPreferences.getInt('is_dark') ?? 1]!;

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ColorProvider(colorOption),
      builder: (context, snapshot) {
        return ChangeNotifierProvider(
          create: (context) => ThemeProvider(isDark),
          builder: (context, snapshot) {
            return MaterialApp(
              theme: Provider.of<ThemeProvider>(context).themeData.copyWith(
                    appBarTheme: AppBarTheme(
                        color: Provider.of<ColorProvider>(context).appColor),
                  ),
              home: LoginPage(),
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
              child: Text("Login in Successful!"),
            ),
            duration: Duration(seconds: 2),
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
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(
            child: Text("Your Username Or Password Is Incdforrect"),
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
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
                    inputFormatters: [
                      // FilteringTextInputFormatter.allow(
                      //     RegExp(r'^[a-zA-Z0-9]+$')),
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
                ElevatedButton(
                  onPressed: () async {
                    await viewUser();
                    _username.clear();
                    _password.clear();
                  },
                  child: Text("Login"),
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
          ],
        ),
      ),
    );
  }
}
