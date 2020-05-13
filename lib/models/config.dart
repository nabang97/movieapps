class Language {
  String iso6391;
  String englishName;
  String name;

  Language({this.iso6391, this.englishName, this.name});

  factory Language.fromJson(Map<String, dynamic> json) => Language(
      iso6391: json['iso_639_1'],
      englishName: json['english_name'],
      name: json['name']);

  Map<String, dynamic> toJson() =>
      {'iso_639_1': iso6391, 'english_name': englishName, 'name': name};
}
