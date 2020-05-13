import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:movieapps/models/casts.dart';
import 'package:movieapps/models/config.dart';
import 'package:movieapps/models/genre.dart';
import 'package:movieapps/models/movie.dart';
import 'package:movieapps/models/moviedetail.dart';
import 'package:movieapps/models/person.dart';
import 'package:movieapps/models/tvdetail.dart';
import 'package:movieapps/models/tvshow.dart' as TV;

class Api {
  String apikey = "2105eeb16c2ac67a002123c95e40a86b";
  String url = "https://api.themoviedb.org/3/";

  Future getGenreList() async {
    final response = await http.get('${url}genre/movie/list?api_key=$apikey');

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body)['genres'].cast();

      return parsed.map((json) => GenreModel.fromJson(json)).toList();
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<Movies> getFetchMovies(int genre) async {
    http.Response response;
    if (genre != null) {
      response = await http
          .get("${url}discover/movie?api_key=$apikey&with_genres=$genre");
    } else {
      response = await http.get("${url}discover/movie?api_key=$apikey");
    }

    Movies listmovies = modelFromJson(response.body);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listmovies;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load list movies');
    }
  }

  Future<TV.TvShows> getFetchTvs(int genre) async {
    http.Response response;
    if (genre != null) {
      response = await http
          .get("${url}discover/tv?api_key=$apikey&with_genres=$genre");
    } else {
      response = await http.get("${url}discover/tv?api_key=$apikey");
    }

    TV.TvShows listtvshows = TV.modelFromJson(response.body);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listtvshows;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load list movies');
    }
  }

  Future<Result> getMovieDetail(int id) async {
    http.Response response =
        await http.get("${url}movie/${id.toString()}?api_key=$apikey");
    Result movie = Result.fromJson(json.decode(response.body));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      log(movie.originalTitle);
      return movie;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load list movies');
    }
  }

  Future<ResultTv> getTvDetail(int id) async {
    http.Response response =
        await http.get("${url}tv/${id.toString()}?api_key=$apikey");
    ResultTv tv = ResultTv.fromJson(json.decode(response.body));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return tv;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load list movies');
    }
  }

  getMovieLanguage(int id) async {
    http.Response response =
        await http.get("${url}movie/${id.toString()}?api_key=$apikey");
    final parsed = json.decode(response.body)['spoken_languages'].cast();

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return parsed.map((json) => SpokeLanguage.fromJson(json)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load list movies');
    }
  }

  getTvLanguage() async {
    http.Response response =
        await http.get("${url}configuration/languages?api_key=$apikey");
    final parsed = json.decode(response.body).cast();

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return parsed.map((json) => Language.fromJson(json)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load list movies');
    }
  }

  Future<Movies> getNowPlayingMovies(String type, int genre) async {
    http.Response response;
    if (genre != null) {
      //  response = await http.get("${url}discover/movie?api_key=$apikey&with_genres=$genre");
      response = await http
          .get("${url}movie/$type?api_key=$apikey&with_genres=$genre");
    } else {
      response = await http.get("${url}movie/$type?api_key=$apikey");
    }
    Movies listmovies = modelFromJson(response.body);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listmovies;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load list movies');
    }
  }

  Future<TV.TvShows> getNowPlayingTvs(String type, int genre) async {
    http.Response response;
    if (genre != null) {
      //  response = await http.get("${url}discover/movie?api_key=$apikey&with_genres=$genre");
      response =
          await http.get("${url}tv/$type?api_key=$apikey&with_genres=$genre");
    } else {
      response = await http.get("${url}tv/$type?api_key=$apikey");
    }

    TV.TvShows listmovies = TV.modelFromJson(response.body);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listmovies;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load list movies');
    }
  }

  Future<Casts> getMovieActors(int id) async {
    http.Response response;
    if (id != null) {
      response = await http.get("${url}movie/$id/credits?api_key=$apikey");
    }

    Casts listactors = Casts.fromJson(json.decode(response.body));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listactors;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load list actors');
    }
  }

  Future<Casts> getTvActors(int id) async {
    http.Response response;
    if (id != null) {
      response = await http.get("${url}tv/$id/credits?api_key=$apikey");
    }

    Casts listactors = Casts.fromJson(json.decode(response.body));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listactors;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load list actors');
    }
  }

  Future<Persons> getFetchPersons() async {
    http.Response response;

    response = await http.get("${url}person/popular?api_key=$apikey");

    Persons listpersons = Persons.fromJson(json.decode(response.body));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listpersons;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load list movies');
    }
  }

  Future<PersonDetail> getPersonDetail(int id) async {
    http.Response response =
        await http.get("${url}person/${id.toString()}?api_key=$apikey");
    PersonDetail person = PersonDetail.fromJson(json.decode(response.body));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      log(person.name);
      return person;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load list movies');
    }
  }

  Future<PersonMovies> getPersonMovies(int id) async {
    http.Response response = await http
        .get("${url}person/${id.toString()}/movie_credits?api_key=$apikey");
    PersonMovies personMovies =
        PersonMovies.fromJson(json.decode(response.body));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      log("{$personMovies}");
      return personMovies;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load list movies');
    }
  }

  Future getTvGenreList() async {
    final response = await http.get('${url}genre/tv/list?api_key=$apikey');

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body)['genres'].cast();

      return parsed.map((json) => GenreModel.fromJson(json)).toList();
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<Movies> getSearchMovies(String s) async {
    http.Response response;
    Movies listMovies;
    if (s == null) {
      listMovies = null;
    } else {
      String news = Uri.encodeFull(s);
      log("${url}search/movie?api_key=$apikey&query=$news");
      response =
          await http.get("${url}search/movie?api_key=$apikey&query=$news");
      listMovies = modelFromJson(response.body);
      log("${listMovies.results.length}");
      if (listMovies.results.length == 0) {
        listMovies = null;
      }
    }

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listMovies;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load list movies');
    }
  }

  Future<TV.TvShows> getSearchTvs(String s) async {
    http.Response response;
    TV.TvShows listTvs;
    if (s == null) {
      listTvs = null;
    } else {
      String news = Uri.encodeFull(s);
      log("${url}search/movie?api_key=$apikey&query=$news");
      response = await http.get("${url}search/tv?api_key=$apikey&query=$news");
      listTvs = TV.modelFromJson(response.body);
      log("${listTvs.results.length}");
      if (listTvs.results.length == 0) {
        listTvs = null;
      }
    }

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listTvs;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load list movies');
    }
  }

  Future<Persons> getSearchPersons(String s) async {
    http.Response response;
    Persons listPersons;
    if (s == null) {
      listPersons = null;
    } else {
      String news = Uri.encodeFull(s);
      log("${url}search/movie?api_key=$apikey&query=$news");
      response =
          await http.get("${url}search/person?api_key=$apikey&query=$news");
      listPersons = Persons.fromJson(json.decode(response.body));
      if (listPersons.results.length == 0) {
        listPersons = null;
      }
    }

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listPersons;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load list movies');
    }
  }

  Future getLanguages() async {
    http.Response response;

    response = await http.get("${url}configuration/languages?api_key=$apikey");

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);

      return parsed.map((json) => SpokeLanguage.fromJson(json)).toList();
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
