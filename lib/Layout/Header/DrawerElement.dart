import 'package:flutter/material.dart';

class DrawerElement extends StatelessWidget {
  final List<Map<String, dynamic>> items = [
//    {"title": "Settings", 'onTap': null},
    {"title": "Check For Update", 'onTap': null},
  ];

  Widget _buildItem(item, context) {
    return Container(
      child: ListTile(
        title: Text(
          item["title"],
          style: TextStyle(color: Color.fromRGBO(90, 86, 86, 1.0)),
        ),
        onTap: () {
          item["onTap"](context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Column(
          children: items
              .map((item) => Container(
                    margin: EdgeInsets.all(4),
                    child: _buildItem(item, context),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
