import 'about_libraries_format.dart';
import 'commons/format_holdable.dart';
import 'settings_bundle_plist_format.dart';

/// Get instance of all formats class.
List<FormatHoldable> instanceAllFormats() {
  return [
    AboutLibrariesFormat(),
    SettingsBundlePlistFormat(),
  ];
}
