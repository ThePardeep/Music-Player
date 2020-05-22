import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scope_model/Songs.dart';
import 'dart:io';

class QueueList extends StatelessWidget {
  @override
  List<Map<String, dynamic>> _queueList = [];
  Function setSongIndex, removeFromQueueList,playFromQueueList;

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
    String name = _queueList[index]['Title'].toString();
    if (name.length > 30) {
      name = name.substring(0, 30);
    }

    return Container(
      height: 60.0,
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 0),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 1.0, color: Color.fromRGBO(245, 235, 235, 1.0)))),
      child: ListTile(
        title: Text(name),
        onTap: () {
          this.playFromQueueList(index);
        },
        leading: buildLeading(_queueList[index]['Image']),
        trailing: PopupMenuButton(
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                  PopupMenuItem<String>(child: Text("Add To Playlist"), value: 'playlist'),
                  PopupMenuItem<String>(child: Text("Remove"), value: 'remove'),
                ],
            onSelected: (event) {
              if (event == "Playlist") {
                print(_queueList[index]['path']);
                this.playFromQueueList(index);
              } else if (event == "remove") {
                this.removeFromQueueList(index);
              }
            }),
      ),
    );
  }

  Widget build(BuildContext context) {
    return ScopedModelDescendant<SongsModel>(
      builder: (BuildContext context, Widget child, SongsModel model) {
        this._queueList = model.getQueue;
        this.playFromQueueList = model.playFromQueueList;
        this.removeFromQueueList = model.removeFromQueueList;

        if (_queueList.length <= 0) {
          return Center(child: Text("Empty Queue"));
        }
        return Center(
            child: ListView.builder(
                itemBuilder: _song, itemCount: _queueList.length));
      },
    );
  }
}
