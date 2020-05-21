import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movieapps/models/movie.dart';
import 'package:movieapps/models/person.dart';
import 'package:movieapps/models/tvshow.dart';
import 'package:movieapps/screens/detail_person.dart';
import 'package:movieapps/screens/detail_screen_tv.dart';
import 'package:movieapps/utils/api_key.dart';
import 'package:movieapps/utils/global.dart';

import 'detail_screen_movie.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<Movies> movies;
  Future<TvShows> tvs;
  Future<Persons> persons;
  double heightTv, heightMovie, heightPerson, heightContainer, widthContainer;
  String subtitle;

  void setHeightTv(double l) {
    setState(() {
      heightTv = l;
    });
  }

  void setHeightMovie(double l) {
    setState(() {
      heightMovie = l;
    });
  }

  void setHeightPerson(double l) {
    setState(() {
      heightPerson = l;
    });
  }

  void searchMovie(String s) {
    setState(() {
      movies = Api().getSearchMovies(s);
    });
    movies.then((value) {
      if (value == null) {
        setHeightMovie(0.0);
      } else {
        setHeightMovie(heightContainer);
      }
    });
  }

  void searchTv(String s) {
    setState(() {
      tvs = Api().getSearchTvs(s);
    });
    tvs.then((value) {
      if (value == null) {
        setHeightTv(0.0);
      } else {
        setHeightTv(heightContainer);
      }
    });
  }

  void searchPerson(String s) {
    setState(() {
      persons = Api().getSearchPersons(s);
    });
    persons.then((value) {
      if (value == null) {
        setHeightPerson(0.0);
      } else {
        setHeightPerson(heightContainer);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    heightContainer = 0;
    widthContainer = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black54,
                size: 32,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Expanded(
                child: TextField(
              textInputAction: TextInputAction.search,
              autocorrect: false,
              autofocus: true,
              enableSuggestions: false,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.normal),
              decoration: InputDecoration(
                  fillColor: Colors.pink,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(left: 5, bottom: 15, top: 15, right: 5),
                  hintStyle: TextStyle(fontSize: 20),
                  hintText: 'Search'),
              onEditingComplete: () {
                log("Editing Complete");
              },
              onChanged: (s) {
                log("onChanged $s");
              },
              onSubmitted: (s) {
                searchMovie(s);
                searchTv(s);
                searchPerson(s);
                setState(() {
                  heightContainer = MediaQuery.of(context).size.height / 4.5;
                  widthContainer = MediaQuery.of(context).size.width / 4;
                });
              },
            )),
            IconButton(
              icon: Icon(Icons.close, color: Colors.black54, size: 32),
              onPressed: () {},
            )
          ],
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
              _buildSubTitle("Movie", heightMovie),
              _buildMovieTv(heightMovie, widthContainer, movies, "movie"),
              _buildSubTitle("Tv Shows", heightTv),
              _buildMovieTv(heightTv, widthContainer, tvs, "tv"),
              _buildSubTitle("Actors", heightPerson),
              _buildPerson(heightPerson, widthContainer, persons),
        ])));
  }

  Widget _buildSubTitle(String s, double heightMovie) {
    if ((heightMovie != null) && (heightMovie != 0.0)) {
      return Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment.centerLeft,
          child: Text(
            s,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 20),
          ));
    } else {
      return Container(height: 0);
    }
  }

  Widget _buildMovieTv(double heightContainer, double widthContainer,
          Future future, String key) =>
      Container(
          height: heightContainer,
          child: FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(height: 0);
              }
              if (snapshot.hasData) {
                return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.results.length,
                    itemBuilder: (context, index) {
                      return new GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => key == "movie"
                                    ? DetailMovieScreen(
                                        snapshot.data.results[index])
                                    : DetailTvScreen(
                                        snapshot.data.results[index]),
                              ),
                            );
                          },
                          child: Container(
                              color: Colors.white,
                              padding: EdgeInsets.only(
                                  left: 10,
                                  right:
                                      index == snapshot.data.results.length - 1
                                          ? 10
                                          : 0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child:
                                      snapshot.data.results[index].posterPath ==
                                              null
                                          ? Image.asset(
                                              'lib/images/user.png',
                                              width: widthContainer,
                                              height: heightContainer,
                                              fit: BoxFit.cover,
                                            )
                                          : CachedNetworkImage(
                                              imageUrl: getPosterImage(
                                                  "${snapshot.data.results[index].posterPath}"),
                                              width: widthContainer,
                                              height: heightContainer,
                                              fit: BoxFit.cover,
                                            ))));
                    });
              }

              return CircularProgressIndicator();
            },
          ));

  Widget _buildPerson(
          double heightContainer, double widthContainer, Future future) =>
      Container(
          height: heightContainer,
          child: FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(height: 0);
              }
              if (snapshot.hasData) {
                return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.results.length,
                    itemBuilder: (context, index) {
                      return new GestureDetector(
                          child: Container(
                              color: Colors.white,
                              padding: EdgeInsets.only(
                                  left: 10,
                                  right: index ==
                                      snapshot.data.results.length - 1
                                      ? 10
                                      : 0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: snapshot.data.results[index]
                                      .profilePath ==
                                      null
                                      ? Image.asset(
                                    'lib/images/user.png',
                                    width: widthContainer,
                                    height: heightContainer,
                                    fit: BoxFit.cover,
                                  )
                                      : CachedNetworkImage(
                                    imageUrl: getPosterImage(
                                        "${snapshot.data.results[index]
                                            .profilePath}"),
                                    width: widthContainer,
                                    height: heightContainer,
                                    fit: BoxFit.cover,
                                  ))),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailPerson(id: snapshot.data
                                        .results[index].id),
                              ),
                            );
                          }
                      );
                    });
              }

              return CircularProgressIndicator();
            },
          ));
}
