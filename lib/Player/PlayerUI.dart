import 'package:flutter/material.dart';
import 'dart:io';
import './NowPlaying.dart';

class PlayerUI extends StatelessWidget {
  Map<String, dynamic> _song;
  Function play, pause;
  bool paused;

  PlayerUI(this._song, this.play, this.pause, this.paused);

  Widget buildButton() {
    if (paused) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 7.0),
        child: InkWell(
            child: Icon(Icons.play_arrow, color: Colors.white, size: 30.0),
            onTap: () => play()),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 7.0),
      child: InkWell(
          child: Icon(Icons.pause, color: Colors.white, size: 30.0),
          onTap: () => pause()),
    );
  }

  Widget buildLeading(img) {
    if (img != null) {
      if (img == 'unknown') {
        return ClipOval(
          child: Image.asset(
            "./assets/images/songlogo.png",
            width: 40.0,
            height: 40.0,
          ),
        );
      } else {
        File pic = new File.fromUri(Uri.parse(img));
        return ClipOval(
          child: Image.file(pic, height: 40.0, width: 40.0),
        );
      }
    } else {
      return ClipOval(
        child: Image.asset(
          "./assets/images/songlogo.png",
          width: 40.0,
          height: 40.0,
        ),
      );
    }
  }

  Widget build(BuildContext context) {
    if (_song == null) {
      return Container(
        child: Text("Null"),
      );
    }
    String Title = _song["Title"];
    if (Title.length > 22) {
      Title = Title.substring(0, 22);
      Title = Title + "...";
    }
    return InkWell(
      child: Row(
        children: <Widget>[
          Container(
            child: buildLeading(_song["Image"]),
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5.0),
          ),
          buildButton(),
          Text(
            Title,
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          )
        ],
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return new NowPlaying();
        }));
      },
    );
  }
}
