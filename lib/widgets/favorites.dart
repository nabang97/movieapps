import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movieapps/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:movieapps/models/moviedetail.dart';
import 'package:movieapps/models/tvdetail.dart';
import 'package:movieapps/screens/detail_screen_movie.dart';
import 'package:movieapps/screens/detail_screen_tv.dart';
import 'package:movieapps/utils/database.dart';
import 'package:movieapps/utils/global.dart';

import 'appbar_menu.dart';
class FavoritePage extends StatefulWidget with NavigationStates {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Result> filteredMovies = List();
  List<ResultTv> filteredTvs = List();
  static int _selectedMenu = 0;

  static Future tvGenres;

  void _onMenuTapped(int index) {
    setState(() {
      _selectedMenu = index;
    });
  }

  int _selectedGenreIndex;

  void _onSelectedGenre(int index, genreId) {
    setState(() {
      _selectedGenreIndex = index;
    });
  }

  void setupList() async {
    MovieDatabase db = MovieDatabase();

    await db.getMovies().then((value) {
      setState(() {
        filteredMovies = value;
      });
    });

    await db.getTvs().then((value) {
      setState(() {
        filteredTvs = value;
      });
    });
  }

  @override
  initState() {
    super.initState();
    filteredMovies = [];
    filteredTvs = [];
    setupList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AppBarMovies(titleAppBar: 'Favorites'),
        Positioned(
            top: 100,
            left: 0,
            right: 0,
            bottom: 0,
            child: _init())
      ],);

  }

  Widget _init() {
    List<String> menu = ['Movie', 'TV Show'];
    List<Widget> _discoverOptions = <Widget>[
      _discoverMovies(),
      _discoverTvShows()
//      _discoverTvs(),
//      _buildActors()
    ];
    return Container(
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
                                  ? TextStyle(color: Colors.black, fontSize: 25)
                                  : TextStyle(color: Colors.grey, fontSize: 20),
                            ),
                            onTap: () {
                              _onMenuTapped(index);
                              _onSelectedGenre(null, null);
                            },
                          )),
                    );
                  })),
//          _selectedMenu == 2 ? Container() :  _genreMenu(),
          _discoverOptions.elementAt(_selectedMenu)
        ],
      ),
    ));
  }

  Widget _discoverMovies() => Container(
    child: Center(
        child: CarouselSlider.builder(
          itemCount: filteredMovies.length,
          itemBuilder: (context, index) {
            if (filteredMovies.length != 0) {
              return Container(
                  child: _imageMovieCarousel(filteredMovies[index]));
            }
            return CircularProgressIndicator();
          },
          //            items: filteredMovies.map((item)=> _imageMovieCarousel(item)).toList(),
          options: CarouselOptions(
              aspectRatio: 0.6,
              height: 500,
              enlargeCenterPage: true,
              autoPlay: true,
              reverse: true,
              enableInfiniteScroll: false),
        )),
      );

  Widget _discoverTvShows() => Container(
        child: Center(
            child: CarouselSlider.builder(
          itemCount: filteredTvs.length,
          itemBuilder: (context, index) {
            if (filteredTvs.length != 0) {
              return Container(child: _imageTvCarousel(filteredTvs[index]));
            }
            return CircularProgressIndicator();
          },
          options: CarouselOptions(
              aspectRatio: 0.6,
              height: 500,
              enlargeCenterPage: true,
              autoPlay: true,
              reverse: true,
              enableInfiniteScroll: false),
        )),
      );

  Widget _imageMovieCarousel(Result results) => new GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _selectedMenu == 0
                ? DetailMovieScreen(results)
                : DetailMovieScreen(results),
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
                tag: "${results.id}",
                child: Material(
                  child: results.posterPath == null
                      ? Image.asset('lib/images/user.png',
                          width: 300, fit: BoxFit.cover)
                      : CachedNetworkImage(
                          placeholder: (context, image) {
                            return Image.asset('lib/images/user.png',
                                fit: BoxFit.cover, width: 300);
                          },
                          imageUrl: getPosterImage("${results.posterPath}"),
                          imageBuilder: (context, imageProvider) => Container(
                                width: 300,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                          Colors.pink, BlendMode.colorBurn)),
                                ),
                              ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.cover,
                          width: 300),
                ))),
      ));

  Widget _imageTvCarousel(ResultTv results) => new GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailTvScreen(results),
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
                tag: "${results.id}",
                child: Material(
                  child: results.posterPath != null
                      ? CachedNetworkImage(
                          placeholder: (context, image) {
                            return Image.asset('lib/images/user.png',
                                fit: BoxFit.cover, width: 300);
                          },
                          imageUrl: getPosterImage("${results.posterPath}"),
                          imageBuilder: (context, imageProvider) => Container(
                                width: 300,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                          Colors.pink, BlendMode.colorBurn)),
                                ),
                              ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.cover,
                          width: 300)
                      : Image.asset('lib/images/user.png',
                          width: 300, fit: BoxFit.cover),
                ))),
      ));

}
