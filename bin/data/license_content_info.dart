/// License terms class.
class LicenseContentInfo {
  final String licenseContent;

  String _licenseYear;
  String _licenseAuthor;

  /// license year.
  String get licenseYear => _licenseYear;

  /// license author.
  String get licenseAuthor => _licenseAuthor;

  /// whether BSD-3.
  /// if true, BSD-3.
  bool get isBSD3 {
    if (this.licenseContent == null) {
      return false;
    }
    var contentWithoutLineBreaks = licenseContent
        .replaceAll("\n", "")
        .replaceAll("//", "")
        .replaceAll(" ", "");

    var pattern = RegExp(
        r"Neither the name of (.*). nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission."
            .replaceAll(" ", ""));
    return contentWithoutLineBreaks.contains(pattern);
  }

  LicenseContentInfo(this.licenseContent) {
    extractWithBSDPattern();
    extractWithMITPattern();
    extractWithApatch2Pattern();
  }

  /// case of BSD, extract year and author.
  /// By doing this, it is possible to get [licenseYear] and [licenseAuthor].
  void extractWithBSDPattern() {
    if (licenseContent != null) {
      if (_licenseYear == null || _licenseAuthor == null) {
        var pattern = r"(\d{4})[,| ](.*)[.|\n][ ]?All rights reserved.";

        RegExp regExp = new RegExp(
          pattern,
          caseSensitive: false,
          multiLine: true,
        );

        Match match = regExp.firstMatch(licenseContent);
        if (match != null) {
          _licenseYear = match.group(1);
          String author = match.group(2);
          if (author != null) {
            _licenseAuthor = author.trim();
          }
        }
      }
    }
  }

  /// case of MIT, extract year and author.
  /// By doing this, it is possible to get [licenseYear] and [licenseAuthor].
  void extractWithMITPattern() {
    if (licenseContent != null) {
      if (_licenseYear == null || _licenseAuthor == null) {
        var pattern = r'Copyright \(c\) (\d{4}|\d{4}-\d{4}) (.*)';

        RegExp regExp = new RegExp(
          pattern,
          caseSensitive: false,
          multiLine: true,
        );

        Match match = regExp.firstMatch(licenseContent);
        if (match != null) {
          _licenseYear = match.group(1);
          String author = match.group(2);
          if (author != null) {
            _licenseAuthor = author.trim();
          }
        }
      }
    }
  }

  /// case of Apatch 2.0, extract year and author.
  /// By doing this, it is possible to get [licenseYear] and [licenseAuthor].
  void extractWithApatch2Pattern() {
    if (licenseContent != null) {
      if (_licenseYear == null || _licenseAuthor == null) {
        var pattern = r'Copyright (\d{4}) (.*)';

        RegExp regExp = new RegExp(
          pattern,
          caseSensitive: false,
          multiLine: true,
        );

        Match match = regExp.firstMatch(licenseContent);
        if (match != null) {
          _licenseYear = match.group(1);
          String author = match.group(2);
          if (author != null) {
            _licenseAuthor = author.trim();
          }
        }
      }
    }
  }
}
