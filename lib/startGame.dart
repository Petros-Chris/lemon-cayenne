import 'package:flutter/material.dart';
import 'package:lemon_cayenne/testOfGame.dart';

void main() {
  runApp(
    Directionality(
      textDirection: TextDirection.ltr,
      child: MaterialApp(
        home: BeforeGamingPage(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}

class BeforeGamingPage extends StatefulWidget {
  const BeforeGamingPage({super.key});

  @override
  State<BeforeGamingPage> createState() => _BeforeGamingPageState();
}

class _BeforeGamingPageState extends State<BeforeGamingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: 300,
              child: Column(
                children: [
                  Text(
                    "How To Play",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  Text(
                    "There will be red squares that will appear on your display, click them as fast as you can",
                    style: TextStyle(fontSize: 24),
                  )
                ],
              ),
            ),
            Expanded(child: SizedBox()),
            SizedBox(
                height: 50,
                width: 200,
                child: ElevatedButton(onPressed: () {
                }, child: Text("Play"))),
            SizedBox(
              height: 150,
            ),
          ],
        ),
      ),
    );
  }
}
