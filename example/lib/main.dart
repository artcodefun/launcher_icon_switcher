import 'package:flutter/material.dart';
import 'package:launcher_icon_switcher/launcher_icon_switcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

enum AppIcons {
  whiteBlue('WhiteBlue'),
  whitePink('WhitePink'),
  blackBlue('BlackBlue'),
  blackPink('BlackPink');

  final String name;

  const AppIcons(this.name);
}

class _MyAppState extends State<MyApp> {
  final _launcherIconSwitcherPlugin = LauncherIconSwitcher();
  bool isInitialized = false;
  String? currentIcon;

  @override
  void initState() {
    initPlugin();
    super.initState();
  }

  Future initPlugin() async {
    await _launcherIconSwitcherPlugin.initialize(
        AppIcons.values.map((e) => e.name).toList(), AppIcons.whiteBlue.name);
    currentIcon = await _launcherIconSwitcherPlugin.getCurrentIcon();
    setState(() => isInitialized = true);
  }

  Future changeIcon(AppIcons icon) async {
    await _launcherIconSwitcherPlugin.setIcon(icon.name);
    setState(() => currentIcon = icon.name);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: isInitialized
              ? Wrap(
                  spacing: 50,
                  runSpacing: 50,
                  alignment: WrapAlignment.center,
                  children: AppIcons.values
                      .map((e) => GestureDetector(
                            onTap: () => changeIcon(e),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: currentIcon == e.name
                                          ? Colors.green
                                          : Colors.black45,
                                      width: 2),
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/sharp-${e.name.replaceAllMapped(RegExp(r'[A-Z]'), (match) => ' ${match.group(0)!.toLowerCase()}').trim().split(' ').join('-')}.png'))),
                            ),
                          ))
                      .toList(),
                )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
