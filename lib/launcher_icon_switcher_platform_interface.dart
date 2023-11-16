import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'launcher_icon_switcher_method_channel.dart';

abstract class LauncherIconSwitcherPlatform extends PlatformInterface {
  /// Constructs a LauncherIconSwitcherPlatform.
  LauncherIconSwitcherPlatform() : super(token: _token);

  static final Object _token = Object();

  static LauncherIconSwitcherPlatform _instance = MethodChannelLauncherIconSwitcher();

  /// The default instance of [LauncherIconSwitcherPlatform] to use.
  ///
  /// Defaults to [MethodChannelLauncherIconSwitcher].
  static LauncherIconSwitcherPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [LauncherIconSwitcherPlatform] when
  /// they register themselves.
  static set instance(LauncherIconSwitcherPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Initializes plugin with [icons] and [defaultIcon].
  /// Should be called before any other method
  Future<void> initialize(List<String> icons, String defaultIcon) {
    throw UnimplementedError('initialize(List<String> icons, String defaultIcon) has not been implemented.');
  }

  /// Finds out which icon is currently set
  Future<String> getCurrentIcon() {
    throw UnimplementedError('getCurrentIcon() has not been implemented.');
  }

  /// Sets new [icon].
  /// If changing icon requires closing the app and [shouldKeepAlive] is true, plugin will attempt to restart the app
  Future<void> setIcon(String icon, {bool shouldKeepAlive = true}) {
    throw UnimplementedError('setIcon(String icon, {bool shouldKeepAlive = true}) has not been implemented.');
  }
}
