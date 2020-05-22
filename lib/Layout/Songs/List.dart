import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scope_model/Songs.dart';
import '../../Helper/Form.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PlayList extends StatelessWidget {
  @override
  List<Map<String, dynamic>> _playlists = [];
  Function insertPlaylist;
  List<Map<String, dynamic>> inputFields = [
    {
      "lableText": "Title",
      'type': TextInputType.text,
      'title': "Playlist Name",
      'value': ""
    },
    {"title": "SubmitButton", 'type': "FlatButton", 'buttonTitle': "Save"}
  ];

  void onSubmit(BuildContext context) {
    Navigator.of(context).pop();
    bool exist = false;
    _playlists.forEach((item) {
      if (item["title"] == inputFields[0]['value']) {
        Fluttertoast.showToast(
            msg: "Playlist Name Already Exist",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        exist = true;
        return;
      }
    });
    if (exist) return;
    insertPlaylist({'title': inputFields[0]['value'], 'numberOfSongs': 0});
  }

  Widget buildPlaylist(dynamic item) {
    return Card(
        child: ListTile(
      title: Text(item['title']),
      trailing: Text(item['numberOfSongs'].toString()),
      onTap: () {},
    ));
  }

  Widget build(BuildContext context) {
    return ScopedModelDescendant<SongsModel>(
        builder: (BuildContext context, Widget child, SongsModel model) {
      insertPlaylist = model.insertPlaylist;
      if (_playlists.length == 0) {
        _playlists = model.getPlaylists;
      }
      return Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: ListView(
          children: <Widget>[
            Card(
                child: ListTile(
              title: Text('Artists'),
              onTap: () {
                Navigator.pushNamed(context, "/Artists");
              },
            )),
            Card(
                child: ListTile(
              title: Text('Albums'),
              onTap: () {
                Navigator.pushNamed(context, "/Albums");
              },
            )),
            Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0)),
            Card(
                child: ListTile(
              leading: Icon(
                Icons.add,
                color: Colors.red,
              ),
              title: Text('Create Playlist'),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Create Playlist"),
                        content: CustomForm(onSubmit, inputFields),
                        actions: <Widget>[
                          new FlatButton(
                            child: new Text("Close"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              },
            )),
            Column(
              children: _playlists.map((item) {
                return buildPlaylist(item);
              }).toList(),
            )
          ],
        ),
      );
    });
  }
}
