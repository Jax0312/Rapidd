import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rapidd/foodPage.dart';
import 'package:rapidd/rentalPage.dart';
import 'package:rapidd/shopPage.dart';
import 'package:rapidd/singleton.dart';
import 'package:rapidd/listPage.dart';
import 'package:qrscan/qrscan.dart' as Scanner;
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> pages = [
    FoodPage(
      key: PageStorageKey('FoodPage'),
      pageId: 0,
    ),
    RentalPage(
      key: PageStorageKey('RentalPage'),
    ),
    ShopPage(
      key: PageStorageKey('RentalPage'),
      pageId: 2,
    ),
    ListPage(
      key: PageStorageKey('RentalPage'),
    ),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  final TextEditingController _searchText = new TextEditingController();
  var singleton = Singleton.instance;
  var prefs;
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  Widget _bottomNavigationBar(int selectedIndex) => BottomNavigationBar(
    currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black,
        onTap: (int index) {
          setState(
            () {
              _selectedIndex = index;
              singleton.currentPage = index;
            },
          );
        },
        items: [
          new BottomNavigationBarItem(
              icon: _selectedIndex == 0
                  ? new Image.asset('assets/images/DRUMSTICK red.png', scale: 4)
                  : new Image.asset('assets/images/DRUMSTICK black.png', scale: 4),
              label: "Food"),
          new BottomNavigationBarItem(
              icon: _selectedIndex == 1
                  ? new Image.asset('assets/images/KEY RED.png', scale: 4)
                  : new Image.asset('assets/images/KEY BLACK.png', scale: 4),
              label: ('Rental')),
          new BottomNavigationBarItem(
              icon: _selectedIndex == 2
                  ? new Image.asset('assets/images/shopping cart red.png', scale: 4)
                  : new Image.asset('assets/images/shopping cart black.png', scale: 4),
              label: ('Shop')),
      new BottomNavigationBarItem(
          icon: _selectedIndex == 3
              ? new Image.asset('assets/images/list logo (red).png',
              scale: 4)
              : new Image.asset('assets/images/list logo (black).png',
              scale: 4),
          label: ('List'))
    ],
      );

  @override
  void initState() {
    super.initState();
    singleton.searchFilterController = _searchText;
    getSpInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              icon: ImageIcon(
                AssetImage("assets/images/SETTINGS LOGO 1.png"),
                color: Colors.black,
              ),
              iconSize: 40,
              onPressed: () => _key.currentState.openDrawer()),
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: Colors.black,
          ),
          Expanded(
            child: TextField(
              cursorColor: Colors.white,
              controller: _searchText,
              decoration: InputDecoration(
                hintText: "SEARCH",
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 10, bottom: 0, top: 11),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            iconSize: 40,
          ),
          VerticalDivider(
            width: 0.5,
            thickness: 1,
            color: Colors.black,
          ),
          IconButton(
              icon: ImageIcon(
                AssetImage("assets/images/qrScanner.png"),
                color: Colors.black,
              ),
              iconSize: 55,
              onPressed: () {
                _scan();
              }),
        ],
      ),
      drawer: Drawer(
        elevation: 8,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Row(children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 40.0,
                ),
                Spacer(
                  flex: 1,
                ),
                Column(
                  children: [
                    Spacer(flex: 2),
                    Text('Email'),
                    Spacer(
                      flex: 1,
                    ),
                    Text('Username'),
                    Spacer(flex: 2),
                  ],
                ),
                Spacer(
                  flex: 2,
                ),
              ]),
              decoration: BoxDecoration(
                color: Colors.red,
              ),
            ),
            ListTile(title: Text('Item 1'), leading: Icon(Icons.cancel)),
            ListTile(
              title: Text('Log out'),
              leading: Icon(Icons.directions_walk),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
      body: PageStorage(
        child: pages[_selectedIndex],
        bucket: bucket,
      ),
    );
  }

  Future _scan() async {
    String barcode = await Scanner.scan();
    print(barcode);
  }

  Future getSpInstance() async {
    Singleton.instance.prefs = await SharedPreferences.getInstance();
    if (Singleton.instance.prefs.getStringList('listNames') == null) {
      Singleton.instance.prefs.setStringList('listNames', List<String>());
    }
  }
}
