import 'package:flutter/material.dart';
import 'package:music_player/Layout/Songs/AlbumInfo.dart';
import '../Layout/Songs/Album.dart';
import '../Layout/Songs/Artists.dart';
import '../Layout/Header/DrawerElement.dart';
import '../Layout/Songs/ArtistInfo.dart';

class CustomMaterialApp extends StatelessWidget {
  @override
  String routeName;
  dynamic routeData;

  CustomMaterialApp(this.routeName, this.routeData);

  Widget buildHome(BuildContext context, String routeName) {
    if (routeName == '/Albums') {
      return new Album();
    } else if (routeName == "/Artists") {
      return new Artist();
    } else if (routeName == "/ArtistInfo") {
      int index = routeData["index"];
      return new ArtistInfo(index);
    } else if (routeName == "/AlbumInfo") {
      int index = routeData["index"];
      return new AlbumInfo(index);
    }

    return Container();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Raleway'),
      routes: {
        '/ArtistInfo': (BuildContext context) => CustomMaterialApp(
            '/ArtistInfo', ModalRoute.of(context).settings.arguments),
        '/AlbumInfo': (BuildContext context) => CustomMaterialApp(
            '/AlbumInfo', ModalRoute.of(context).settings.arguments),
      },
      home: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.black,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: Text(
            'Music App',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Color.fromRGBO(245, 235, 235, 1),
        ),
        drawer: Drawer(
          child: Container(
            height: 300.0,
            child: DrawerElement(),
          ),
        ),
        body: Container(
          child: buildHome(context, routeName),
        ),
      ),
    );
  }
}
