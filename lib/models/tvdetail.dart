import 'package:movieapps/models/genre.dart';

class ResultTv {
  String posterPath;
  double popularity;
  int id;
  String backdropPath;
  double voteAverage;
  String overview;
  String firstAirDate;
  List<GenreModel> genres;
  String originalLanguage;
  int voteCount;
  String name;
  String originalName;
  bool favorite;

  ResultTv({
    this.posterPath,
    this.popularity,
    this.id,
    this.backdropPath,
    this.voteAverage,
    this.overview,
    this.firstAirDate,
    this.genres,
    this.originalLanguage,
    this.voteCount,
    this.name,
    this.originalName,
    this.favorite,
  });

  factory ResultTv.fromJson(Map<String, dynamic> json) => ResultTv(
      posterPath: json["poster_path"],
      popularity: json["popularity"].toDouble(),
      id: json["id"],
      backdropPath: json["backdrop_path"],
      voteAverage: json["vote_average"].toDouble(),
      overview: json["overview"],
      firstAirDate: json["first_air_date"],
      genres: json["genres"] != null
          ? List<GenreModel>.from(
              json["genres"].map((x) => GenreModel.fromJson(x)))
          : List<GenreModel>(),
      originalName: json["original_name"],
      voteCount: json["vote_count"],
      name: json["name"],
      originalLanguage: json["original_language"],
      favorite: json['favorite'] == 1 ? true : false);

  Map<String, dynamic> toJson() => {
        "poster_path": posterPath,
        "popularity": popularity,
        "id": id,
        "backdrop_path": backdropPath,
        "vote_average": voteAverage,
        "overview": overview,
        "first_air_date": firstAirDate,
        "original_name": originalName,
        "vote_count": voteCount,
        "name": name,
        "original_language": originalLanguage,
        "favorite": favorite
      };
}

class TvCastsDB {
  int tvId;
  int personId;
  String character;
  String creditId;

  TvCastsDB({this.tvId, this.personId, this.character, this.creditId});

  factory TvCastsDB.fromDB(Map<String, dynamic> json) => TvCastsDB(
        character: json['character'],
        personId: json['person_id'],
        tvId: json['tv_id'],
        creditId: json['credit_id'],
      );

  Map<String, dynamic> toJson() => {
        'tv_id': tvId,
        'character': character,
        'person_id': personId,
        'credit_id': creditId
      };
}
