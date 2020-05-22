import 'package:flutter/material.dart';
import "./Layout/Header/DrawerElement.dart";
import './Layout/Songs/List.dart';
import './Layout/Songs/Song.dart';
import 'package:scoped_model/scoped_model.dart';
import './scope_model/Songs.dart';
import './Layout/Footer/Footer.dart';
import './Layout/Songs/Search.dart';
import "./Layout/Songs/QueueList.dart";
import './Helper/CustomMaterialApp.dart';

void main() => runApp(APP());

class APP extends StatelessWidget {
  final ThemeData myTheme = ThemeData(fontFamily: 'Raleway');
  @override
  Widget build(BuildContext context) {
    return ScopedModel<SongsModel>(
      model: new SongsModel(),
      child: MaterialApp(
        theme: myTheme,
        home: new Home(),
        routes: {
          '/search': (BuildContext context) => SearchSong(),
          '/Albums': (BuildContext context) => CustomMaterialApp('/Albums',null),
          '/Artists': (BuildContext context) => CustomMaterialApp('/Artists',null),
        },

      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _Home createState() {
    return new _Home();
  }
}

class _Home extends State<Home>  with WidgetsBindingObserver {
  Map<String, dynamic> error = {"msg": "", "error": false};
  int _tabIndex = 0;
  String url = "null";

  void _changeTabIndex(int tabIndex) {
    setState(() {
      _tabIndex = tabIndex;
    });
  }

  Widget _buildBodyWidget(BuildContext context) {
    if (_tabIndex == 0) {
      return new Song();
    } else if (_tabIndex == 1) {
      return new PlayList();
    } else if (_tabIndex == 2) {
      return new QueueList();
    }
    return Container();
  }


  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SongsModel>(
      builder: (BuildContext context, Widget child, SongsModel model) {
        return Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    return Navigator.pushNamed(context, "/search");
                  })
            ],
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
            child: _buildBodyWidget(context),
          ),
          bottomNavigationBar:
              BottomNavigation(_changeTabIndex, _tabIndex, model.showPlayer),
        );
      },
    );
  }
}
