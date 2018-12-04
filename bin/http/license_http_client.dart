import 'dart:async';

import 'package:http/http.dart' as http;

import 'http_exception.dart';

/// http client that obtain license content.
class LicenseHttpClient {
  final String _url;

  LicenseHttpClient(this._url);

  /// Obtain license content text.
  Future<String> fetchLicense() async {
    var response =
        await http.get(_url, headers: {"Content-Type": "text/plain"});
    if (response.statusCode >= 300) {
      throw new HttpException(response.statusCode, response.body);
    }
    return response.body;
  }
}
