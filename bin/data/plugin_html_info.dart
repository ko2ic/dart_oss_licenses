import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;

import 'data_exception.dart';
import 'license_content_info.dart';
import 'plugin_info.dart';

/// Library information class that can be retrieved from html.
class PluginHtmlInfo {
  final String _html;
  final PluginInfo _pluinInfo;

  /// License content class.
  final LicenseContentInfo licenseContentInfo;

  String _licenseName;
  String _licenseUrl;
  String _repositoryUrl;

  /// license name.
  String get licenseName => _licenseName;

  /// license terms url.
  String get licenseUrl => _licenseUrl;

  /// code repository url of library
  String get repositoryUrl => _repositoryUrl;

  PluginHtmlInfo(this._html, this._pluinInfo, {this.licenseContentInfo}) {
    var document = parse(_html);
    Element aside = document.getElementsByTagName("aside").first;

    aside.querySelectorAll("h3").forEach((element) {
      if (element.nodes.first.text == 'License') {
        _licenseName = element.nextElementSibling.nodes.first.text
            .replaceAll(" (LICENSE)", "")
            .replaceAll(" (", "");
      }
    });

    if (_licenseName == null) {
      throw DataException("License is not found.");
    }

    aside.querySelectorAll("h3").forEach((element) {
      if (element.nodes.first.text == 'License') {
        var firstElement = element.nextElementSibling.children
            .firstWhere((test) => test != null, orElse: () => null);
        if (firstElement != null) {
          _licenseUrl = firstElement.attributes["href"];
          _licenseUrl = licenseUrl
              .replaceAll("github.com", "raw.githubusercontent.com")
              .replaceAll("blob/", "");
        }
      }
    });

    if (_licenseUrl == null) {
      throw DataException("License is not found.");
    }

    aside.getElementsByClassName("link").forEach((link) {
      if (link.nodes.first.text == 'Repository (GitHub)') {
        _repositoryUrl = link.attributes["href"];
      }
    });

    if (_repositoryUrl == null) {
      _repositoryUrl = _pluinInfo.homepage;
    }
  }

  /// copy with [licenseContentInfo].
  PluginHtmlInfo copyWith({
    LicenseContentInfo licenseContentInfo,
  }) {
    return PluginHtmlInfo(
      this._html,
      this._pluinInfo,
      licenseContentInfo: licenseContentInfo,
    );
  }
}
