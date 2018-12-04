import 'dart:io';

import 'package:yaml/yaml.dart';

import 'data/data_exception.dart';
import 'data/license_content_info.dart';
import 'data/plugin_html_info.dart';
import 'data/plugin_info.dart';
import 'formats/format_kind.dart';
import 'http/license_http_client.dart';
import 'http/package_http_client.dart';

main(List<String> arguments) async {
  exitCode = 0;

  var names = findPluginNames();

  var allFormats = instanceAllFormats();
  StringBuffer successPackages = StringBuffer();
  StringBuffer errorPackages = StringBuffer();

  for (var name in names) {
    stdout.write("Process... $name");

    try {
      PluginInfo pluginInfo = await PackageHttpClient().fetchPackageJson(name);
      if (pluginInfo == null) {
        throw DataException("Plugin is nof found.");
      }

      var html = await PackageHttpClient().fetchPackageHtml(name);

      var pluginHtmlInfo = PluginHtmlInfo(html, pluginInfo);

      if (pluginHtmlInfo.licenseUrl != null) {
        final licenseContent =
            await LicenseHttpClient(pluginHtmlInfo.licenseUrl).fetchLicense();
        pluginHtmlInfo = pluginHtmlInfo.copyWith(
            licenseContentInfo: LicenseContentInfo(licenseContent));
      }

      allFormats.forEach((format) {
        format.hold(pluginInfo, pluginHtmlInfo);
      });

      stdout.writeln(" Success.");

      successPackages.write("\"$name\",");
    } catch (e) {
      stderr.writeln("\n  => Erorr!: $e");
      errorPackages.write("\"$name\",");
    }
  }

  allFormats.forEach((format) async {
    await format.write();
  });

  stdout.writeln("Succeeded Package List:");
  stdout.writeln(successPackages.toString());
  stdout.writeln("");

  stderr.writeln("Error Package List:");
  stderr.writeln(errorPackages.toString());
}

/// acquire all the names of the using library.
Iterable<dynamic> findPluginNames() {
  Map environmentVars = Platform.environment;
  String path = '${environmentVars["PWD"]}/pubspec.lock';

  if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
    throw AssertionError(
        "pubspec.lock is not found.  Please run the command on the root of project.");
  }

  var lines = File(path).readAsLinesSync();
  var sb = StringBuffer();
  lines.forEach((line) {
    sb.writeln(line);
  });

  var doc = loadYaml(sb.toString());
  var map = doc['packages'] as YamlMap;
  return map.keys;
}
