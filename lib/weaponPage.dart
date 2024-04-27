import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lemon_cayenne/valorantPage.dart';
import 'dart:convert';

import 'minecraftPast.dart';
import 'minecraftUUID.dart';

void main() {
  runApp(
    Directionality(
      textDirection: TextDirection.ltr,
      child: MaterialApp(home: WeaponPage(),debugShowCheckedModeBanner: false,),
    ),
  );
}

class WeaponPage extends StatefulWidget {
  const WeaponPage({super.key});

  @override
  State<WeaponPage> createState() => WeaponPageState();
}

class WeaponPageState extends State<WeaponPage> {
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

  Future<void> getMinecraftProfile(String userId) async {
    var url = Uri.parse(
        'https://sessionserver.mojang.com/session/minecraft/profile/$userId');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

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

      appBar: AppBar(
        title: Text(
          "Weapon Info", style: TextStyle(color: Colors.white),),
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
                                hintText: "Search Weapon By Name",
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
                        await fetchHuman(_search.text);
                        await getMinecraftProfile(_id);
                      },
                      child: Text("Search")),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 50),
              child: Text("Information of weapon would go here"),
            ),
            SizedBox(
              height: 10,
            ),
            if(_url != "")
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
            label: 'Player Data',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mode_fan_off_outlined),
            label: 'Weapon Data',
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
          MaterialPageRoute(builder: (context) => ValorantPage()),
        );
    }
  }
}
