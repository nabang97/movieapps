import 'package:movieapps/utils/api_key.dart';
import 'package:movieapps/utils/database.dart';

String getPosterImage(String input) {
  return "https://image.tmdb.org/t/p/original$input";
}

void addLanguages() async {
  MovieDatabase db = MovieDatabase();
  await Api().getLanguages().then((value) {
    for (int i = 0; i < value.length; i++) {
      db.addLanguages(value[i]);
    }
  }).catchError((e) {
    return e;
  });
}
