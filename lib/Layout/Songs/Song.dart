import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scope_model/Songs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';

class Song extends StatelessWidget {
  @override
  List<Map<String, dynamic>> _songList = [];
  Function playSong, setSongIndex;

  void insertToQueue(index) {
    Fluttertoast.showToast(
        msg: "Song Added To Queue",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0);
    this.setSongIndex(index);
  }

  Widget buildLeading(img) {
    if (img != null) {
      if (img == 'unknown') {
        return ClipOval(
          child: Image.asset(
            "./assets/images/songlogo.png",
            width: 50.0,
            height: 50.0,
          ),
        );
      } else {
        File pic = new File.fromUri(Uri.parse(img));
        return ClipOval(
          child: Image.file(pic, height: 50.0, width: 50.0),
        );
      }
    } else {
      return ClipOval(
        child: Image.asset(
          "./assets/images/songlogo.png",
          width: 50.0,
          height: 50.0,
        ),
      );
    }
  }

  Widget _song(BuildContext context, int index) {
    String name = _songList[index]['Title'].toString();
    dynamic img;
    if (name.length > 30) {
      name = name.substring(0, 30);
    }

    img = buildLeading(_songList[index]['Image']);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 0),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 1.0, color: Color.fromRGBO(245, 235, 235, 1.0)))),
      child: ListTile(
        title: Text(name),
        onTap: () {
          this.insertToQueue(index);
        },
        subtitle: Text(_songList[index]['Artist']),
        leading: img,
        trailing: PopupMenuButton(
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                  PopupMenuItem<String>(
                      child: Text('PlayNow'), value: 'PlayNow'),
                  PopupMenuItem<String>(child: Text('Delete'), value: 'Delete'),
                  PopupMenuItem<String>(
                      child: Text('Add To Queue'), value: 'ATQ'),
                  PopupMenuItem<String>(
                      child: Text('Add To PlayList'), value: 'ATP')
                ],
            onSelected: (action) {
              if (action == "PlayNow") {
                this.playSong(index);
              } else if (action == "ATQ") {
                this.insertToQueue(index);
              }
            }),
      ),
    );
  }

  Widget build(BuildContext context) {
    return ScopedModelDescendant<SongsModel>(
      builder: (BuildContext context, Widget child, SongsModel model) {
        this._songList = model.getSongs;
        this.playSong = model.playDirect;
        this.setSongIndex = model.setSelectedSongIndex;

        if (_songList.length <= 0) {
          return Center(child: Text("Loading..."));
        }
        return Center(
            child: ListView.builder(
                itemBuilder: _song, itemCount: _songList.length));
      },
    );
  }
}
