import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movieapps/screens/search_screen.dart';

class AppBarMovies extends StatelessWidget {
  final String titleAppBar;

  const AppBarMovies({Key key, this.titleAppBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: AppBar(
        title: Center(
          child: Text(
            titleAppBar,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54,
                fontFamily: 'FasterOne',
                fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.white70,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: Colors.black54, size: 32),
            onPressed: () {
              Navigator.of(context).push(
                  new MaterialPageRoute(builder: (context) => SearchScreen()));
//                    showSearch(context: context, delegate: SearchMovies());
            },
          )
        ],
      ),
    );
  }
}
