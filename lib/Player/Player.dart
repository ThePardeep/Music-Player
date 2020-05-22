import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './PlayerUI.dart';
import '../scope_model/Songs.dart';

class Player extends StatelessWidget {

  Widget build(BuildContext context) {
    return new ScopedModelDescendant<SongsModel>(
        builder: (BuildContext context, Widget child, SongsModel model) {
      return PlayerUI(model.getSelectedSong(model.getSelectedSongIndex),
          model.resume, model.pause, model.paused);
    });
  }
}
