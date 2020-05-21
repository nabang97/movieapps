import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movieapps/models/moviedetail.dart';
import 'package:movieapps/models/person.dart';
import 'package:movieapps/screens/detail_screen_tv.dart';
import 'package:movieapps/utils/api_key.dart';
import 'package:movieapps/utils/global.dart';
import 'package:movieapps/widgets/read_more_text.dart';

import '../widgets/general_widget.dart' as GeneralStyle;
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
  PersonTvs personTvs;
  String dateFormatCustom = "";
  int age;

  // ignore: non_constant_identifier_names
  final double expanded_height = 400;

  // ignore: non_constant_identifier_names
  final double rounded_container_height = 50;
  var formatter = new DateFormat('yyyy-MMMM-dd');

  void setPersonDetail() async {
    await Api().getPersonDetail(widget.id).then((value) {
      setState(() {
        person = value;
        if (value.birthday != null) {
          dateFormatCustom = DateFormatCustom
              .convertDate(DateTime.parse(value.birthday))
              .date;
        }
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

  void setCastTvs() async {
    await Api().getPersonTvs(widget.id).then((value) {
      setState(() {
        personTvs = value;
      });
    }).catchError((error) {
      throw error;
    });
  }

  @override
  void initState() {
    dateFormatCustom = "";
    setPersonDetail();
    setCastMovies();
    setCastTvs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _buildSliverHead(),
          SliverToBoxAdapter(
              child: person != null ? _buildName() : Container()),
          SliverToBoxAdapter(
              child: person != null ? _buildOverview() : GeneralStyle
                  .buildLinearProgressBar(context)),
          SliverToBoxAdapter(
              child: person != null ? _buildDetail() : Container()),
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
                          : Text("${person.name}",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold))),
                ],
              ),
            )
          ]),
          dateFormatCustom == "" ? Container() : Container(
            margin: EdgeInsets.only(top: 10, bottom: 20),
            child: Row(
                children: <Widget>[
                  Icon(
                    Icons.cake,
                    color: Colors.pink,
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 10),
                      alignment: Alignment.centerLeft,
                      child: Text("$dateFormatCustom")
                  ),
                ]
            ),
          ),

          person != null ?
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 20),
            child: Row(
              children: <Widget>[
                dateFormatCustom == "" ? Container() : Expanded(
                  child: Column(
                    children: <Widget>[
                      GeneralStyle.buildContentText(
                          context, person.birthday == null ? "0" : "${DateTime
                          .now()
                          .year - DateTime
                          .parse(person.birthday)
                          .year}"),
                      GeneralStyle.buildSubtitleTwo(context, "age")
                    ],
                  ),
                ),

                Expanded(
                  child: Column(
                    children: <Widget>[
                      GeneralStyle.buildContentText(
                          context, "${person.popularity}"),
                      GeneralStyle.buildSubtitleTwo(context, "popularity")
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      GeneralStyle.buildContentText(
                          context, "${person.knownForDepartment}"),
                      GeneralStyle.buildSubtitleTwo(context, "department")
                    ],
                  ),
                )
              ],
            ),
          ) : CircularProgressIndicator(),

        ]
        )
    );
  }

  Widget _buildOverview() {
    return Column(
      children: <Widget>[
        _buildSubTitle("Biography"),
        Container(
            margin: EdgeInsets.only(left: 30, top: 5, right: 30),
            alignment: Alignment.topLeft,
            child: person != null
                ?
            ReadMoreText(
              person.biography,
              trimLines: 4,
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

                : CircularProgressIndicator()),

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
      personMovies == null || personMovies.cast.length == 0 ?
      Text("data not available")
          : Container(
          height: 150,
          child: personMovies != null
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: personMovies.cast.length,
                  itemBuilder: (context, index) {
                    return new GestureDetector(
                      child: personMovies.cast[index].movie.posterPath != null
                          ? Container(
                        padding: EdgeInsets.only(
                            left: index == 0 ? 30 : 10, top: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(12)),

                          child: CachedNetworkImage(
                              placeholder: (context, image) {
                                return Image.asset(
                                    'lib/images/miscellaneous.png',
                                    fit: BoxFit.contain, width: 90);
                              },
                              imageUrl: getPosterImage(
                                  "${personMovies.cast[index].movie.posterPath}"),
                              height: 150,
                          ),
                        ),
                      )
                          : Image.asset(
                          'lib/images/miscellaneous.png', fit: BoxFit.contain,
                          height: 150, width: 90),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailMovieScreen(
                                      personMovies.cast[index].movie)),
                        );
                      },
                    );
                  })
              : CircularProgressIndicator()),
      _buildSubTitle("TV Show"),
      personTvs == null || personTvs.cast.length == 0 ?
      Text("data not available")
          : Container(
          margin: EdgeInsets.only(bottom: 30),
          height: 150,
          child: personTvs != null
              ? ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: personTvs.cast.length,
              itemBuilder: (context, index) {
                return new GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(
                        left: index == 0 ? 30 : 10, top: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12)),

                      child: personTvs.cast[index].tv.posterPath != null
                          ?
                      CachedNetworkImage(
                        placeholder: (context, image) {
                          return Image.asset('lib/images/miscellaneous.png',
                              fit: BoxFit.contain);
                        },
                        imageUrl: getPosterImage(
                            "${personTvs.cast[index].tv.posterPath}"),

                      ) : Image.asset(
                          'lib/images/miscellaneous.png', fit: BoxFit.contain,
                          width: 90),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DetailTvScreen(
                                  personTvs.cast[index].tv)),
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
