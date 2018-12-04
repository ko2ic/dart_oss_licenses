import 'dart:io';

import 'package:tuple/tuple.dart';

import '../data/plugin_html_info.dart';
import '../data/plugin_info.dart';
import 'commons/format_holdable.dart';

/// Class handling data format for displaying license information with Settings.bundle on ios.
class SettingsBundlePlistFormat extends FormatHoldable {
  /// Format the license terms per library.
  @override
  dynamic format(PluginInfo pluginInfo, PluginHtmlInfo pluginHtmlInfo) {
    var licenseContent = pluginHtmlInfo.licenseContentInfo.licenseContent
        .replaceAll("&", "&amp;")
        .replaceAll("<", "&lt;")
        .replaceAll(">", "&gt;");

    var formatRoot = '''
		<dict>
			<key>File</key>
			<string>com.ko2ic.dart-oss-licenses/${pluginInfo.name}</string>
			<key>Title</key>
			<string>${pluginInfo.name}</string>
			<key>Type</key>
			<string>PSChildPaneSpecifier</string>
		</dict>
''';

    var formatDetail = '''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>PreferenceSpecifiers</key>
	<array>
		<dict>
			<key>FooterText</key>
			<string>${licenseContent}</string>
			<key>Type</key>
			<string>PSGroupSpecifier</string>
		</dict>
	</array>
</dict>
</plist>
''';

    return Tuple3(formatRoot, pluginInfo.name, formatDetail);
  }

  /// Write formated text to file.
  @override
  void write() async {
    Map environmentVars = Platform.environment;
    String directoryPath =
        '${environmentVars["PWD"]}/ios/Runner/Settings.bundle';
    if (FileSystemEntity.typeSync(directoryPath) ==
        FileSystemEntityType.notFound) {
      throw AssertionError(
          "$directoryPath is not found. Please create New File(Settings Bundle) on Xcode.");
    }

    String fullPath = "$directoryPath/com.ko2ic.dart-oss-licenses.plist";

    var tuples = outputTargets.cast<Tuple3<String, String, String>>();
    var rootOutput = tuples.map((tuple) {
      return tuple.item1;
    });

    var output = """\
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>PreferenceSpecifiers</key>
	<array>
${rootOutput.join("\n")}	
	</array>
</dict>
</plist>
""";
    File file = File(fullPath);
    doWrite(file, output);

    String subDirectoryPath =
        '${environmentVars["PWD"]}/ios/Runner/Settings.bundle/com.ko2ic.dart-oss-licenses';
    await new Directory(subDirectoryPath).create(recursive: true);

    tuples.forEach((tuple) {
      var name = tuple.item2;
      var detailOutput = tuple.item3;

      var file = File("$subDirectoryPath/$name.plist");

      doWrite(file, detailOutput);
    });
  }
}
