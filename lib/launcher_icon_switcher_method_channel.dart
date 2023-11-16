import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'launcher_icon_switcher_platform_interface.dart';

/// An implementation of [LauncherIconSwitcherPlatform] that uses method channels.
class MethodChannelLauncherIconSwitcher extends LauncherIconSwitcherPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('launcher_icon_switcher');

  @override
  Future<void> initialize(List<String> icons, String defaultIcon) async =>
      await methodChannel.invokeMethod('initialize', {'icons': icons, 'defaultIcon': defaultIcon});

  @override
  Future<String> getCurrentIcon() async => (await methodChannel.invokeMethod<String>('getCurrentIcon'))!;

  @override
  Future<void> setIcon(String icon, {bool shouldKeepAlive = true}) async =>
      await methodChannel.invokeMethod('setIcon', {'icon': icon, 'shouldKeepAlive': shouldKeepAlive});
}
