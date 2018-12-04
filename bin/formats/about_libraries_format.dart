import 'dart:io';

import '../data/plugin_html_info.dart';
import '../data/plugin_info.dart';
import 'commons/format_holdable.dart';

/// Class handling data format for displaying license information with [AboutLibraries](https://github.com/mikepenz/AboutLibraries) on Android.
class AboutLibrariesFormat extends FormatHoldable {
  /// Format the license information per library.
  @override
  dynamic format(PluginInfo pluginInfo, PluginHtmlInfo pluginHtmlInfo) {
    String licenseName = pluginHtmlInfo.licenseName;

    if (licenseName == "BSD") {
      if (pluginHtmlInfo.licenseContentInfo.isBSD3) {
        licenseName = "bsd_3";
      } else {
        licenseName = "bsd_2";
      }
    } else if (licenseName == "MIT") {
      licenseName = "mit";
    } else if (licenseName == "Apache 2.0") {
      licenseName = "apache_2_0";
    }

    var description = pluginInfo.description
        .replaceAll("'", "\\'")
        .replaceAll('"', '\\"')
        .replaceAll("&", "&amp;");

    var format = '''
    <!-- ${pluginInfo.name} -->
    <string name="define_int_${pluginInfo.name}">year;owner</string>
    <string name="library_${pluginInfo.name}_author">${pluginInfo.author}</string>
    <string name="library_${pluginInfo.name}_libraryName">${pluginInfo.name}</string>
    <string name="library_${pluginInfo.name}_libraryDescription">$description</string>
    <string name="library_${pluginInfo.name}_libraryWebsite">
    ${pluginInfo.homepage}
    </string>
    <string name="library_${pluginInfo.name}_isOpenSource">true</string>
    <string name="library_${pluginInfo.name}_repositoryLink">${pluginHtmlInfo.repositoryUrl}</string>
    <string name="library_${pluginInfo.name}_licenseId">$licenseName</string>
    <!-- Custom variables section -->
    <string name="library_${pluginInfo.name}_year">${pluginHtmlInfo.licenseContentInfo.licenseYear ?? "TODO"}</string>
    <string name="library_${pluginInfo.name}_owner">${pluginHtmlInfo.licenseContentInfo.licenseAuthor ?? pluginInfo.author ?? "TODO"}</string>
''';
    return format;
  }

  /// Write formated text to file.
  @override
  void write() async {
    Map environmentVars = Platform.environment;
    String directoryPath =
        '${environmentVars["PWD"]}/android/app/src/main/res/values';
    String fullPath = "$directoryPath/license_strings.xml";
    await new Directory(directoryPath).create(recursive: true);
    var output = """\
<?xml version="1.0" encoding="utf-8"?>
<resources>
${outputTargets.join("\n")}
</resources>
""";
    if (FileSystemEntity.typeSync(fullPath) == FileSystemEntityType.notFound) {
      File file = File(fullPath);
      doWrite(file, output);
    } else {
      File file = File("$fullPath.temp");
      doWrite(file, output);
    }
  }
}
