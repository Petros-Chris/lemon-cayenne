import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeaponSkinsPage extends StatefulWidget {
  final String weaponUuid;

  const WeaponSkinsPage({Key? key, required this.weaponUuid}) : super(key: key);

  @override
  _WeaponSkinsPageState createState() => _WeaponSkinsPageState();
}

class _WeaponSkinsPageState extends State<WeaponSkinsPage> {
  List<dynamic> skins = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSkins();
  }

  Future<void> fetchSkins() async {
    var response = await http.get(Uri.parse('https://valorant-api.com/v1/weapons'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var weapon = (data['data'] as List).firstWhere((weapon) => weapon['uuid'] == widget.weaponUuid);
      setState(() {
        skins = weapon['skins'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        skins = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weapon Skins')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: skins.map((skin) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    skin['displayName'] ?? 'No name',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  skin['displayIcon'] != null
                      ? Container(
                    width: double.infinity,
                    height: 300,
                    child: Image.network(
                      skin['displayIcon'],
                      fit: BoxFit.contain,
                    ),
                  )
                      : SizedBox.shrink(),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
