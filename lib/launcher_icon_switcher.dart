import 'launcher_icon_switcher_platform_interface.dart';

class LauncherIconSwitcher {
  /// Initializes plugin with [icons] and [defaultIcon].
  /// Should be called before any other method
  Future<void> initialize(List<String> icons, String defaultIcon) async {
    assert(icons.isNotEmpty, 'icons cant be empty');
    assert(icons.contains(defaultIcon), 'icons must contain defaultIcon');

    await LauncherIconSwitcherPlatform.instance.initialize(icons, defaultIcon);
  }

  /// Finds out which icon is currently set
  Future<String> getCurrentIcon() => LauncherIconSwitcherPlatform.instance.getCurrentIcon();

  /// Sets new [icon].
  /// If changing icon requires closing the app and [shouldKeepAlive] is true, plugin will attempt to restart the app
  Future<void> setIcon(String icon, {bool shouldKeepAlive = true}) =>
      LauncherIconSwitcherPlatform.instance.setIcon(icon, shouldKeepAlive: shouldKeepAlive);
}
