import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scope_model/Songs.dart';
import 'dart:io';

class Album extends StatelessWidget {
  List<Map<String, dynamic>> albumSongs = [];


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

  Widget buildItem(BuildContext context, int index) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1.0,
            color: Color.fromRGBO(245, 235, 235, 1.0),
          ),
        ),
      ),
      child: ListTile(
        trailing: Icon(Icons.arrow_forward_ios),
        leading: buildLeading(albumSongs[index]["Songs"][0]['Image']),
        title: Text(albumSongs[index]["Album"]),
        onTap: () {
          Navigator.pushNamed(context, "/AlbumInfo",arguments: {
            'index':index
          });
        },
      ),
    );
  }

  Widget build(BuildContext context) {
    return ScopedModelDescendant<SongsModel>(
      builder: (BuildContext context, Widget child, SongsModel model) {
        albumSongs = model.getAlbumSongs;
        return Container(
          child: ListView.builder(
            itemBuilder: buildItem,
            itemCount: albumSongs.length,
          ),
        );
      },
    );
  }
}
