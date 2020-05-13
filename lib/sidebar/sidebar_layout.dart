import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapps/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:movieapps/sidebar/sidebar.dart';
import 'package:movieapps/widgets/appbar_menu.dart';

class SideBarLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: BlocProvider<NavigationBloc>(
          create: (context) => NavigationBloc(),
          child: Stack(
            children: <Widget>[
              AppBarMovies(titleAppBar: ''),
              Positioned(
                top: 100,
                bottom: 0,
                right: 0,
                left: 0,
                child: BlocBuilder<NavigationBloc, NavigationStates>(
                  builder: (context, navigationState) {
                    return navigationState as Widget;
                  },
                ),
              ),
              SideBar(),
            ],
          )),
    );
  }
}
