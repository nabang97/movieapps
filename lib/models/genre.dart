import 'package:movieapps/utils/api_key.dart';

class GenreModel {
  final int id;
  final String name;

  GenreModel({this.id, this.name});

  factory GenreModel.fromJson(Map<String, dynamic> json) => GenreModel(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {"id": id, "name": name};

  factory GenreModel.getJson(int x) {
    GenreModel genre;
    Api().getGenreList().then((value) {
      for (int i = 0; i < value.length; i++) {
        if (value[i].id == x) {
          genre = GenreModel(id: x, name: value[i].name);
        }
      }
    }).catchError((error) {
      throw error;
    });
    return genre;
  }
}
