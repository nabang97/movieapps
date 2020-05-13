import 'package:flutter/material.dart';
import 'package:movieapps/models/movie.dart';

class SearchMovies extends SearchDelegate<Movies> {
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [Icon(Icons.clear)];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return Container();
  }
}
