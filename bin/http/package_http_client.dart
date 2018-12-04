import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/plugin_info.dart';
import 'http_exception.dart';

/// httpclient that obtain library information.
class PackageHttpClient {
  final String _baseUrl;

  static PackageHttpClient _instance;

  /// constructor factory.
  /// it possible to specify [baseUrl] for unit test.
  factory PackageHttpClient({String baseUrl = 'https://pub.dartlang.org'}) {
    if (_instance == null) {
      _instance = new PackageHttpClient._internal(baseUrl);
    }
    return _instance;
  }

  PackageHttpClient._internal(this._baseUrl);

  /// Obtain html from pub.dartlang.org.
  /// A [name] paramter is package name.
  Future<String> fetchPackageHtml(String name) async {
    var url = "$_baseUrl/packages/$name";
    var response = await http.get(url, headers: {"Content-Type": "text/html"});
    if (response.statusCode >= 300) {
      throw new HttpException(response.statusCode, response.body);
    }
    return response.body;
  }

  /// Obtain json from pub.dartlang.org.
  /// A [name] paramter is package name.
  Future<PluginInfo> fetchPackageJson(String name) async {
    var url = "$_baseUrl/api/packages/$name";
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    if (response.statusCode >= 300) {
      throw new HttpException(response.statusCode, response.body);
    }
    PluginInfo package = PluginInfo.fromJson(name, json.decode(response.body));
    return package;
  }
}
