import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lemon_cayenne/Drawer.dart';
import 'dart:convert';

import 'minecraftUser.dart';
import 'minecraftPast.dart';

class SeeUserByUUIDPage extends StatefulWidget {
  const SeeUserByUUIDPage({super.key});

  @override
  State<SeeUserByUUIDPage> createState() => _SeeUserByUUIDPageState();
}

class _SeeUserByUUIDPageState extends State<SeeUserByUUIDPage> {
  TextEditingController _search = TextEditingController();
  int _selectedIndex = 2;
  String _name = "";
  String _id = "";
  String _url = "";
  var decodedResponse;

  // Future<void> fetchHuman(String uuid) async {
  //   final response = await http.get(
  //       Uri.parse('https://sessionserver.mojang.com/session/minecraft/profile/$uuid'));
  //
  //   if (response.statusCode == 200) {
  //     var jsonResponse = json.decode(response.body);
  //
  //     setState(() {
  //       _name = jsonResponse['name'];
  //       _id = jsonResponse['id'];
  //     });
  //   }
  // }

  Future<void> getMinecraftProfile(String uuid) async {
    var url = Uri.parse(
        'https://sessionserver.mojang.com/session/minecraft/profile/$uuid');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      setState(() {
        _name = jsonResponse['name'];
        _id = jsonResponse['id'];
      });

      if (jsonResponse.containsKey('properties') &&
          jsonResponse['properties'].isNotEmpty) {
        String base64Value = jsonResponse['properties'][0]['value'];

        String decodedJson = utf8.decode(base64Decode(base64Value));

        decodedResponse = json.decode(decodedJson);
        _url = decodedResponse['textures']['SKIN']['url'];

        print(decodedResponse);
      } else {
        print("No properties found or properties array is empty.");
      }
    } else {
      print("Failed to retrieve user profile.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEdgeDragWidth: MediaQuery.of(context).size.width,
      appBar: AppBar(
        title: Text(
          "Search Owner Of UUID",
        ),
        centerTitle: true,
      ),
      drawer: DrawerNav(),
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
                                hintText: "Search By UUID",
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
                  ElevatedButton(
                      onPressed: () async {
                        await getMinecraftProfile(_search.text);
                      },
                      child: Text("Search")),
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MinecraftPage()),
        );
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SeePastUsersPage()),
        );
    }
  }
}
