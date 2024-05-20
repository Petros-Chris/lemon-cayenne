import 'dart:io';
import 'package:android_intent/android_intent.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lemon_cayenne/Drawer.dart';
import 'package:lemon_cayenne/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'minecraft_create.dart';
import 'minecraft_uuid.dart';

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
  String _url2 = "";
  String errorMessage = "";

  bool failed = false;
  bool hasImageLoaded = false;
  bool hasTextLoaded = false;
  bool isLoadingFetch = false;
  bool isLoadingImage = false;

  Future<void> fetchHuman(String userName) async {
    setState(() {
      isLoadingFetch = true;
    });
    final response = await http.get(
        Uri.parse('https://api.mojang.com/users/profiles/minecraft/$userName'));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      setState(() {
        _name = jsonResponse['name'];
        _id = jsonResponse['id'];
        hasTextLoaded = true;
        isLoadingFetch = false;
      });
      await generatePicture(_name, renderTypeVal, renderViewVal);
    } else {
      setState(() {
        failed = true;
        hasTextLoaded = false;
        hasImageLoaded = false;
        isLoadingFetch = false;
        errorMessage = response.reasonPhrase!;
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

  Future<void> generatePicture(
      String name, String renderType, String renderCrop) async {
    setState(() {
      isLoadingImage = true;
    });
    final response = await http.get(Uri.parse(
        'https://starlightskins.lunareclipse.studio/render/$renderType/$name/$renderCrop'));
    if (response.statusCode == 200) {
      setState(() {
        _url = response.request!.url.toString();
        isLoadingImage = false;
        hasImageLoaded = true;
        failed = false;
      });
    } else {
      setState(() {
        failed = true;
        isLoadingImage = false;
        hasImageLoaded = false;
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
        var decodedResponse = json.decode(decodedJson);

        setState(() {
          _url2 = decodedResponse['textures']['SKIN']['url'];
        });
      }
    }
  }

  void openPhotosApp() {
    AndroidIntent intent = const AndroidIntent(
      action: 'android.intent.action.VIEW_DOWNLOADS',
    );
    intent.launch();
  }

  @override
  void initState() {
    _loadRenderType();
    _loadRenderView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEdgeDragWidth: MediaQuery.of(context).size.width,
      appBar: AppBar(
        title: const Text(
          "Search By Username",
        ),
        centerTitle: true,
      ),
      drawer: const DrawerNav(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 200,
                          child: TextField(
                            controller: _search,
                            decoration: const InputDecoration(
                              hintText: "Username",
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                            onSubmitted: (value) async {
                              FocusScope.of(context).unfocus();
                              await fetchHuman(_search.text);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        await fetchHuman(_search.text);
                      },
                      child: const Text("Search")),
                ],
              ),
              hasTextLoaded && hasImageLoaded
                  ? Row(
                      children: [
                        const Text("Render Type"),
                        const Spacer(),
                        DropdownButton<String>(
                          menuMaxHeight: 300,
                          value: renderTypeVal,
                          onChanged: (String? newValue) {
                            setState(() {
                              renderTypeVal = newValue!;
                              switch (renderTypeVal) {
                                case 'mojavatar':
                                  {
                                    if (renderViewVal == 'face') {
                                      renderViewVal = 'bust';
                                    }

                                    renderView = ['full', 'bust'];
                                    generatePicture(
                                        _name, renderTypeVal, renderViewVal);
                                    break;
                                  }
                                case 'head':
                                  {
                                    if (renderViewVal != 'full') {
                                      renderViewVal = 'full';
                                    }
                                    renderView = ['full'];
                                    generatePicture(
                                        _name, renderTypeVal, renderViewVal);
                                    break;
                                  }
                                default:
                                  {
                                    renderView = ['full', 'bust', 'face'];
                                    generatePicture(
                                        _name, renderTypeVal, renderViewVal);
                                  }
                              }
                            });
                          },
                          items: rendertype.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        const Spacer(),
                        const Text("Render View"),
                        const Spacer(),
                        DropdownButton<String>(
                          value: renderViewVal,
                          onChanged: (String? newValue) {
                            setState(() {
                              renderViewVal = newValue!;
                              generatePicture(_name, renderTypeVal, renderViewVal);
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
                    )
                  : const SizedBox(),
              if (isLoadingFetch) const CircularProgressIndicator(),
              hasImageLoaded || failed == false
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 20),
                          child: Row(
                            children: [
                              SelectableText(
                                _name,
                                style: const TextStyle(fontSize: 24),
                              ),
                              const Expanded(child: SizedBox()),
                              SizedBox(
                                width: 150,
                                child: SelectableText(
                                  _id,
                                  style: const TextStyle(fontSize: 14),
                                  //overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (_url != "")
                          Image.network(
                            _url,
                            height: 400,
                          ),
                      ],
                    )
                  : Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Text("Something Went Wrong $errorMessage"),
                    ),
              const SizedBox(
                height: 20,
              ),
              hasTextLoaded && hasImageLoaded
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: const Row(
                            children: [
                              Text("Download Raw Skin"),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.download),
                            ],
                          ),
                          onTap: () async {
                            await getMinecraftProfile(_id);
                            String timeStamp =
                                "${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}";
                            http.Response response =
                                await http.get(Uri.parse(_url2));
                            File file = File(
                                "/storage/emulated/0/Download/$_name-Skin-$timeStamp.png");
                            file.writeAsBytes(response.bodyBytes);

                            AwesomeNotifications().createNotification(
                              content: NotificationContent(
                                id: 10,
                                channelKey: 'download_channel',
                                title: 'File Has Been Downloaded',
                              ),
                            );
                            openPhotosApp();
                          },
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        GestureDetector(
                          child: const Row(
                            children: [
                              Text("Download Skin"),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.download),
                            ],
                          ),
                          onTap: () async {
                            String timeStamp =
                                "${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}";
                            http.Response response =
                                await http.get(Uri.parse(_url));
                            File file = File(
                                "/storage/emulated/0/Download/$_name-$renderTypeVal-$renderViewVal-$timeStamp.png");
                            file.writeAsBytes(response.bodyBytes);

                            AwesomeNotifications().createNotification(
                              content: NotificationContent(
                                id: 10,
                                channelKey: 'download_channel',
                                title: 'File Has Been Downloaded',
                              ),
                            );
                            openPhotosApp();
                          },
                        ),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Current',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.create),
            label: 'Create',
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
          MaterialPageRoute(builder: (context) => const MinecraftCustomLook()),
        );
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SeeUserByUUIDPage()),
        );
    }
  }
}
