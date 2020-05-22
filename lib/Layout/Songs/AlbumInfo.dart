import 'package:flutter/material.dart';
import 'package:music_player/Helper/Song.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scope_model/Songs.dart';
import 'dart:io';

class AlbumInfo extends StatelessWidget {
  List<Map<String, dynamic>> albumSongs = [];
  int albumIndex;

  AlbumInfo(this.albumIndex);

  Widget build(BuildContext context) {
    return ScopedModelDescendant<SongsModel>(
      builder: (BuildContext context, Widget child, SongsModel model) {
        albumSongs = (model.getAlbumSongs)[albumIndex]["Songs"];

        return Container(
          child: BuildSong(albumSongs),
        );
      },
    );
  }
}
