import 'package:flutter/material.dart';
import '../../Player/Player.dart';

class BottomNavigation extends StatelessWidget {
  final Function _changeTabIndex;
  int _tabIndex = 0;
  bool _showPlayer;
  double _width = 56.0;
  BottomNavigation(this._changeTabIndex, this._tabIndex, this._showPlayer);
  Widget showPlayer() {
    if (_showPlayer) {
      return SizedBox(
        child: Container(

          child: new Player(),
          color: Colors.grey,
          height: 50.0,
        ),
        width: double.infinity,
      );
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    if (_showPlayer) {
      _width = 106.0;
    }
    return Container(
        height: _width,
        width: double.infinity,
        child: Column(
          children: <Widget>[
            showPlayer(),
            BottomNavigationBar(
              backgroundColor: Color.fromRGBO(245, 235, 235, 1),
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.library_music),
                  title: Text('Songs'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.playlist_play),
                  title: Text('Playlist'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.queue),
                  title: Text('Queue'),
                ),
              ],
              currentIndex: _tabIndex,
              selectedItemColor: Colors.black,
              onTap: (int index) {
                _changeTabIndex(index);
              },
            ),
          ],
        ));
  }
}
