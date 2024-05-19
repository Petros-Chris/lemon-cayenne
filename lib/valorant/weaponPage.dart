import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lemon_cayenne/valorant/valorantPage.dart';
import 'dart:convert';
import '../Drawer.dart';
import 'package:lemon_cayenne/Drawer.dart'; // Make sure this import path is correct based on your project structure
import 'WeaponSkins.dart'; // Import the ValorantPage

class WeaponPage extends StatefulWidget {
  @override
  _WeaponPageState createState() => _WeaponPageState();
}

class _WeaponPageState extends State<WeaponPage> {
  String? selectedCategory;
  List<dynamic> items = [];
  bool isLoading = false;
  int _selectedIndex = 1; // Default to WeaponPage

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchData(String category) async {
    setState(() {
      isLoading = true;
    });

    String url;
    if (category == 'Maps') {
      url = 'https://valorant-api.com/v1/maps';
    } else if (category == 'Characters') {
      url = 'https://valorant-api.com/v1/agents';
    } else if (category == 'Weapons') {
      url = 'https://valorant-api.com/v1/weapons';
    } else {
      return;
    }

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        if (category == 'Characters') {
          items = (data['data'] as List)
              .where((agent) => agent['isPlayableCharacter'] == true)
              .toList();
        } else {
          items = data['data'];
        }
      });
    } else {
      setState(() {
        items = [{'displayName': 'Failed to load $category'}];
      });
    }

    setState(() {
      isLoading = false;
    });
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
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WeaponPage()),
        );
        break;
    }
  }

  void _onWeaponTap(String weaponUuid) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WeaponSkinsPage(weaponUuid: weaponUuid),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weapon Page')),
      drawer: DrawerNav(), // Assuming DrawerNav is your Drawer widget
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: "Select a Category"),
              value: selectedCategory,
              onChanged: (newValue) {
                setState(() {
                  selectedCategory = newValue;
                  fetchData(newValue!);
                });
              },
              items: ['Maps', 'Characters', 'Weapons']
                  .map<DropdownMenuItem<String>>((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                var item = items[index];
                if (selectedCategory == 'Maps') {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['displayName'] ?? 'No name',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        item['splash'] != null
                            ? Container(
                          width: double.infinity,
                          height: 200,
                          child: Image.network(
                            item['splash'],
                            fit: BoxFit.cover,
                          ),
                        )
                            : SizedBox.shrink(),
                      ],
                    ),
                  );
                } else if (selectedCategory == 'Characters') {
                  return ExpansionTile(
                    title: Text(item['displayName'] ?? 'No name'),
                    leading: item['displayIcon'] != null
                        ? Image.network(item['displayIcon'], width: 50, height: 50)
                        : null,
                    children: (item['abilities'] as List)
                        .map<Widget>((ability) => ListTile(
                      title: Text(ability['displayName'] ?? 'No ability name'),
                      subtitle: Text(ability['description'] ?? 'No description'),
                      leading: ability['displayIcon'] != null
                          ? Image.network(
                        ability['displayIcon'],
                        width: 30,
                        height: 30,
                        color: Colors.black,
                        colorBlendMode: BlendMode.srcIn,
                      )
                          : null,
                    ))
                        .toList(),
                  );
                } else if (selectedCategory == 'Weapons') {
                  return GestureDetector(
                    onTap: () => _onWeaponTap(item['uuid']),
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10),
                        title: Text(item['displayName'] ?? 'No name'),
                        subtitle: Text(item['category'] != null ? item['category'].replaceAll('EEquippableCategory::', '') : ''),
                        leading: item['displayIcon'] != null
                            ? Image.network(item['displayIcon'], width: 50, height: 50)
                            : null,
                      ),
                    ),
                  );
                } else {
                  return ListTile(
                    title: Text('Unknown category'),
                  );
                }
              },
            ),
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
}