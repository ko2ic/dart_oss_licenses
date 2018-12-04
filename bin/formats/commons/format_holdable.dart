import 'dart:io';

import 'package:meta/meta.dart';

import '../../data/plugin_html_info.dart';
import '../../data/plugin_info.dart';
import 'format_writable.dart';

/// Represents holding a format that can display the license list.
abstract class FormatHoldable implements FormatWritable {
  List<dynamic> _holder = [];

  /// list of format that can display the license list.
  List<dynamic> get outputTargets => List.unmodifiable(_holder);

  /// Format the license information per library.
  /// Implementation at the inherited destination.
  @protected
  dynamic format(PluginInfo pluginInfo, PluginHtmlInfo pluginHtmlInfo);

  /// Write to [file].
  /// [output] is format text that can display the license list.
  @protected
  void doWrite(File file, String output) async {
    try {
      await file.writeAsString(output);
    } catch (e) {
      throw e;
    }
  }

  /// Hold formated text list.
  void hold(PluginInfo pluginInfo, PluginHtmlInfo pluginHtmlInfo) {
    var outputTarget = format(pluginInfo, pluginHtmlInfo);
    _holder.add(outputTarget);
  }
}
