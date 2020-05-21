import 'dart:core';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movieapps/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:movieapps/models/tvdetail.dart';
import 'package:movieapps/models/tvshow.dart';
import 'package:movieapps/screens/detail_screen_tv.dart';
import 'package:movieapps/utils/api_key.dart';
import 'package:movieapps/utils/global.dart';
import 'package:movieapps/widgets/general_widget.dart' as GeneralStyle;

import 'appbar_menu.dart';

class TvShowPage extends StatefulWidget with NavigationStates {
  @override
  _TvShowPageState createState() => _TvShowPageState();
}

class _TvShowPageState extends State<TvShowPage> {
  Future<TvShows> futureTvs;
  static Future tvGenres;
  static int _selectedMenu = 0;
  static int _selectedGenreIndex;
  static int _selectedGenre;
  static String _selectedMenuTv = 'on_the_air';
  List<String> menu = ['On Air', 'Airing Today', 'Top Rated', 'Popular'];
  List<String> _discoverOptions = <String>[
    'on_the_air',
    'airing_today',
    'top_rated',
    'popular'
  ];

  void _onMenuTapped(int index) {
    setState(() {
      _selectedMenu = index;
    });
  }

  void _onSelectedGenre(int index, genreId) {
    setState(() {
      _selectedGenreIndex = index;
      _selectedGenre = genreId;
    });
  }

  void _onSelectedMenu(String type) {
    setState(() {
      _selectedMenuTv = type;
    });
  }

  void showItems() {
    setState(() {
      futureTvs = Api().getNowPlayingTvs(_selectedMenuTv, _selectedGenre);
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedGenreIndex = null;
    _selectedGenre = null;
    showItems();
    tvGenres = Api().getTvGenreList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AppBarMovies(titleAppBar: 'TV SHOW'),
        Positioned(
            top: 100,
            left: 0,
            right: 0,
            bottom: 0,
            child: _init())
      ],);
  }

  Widget _init() {
    return Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                  height: 50,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: menu.length,
                      itemBuilder: (context, index) {
                        return new Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: GestureDetector(
                                child: Text.rich(
                                  TextSpan(
                                      text: menu[index],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat')),
                                  textAlign: TextAlign.left,
                                  style: _selectedMenu == index
                                      ? TextStyle(
                                          color: Colors.black, fontSize: 25)
                                      : TextStyle(
                                          color: Colors.grey, fontSize: 20),
                                ),
                                onTap: () {
                                  _onMenuTapped(index);
                                  _onSelectedMenu(_discoverOptions[index]);
                                  showItems();
                                },
                              )),
                        );
                      })),
              _genreMenu(),
              _nowPlaying()
            ],
          ),
        ));
  }

  Widget _nowPlaying() {
    return Container(
      child: Center(
        child: FutureBuilder<TvShows>(
            future: futureTvs,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return new CarouselSlider.builder(
                  itemCount: snapshot.data.results.length,
                  itemBuilder: (context, index) {
                    return Container(
                        child: _imageCarousel(snapshot.data.results, index));
                  },
                  // items: listCarousel,
                  options: CarouselOptions(
                      aspectRatio: 0.6,
                      height: 500,
                      enlargeCenterPage: true,
                      autoPlay: true),
                );
              }

              if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              if (snapshot.connectionState == ConnectionState.none) {
                return Text("Connection not available");
              }

              return GeneralStyle.buildLinearProgressBar(context);
            }),
      ),
    );
  }

  Widget _imageCarousel(List<ResultTv> results, int index) =>
      new GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailTvScreen(results[index]),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 30),
            decoration: new BoxDecoration(
              boxShadow: [
                new BoxShadow(
                  color: Colors.grey[300],
                  blurRadius: 20.0, // has the effect of softening the shadow
                  spreadRadius: 2.0, // has the effect of extending the shadow
                  offset: Offset(
                    5.0, // horizontal, move right 10
                    5.0, // vertical, move down 10
                  ),
                )
              ],
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Hero(
                    tag: "${results[index].id}",
                    child: Material(
                      child: results[index].posterPath == null
                          ? Image.asset('lib/images/miscellaneous.png',
                          fit: BoxFit.contain,
                          width: 300)
                          : CachedNetworkImage(
                              placeholder: (context, image) {
                                return Image.asset(
                                    'lib/images/miscellaneous.png',
                                    fit: BoxFit.contain, width: 300);
                              },
                              imageUrl: getPosterImage(
                                  "${results[index].posterPath}"),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                    width: 300,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                          colorFilter: ColorFilter.mode(
                                              Colors.pink,
                                              BlendMode.colorBurn)),
                                    ),
                                  ),
                              errorWidget: (context, url, error) =>
                                  Image.asset('lib/images/miscellaneous.png',
                                      fit: BoxFit.contain,
                              width: 300),
                    ))),
            )));

  Widget _genreMenu() => Container(
        width: double.infinity,
        height: 60,
        child: FutureBuilder(
            future: tvGenres,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 15.0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            child: Center(
                                child: Text(
                              snapshot.data[index].name.toString(),
                                  style: TextStyle(color: _selectedGenreIndex ==
                                      index ? Colors.black : Colors.black54,
                                      fontSize: _selectedGenreIndex == index
                                          ? 15
                                          : 14),
                            )),
                            decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey[300],
                                )),
                          ),
                          onTap: () {
                            _onSelectedGenre(index, snapshot.data[index].id);
                            showItems();
                          });
                    });
              } else if (snapshot.hasError) {
                return Text(snapshot.error);
              }
              return Container();
            }),
      );
}
