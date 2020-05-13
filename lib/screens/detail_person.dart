import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movieapps/models/person.dart';
import 'package:movieapps/utils/api_key.dart';
import 'package:movieapps/utils/global.dart';

import 'detail_screen_movie.dart';

class DetailPerson extends StatefulWidget {
  final int id;

  const DetailPerson({Key key, this.id}) : super(key: key);

  @override
  _DetailPersonState createState() => _DetailPersonState();
}

class _DetailPersonState extends State<DetailPerson> {
  PersonDetail person;
  PersonMovies personMovies;

  // ignore: non_constant_identifier_names
  final double expanded_height = 400;

  // ignore: non_constant_identifier_names
  final double rounded_container_height = 50;

  void setPersonDetail() async {
    await Api().getPersonDetail(widget.id).then((value) {
      setState(() {
        person = value;
      });
    }).catchError((error) {
      throw error;
    });
  }

  void setCastMovies() async {
    await Api().getPersonMovies(widget.id).then((value) {
      setState(() {
        personMovies = value;
      });
    }).catchError((error) {
      throw error;
    });
  }

  @override
  void initState() {
    setPersonDetail();
    setCastMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _buildSliverHead(),
          SliverToBoxAdapter(child: _buildName()),
          SliverToBoxAdapter(child: _buildOverview()),
          SliverToBoxAdapter(child: _buildDetail()),
        ],
      ),
    );
  }

  Widget listItem(Color color, String title) => Container(
        height: 100.0,
        color: color,
        child: Center(
          child: Text(
            "$title",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      );

  Widget _buildSliverHead() {
    return SliverPersistentHeader(
      delegate: DetailSliverDelegate(
          expanded_height, person, rounded_container_height),
    );
  }

  Widget _buildName() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: Column(children: <Widget>[
          Row(children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Align(
                      alignment: Alignment.topLeft,
                      child: person == null
                          ? CircularProgressIndicator()
                          : Text(person.name,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold))),
                ],
              ),
            )
          ])
        ]));
  }

  Widget _buildOverview() {
    return Column(
      children: <Widget>[
        _buildSubTitle("Biography"),
        Container(
            margin: EdgeInsets.only(left: 30, top: 5, right: 30),
            alignment: Alignment.topLeft,
            child: person == null
                ? CircularProgressIndicator()
                : Text(
                    person.biography != ""
                        ? person.biography
                        : "not available in our database",
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

  Widget _buildSubTitle(String s) => Container(
      margin: EdgeInsets.only(left: 30, top: 30),
      alignment: Alignment.topLeft,
      child: Text(
        s,
        textAlign: TextAlign.left,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ));

  Widget _buildDetail() {
    return Column(children: <Widget>[
      _buildSubTitle("Movie"),
      Container(
          height: personMovies != null ? 160 : 35,
          child: personMovies != null
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: personMovies.cast.length,
                  itemBuilder: (context, index) {
                    return new GestureDetector(
                      child: personMovies.cast[index].movie.posterPath != null
                          ? CachedNetworkImage(
                              placeholder: (context, image) {
                                return Image.asset('lib/images/user.png',
                                    fit: BoxFit.cover, height: 150, width: 100);
                              },
                              imageUrl: getPosterImage(
                                  "${personMovies.cast[index].movie.posterPath}"),
                              height: 150,
                              width: 100,
                            )
                          : Image.asset('lib/images/user.png',
                              height: 150, width: 100),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailMovieScreen(
                                  personMovies.cast[index].movie)),
                        );
                      },
                    );
                  })
              : CircularProgressIndicator()),
    ]);
  }
}

class DetailSliverDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final PersonDetail person;

  // ignore: non_constant_identifier_names
  final double rounded_container_height;

  DetailSliverDelegate(
      this.expandedHeight, this.person, this.rounded_container_height);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Hero(
            tag: person == null ? "kosong" : person.profilePath,
            child: person == null
                ? Image.asset('lib/images/user.png', fit: BoxFit.cover)
                : CachedNetworkImage(
                    imageUrl: getPosterImage(person.profilePath),
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
