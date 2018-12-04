/// Library Information class.
class PluginInfo {
  final String name;

  final String author;

  final String description;

  final String homepage;

  PluginInfo(this.name, this.author, this.description, this.homepage);

  /// instance from json.
  static PluginInfo fromJson(String name, Map<String, dynamic> json) {
    var pubspec = json['latest']['pubspec'];
    var author = pubspec["author"] as String;
    if (author != null) {
      author = removeMail(author);
    } else {
      var authors = pubspec["authors"];
      if (authors != null) {
        author = authors.map((value) {
          return removeMail(value);
        }).join(",");
      } else {
        author = "";
      }
    }

    return PluginInfo(
        name, author, pubspec["description"], pubspec["homepage"]);
  }

  /// remove mail information from [author].
  static String removeMail(String author) {
    int start = author.indexOf("<");
    int end = author.indexOf(">") + 1;
    author = author.replaceRange(start, end, "").trim();
    return author;
  }
}
