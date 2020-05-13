import 'package:movieapps/models/genre.dart';
import 'package:movieapps/models/moviedetail.dart';

class Persons {
  int page;
  List<Person> results;
  int totalResults;
  int totalPages;

  Persons({this.page, this.results, this.totalResults, this.totalPages});

  factory Persons.fromJson(Map<String, dynamic> json) => Persons(
      page: json['page'],
      results:
          List<Person>.from(json["results"].map((x) => Person.fromJson(x))),
      totalResults: json['total_results'],
      totalPages: json['total_pages']);

  Map<String, dynamic> toJson() => {
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "total_results": totalResults,
        "total_pages": totalPages
      };
}

class Person {
  String profilePath;
  bool adult;
  int id;
  List<KnownFor> knownFor;
  String name;

  Person({this.profilePath, this.adult, this.id, this.knownFor, this.name});

  factory Person.fromJson(Map<String, dynamic> json) => Person(
      profilePath: json['profile_path'],
      adult: json['adult'],
      id: json['id'],
      knownFor: json['known_for'] != null
          ? List<KnownFor>.from(
              json["known_for"].map((x) => KnownFor.fromJson(x)))
          : List<KnownFor>(),
      name: json['name']);

  Map<String, dynamic> toJson() => {
        "profile_path": profilePath,
        "adult": adult,
        "id": id,
        "known_for": List<dynamic>.from(knownFor.map((x) => x.toJson())),
        "name": name
      };
}

class KnownFor {
  String posterPath;
  String mediaType;
  int id;

  KnownFor({this.posterPath, this.mediaType, this.id});

  factory KnownFor.fromJson(Map<String, dynamic> json) => KnownFor(
        posterPath: json['poster_path'],
        mediaType: json['media_type'],
        id: json['id'],
      );

  Map<String, dynamic> toJson() =>
      {"poster_path": posterPath, "media_type": mediaType, "id": id};
}

class PersonDetail {
  String birthday;
  String knownForDepartment;
  String deathDay;
  int id;
  String name;

//  List<String> alsoKnownAs;
  int gender;
  String biography;
  double popularity;
  String placeOfBirth;
  String profilePath;
  bool adult;
  String imdbId;
  String homepage;

  PersonDetail(
      {this.birthday,
      this.knownForDepartment,
      this.deathDay,
      this.id,
      this.name,
//    this.alsoKnownAs,
      this.gender,
      this.biography,
      this.popularity,
      this.profilePath,
      this.adult,
      this.imdbId,
      this.homepage});

  factory PersonDetail.fromJson(Map<String, dynamic> json) => PersonDetail(
      birthday: json['birthday'],
      knownForDepartment: json['known_for_department'],
      deathDay: json['death_day'],
      id: json['id'],
      name: json['name'],
//    alsoKnownAs:json['also_known_as'] != null? List<String>.from(json['also_known_as'].map((x)=>x)) : List<String>(),
      gender: json['gender'],
      biography: json['biography'],
      popularity: json['popularity'].toDouble(),
      profilePath: json['profile_path'],
      adult: json['adult'],
      imdbId: json['imdb_id'],
      homepage: json['homepage']);

  Map<String, dynamic> toJson() => {
        'birthday': birthday,
        'known_for_department': knownForDepartment,
        'death_day': deathDay,
        'id': id,
        'name': name,
//    'also_known_as':List<dynamic>.from(alsoKnownAs.map((x)=>x)),
        'gender': gender,
        'biography': biography,
        'popularity': popularity,
        'profile_path': profilePath,
        'adult': adult,
        'imdb_id': imdbId,
        'homepage': homepage
      };
}

class PersonMovies {
  int id;
  List<PersonCastMovie> cast;
  List<PersonCrewMovie> crew;

  PersonMovies({this.id, this.cast, this.crew});

  factory PersonMovies.fromJson(Map<String, dynamic> json) => PersonMovies(
      id: json['id'],
      cast: List<PersonCastMovie>.from(
          json['cast'].map((x) => PersonCastMovie.fromJson(x))),
      crew: List<PersonCrewMovie>.from(
          json['crew'].map((x) => PersonCrewMovie.fromJson(x))));
}

class PersonTvs {
  int id;
  List<PersonCastMovie> cast;
  List<PersonCrewMovie> crew;

  PersonTvs({this.id, this.cast, this.crew});

  factory PersonTvs.fromJson(Map<String, dynamic> json) => PersonTvs(
      id: json['id'],
      cast: List<PersonCastMovie>.from(
          json['cast'].map((x) => PersonCastMovie.fromJson(x))),
      crew: List<PersonCrewMovie>.from(
          json['crew'].map((x) => PersonCrewMovie.fromJson(x))));
}

class PersonCastMovie {
  int id;
  String character;
  Result movie;

  PersonCastMovie({this.character, this.id, this.movie});

  factory PersonCastMovie.fromJson(Map<String, dynamic> json) =>
      PersonCastMovie(
          character: json['character'],
          id: json['id'],
          movie: Result(
              popularity: json['popularity'].toDouble(),
              voteCount: json['vote_count'],
              video: json['video'],
              adult: json['adult'],
              voteAverage: json['vote_average'].toDouble(),
              title: json['title'],
              originalLanguage: json[' original_language'],
              originalTitle: json['original_title'],
              id: json['id'],
              backdropPath: json['backdrop_path'],
              overview: json['overview'],
              posterPath: json['poster_path'],
              genres: json['genre_ids'] != null
                  ? List<GenreModel>.from(
                      json['genre_ids'].map((x) => GenreModel.getJson(x)))
                  : List<GenreModel>(),
              favorite: false));

  Map<String, dynamic> toJson() =>
      {'character': character, 'id': id, 'movie': movie};
}

class PersonCrewMovie {
  String job;
  String department;
  String posterPath;
  int id;
  String name;

  PersonCrewMovie(
      {this.job, this.department, this.posterPath, this.id, this.name});

  factory PersonCrewMovie.fromJson(Map<String, dynamic> json) =>
      PersonCrewMovie(
        job: json['job'],
        department: json['department'],
        posterPath: json['poster_path'],
        id: json['id'],
        name: json['title'],
      );

  Map<String, dynamic> toJson() => {
        'job': job,
        'department': department,
        'poster_path': posterPath,
        'id': id,
        'title': name
      };
}
