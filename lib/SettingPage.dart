import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final appTitle = 'Drawer Demo';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('My Page!')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Row(
                  children: [ CircleAvatar(
                    backgroundImage:AssetImage('lib/Ellipse 1.png'),
                    radius: 40.0,
                  ),
                    Spacer(
                      flex:1,
                    ),
                    Column(
                      children: [
                        Spacer(
                            flex:2
                        ),
                        Text('Email'),
                        Spacer(
                          flex: 1,
                        ),
                        Text('Username'),
                        Spacer(
                            flex:2
                        ),
                      ],
                    ),
                    Spacer(
                      flex: 2,
                    ),
                  ]),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              leading:   CircleAvatar(
                backgroundImage:AssetImage('lib/Ellipse 1.png'),
                radius: 40.0,
              ),
            ),
            ListTile(
              title: Text('Log out'),
              leading:  CircleAvatar(
                backgroundImage:AssetImage('lib/Ellipse 1.png'),
                radius: 40.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}