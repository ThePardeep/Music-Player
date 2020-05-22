import 'package:flutter/material.dart';
import 'package:music_player/Helper/Song.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scope_model/Songs.dart';

class ArtistInfo extends StatelessWidget {
  List<Map<String, dynamic>> artistSongs = [];
  int artistIndex;

  ArtistInfo(this.artistIndex);


  Widget build(BuildContext context) {
    return ScopedModelDescendant<SongsModel>(
      builder: (BuildContext context, Widget child, SongsModel model) {
        artistSongs = (model.getArtistSongs)[artistIndex]["Songs"];
        return Container(
          child: BuildSong(artistSongs),
        );
      },
    );
  }
}
