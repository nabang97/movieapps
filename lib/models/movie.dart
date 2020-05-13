import 'dart:convert' show json;

import 'moviedetail.dart';

Movies modelFromJson(String str) => Movies.fromJson(json.decode(str));

class Movies {
  List<Result> results;

  Movies({
    this.results,
  });

  factory Movies.fromJson(Map<String, dynamic> json) => Movies(
      results:
          List<Result>.from(json["results"].map((x) => Result.fromJson(x))));

  Map<String, dynamic> toJson() =>
      {"results": List<dynamic>.from(results.map((x) => x.toJson()))};
}
