import 'dart:io';
import 'package:android_intent/android_intent.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lemon_cayenne/Drawer.dart';
import 'package:lemon_cayenne/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'minecraft_uuid.dart';
import 'minecraft_user.dart';

class MinecraftCustomLook extends StatefulWidget {
  const MinecraftCustomLook({super.key});

  @override
  State<MinecraftCustomLook> createState() => _MinecraftCustomLookState();
}

class _MinecraftCustomLookState extends State<MinecraftCustomLook> {
  final TextEditingController _search = TextEditingController();
  final TextEditingController _renderScale = TextEditingController(text: "0");
  final TextEditingController _directLightIntensity =
      TextEditingController(text: "0");
  final TextEditingController _globalLightIntensity =
      TextEditingController(text: "0");
  final TextEditingController _xCamPos = TextEditingController(text: "11.92");
  final TextEditingController _yCamPos = TextEditingController(text: "15.81");
  final TextEditingController _zCamPos = TextEditingController(text: "-29.71");
  final TextEditingController _xCamFocPon = TextEditingController(text: "0.31");
  final TextEditingController _yCamFocPon =
      TextEditingController(text: "18.09");
  final TextEditingController _zCamFocPon = TextEditingController(text: "1.32");

  bool isometric = false;
  bool dropShadow = false;
  String borderColor = "ff0000";
  String cameraPosition = "";
  String cameraFocalPoint = "";
  String _renderTypeVal = "";
  String _renderViewVal = "";

  int _selectedIndex = 1;
  String _name = "";
  String _id = "";
  String _url = "";

  bool failed = false;
  bool hasImageLoaded = false;
  bool hasTextLoaded = false;
  bool isLoadingFetch = false;
  bool isLoadingImage = false;

  String errorMessage = "";

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
      custom(_name);
    } else {
      setState(() {
        failed = true;
        hasTextLoaded = false;
        hasImageLoaded = false;
        isLoadingFetch = false;
      });
    }
  }

  void stopIncorrectValuesNoSaveVersion() {
    switch (_renderTypeVal) {
      case 'mojavatar':
        {
          if (_renderViewVal == 'face') {
            _renderViewVal = 'bust';
          }

          renderView = ['full', 'bust'];
          break;
        }
      case 'head':
        {
          if (_renderViewVal != 'full') {
            _renderViewVal = 'full';
          }
          renderView = ['full'];
          break;
        }
      default:
        {
          renderView = ['full', 'bust', 'face'];
        }
    }
  }

  TextInputFormatter rangeTextInputFormatter(double min, double max) {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      if (newValue.text.isEmpty) {
        return newValue;
      }
      final double value = double.tryParse(newValue.text) ?? min;
      if (value < min) {
        return const TextEditingValue().copyWith(text: min.toString());
      } else if (value > max) {
        return const TextEditingValue().copyWith(text: max.toString());
      }
      return newValue;
    });
  }

  void custom(
    String name,
  ) async {
    setState(() {
      isLoadingImage = true;
      Map<String, String> jsonDataCamPos = {
        "x": _xCamPos.text,
        "y": _yCamPos.text,
        "z": _zCamPos.text,
      };

      cameraPosition = jsonEncode(jsonDataCamPos);

      Map<String, String> jsonDataCamFocPo = {
        "x": _xCamFocPon.text,
        "y": _yCamFocPon.text,
        "z": _zCamFocPon.text,
      };

      cameraFocalPoint = jsonEncode(jsonDataCamFocPo);
    });
    url =
        'https://starlightskins.lunareclipse.studio/render/$_renderTypeVal/$name/$_renderViewVal?'
        'isometric=$isometric&dropShadow=$dropShadow'
        '&renderScale=${_renderScale.text}'
        '&cameraPosition=$cameraPosition&cameraFocalPoint=$cameraFocalPoint'
        '&dirLightIntensity=${_directLightIntensity.text}'
        '&globalLightIntensity=${_globalLightIntensity.text}';

    final response = await http.get(Uri.parse(url));
    //'&borderHighlight=true'
    //&borderHighlightRadius=20'
    //'&borderHighlightColor=$borderColor'

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
        errorMessage = response.reasonPhrase!;
      });
    }
  }

  void _loadRenderType() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _renderTypeVal = prefs.getString('render_type_val') ?? 'default';
    });
  }

  void _loadRenderView() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _renderViewVal = prefs.getString('render_view_val') ?? 'full';
    });
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
    stopIncorrectValuesNoSaveVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEdgeDragWidth: MediaQuery.of(context).size.width,
      appBar: AppBar(
        title: const Text(
          "Create A Look 😝",
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
                          value: _renderTypeVal,
                          onChanged: (String? newValue) {
                            setState(() {
                              _renderTypeVal = newValue!;
                              stopIncorrectValuesNoSaveVersion();
                              custom(_name);
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
                          value: _renderViewVal,
                          onChanged: (String? newValue) {
                            setState(() {
                              _renderViewVal = newValue!;
                              custom(_name);
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
              hasTextLoaded && hasImageLoaded
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Toggle Isometric"),
                            Switch(
                              value: isometric,
                              onChanged: (value) {
                                setState(() {
                                  isometric = value;
                                  custom(_name);
                                });
                              },
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text("Toggle Shadow"),
                            Switch(
                              value: dropShadow,
                              onChanged: (value) {
                                setState(() {
                                  dropShadow = value;
                                  custom(_name);
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 400,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _xCamPos,
                                  decoration: const InputDecoration(
                                    labelText: "x for camera position",
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^-?\d*$')),
                                  ],
                                  onSubmitted: (value) async {
                                    FocusScope.of(context).unfocus();
                                    await fetchHuman(_search.text);
                                  },
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _yCamPos,
                                  decoration: const InputDecoration(
                                    labelText: "y for camera position",
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^-?\d*$')),
                                  ],
                                  onSubmitted: (value) async {
                                    FocusScope.of(context).unfocus();
                                    await fetchHuman(_search.text);
                                  },
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _zCamPos,
                                  decoration: const InputDecoration(
                                    labelText: "z for camera position",
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^-?\d*$')),
                                  ],
                                  onSubmitted: (value) async {
                                    FocusScope.of(context).unfocus();
                                    await fetchHuman(_search.text);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 400,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _xCamFocPon,
                                  decoration: const InputDecoration(
                                    labelText: "X Focal Position",
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^-?\d*$')),
                                  ],
                                  onSubmitted: (value) async {
                                    FocusScope.of(context).unfocus();
                                    await fetchHuman(_search.text);
                                  },
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _yCamFocPon,
                                  decoration: const InputDecoration(
                                    labelText: "Y Focal Position",
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^-?\d*\.?\d*$')),
                                  ],
                                  onSubmitted: (value) async {
                                    FocusScope.of(context).unfocus();
                                    await fetchHuman(_search.text);
                                  },
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _zCamFocPon,
                                  decoration: const InputDecoration(
                                    labelText: "Z Focal Position",
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^-?\d*\.?\d*$')),
                                  ],
                                  onSubmitted: (value) async {
                                    FocusScope.of(context).unfocus();
                                    await fetchHuman(_search.text);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 400,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _directLightIntensity,
                                  decoration: const InputDecoration(
                                    labelText: "DirectLight",
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^-?\d*$')),
                                    rangeTextInputFormatter(
                                        -99999999999, 999999999999),
                                  ],
                                  onSubmitted: (value) async {
                                    FocusScope.of(context).unfocus();
                                    await fetchHuman(_search.text);
                                  },
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _globalLightIntensity,
                                  decoration: const InputDecoration(
                                    labelText: "GlobalLight",
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^-?\d*$')),
                                    rangeTextInputFormatter(
                                        -99999999999, 999999999999),
                                  ],
                                  onSubmitted: (value) async {
                                    FocusScope.of(context).unfocus();
                                    await fetchHuman(_search.text);
                                  },
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _renderScale,
                                  decoration: const InputDecoration(
                                    labelText: "RenderScale (0-3)",
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                    rangeTextInputFormatter(0, 3),
                                  ],
                                  onSubmitted: (value) async {
                                    FocusScope.of(context).unfocus();
                                    await fetchHuman(_search.text);
                                  },
                                ),
                              ),
                            ],
                          ),
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
                              Text(
                                _name,
                                style: const TextStyle(fontSize: 24),
                              ),
                              const Expanded(child: SizedBox()),
                              SizedBox(
                                width: 150,
                                child: Text(
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
                      child: Column(
                        children: [
                          Text("Something Went Wrong $errorMessage"),
                          ElevatedButton(
                            onPressed: () {
                              _xCamPos.text = "11.92";
                              _yCamPos.text = "15.81";
                              _zCamPos.text = "-29.71";
                              _xCamFocPon.text = "0.31";
                              _yCamFocPon.text = "18.09";
                              _zCamFocPon.text = "1.32";
                              custom(_name);
                            },
                            child: const Text("Reset?"),
                          )
                        ],
                      ),
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
                                "/storage/emulated/0/Download/$_name-$_renderTypeVal-$_renderViewVal-$timeStamp.png");
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
            icon: Icon(Icons.person),
            label: 'Current',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.plumbing_sharp),
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
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MinecraftPage()),
        );
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SeeUserByUUIDPage()),
        );
    }
  }
}
