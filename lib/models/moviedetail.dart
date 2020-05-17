import 'package:movieapps/models/genre.dart';
import 'package:intl/intl.dart';

class Result {
  double popularity;
  int voteCount;
  bool video;
  String posterPath;
  int id;
  bool adult;
  String backdropPath;
  String originalLanguage;
  String originalTitle;
  List<GenreModel> genres;
  String title;
  double voteAverage;
  String overview;
  DateTime releaseDate;
  int runtime;
  List spokenLanguage;
  bool favorite;

  Result({
    this.popularity,
    this.voteCount,
    this.video,
    this.posterPath,
    this.id,
    this.adult,
    this.backdropPath,
    this.originalLanguage,
    this.originalTitle,
    this.genres,
    this.title,
    this.voteAverage,
    this.overview,
    this.releaseDate,
    this.runtime,
    this.spokenLanguage,
    this.favorite,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
      popularity: json["popularity"].toDouble(),
      voteCount: json["vote_count"],
      video: json["video"],
      posterPath: json["poster_path"],
      id: json["id"],
      adult: json["adult"],
      backdropPath: json["backdrop_path"],
      originalLanguage: json["original_language"],
      originalTitle: json["original_title"],
      genres: json["genres"] != null
          ? List<GenreModel>.from(
              json["genres"].map((x) => GenreModel.fromJson(x)))
          : List<GenreModel>(),
      title: json["title"],
      voteAverage: json["vote_average"].toDouble(),
      overview: json["overview"],
      releaseDate: json["release_date"] != ""
          ? DateTime.parse(json["release_date"])
          : null,
      runtime: json["runtime"],
      spokenLanguage: json["spoken_languages"] != null
          ? List<SpokeLanguage>.from(
              json["spoken_languages"].map((x) => SpokeLanguage.fromJson(x)))
          : List<SpokeLanguage>(),
      favorite: false);

  Map<String, dynamic> toJson() => {
        "popularity": popularity,
        "vote_count": voteCount,
        "video": video,
        "poster_path": posterPath,
        "id": id,
        "adult": adult,
        "backdrop_path": backdropPath,
        "original_language": originalLanguage,
        "original_title": originalTitle,
        "title": title,
        "vote_average": voteAverage,
        "overview": overview,
        "release_date":
            "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "runtime": runtime,
        "favorite": favorite
      };

  factory Result.fromDB(Map<String, dynamic> json) => Result(
      popularity: json["popularity"].toDouble(),
      voteCount: json["vote_count"],
      video: json["video"] == 1 ? true : false,
      posterPath: json["poster_path"],
      id: json["id"],
      adult: json["adult"] == 1 ? true : false,
      backdropPath: json["backdrop_path"],
      originalLanguage: json["original_language"],
      originalTitle: json["original_title"],
      genres: json["genres"] != null
          ? List<GenreModel>.from(
              json["genres"].map((x) => GenreModel.fromJson(x)))
          : List<GenreModel>(),
      title: json["title"],
      voteAverage: json["vote_average"].toDouble(),
      overview: json["overview"],
      releaseDate: json["release_date"] != ""
          ? DateTime.parse(json["release_date"])
          : null,
      runtime: json["runtime"],
//        spokenLanguage: json["spoken_languages"] != null ? List<SpokeLanguage>.from(json["spoken_languages"].map((x) => SpokeLanguage.fromJson(x))) : List<SpokeLanguage>(),
      favorite: json['favorite'] == 1 ? true : false);
}

class DateFormatCustom {
  String date;

  DateFormatCustom({this.date});

  factory DateFormatCustom.convertDate(DateTime d)=>
      DateFormatCustom(
          date: convertDateToString(d)
      );

}

String convertDateToString(DateTime d) {
  var formatter = new DateFormat('yyyy-MMMM-dd');
  var newFormat = formatter.format(d);
  List<String> splitNewDate = newFormat.split("-");
  String day = splitNewDate[2];
  String month = splitNewDate[1];
  String year = splitNewDate[0];

  String finalFormat = "$month $day, $year";
  return finalFormat;
}

class Dates {
  DateTime maximum;
  DateTime minimum;

  Dates({
    this.maximum,
    this.minimum,
  });

  factory Dates.fromJson(Map<String, dynamic> json) => Dates(
        maximum: DateTime.parse(json["maximum"]),
        minimum: DateTime.parse(json["minimum"]),
      );

  Map<String, dynamic> toJson() => {
        "maximum":
            "${maximum.year.toString().padLeft(4, '0')}-${maximum.month.toString().padLeft(2, '0')}-${maximum.day.toString().padLeft(2, '0')}",
        "minimum":
            "${minimum.year.toString().padLeft(4, '0')}-${minimum.month.toString().padLeft(2, '0')}-${minimum.day.toString().padLeft(2, '0')}",
      };
}

class SpokeLanguage {
  String iso;
  String name;

  SpokeLanguage({this.iso, this.name});

  factory SpokeLanguage.fromJson(Map<String, dynamic> json) =>
      SpokeLanguage(iso: json['iso_639_1'], name: json['name']);

  Map<String, dynamic> toJson() => {'iso_639_1': iso, 'name': name};

  factory SpokeLanguage.fromDB(Map<String, dynamic> json) =>
      SpokeLanguage(iso: json['iso_639_1'], name: json['name']);
}

class MovieCastsDB {
  int movieId;
  int personId;
  String character;
  int castId;
  String creditId;

  MovieCastsDB(
      {this.movieId,
      this.personId,
      this.character,
      this.castId,
      this.creditId});

  factory MovieCastsDB.fromDB(Map<String, dynamic> json) => MovieCastsDB(
        castId: json['cast_id'],
        character: json['character'],
        personId: json['person_id'],
        movieId: json['movie_id'],
        creditId: json['credit_id'],
      );

  Map<String, dynamic> toJson() => {
        'cast_id': castId,
        'movie_id': movieId,
        'character': character,
        'person_id': personId,
        'credit_id': creditId
      };
}
