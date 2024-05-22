import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lemon_cayenne/valorant/valorant_page.dart';
import 'dart:convert';
import 'package:lemon_cayenne/drawer.dart';
import '../Theme/theme.dart';
import 'weapon_skins.dart';

class WeaponPage extends StatefulWidget {
  const WeaponPage({super.key});

  @override
  _WeaponPageState createState() => _WeaponPageState();
}

class _WeaponPageState extends State<WeaponPage> {
  String? selectedCategory;
  List<dynamic> items = [];
  bool isLoading = false;
  int _selectedIndex = 1;

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
        items = [
          {'displayName': 'Failed to load $category'}
        ];
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ValorantPage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WeaponPage()),
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
      appBar: AppBar(title: const Text('Weapon Page')),
      drawer: const DrawerNav(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Select a Category"),
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
            const SizedBox(height: 20),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var item = items[index];
                      if (selectedCategory == 'Maps') {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['displayName'] ?? 'No name',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              item['splash'] != null
                                  ? SizedBox(
                                      width: double.infinity,
                                      height: 200,
                                      child: Image.network(
                                        item['splash'],
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        );
                      } else if (selectedCategory == 'Characters') {
                        return ExpansionTile(
                          title: Text(item['displayName'] ?? 'No name'),
                          leading: item['displayIcon'] != null
                              ? Image.network(item['displayIcon'],
                                  width: 50, height: 50)
                              : null,
                          children: (item['abilities'] as List)
                              .map<Widget>((ability) => ListTile(
                                    title: Text(ability['displayName'] ??
                                        'No ability name'),
                                    subtitle: Text(ability['description'] ??
                                        'No description'),
                                    leading: ability['displayIcon'] != null
                                        ? Image.network(
                                            ability['displayIcon'],
                                            width: 30,
                                            height: 30,
                                            color: isDarkMode ? Colors.white : Colors.black,
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
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(10),
                              title: Text(item['displayName'] ?? 'No name'),
                              subtitle: Text(item['category'] != null
                                  ? item['category']
                                      .replaceAll('EEquippableCategory::', '')
                                  : ''),
                              leading: item['displayIcon'] != null
                                  ? Image.network(item['displayIcon'],
                                      width: 50, height: 50)
                                  : null,
                            ),
                          ),
                        );
                      } else {
                        return const ListTile(
                          title: Text('Unknown category'),
                        );
                      }
                    },
                  ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
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
