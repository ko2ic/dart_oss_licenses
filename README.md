# dart_oss_licenses

CLI tool that generate OSS license list of dart used in your project.


# Getting Started

install Dart SDK.

For example, if you are using homebrew with mac.

```
$ brew tap dart-lang/dart
$ brew install dart
```

inatall dart-oss-licenses.

```
$ pub global activate dart-oss-licenses
```

run in your project root (exists pubspec.lock).
But you have task to do before that.

```
$ cd <your project root>
$ dart-oss-licenses
```

## For ios

In ios, it is realized with settings.bundle. So make it.

On Menu of Xcode   
__File__ -> __New__ -> __File...__ -> Select __Settings.bundle__ -> Next -> __Create__ as ```<Project>/ios/Runner/Settings.bundle```

Then Rewrite Root.plist as follows.

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>PreferenceSpecifiers</key>
	<array>
		<dict>
			<key>Type</key>
			<string>PSChildPaneSpecifier</string>
			<key>Title</key>
			<string>Licenses</string>
			<key>File</key>
			<string>com.ko2ic.dart-oss-licenses</string>
		</dict>
	</array>
	<key>StringsTable</key>
	<string>Root</string>
</dict>
</plist>
```

en.lproj/Root.strings

```
"Licenses" = "Licenses";
```

By doing this, the above command will succeed.

### Application Code

In order to transition from the application, write the following.

```
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private var _result: FlutterResult?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "sample/platform",
                                                 binaryMessenger: controller)
        channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method {
            case "toOssLicense":
                if let url = URL(string: UIApplicationOpenSettingsURLString) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            default:
                result(FlutterMethodNotImplemented)
                break
            }
        })
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
```

### For OSS used in native

dart_oss_licenses supports dart's OSS only.   
So native needs to use another tool for ios.   

The recommendation is [LicensePlist](https://github.com/mono0926/LicensePlist).   
It also supports CocoaPods, Carthage and Manual(Git SubModule, direct sources and so on).

Merge results of dart_oss_licenses and LicensePlist.

## For Android

Currently, only [AboutLibraries](https://github.com/mikepenz/AboutLibraries) is supported.

Run command then generated in ```/android/app/src/main/res/values/license_strings.xml```.

If it already exists, generated in ```/android/app/src/main/res/values/license_strings.xml.temp```.

Since license_strings.xml is not perfect in some cases, you need to complete it yourself.

If the tool fails to acquire information, it is written ```TODO```, so you can search for it and fix it.

### Application Code

android/app/build.gradle

```
dependencies {
    implementation "com.mikepenz:aboutlibraries:6.1.1"
```

Replace <package name> with the command outputted ```Succeeded Package List```.

```
class MainActivity() : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        MethodChannel(
            flutterView,
            "sample/platform"
        ).setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
            when (call.method) {
                "toOssLicense" -> {
                    LibsBuilder()
                        .withActivityStyle(Libs.ActivityStyle.LIGHT_DARK_TOOLBAR)
                        .withActivityTitle("Licenses")
                        .withLicenseShown(true)
                        .withLibraries(
                            <package name>
                        )
                        //start the activity
                        .start(this)
                }
            }
        }
    }
}
```

## Dart

Finally you can complete the following method with ui.

```
  static const platform = const MethodChannel('sample/platform');

  Future<void> toOssLicense() {
    return platform.invokeMethod('toOssLicense', {});
  }
```

# Contributing

Anything, such as corresponding to other formats, is happy. Please feel free Pull Request.

## How to create other format

Please refer to ```formats``` package and implement the ```FormatHoldable``` interface.

then add a instance in ```formats/format_kind.dart```.

```
 List<FormatHoldable> instanceAllFormats() {
   return [
     AboutLibrariesFormat(),
     SettingsBundlePlistFormat(),
+    SomethingFormat(),
   ];
 }
```



