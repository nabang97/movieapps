import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:movieapps/models/casts.dart';
import 'package:movieapps/models/moviedetail.dart' as MovieModel;
import 'package:movieapps/utils/api_key.dart';
import 'package:movieapps/utils/global.dart';

class MovieDetail extends StatefulWidget {
  final MovieModel.Result movie;

  MovieDetail({Key key, @required this.movie}) : super(key: key);

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  Future<MovieModel.Result> futureMovie;
  Future<Casts> futureCasts;

  @override
  void initState() {
    super.initState();
    futureMovie = Api().getMovieDetail(widget.movie.id);
    futureCasts = Api().getMovieActors(widget.movie.id);
    log("nilai ID :" + widget.movie.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: _buildScrollable()));
  }

  Widget _buildScrollable() => CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text("hello"),
            leading: new IconButton(
                icon: new Icon(Icons.arrow_back, color: Color(0xffa8b1c4)),
                onPressed: () => Navigator.of(context).pop()),
            backgroundColor: Colors.white,
            expandedHeight: 350,
            elevation: 0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
                background: Stack(
              children: <Widget>[
                ClipRRect(
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(50)),
                    child: CachedNetworkImage(
                      imageUrl: getPosterImage("${widget.movie.backdropPath}"),
                      fit: BoxFit.cover,
                      height: 300,
                    )),
                Container(
                  width: MediaQuery.of(context).size.width - 20,
                  height: 100,
                  margin: EdgeInsets.only(
                      top: 250.0,
                      left: MediaQuery.of(context).size.width -
                          (MediaQuery.of(context).size.width - 20)),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(50)),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey,
                        blurRadius: 20.0,
                        // has the effect of softening the shadow
                        spreadRadius: 3.0,
                        // has the effect of extending the shadow
                        offset: Offset(
                          5.0, // horizontal, move right 10
                          5.0, // vertical, move down 10
                        ),
                      )
                    ],
                  ),
                )
              ],
            )),
          ),
          SliverFilip(
              child: Container(
                  decoration: new BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0))),
                  height: MediaQuery.of(context).size.height,
                  child: FutureBuilder<MovieModel.Result>(
                      future: futureMovie,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return _detailContainer(snapshot);
                        } else if (snapshot.hasError) {
                          return Text(snapshot.error);
                        }
                        return CircularProgressIndicator();
                      })))
        ],
      );

  Widget _detailContainer(AsyncSnapshot snapshot) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(20),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("${widget.movie.title}",
                      style: TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold)))),
          Container(
            margin: EdgeInsets.only(left: 20),
            alignment: Alignment.topCenter,
//          child : GenreWidget.GenreWidget(snapshot : snapshot)
          ),
          _buildSubTitle("Overview"),
          Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("${widget.movie.overview}",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 13, color: Colors.black54, height: 1.5)))),
          // Text("${widget.movie.releaseDate}"),
          // Text("${widget.movie.voteAverage}"),
          _buildSubTitle("Cast"),
          Flexible(fit: FlexFit.loose, child: _actorsWidget(context))
        ],
      );

  Widget _buildSubTitle(String s) => Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Text(s,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ))));

  Widget _actorsWidget(BuildContext context) => Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: FutureBuilder<Casts>(
          future: futureCasts,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.cast.length,
                  itemBuilder: (context, index) {
                    return _buildCastProfile(snapshot.data.cast[index].name,
                        snapshot.data.cast[index].profilePath);
                  });
            }
            if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            if (snapshot.connectionState == ConnectionState.none) {
              return Text("Connection not available");
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                decoration: BoxDecoration(color: Colors.grey),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return CircularProgressIndicator();
          }));

  Widget _buildCastProfile(String name, String profilePath) {
    return Column(children: <Widget>[
      ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: profilePath == null
              ? Image.asset('lib/images/user.png', width: 80, fit: BoxFit.cover)
              : CachedNetworkImage(
                  placeholder: (context, image) {
                    return Image.asset('lib/images/user.png',
                        width: 80, fit: BoxFit.cover);
                  },
                  imageUrl: getPosterImage(profilePath),
                  width: 80,
                  fit: BoxFit.cover,
                  height: 80,
                )),
      Container(
          width: 80,
          margin: EdgeInsets.all(20.0),
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          )),
    ]);
  }
}

class SliverFilip extends SingleChildRenderObjectWidget {
  SliverFilip({Widget child, Key key}) : super(child: child, key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSliverFilip();
  }
}

class RenderSliverFilip extends RenderSliverSingleBoxAdapter {
  RenderSliverFilip({
    RenderBox child,
  }) : super(child: child);

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
