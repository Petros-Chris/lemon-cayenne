import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lemon_cayenne/Drawer.dart';
import 'package:lemon_cayenne/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'minecraftPast.dart';
import 'minecraftUUID.dart';

class MinecraftPage extends StatefulWidget {
  const MinecraftPage({super.key});

  @override
  State<MinecraftPage> createState() => _MinecraftPageState();
}

class _MinecraftPageState extends State<MinecraftPage> {
  final TextEditingController _search = TextEditingController();
  int _selectedIndex = 0;
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
  void _loadRenderType() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      renderTypeVal = prefs.getString('render_type_val') ?? 'default';
    });
  }

  void _loadRenderView() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      renderViewVal = prefs.getString('render_view_val') ?? 'full';
    });
  }

  Future<void> HeHeHEHAW(
      String name, String renderType, String renderCrop) async {
    _url =
        'https://starlightskins.lunareclipse.studio/render/$renderType/$name/$renderCrop';
  }
  @override
  void initState() {
    super.initState();
    _loadRenderType();
    _loadRenderView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEdgeDragWidth: MediaQuery.of(context).size.width,
      appBar: AppBar(
        title: Text(
          "Search For Current Owner",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: DrawerNav(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Column(
            children: [
              Row(
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
                  ElevatedButton(
                      onPressed: () async {
                        await fetchHuman(_search.text);
                        await HeHeHEHAW(_name, renderTypeVal, renderViewVal);
                      },
                      child: Text("Search")),
                ],
              ),
              Row(
                children: [
                  Text("Render Type"),
                  Spacer(),
                  DropdownButton<String>(
                    value: renderTypeVal,
                    onChanged: (String? newValue) {
                      setState(() {
                        renderTypeVal = newValue!;
                        HeHeHEHAW(_name, renderTypeVal, renderViewVal);
                      });
                    },
                    items: rendertype.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  Spacer(),
                  Text("Render View"),
                  Spacer(),
                  DropdownButton<String>(
                    value: renderViewVal,
                    onChanged: (String? newValue) {
                      setState(() {
                        renderViewVal = newValue!;
                        HeHeHEHAW(_name, renderTypeVal, renderViewVal);
                      });
                    },
                    items: renderView.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
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
                  _url,
                  height: 400,
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
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
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SeePastUsersPage()),
        );
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SeeUserByUUIDPage()),
        );
    }
  }
}

// Future<void> getMinecraftProfile(String userId) async {
//   var url = Uri.parse(
//       'https://sessionserver.mojang.com/session/minecraft/profile/$userId');
//   var response = await http.get(url);
//   if (response.statusCode == 200) {
//     var jsonResponse = json.decode(response.body);
//
//     if (jsonResponse.containsKey('properties') &&
//         jsonResponse['properties'].isNotEmpty) {
//       String base64Value = jsonResponse['properties'][0]['value'];
//
//       String decodedJson = utf8.decode(base64Decode(base64Value));
//
//       decodedResponse = json.decode(decodedJson);
//       _url = decodedResponse['textures']['SKIN']['url'];
//
//       print(decodedResponse);
//     } else {
//       print("No properties found or properties array is empty.");
//     }
//   } else {
//     print("Failed to retrieve user profile.");
//   }
// }
