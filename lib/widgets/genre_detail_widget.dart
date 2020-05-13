import 'package:flutter/material.dart';
import 'package:movieapps/models/genre.dart';

class GenreWidget extends StatelessWidget {
  final List<GenreModel> listGenre;

  const GenreWidget({Key key, this.listGenre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _genreList();
  }

  Widget _genreList() {
    return Container(
        alignment: Alignment.topCenter,
        width: double.infinity,
        height: 30,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: listGenre.length,
            itemBuilder: (context, index) {
              return Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                child: Center(
                    child: Text(
                  "${listGenre[index].name}",
                  style: TextStyle(color: Colors.black),
                )),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      width: 1,
                      color: Colors.grey[300],
                    )),
              );
            }));
  }
}
