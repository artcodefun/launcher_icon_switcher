# Launcher Icon Switcher

<img src="https://github.com/artcodefun/launcher_icon_switcher/blob/main/.github/assets/switch-them.png?raw=true" height="138px" width="522px">

[![pub version](https://img.shields.io/pub/v/launcher_icon_switcher.svg)](https://pub.dev/packages/launcher_icon_switcher)
[![likes](https://img.shields.io/pub/likes/launcher_icon_switcher)](https://pub.dev/packages/launcher_icon_switcher/score)
[![popularity](https://img.shields.io/pub/popularity/launcher_icon_switcher)](https://pub.dev/packages/launcher_icon_switcher/score)
[![pub points](https://img.shields.io/pub/points/launcher_icon_switcher)](https://pub.dev/packages/launcher_icon_switcher/score)
[![license](https://img.shields.io/github/license/artcodefun/launcher_icon_switcher.svg)](https://pub.dev/packages/launcher_icon_switcher/license)

A Flutter plugin that allows you to dynamically change your app launcher icon.

| iOS                                                                                                            |  Android                                                                                                           |
|----------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------|
| <img src="https://github.com/artcodefun/launcher_icon_switcher/blob/main/.github/assets/ios-example.gif?raw=true" height="750px" width="342px"> | <img src="https://github.com/artcodefun/launcher_icon_switcher/blob/main/.github/assets/android-example.gif?raw=true" height="750px" width="338px"> |

## Generating icons
First you'll need to generate some icons for your app. For that you can use [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) package. Use CamelCase for your IOS icon names, as these same names will also be used for activity aliases on Android.
Your config might look something like this:

```yaml
flutter_launcher_icons:
  android: "snake_case_icon"
  ios: "CamelCaseIcon"
  remove_alpha_ios: true
  image_path_ios: "assets/launcher/icon-ios.png"
  image_path_android: "assets/launcher/icon-android.png"
```

## Platform Setup
For this plugin to work correctly there needs to be some platform specific setup. Check below on how to add support for Android and iOS

<details><summary>Android</summary>

### Add Activity Aliases

Once you have generated the Android icons, you can use them as launcher icons by adding activity aliases. To do so, disable your main activity in the `AndroidManifest.xml` file and add activity-alias elements for each icon like this:

```xml
<activity
    android:name=".MainActivity"
    android:exported="true"
    android:launchMode="singleTop"
    android:theme="@style/LaunchTheme"
    android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
    android:hardwareAccelerated="true"
    android:windowSoftInputMode="adjustResize"
    android:enabled="false"
    >
    <meta-data
        android:name="io.flutter.embedding.android.NormalTheme"
        android:resource="@style/NormalTheme"
        />
    <intent-filter>
        <action android:name="android.intent.action.MAIN"/>
        <category android:name="android.intent.category.LAUNCHER"/>
    </intent-filter>
</activity>
<activity-alias
    android:name=".DefaultIcon"
    android:icon="@mipmap/default_icon"
    android:enabled="true"
    android:exported="true"
    android:targetActivity=".MainActivity">
    <intent-filter>
        <action android:name="android.intent.action.MAIN"/>
        <category android:name="android.intent.category.LAUNCHER"/>
    </intent-filter>
</activity-alias>
<activity-alias
    android:name=".AdditionalIcon"
    android:icon="@mipmap/additional_icon"
    android:enabled="false"
    android:exported="true"
    android:targetActivity=".MainActivity">
    <intent-filter>
        <action android:name="android.intent.action.MAIN"/>
        <category android:name="android.intent.category.LAUNCHER"/>
    </intent-filter>
</activity-alias>
```

Make sure, that the only enabled alias is the default one.

</details>

<details><summary>iOS</summary>

### Enable IOS Alternate App Icons

Open your ios project in Xcode, select your app target, go to __Build Settings__ tab and add the following changes:

* enable `Include All App Icon Assets` option
* and all your icons to `Alternate App Icon Sets`
* set `Primary App Icon Set Name` to your default icon

<img src="https://github.com/artcodefun/launcher_icon_switcher/blob/main/.github/assets/xcode-explanation.png?raw=true" height="660px" width="1124px">
</details>

## Usage

Congratulations, you can now use the plugin!!! 🥳🎉🎊

### Setup
First of all you need to initialize the plugin with your icons:
```dart
LauncherIconSwitcher().initialize(['DefaultIcon', 'AdditionalIcon', 'OneMoreIcon'], 'DefaultIcon');
```

### Retreving current icon
To know which icon is currently enabled call 
```dart
LauncherIconSwitcher().getCurrentIcon();
```

### Updating launcher icon
In order to set new icon as your launcher icon call
```dart
LauncherIconSwitcher().setIcon('AdditionalIcon');
```

For a more detailed usage example, see [here](https://github.com/artcodefun/launcher_icon_switcher/tree/main/example).