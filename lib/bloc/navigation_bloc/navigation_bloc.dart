import 'package:bloc/bloc.dart';
import 'package:movieapps/widgets/_movies.dart';
import 'package:movieapps/widgets/_tvshow.dart';
import 'package:movieapps/widgets/discover.dart';
import 'package:movieapps/widgets/favorites.dart';

enum NavigationEvents {
  HomePageClickedEvent,
  MovieClickedEvent,
  TvShowClickedEvent,
  FavoriteClickedEvent
}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  @override
  // TODO: implement initialState
  NavigationStates get initialState => DiscoverPage();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.HomePageClickedEvent:
        yield DiscoverPage();
        break;
      case NavigationEvents.MovieClickedEvent:
        yield MoviesPage();
        break;
      case NavigationEvents.TvShowClickedEvent:
        yield TvShowPage();
        break;
      case NavigationEvents.FavoriteClickedEvent:
        yield FavoritePage();
        break;
    }
  }
}
