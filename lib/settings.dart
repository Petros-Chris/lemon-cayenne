import 'package:flutter/material.dart';
import 'package:lemon_cayenne/Drawer.dart';
import 'package:lemon_cayenne/Theme/theme.dart';
import 'package:lemon_cayenne/Theme/theme_provider.dart';
import 'package:provider/provider.dart';

class CustomizePage extends StatefulWidget {
  const CustomizePage({super.key});

  @override
  State<CustomizePage> createState() => _CustomizePageState();
}

class _CustomizePageState extends State<CustomizePage> {
  String _selectedValue = 'Option 1';
  final List<String> _options = ['Option 1', 'Option 2', 'Option 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEdgeDragWidth: MediaQuery.of(context).size.width,
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
      ),
      drawer: DrawerNav(),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Text("App Bar Color"),
                  Expanded(
                    child: SizedBox(),
                  ),
                  DropdownButton<String>(
                    value: _selectedValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedValue = newValue!;
                      });
                    },
                    items: _options.map((String value) {
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
                  Text("Dark Mode"),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Switch(
                    value: isDark, // Current state of the switch
                    onChanged: (bool value) {
                      setState(() {
                        isDark = value; // Update the state
                      });
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
