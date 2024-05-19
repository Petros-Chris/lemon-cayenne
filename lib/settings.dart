import 'package:flutter/material.dart';
import 'package:lemon_cayenne/Drawer.dart';
import 'package:lemon_cayenne/Theme/theme.dart';
import 'package:lemon_cayenne/Theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Theme/color_theme.dart';
import 'const.dart';

class CustomizePage extends StatefulWidget {
  const CustomizePage({super.key});

  @override
  State<CustomizePage> createState() => _CustomizePageState();
}

class _CustomizePageState extends State<CustomizePage> {
  void _saveRenderView() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('render_view_val', renderViewVal);
  }

  void _saveRenderType() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('render_type_val', renderTypeVal);
  }

  @override
  void initState() {
    super.initState();
    switch (isDarkMode) {
      case true:
        {
          colorOptions = colorOptionsDark;
          break;
        }
      case false:
        colorOptions = colorOptionsLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEdgeDragWidth: MediaQuery.of(context).size.width,
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      drawer: const DrawerNav(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Column(
            children: [
              const Row(
                children: [
                  Text(
                    "Main Ui",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text("App Bar Color"),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  DropdownButton<String>(
                    value: colorOption,
                    onChanged: (String? newValue) {
                      setState(() {
                        colorOption = newValue!;
                      });
                      Provider.of<ColorProvider>(context, listen: false)
                          .toggleColor();
                    },
                    items: colorOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const Divider(height: 0),
              Row(
                children: [
                  const Text("Dark Mode"),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  DropdownButton<String>(
                    value: hjel,
                    onChanged: (String? newValue) async {
                      setState(() {
                        hjel = newValue!;
                        isDark = stringToInt[hjel]!;
                      });
                      await Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme();

                      setState(
                        () {
                          switch (isDarkMode) {
                            case true:
                              {
                                colorOptions = colorOptionsDark;
                                colorOption = 'default';
                                Provider.of<ColorProvider>(context,
                                        listen: false)
                                    .toggleColor();
                                break;
                              }
                            case false:
                              colorOptions = colorOptionsLight;
                              colorOption = 'default';
                              Provider.of<ColorProvider>(context, listen: false)
                                  .toggleColor();
                          }
                        },
                      );
                    },
                    items: stringToInt.keys.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const Divider(height: 0),
              const SizedBox(
                height: 10,
              ),
              const Row(
                children: [
                  Text(
                    "Minecraft",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text("Render Type"),
                  const Expanded(
                    child: SizedBox(),
                  ),
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
                              break;
                            }
                          case 'head':
                            {
                              if (renderViewVal != 'full') {
                                renderViewVal = 'full';
                              }
                              renderView = ['full'];
                              break;
                            }
                          default:
                            {
                              renderView = ['full', 'bust', 'face'];
                            }
                        }
                        _saveRenderType();
                      });
                    },
                    items: rendertype.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const Divider(height: 0),
              Row(
                children: [
                  const Text("Render View"),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  DropdownButton<String>(
                    value: renderViewVal,
                    onChanged: (String? newValue) {
                      setState(() {
                        renderViewVal = newValue!;
                        _saveRenderView();
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
              const Divider(height: 0),
            ],
          ),
        ),
      ),
    );
  }
}
