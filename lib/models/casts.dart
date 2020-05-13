class Casts {
  int id;
  List<Cast> cast;

  Casts({this.id, this.cast});

  factory Casts.fromJson(Map<String, dynamic> json) => Casts(
      id: json["id"],
      cast: List<Cast>.from(json["cast"].map((x) => Cast.fromJson(x))));

  Map<String, dynamic> toJson() =>
      {"id": id, "cast": List<dynamic>.from(cast.map((x) => x.toJson()))};
}

class Cast {
  int castId;
  String character;
  int id;
  String name;
  String profilePath;
  String creditId;

  Cast(
      {this.castId,
      this.character,
      this.id,
      this.name,
      this.profilePath,
      this.creditId});

  factory Cast.fromJson(Map<String, dynamic> json) => Cast(
        castId: json["cast_id"],
        character: json["character"],
        id: json["id"],
        name: json["name"],
        profilePath: json["profile_path"],
        creditId: json["credit_id"],
      );

  Map<String, dynamic> toJson() => {
        "cast_id": castId,
        "character": character,
        "id": id,
        "name": name,
        "profile_path": profilePath,
        "credit_id": creditId
      };

  factory Cast.fromDB(Map<String, dynamic> json) => Cast(
        castId: json["cast_id"],
        character: json["character"],
        id: json["id"],
        name: json["name"],
        profilePath: json["profile_path"],
        creditId: json["credit_id"],
      );
}
