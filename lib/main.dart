import 'package:flutter/material.dart';
import 'package:movieapps/screens/search_screen.dart';
import 'package:movieapps/sidebar/sidebar_layout.dart';
import 'package:movieapps/widgets/_movies.dart';
import 'package:movieapps/widgets/_tvshow.dart';
import 'package:movieapps/widgets/discover.dart';

void main() => runApp(MaterialApp(

    debugShowCheckedModeBanner: false,
    theme: ThemeData(fontFamily: 'Montserrat'),
    color: Colors.white,
    home: SideBarLayout()));

class MovieApp extends StatefulWidget {
  @override
  _MovieAppState createState() => _MovieAppState();
}

class _MovieAppState extends State<MovieApp> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      DiscoverPage(),
      MoviesPage(),
      TvShowPage(),
    ];
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.white70,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).push(
                  new MaterialPageRoute(builder: (context) => SearchScreen()));
//                    showSearch(context: context, delegate: SearchMovies());
            },
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).push(
                  new MaterialPageRoute(builder: (context) => SearchScreen()));
//                    showSearch(context: context, delegate: SearchMovies());
            },
          )
        ],
      ),
      body: Container(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_filter),
            title: Text('Discover'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_movies),
            title: Text('Movie'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv),
            title: Text('TV Show'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
