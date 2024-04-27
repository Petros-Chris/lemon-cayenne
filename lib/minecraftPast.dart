import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'main.dart';
import 'minecraftUUID.dart';

class SeePastUsersPage extends StatefulWidget {
  const SeePastUsersPage({super.key});

  @override
  State<SeePastUsersPage> createState() => _SeePastUsersPageState();
}

class _SeePastUsersPageState extends State<SeePastUsersPage> {
  TextEditingController _search = TextEditingController();
  int _selectedIndex = 1;
  String _name = "";
  String _id = "";
  String _url = "";
  var decodedResponse;

  Future<void> fetchHuman(String userName) async {
    final response = await http.get(
        Uri.parse('https://api.mojang.com/users/profiles/minecraft/$userName'));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      setState(() {
        _name = jsonResponse['name'];
        _id = jsonResponse['id'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search For all Owners",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search),
                        SizedBox(
                          width: 200,
                          child: TextField(
                            controller: _search,
                            decoration: InputDecoration(
                                hintText: "Search For Username",
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide.none)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(onPressed: () async {
                    await fetchHuman(_search.text);
                  }, child: Text("Search")),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 50),
              child: Row(
                children: [
                  Text(
                    "$_name",
                    style: TextStyle(fontSize: 24),
                  ),
                  Expanded(child: SizedBox()),
                  Text(
                    "$_id",
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            if (_url != "")
              Image.network(
                "$_url",
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Current',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Past',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility_new),
            label: 'UUID',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MinecraftPage()),
        );
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SeeUserByUUIDPage()),
        );
    }
  }
}
