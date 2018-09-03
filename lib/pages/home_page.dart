import 'package:flutter/material.dart';
import 'headline_page.dart';
import 'sources_page.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title,this.icon);
}

class HomePage extends StatefulWidget{

  final drawerItems = [
    new DrawerItem("Headlines", Icons.rss_feed),
    new DrawerItem("Sources", Icons.info)
  ];

  @override
  State<StatefulWidget> createState() {
    return new _HomePageState();
  }

}

class _HomePageState extends State<HomePage>{

  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return HeadlinePage();
      case 1:
        return SourcesPage();

      default:
        return Text("Error");
    }
  }

  _onSelectItem(int index){
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {

    var drawerOptions = <Widget>[];

    for (var i = 0; i < widget.drawerItems.length; i++){
      var d = widget.drawerItems[i];
      drawerOptions.add(
        ListTile(
          leading: Icon(d.icon),
          title: Text(d.title),
          selected: i == _selectedDrawerIndex,
          onTap: () => _onSelectItem(i),
        )
      );
    }

    return new Scaffold(
      appBar: AppBar(
        title: Text(widget.drawerItems[_selectedDrawerIndex].title),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("THE NEWS"),
              accountEmail: Text("Daily News From Varoius Sources"),
            ),
            Column(
              children: drawerOptions,
            )
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }

}