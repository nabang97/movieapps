import 'dart:convert' show json;

import 'tvdetail.dart';

TvShows modelFromJson(String str) => TvShows.fromJson(json.decode(str));

class TvShows {
  List<ResultTv> results;

  TvShows({
    this.results,
  });

  factory TvShows.fromJson(Map<String, dynamic> json) => TvShows(
      results: List<ResultTv>.from(
          json["results"].map((x) => ResultTv.fromJson(x))));

  Map<String, dynamic> toJson() =>
      {"results": List<dynamic>.from(results.map((x) => x.toJson()))};
}
