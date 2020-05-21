import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movieapps/models/casts.dart';
import 'package:movieapps/models/genre.dart';
import 'package:movieapps/models/moviedetail.dart';
import 'package:movieapps/screens/detail_person.dart';
import 'package:movieapps/utils/api_key.dart';
import 'package:movieapps/utils/database.dart';
import 'package:movieapps/utils/global.dart';
import 'package:movieapps/widgets/genre_detail_widget.dart';
import 'package:movieapps/widgets/read_more_text.dart';
import '../widgets/general_widget.dart' as GeneralStyle;

class DetailMovieScreen extends StatefulWidget {
  final Result movie;

  DetailMovieScreen(this.movie);

  @override
  _DetailMovieScreenState createState() => _DetailMovieScreenState();
}

class _DetailMovieScreenState extends State<DetailMovieScreen> {
  // ignore: non_constant_identifier_names
  final double expanded_height = 400;

  // ignore: non_constant_identifier_names
  final double rounded_container_height = 50;
  Result futureMovie;
  Casts futureCasts;
  List<SpokeLanguage> spokenLanguages = List();
  String language = "";
  MovieDatabase db = MovieDatabase();
  IconData icon = Icons.add;
  MaterialColor color = Colors.pink;
  List<GenreModel> listGenre = List();
  bool castLoadDone = false;

  void getLanguage() async {
    var result = await db.getLanguages();
    if (result != null) {
      setState(() {
        spokenLanguages = result;
      });
    } else {
      await Api().getLanguages().then((value) {
        setState(() {
          spokenLanguages = value;
        });
      });
    }
    for (int i = 0; i < spokenLanguages.length; i++) {
      if (spokenLanguages[i].iso == futureMovie.originalLanguage) {
        setState(() {
          language = spokenLanguages[i].name;
        });
      }
    }
  }

  String getLanguageName() {
    for (int i = 0; i < spokenLanguages.length; i++) {
      if (spokenLanguages[i].iso == futureMovie.originalLanguage) {
        setState(() {
          language = spokenLanguages[i].name;
        });
      }
    }
    return language;
  }

  void checkDB() async {
    var result = await db.getMovie(widget.movie.id);
    if (result != null) {
      futureMovie = result;
      listGenre = result.genres;
      futureCasts = await db.getMovieCasts(result.id);
    } else {
      await Api().getMovieDetail(widget.movie.id).then((value) {
        setState(() {
          futureMovie = value;
          listGenre = value.genres;
        });
      });
      await Api().getMovieActors(widget.movie.id).then((value) {
        setState(() {
          futureCasts = value;
        });
      });
    }
    setState(() {
      castLoadDone = !castLoadDone;
    });
  }

  void onPressFavorite() {
    setState(() {
      futureMovie.favorite = !futureMovie.favorite;
    });
    if (futureMovie.favorite == true) {
      db.addMovie(futureMovie);
      for (int i = 0; i < futureMovie.genres.length; i++) {
        db.addGenresMovie(futureMovie.genres[i]);
        db.addMovieGenres(futureMovie.id, futureMovie.genres[i].id);
      }
      addCasts(db);
    } else {
      db.deleteMovie(futureMovie.id);
      db.deleteMovieGenre(futureMovie.id);
      db.deleteMovieCasts(futureMovie.id);
    }
  }

  void addCasts(MovieDatabase db) async {
    for (int i = 0; i < futureCasts.cast.length; i++) {
      await Api().getPersonDetail(futureCasts.cast[i].id).then((value) {
        db.addPerson(value);
        Map<String, dynamic> toJson() => {
              'cast_id': futureCasts.cast[i].castId,
              'movie_id': widget.movie.id,
              'person_id': value.id,
              'character': futureCasts.cast[i].character,
              'credit_id': futureCasts.cast[i].creditId
            };
        db.addMovieCasts(MovieCastsDB.fromDB(toJson()));
      });
    }
  }

  void addPerson(MovieDatabase db, int id) async {}

  void checkCasts() async {
    MovieDatabase db = MovieDatabase();
    var result = await db.getMovieCasts(widget.movie.id);
    print("DARI DATABASE : $result");
  }

  // ignore: missing_return
  IconData checkIcon() {
    setState(() {
      if (futureMovie.favorite == true) {
        icon = Icons.check;
      } else {
        icon = Icons.add;
      }
    });

    return icon;
  }

  checkColor() {
    setState(() {
      if (futureMovie.favorite == true) {
        color = Colors.green;
      } else {
        color = Colors.pink;
      }
    });

    return color;
  }

  @override
  void initState() {
    super.initState();
    futureMovie = widget.movie;
    listGenre = [];
    spokenLanguages = [];
    checkDB();
    checkCasts();
    getLanguage();
    print(futureMovie.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        scrollDirection: Axis.vertical,

        slivers: <Widget>[
          _buildSliverHead(),
          SliverToBoxAdapter(child:
          _buildDetail())
        ],
      ),
    );
  }

  Widget _buildSliverHead() {
    return SliverPersistentHeader(
      delegate: DetailSliverDelegate(
          expanded_height, widget.movie, rounded_container_height),
    );
  }

  Widget _buildDetail() {
    log(widget.movie.id.toString());
    return Container(
        color: Colors.white,
        height: MediaQuery
            .of(context)
            .size
            .height + 200,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(widget.movie.title,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold))),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: futureMovie.releaseDate == null
                                      ? CircularProgressIndicator()
                                      : Text("${futureMovie.releaseDate.year}",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                          height: 2)))
                            ],
                          ),
                        ),
                        castLoadDone != true
                            ? Container()
                            : GestureDetector(
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                color: futureMovie.favorite == null
                                    ? Colors.pink
                                    : checkColor(),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10))),
                            child: Icon(
                                futureMovie.favorite == null
                                    ? Icons.add
                                    : checkIcon(),
                                color: Colors.white),
                          ),
                          onTap: () {
                            onPressFavorite();
                          },
                        )
                      ],
                    ),
                  ],
                )),
            Container(
                margin: EdgeInsets.only(left: 20, top: 15),
                alignment: Alignment.topCenter,
                child: listGenre.length == 0
                    ? CircularProgressIndicator()
                    : GenreWidget(listGenre: listGenre)),
            Container(
              decoration: new BoxDecoration(
                border: Border(
//                  top: BorderSide(width: 1.0, color: Colors.black26),
//                  bottom: BorderSide(width: 1.0, color: Colors.black26),
                ),
              ),
              margin: EdgeInsets.only(left: 30, right: 30, top: 15),
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                          decoration: new BoxDecoration(
                            border: Border(
                              right:
                              BorderSide(width: 1.0, color: Colors.black26),
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 35,
                              ),
                              RichText(
                                text: TextSpan(
                                  text: '${widget.movie.voteAverage}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '/10',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15,
                                            color: Colors.black54))
                                  ],
                                ),
                              )
                            ],
                          ))),
                  Expanded(
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.chat,
                            color: Colors.green,
                            size: 35,
                          ),
//
                          spokenLanguages.length == 0
                              ? CircularProgressIndicator()
                              : RichText(
                              text: TextSpan(
                                text: "$language",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: '/${futureMovie.originalLanguage}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15,
                                          color: Colors.black54))
                                ],
                              ))
                        ],
                      )),
                ],
              ),
            ),
            _buildSubTitle("Overview"),
            Container(
                margin: EdgeInsets.only(left: 30, top: 5, right: 30),
                alignment: Alignment.topLeft,
                child:
                ReadMoreText(
                  widget.movie.overview,
                  trimLines: 6,
                  colorClickableText: Colors.pink,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: '...Show more',
                  trimExpandedText: ' show less',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      height: 1.5,
                      color: Colors.black54,
                      fontSize: 13),

                )
//                Text(
//                  widget.movie.overview,
//                  textAlign: TextAlign.justify,
//                  style: TextStyle(
//                      fontWeight: FontWeight.normal,
//                      height: 1.5,
//                      color: Colors.black54,
//                      fontSize: 13),
//                )
            ),
            _buildSubTitle("Casts"),
            Flexible(
                fit: FlexFit.loose,
                child: Container(
                    height: 200,
                    margin: EdgeInsets.only(left: 30, bottom: 30),
                    padding: EdgeInsets.only(top: 10),
                    child: futureCasts != null
                        ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: futureCasts.cast.length,
                        itemBuilder: (context, index) {
                          return _buildCastProfile(
                              futureCasts.cast[index].id,
                              futureCasts.cast[index].name,
                              futureCasts.cast[index].profilePath,
                              futureCasts.cast[index].character);
                        })
                        : CircularProgressIndicator()
//                  }
//                  return CircularProgressIndicator();
//                }
                ))
          ],
        ));
  }

  Widget _buildCastsList() {
    if (futureCasts == null) {
      setState(() {});
      return Container();
    } else {}
  }

  Widget _buildCastProfile(int id, String name, String profilePath,
      String character) {
    return Container(
        height: 200,
        margin: EdgeInsets.only(right: 12),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: profilePath == null
                            ? Image.asset('lib/images/user.png',
                            width: 70, fit: BoxFit.cover)
                            : CachedNetworkImage(
                          placeholder: (context, image) {
                            return Image.asset('lib/images/user.png',
                                width: 70, fit: BoxFit.cover);
                          },
                          imageUrl: getPosterImage(profilePath),
                          width: 70,
                          fit: BoxFit.cover,
                          height: 70,
                        )),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPerson(id: id),
                        ),
                      );
                    },
                  )
              ),
              Container(
                  width: 70,
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  )),
              Container(
                  width: 70,
                  margin: EdgeInsets.only(top: 10),
                  alignment: Alignment.center,
                  child: Text(
                    character,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
                        color: Colors.black54),
                  )),
            ]));
  }

  Widget _buildSubTitle(String s) => Container(
      margin: EdgeInsets.only(left: 30, top: 30),
      alignment: Alignment.topLeft,
      child: Text(
        s,
        textAlign: TextAlign.left,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ));
}

class DetailSliverDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final Result movie;

  // ignore: non_constant_identifier_names
  final double rounded_container_height;

  DetailSliverDelegate(
      this.expandedHeight, this.movie, this.rounded_container_height);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Hero(
            tag: movie.posterPath,
            child: CachedNetworkImage(
              imageUrl: getPosterImage(movie.posterPath),
              width: MediaQuery.of(context).size.width,
              height: expandedHeight,
              fit: BoxFit.cover,
            )),
        Positioned(
          top: expandedHeight - rounded_container_height - shrinkOffset,
          left: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: rounded_container_height,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30))),
          ),
        ),

//        Positioned(
//          top: expandedHeight - 150 - shrinkOffset,
//          left: 30,
//          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: <Widget>[
//              Text(movie.title,
//              style: TextStyle(
//                color: Colors.white,
//                fontSize:30
//              ),),
//              Text("Overview",
//                style: TextStyle(
//                    color: Colors.white,
//                    fontSize:15
//                ),)
//            ],
//          ),
//        )
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => 0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
