import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scope_model/Songs.dart';
import 'package:fluttertoast/fluttertoast.dart';
class SearchSong extends StatefulWidget {
  @override
  _StateSearchSong createState() => _StateSearchSong();
}

class _StateSearchSong extends State<SearchSong> {
  @override
  String searchSongText = '';
  Function insertToQueueUsingPath;
  List<Map<String, dynamic>> _songsList = [];
  List<Map<String, dynamic>> _searchSongs = [];

  void insertToQueue(String path) {
    Fluttertoast.showToast(
        msg: "Song Added To Queue",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0);
    this.insertToQueueUsingPath(path);
  }

  void searchSongs(String s) {
    _searchSongs.clear();
    List<Map<String, dynamic>> songs = [];

    _songsList.forEach((song) {
      if (song['Title'].toLowerCase().contains(s)) {
        songs.add(song);
      }
    });
    setState(() {
      _searchSongs = songs;
    });
  }

  Widget buildBody(BuildContext context, int index) {
    return ListTile(
      onTap: () {
        this.insertToQueue(_searchSongs[index]['path']);
      },
      title: Text(_searchSongs[index]['Title']),
    );
  }

  Widget build(BuildContext context) {
    return ScopedModelDescendant<SongsModel>(
        builder: (BuildContext context, Widget child, SongsModel model) {
      _songsList = model.getSongs;
      this.insertToQueueUsingPath = model.insertToQueueUsingPath;
      return MaterialApp(
        theme: ThemeData(fontFamily: 'Raleway'),
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            actions: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1))),
                  child: TextFormField(
                    style: TextStyle(fontSize: 20.0),
                    onChanged: (String s) {
                      searchSongs(s.toLowerCase());
                    },
                    decoration: InputDecoration(
                        hintText: "Search Song",
                        contentPadding: EdgeInsets.all(10.0),
                        border: InputBorder.none),
                  ),
                ),
              ),
            ],
          ),
          body: ListView.builder(
              itemBuilder: buildBody, itemCount: _searchSongs.length),
        ),
      );
    });
  }
}
