import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:movieapps/models/casts.dart';
import 'package:movieapps/models/genre.dart';
import 'package:movieapps/models/moviedetail.dart';
import 'package:movieapps/models/person.dart';
import 'package:movieapps/models/tvdetail.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final String tableMovie = 'Movies',
    columnPopularity = 'popularity',
    columnVoteCount = 'vote_count',
    columnVideo = 'video',
    columnPosterPath = 'poster_path',
    columnId = 'id',
    columnAdult = 'adult',
    columnBackdropPath = 'backdrop_path',
    columnOriginalLanguage = 'original_language',
    columnOriginalTitle = 'original_title',
    columnGenres = 'genres',
    columnTitle = 'title',
    columnVoteAverage = 'vote_average',
    columnOverview = 'overview',
    columnReleaseDate = 'release_date',
    columnRuntime = 'runtime',
    columnSpokeLanguages = 'spoken_languages',
    columnFavorite = 'favorite';

class MovieDatabase {
  static final MovieDatabase _instance = MovieDatabase._internal();

  factory MovieDatabase() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  MovieDatabase._internal();

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''create table $tableMovie ( 
    $columnPopularity REAL, 
    $columnVoteCount INTEGER,  
    $columnVideo BOOLEAN, 
    $columnPosterPath TEXT,
    $columnId INTEGER primary key not null,
    $columnAdult BIT, 
    $columnBackdropPath TEXT, 
    $columnOriginalLanguage TEXT, 
    $columnOriginalTitle TEXT, 
    $columnTitle TEXT, 
    $columnVoteAverage REAL, 
    $columnOverview TEXT, 
    $columnReleaseDate TEXT, 
    $columnRuntime INTEGER, 
    $columnFavorite BIT)''');
    await db.execute('''create table Tvs (id INTEGER primary key not null,
    poster_path TEXT,
    popularity REAL,
    backdrop_path TEXT,
    vote_average REAL,
    first_air_date TEXT,
    original_language TEXT,
    overview TEXT,
    vote_count INTEGER,
    name TEXT,
    original_name TEXT,
    favorite BIT
    )''');
    await db.execute('''create table Genres_movie(
    id INTEGER primary key not null,
    name TEXT
    )''');

    await db.execute('''create table Genres_tv(
    id INTEGER primary key not null,
    name TEXT
    )''');

    await db.execute('''create table movie_genres(
    movie_id INTEGER not null,
    genre_id INTEGER not null,
    FOREIGN KEY (movie_id) REFERENCES Movies (id) 
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES Genres_movie (id) 
    ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY ( movie_id, genre_id)
    )''');

    await db.execute('''create table tv_genres(
    tv_id INTEGER not null,
    genre_id INTEGER not null,
    FOREIGN KEY (tv_id) REFERENCES Tvs (id) 
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES Genres_tv (id) 
    ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY ( tv_id, genre_id)
    )''');

    await db.execute('''create table Persons(
      id INTEGER primary key not null,
      name TEXT,
      profile_path TEXT,
      birthday TEXT,
      biography TEXT,
      known_for_department TEXT,
      death_day TEXT,
      gender INTEGER,
      popularity REAL,
      place_of_birth TEXT,
      adult BIT,
      imdb_id TEXT,
      homepage TEXT
    )''');
    await db.execute('''create table movie_casts(
    cast_id INTEGER not null,
    movie_id INTEGER not null, 
    character TEXT,
    person_id INTEGER not null,
    credit_id TEXT ,
    FOREIGN KEY (person_id) REFERENCES Persons (id) 
    ON DELETE CASCADE ON UPDATE CASCADE, 
    FOREIGN KEY (movie_id) REFERENCES Movies (id) 
    ON DELETE CASCADE ON UPDATE CASCADE, 
    PRIMARY KEY (cast_id, movie_id)
    )''');

    await db.execute('''create table tv_casts(    
    tv_id INTEGER not null, 
    character TEXT,
    person_id INTEGER not null,
    credit_id TEXT ,
    FOREIGN KEY (person_id) REFERENCES Persons (id) 
    ON DELETE CASCADE ON UPDATE CASCADE, 
    FOREIGN KEY (tv_id) REFERENCES Tvs (id) 
    ON DELETE CASCADE ON UPDATE CASCADE, 
    PRIMARY KEY (person_id, tv_id)
    )''');

    await db.execute('''create table Languages(
    iso_639_1 TEXT primary key not null, 
    english_name TEXT,
    name TEXT
    )''');

    print("Database was Created!");
  }

  Future<List<Result>> getMovies() async {
    var dbClient = await db;
    List<Map> res = await dbClient.query("Movies");
    return res.map((m) => Result.fromDB(m)).toList();
  }

  Future<List<SpokeLanguage>> getLanguages() async {
    var dbClient = await db;
    List<Map> res = await dbClient.query("Languages");
    return res.map((m) => SpokeLanguage.fromDB(m)).toList();
  }

  Future<int> addGenresMovie(GenreModel genre) async {
    var dbClient = await db;
    try {
      int res = await dbClient.insert("Genres_movie", genre.toJson());
      print("Genres TV added $res");
      return res;
    } catch (e) {
      int res = await updateGenresMovie(genre);
      return res;
    }
  }

  Future<int> addGenresTv(GenreModel genre) async {
    var dbClient = await db;
    try {
      int res = await dbClient.insert("Genres_tv", genre.toJson());
      print("Genres Movie added $res");
      return res;
    } catch (e) {
      int res = await updateGenresTv(genre);
      return res;
    }
  }

  Future<int> addLanguages(SpokeLanguage spokeLanguage) async {
    var dbClient = await db;
    try {
      int res = await dbClient.insert("Languages", spokeLanguage.toJson());
      print("Languages added $res");
      return res;
    } catch (e) {
      int res = await updateLanguages(spokeLanguage);
      return res;
    }
  }

  Future<int> updateGenresMovie(GenreModel genre) async {
    var dbClient = await db;
    int res = await dbClient.update("Genres_movie", genre.toJson(),
        where: "id = ?", whereArgs: [genre.id]);
    print("Genres Movie updated $res");
    return res;
  }

  Future<int> updateGenresTv(GenreModel genre) async {
    var dbClient = await db;
    int res = await dbClient.update("Genres_tv", genre.toJson(),
        where: "id = ?", whereArgs: [genre.id]);
    print("Genres TV updated $res");
    return res;
  }

  Future<int> updateLanguages(SpokeLanguage language) async {
    var dbClient = await db;
    int res = await dbClient.update("Languages", language.toJson(),
        where: "iso_639_1 = ?", whereArgs: [language.iso]);
    print("Languages updated $res");
    return res;
  }

  Future<Casts> getMovieCasts(int id) async {
    var dbClient = await db;
    var res = await dbClient
        .rawQuery("SELECT * from movie_casts WHERE movie_id = $id");
    print("hasil : $res");
    var result = await dbClient.rawQuery("SELECT "
        "MC.cast_id as cast_id,  "
        "MC.character as character,"
        "P.id as id, "
        "P.name as name, "
        "P.profile_path as profile_path, "
        "MC.credit_id as credit_id "
        "from movie_casts as MC "
        "LEFT JOIN Persons as P ON P.id = MC.person_id "
        "WHERE MC.movie_id = $id");
    if (result.length == 0) return null;

    Map<String, dynamic> toJson() => {"id": id, "cast": result};
    return Casts.fromJson(toJson());
  }

  Future<Result> getMovie(int id) async {
    var dbClient = await db;
    var res = await dbClient.query("Movies", where: "id = ?", whereArgs: [id]);
    var result = await dbClient.rawQuery("SELECT G.* FROM movie_genres as MG "
        "LEFT JOIN Movies as M ON M.id = MG.movie_id "
        "LEFT JOIN Genres_movie as G ON G.id = MG.genre_id "
        "WHERE movie_id = $id");
    if (res.length == 0) return null;
    Map<String, dynamic> toJson() => {
          "popularity": res[0]['popularity'],
          "vote_count": res[0]['vote_count'],
          "video": res[0]['video'],
          "poster_path": res[0]['poster_path'],
          "id": res[0]['id'],
          "adult": res[0]['adult'],
          "backdrop_path": res[0]['backdrop_path'],
          "original_language": res[0]['original_language'],
          "original_title": res[0]['original_title'],
          "genres": result,
          "title": res[0]['title'],
          "vote_average": res[0]['vote_average'],
          "overview": res[0]['overview'],
          "release_date": res[0]['release_date'],
          "runtime": res[0]['runtime'],
          "favorite": res[0]['favorite']
        };
    log("${toJson()}");
    return Result.fromDB(toJson());
  }

  Future<int> addMovie(Result movie) async {
    var dbClient = await db;
    try {
      int res = await dbClient.insert(tableMovie, movie.toJson());
      print("Movie added $res");
      return res;
    } catch (e) {
      int res = await updateMovie(movie);
      return res;
    }
  }

  Future<int> addPerson(PersonDetail person) async {
    var dbClient = await db;
    try {
      int res = await dbClient.insert("Persons", person.toJson());
      print("Person added $res");
      return res;
    } catch (e) {
      int res = await updatePerson(person);
      return res;
    }
  }

  Future<int> updatePerson(PersonDetail person) async {
    var dbClient = await db;
    int res = await dbClient.update("Persons", person.toJson(),
        where: "id = ?", whereArgs: [person.id]);
    print("Person updated $res");
    return res;
  }

  Future<int> addMovieCasts(MovieCastsDB movieCasts) async {
    var dbClient = await db;
    print(movieCasts.movieId);
    try {
      int res = await dbClient.insert(("movie_casts"), movieCasts.toJson());
      print("Movie Casts added $res");
      return res;
    } catch (e) {
      print(e);
      int res = await updateMovieCasts(movieCasts);
      return null;
    }
  }

  Future<int> updateMovieCasts(MovieCastsDB movieCasts) async {
    var dbClient = await db;
    int res = await dbClient.update("movie_casts", movieCasts.toJson(),
        where: "movie_id = ? AND cast_id = ?",
        whereArgs: [movieCasts.movieId, movieCasts.castId]);
    print("Movie Casts updated $res");
    return res;
  }

  Future<int> deleteMovieCasts(int id) async {
    var dbClient = await db;
    var res = await dbClient
        .delete("movie_casts", where: "movie_id = ?", whereArgs: [id]);
    print("Movie Casts deleted $res");
    return res;
  }

  Future<int> addMovieGenres(int movieId, int genreId) async {
    var dbClient = await db;
    try {
      int res = await dbClient
          .rawInsert("INSERT Into movie_genres (movie_id, genre_id)"
              " VALUES ($movieId,$genreId)");
      print("Movie Genre added $res");
      return res;
    } catch (e) {
      int res = await updateMovieGenres(movieId, genreId);
      return res;
    }
  }

  Future<int> updateMovieGenres(int movieId, int genreId) async {
    var dbClient = await db;
    int res = await dbClient.rawUpdate(
        "UPDATE movie_genres SET genre_id = $genreId WHERE movie_id = $movieId AND genre_id = $genreId");
    print("Movie Genre updated $res");
    return res;
  }

  Future<int> updateMovie(Result movie) async {
    var dbClient = await db;
    int res = await dbClient.update(tableMovie, movie.toJson(),
        where: "id = ?", whereArgs: [movie.id]);
    print("Movie updated $res");
    return res;
  }

  Future<int> deleteMovie(int id) async {
    var dbClient = await db;
    var res =
        await dbClient.delete(tableMovie, where: "id = ?", whereArgs: [id]);
    print("Movie deleted $res");
    return res;
  }

  Future<int> deleteMovieGenre(int id) async {
    var dbClient = await db;
    var res = await dbClient
        .delete("movie_genres", where: "movie_id = ?", whereArgs: [id]);
    print("Movie Genre deleted $res");
    return res;
  }

//  TV SHOW
  Future<int> addTv(ResultTv tv) async {
    var dbClient = await db;
    try {
      int res = await dbClient.insert("Tvs", tv.toJson());
      print("TV added $res");
      return res;
    } catch (e) {
      int res = await updateTv(tv);
      return res;
    }
  }

  Future<int> updateTv(ResultTv tv) async {
    var dbClient = await db;
    int res = await dbClient
        .update("Tvs", tv.toJson(), where: "id = ?", whereArgs: [tv.id]);
    print("TV updated $res");
    return res;
  }

  Future<int> deleteTv(int id) async {
    var dbClient = await db;
    var res = await dbClient.delete("Tvs", where: "id = ?", whereArgs: [id]);
    print("TV deleted $res");
    return res;
  }

  Future<int> addTvGenres(int tvId, int genreId) async {
    var dbClient = await db;
    try {
      int res =
          await dbClient.rawInsert("INSERT Into tv_genres (tv_id, genre_id)"
              " VALUES ($tvId,$genreId)");
      print("TV Genre added $res");
      return res;
    } catch (e) {
      int res = await updateTvGenres(tvId, genreId);
      return res;
    }
  }

  Future<int> updateTvGenres(int tvId, int genreId) async {
    var dbClient = await db;
    int res = await dbClient.rawUpdate(
        "UPDATE tv_genres SET genre_id = $genreId WHERE tv_id = $tvId AND genre_id = $genreId");
    print("TV Genre updated $res");
    return res;
  }

  Future<int> deleteTvGenre(int id) async {
    var dbClient = await db;
    var res =
        await dbClient.delete("tv_genres", where: "tv_id = ?", whereArgs: [id]);
    print("TV Genre deleted $res");
    return res;
  }

  Future<List<ResultTv>> getTvs() async {
    var dbClient = await db;
    List<Map> res = await dbClient.query("Tvs");
    return res.map((m) => ResultTv.fromJson(m)).toList();
  }

  Future<ResultTv> getTv(int id) async {
    var dbClient = await db;
    var res = await dbClient.query("Tvs", where: "id = ?", whereArgs: [id]);
    var result = await dbClient.rawQuery("SELECT G.* FROM tv_genres as MG "
        "LEFT JOIN Tvs as M ON M.id = MG.tv_id "
        "LEFT JOIN Genres_tv as G ON G.id = MG.genre_id "
        "WHERE tv_id = $id");
    if (res.length == 0) return null;
    Map<String, dynamic> toJson() => {
          "poster_path": res[0]['poster_path'],
          "popularity": res[0]['popularity'],
          "id": id,
          "backdrop_path": res[0]['backdrop_path'],
          "vote_average": res[0]['vote_average'],
          "overview": res[0]['overview'],
          "first_air_date": res[0]['first_air_date'],
          "genres": result,
          "original_name": res[0]['original_name'],
          "vote_count": res[0]['vote_count'],
          "name": res[0]['name'],
          "original_language": res[0]['original_language'],
          "favorite": res[0]['favorite']
        };
    log("${toJson()}");
    return ResultTv.fromJson(toJson());
  }

  Future<int> addTvCasts(TvCastsDB tvCasts) async {
    var dbClient = await db;
    print(tvCasts.tvId);
    try {
      int res = await dbClient.insert(("tv_casts"), tvCasts.toJson());
      print("TV Casts added $res");
      return res;
    } catch (e) {
      print(e);
      int res = await updateTvCasts(tvCasts);
      return res;
    }
  }

  Future<int> updateTvCasts(TvCastsDB tvCasts) async {
    var dbClient = await db;
    int res = await dbClient.update("tv_casts", tvCasts.toJson(),
        where: "tv_id = ? AND person_id = ?",
        whereArgs: [tvCasts.tvId, tvCasts.personId]);
    print("TV Casts updated $res");
    return res;
  }

  Future<int> deleteTvCasts(int id) async {
    var dbClient = await db;
    var res =
        await dbClient.delete("tv_casts", where: "tv_id = ?", whereArgs: [id]);
    print("TV Casts deleted $res");
    return res;
  }

  Future<Casts> getTvCasts(int id) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT "
        "MC.character as character,"
        "P.id as id, "
        "P.name as name, "
        "P.profile_path as profile_path, "
        "MC.credit_id as credit_id "
        "from tv_casts as MC "
        "LEFT JOIN Persons as P ON P.id = MC.person_id "
        "WHERE MC.tv_id = $id");
    if (result.length == 0) return null;

    Map<String, dynamic> toJson() => {"id": id, "cast": result};
    return Casts.fromJson(toJson());
  }

  Future<List<GenreModel>> getMovieGenres() async {
    var dbClient = await db;
    List<Map> res = await dbClient.rawQuery("SELECT * from Genres_movie");
    if (res.length == 0) return null;
    print(res);
    return res.map((m) => GenreModel.fromJson(m)).toList();
  }

  Future<List<GenreModel>> getTvGenres() async {
    var dbClient = await db;
    List<Map> res = await dbClient.rawQuery("SELECT * from Genres_tv");
    if (res.length == 0) return null;
    print(res);
    return res.map((m) => GenreModel.fromJson(m)).toList();
  }

  Future closeDb() async {
    var dbClient = await db;
    dbClient.close();
  }
}
