import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:movieapps/models/casts.dart';
import 'package:movieapps/models/genre.dart';
import 'package:movieapps/models/moviedetail.dart';
import 'package:movieapps/models/tvdetail.dart';
import 'package:movieapps/screens/detail_screen.dart';
import 'package:movieapps/utils/api_key.dart';
import 'package:movieapps/utils/database.dart';
import 'package:movieapps/utils/global.dart';
import 'package:movieapps/widgets/genre_detail_widget.dart';

class DetailTvScreen extends StatefulWidget {
  final ResultTv tv;

  DetailTvScreen(this.tv);

  @override
  _DetailTvScreenState createState() => _DetailTvScreenState();
}

class _DetailTvScreenState extends State<DetailTvScreen> {
  // ignore: non_constant_identifier_names
  final double expanded_height = 400;

  // ignore: non_constant_identifier_names
  final double rounded_container_height = 50;
  ResultTv futureTv;
  Casts futureCasts;
  bool castLoadDone = false;
  List<SpokeLanguage> spokenLanguages = List();
  String language = "";
  List<GenreModel> listGenre = List();
  MovieDatabase db = MovieDatabase();

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
      if (spokenLanguages[i].iso == widget.tv.originalLanguage) {
        setState(() {
          language = spokenLanguages[i].name;
        });
      }
    }
  }

  void checkDB() async {
    var result = await db.getTv(widget.tv.id);
    if (result != null) {
      futureTv = result;
      listGenre = result.genres;
      futureCasts = await db.getTvCasts(result.id);
    } else {
      await Api().getTvDetail(widget.tv.id).then((value) {
        setState(() {
          futureTv = value;
          listGenre = value.genres;
        });
      });
      await Api().getTvActors(widget.tv.id).then((value) {
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
      futureTv.favorite = !futureTv.favorite;
    });
    if (futureTv.favorite == true) {
      db.addTv(futureTv);
      for (int i = 0; i < futureTv.genres.length; i++) {
        db.addGenresTv(futureTv.genres[i]);
        db.addTvGenres(futureTv.id, futureTv.genres[i].id);
      }
      addCasts(db);
    } else {
      db.deleteTv(futureTv.id);
      db.deleteTvGenre(futureTv.id);
      db.deleteTvCasts(futureTv.id);
    }
  }

  void addCasts(MovieDatabase db) async {
    for (int i = 0; i < futureCasts.cast.length; i++) {
      await Api().getPersonDetail(futureCasts.cast[i].id).then((value) {
        db.addPerson(value);
        Map<String, dynamic> toJson() => {
              'tv_id': widget.tv.id,
              'person_id': value.id,
              'character': futureCasts.cast[i].character,
              'credit_id': futureCasts.cast[i].creditId
            };
        db.addTvCasts(TvCastsDB.fromDB(toJson()));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    futureTv = widget.tv;
    listGenre = [];
    spokenLanguages = [];
    checkDB();
    getLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            _buildSliverHead(),
            SliverFilip(child: _buildTitle()),
            SliverFilip(child: _buildGenre()),
            SliverFilip(child: _buildRating()),
            SliverFilip(child: _buildOverview()),
            SliverToBoxAdapter(child: _buildCasts()),
//            SliverToBoxAdapter(
//                child:_buildDetail()
//            )
          ],
        ),
      ],
    ));
  }

  Widget _buildSliverHead() {
    return SliverPersistentHeader(
      pinned: false,
      floating: false,
      delegate: DetailSliverDelegate(
          expanded_height, widget.tv, rounded_container_height),
    );
  }

  Widget _buildTitle() {
    return Container(
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
                          child: Text(widget.tv.name,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold))),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                              widget.tv.firstAirDate.toString().substring(0, 4),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  height: 2)))
                    ],
                  ),
                ),
                GestureDetector(
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: futureTv.favorite == false
                            ? Colors.pink
                            : Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Icon(
                        futureTv.favorite == false ? Icons.add : Icons.check,
                        color: Colors.white),
                  ),
                  onTap: () {
                    onPressFavorite();
                  },
                )
              ],
            ),
          ],
        ));
  }

  Widget _buildGenre() {
    return Container(
        margin: EdgeInsets.only(left: 20, top: 15),
        alignment: Alignment.topCenter,
        child: listGenre.length == 0
            ? CircularProgressIndicator()
            : GenreWidget(listGenre: listGenre));
  }

  Widget _buildRating() {
    return Container(
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
                      right: BorderSide(width: 1.0, color: Colors.black26),
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
                          text: '${widget.tv.voteAverage}',
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
                            text: '/${widget.tv.originalLanguage}',
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
    );
  }

  Widget _buildOverview() {
    return Column(
      children: <Widget>[
        _buildSubTitle("Overview"),
        Container(
            margin: EdgeInsets.only(left: 30, top: 5, right: 30),
            alignment: Alignment.topLeft,
            child: Text(
              widget.tv.overview,
              textAlign: TextAlign.justify,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                  color: Colors.black54,
                  fontSize: 13),
            ))
      ],
    );
  }

  Widget _buildCasts() {
    return Column(children: <Widget>[
      _buildSubTitle("Cast"),
      Container(
          height: 200,
          margin: EdgeInsets.only(left: 30, bottom: 30),
          padding: EdgeInsets.only(top: 10),
          child: futureCasts != null
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: futureCasts.cast.length,
                  itemBuilder: (context, index) {
                    return _buildCastProfile(
                        futureCasts.cast[index].name,
                        futureCasts.cast[index].profilePath,
                        futureCasts.cast[index].character);
                  })
              : CircularProgressIndicator()),
    ]);
  }

  Widget _buildDetail() {
    return Container(
        height: MediaQuery.of(context).size.height + 150,
        color: Colors.white,
        child: Column(
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
                                  child: Text(widget.tv.name,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold))),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                      widget.tv.firstAirDate
                                          .toString()
                                          .substring(0, 4),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                          height: 2)))
                            ],
                          ),
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.pink,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Icon(Icons.add, color: Colors.white),
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
                                  text: '${widget.tv.voteAverage}',
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
                      RichText(
                          text: TextSpan(
                        text: "$language",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              text: '/${widget.tv.originalLanguage}',
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
                child: Text(
                  widget.tv.overview,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      height: 1.5,
                      color: Colors.black54,
                      fontSize: 13),
                )),
            _buildSubTitle("Casts"),
            Expanded(
                flex: 10,
                child: Container(
                    margin: EdgeInsets.only(left: 30, bottom: 30),
                    padding: EdgeInsets.only(top: 10),
                    child: futureCasts != null
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: futureCasts.cast.length,
                            itemBuilder: (context, index) {
                              return _buildCastProfile(
                                  futureCasts.cast[index].name,
                                  futureCasts.cast[index].profilePath,
                                  futureCasts.cast[index].character);
                            })
                        : CircularProgressIndicator()))
          ],
        ));
  }

  Widget _buildCastProfile(String name, String profilePath, String character) {
    return Container(
        margin: EdgeInsets.only(right: 12),
        child: Column(children: <Widget>[
          Container(
              alignment: Alignment.center,
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
                        ))),
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
  final ResultTv movie;
  final double rounded_container_height;

  DetailSliverDelegate(
      this.expandedHeight, this.movie, this.rounded_container_height);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
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
          top: (expandedHeight - shrinkOffset - rounded_container_height),
          left: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: rounded_container_height,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: overlapsContent == true
                    ? BorderRadius.all(Radius.circular(0))
                    : BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30))),
          ),
        ),

//        Positioned(
//          top: expandedHeight - 200 - shrinkOffset,
//          child: Center(
//            child: Container(
//                margin: EdgeInsets.only(left: 20),
//                width: 150,
//                height:200,
//                color: Colors.pink
//            ),
//          ),
//        ),
      ],
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => expandedHeight;

  @override
  // TODO: implement minExtent
  double get minExtent => 0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return true;
  }
}

class SilverFilip extends SingleChildRenderObjectWidget {
  SilverFilip({Widget child, Key key}) : super(child: child, key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    // TODO: implement createRenderObject
    return RenderSliverFilip();
  }
}

class RenderSliverFilip extends RenderSliverSingleBoxAdapter {
  RenderSliverFilip({RenderBox child}) : super(child: child);

  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    child.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child.size.width;
        break;
      case Axis.vertical:
        childExtent = child.size.height;
        break;
    }
    assert(childExtent != null);
    final double paintedChildSize =
        calculatePaintOffset(constraints, from: 0.0, to: childExtent);
    final double cacheExtent =
        calculateCacheOffset(constraints, from: 0.0, to: childExtent);

    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);
    geometry = SliverGeometry(
      scrollExtent: childExtent,
      paintExtent: paintedChildSize,
      cacheExtent: cacheExtent,
      maxPaintExtent: childExtent,
      hitTestExtent: paintedChildSize,
      hasVisualOverflow: childExtent > constraints.remainingPaintExtent ||
          constraints.scrollOffset > 0.0,
    );
    setChildParentData(child, constraints, geometry);
  }
}
