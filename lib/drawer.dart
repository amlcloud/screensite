import 'package:flutter/material.dart';
import 'package:screensite/search/search_page.dart';
import 'package:screensite/lists/lists_page.dart';
import 'package:logo/logo.dart';

class TheDrawer {
  static Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              child: Container(
            child: Logo(),
            // Column(children: <Widget>[
            //   Material(
            //     child: Image.asset("amlcloud-lg.png", height: 50, width: 50),
            //   )
            // ]),
          )),
          ListTile(
              leading: IconButton(
                icon: Icon(Icons.search),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
              title: const Text('Search'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return SearchPage();
                  },
                ));
              }),
          ListTile(
              leading: IconButton(
                icon: Icon(Icons.view_list),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
              title: const Text('Lists'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return ListsPage();
                  },
                ));
              }),
        ],
      ),
    );
  }
}
