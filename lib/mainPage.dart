import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rapidd/foodPage.dart';
import 'package:rapidd/rentalPage.dart';
import 'package:rapidd/shopPage.dart';
import 'package:rapidd/singleton.dart';
import 'package:rapidd/listPage.dart';
import 'package:qrscan/qrscan.dart' as Scanner;

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> pages = [
    FoodPage(
      key: PageStorageKey('FoodPage'),
    ),
    RentalPage(
      key: PageStorageKey('RentalPage'),
    ),
    ShopPage(
      key: PageStorageKey('RentalPage'),
    ),
    ListPage(
      key: PageStorageKey('RentalPage'),
    ),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  final TextEditingController _searchText = new TextEditingController();
  var singleton = Singleton.instance;
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  Widget _bottomNavigationBar(int selectedIndex) => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black,
        onTap: (int index) {
          setState(
            () {
              _selectedIndex = index;
            },
          );
        },
        currentIndex: selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/New_Drumstick.png"),
            ),
            label: "Food",
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/New_Key.png"),
            ),
            label: "Rental",
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/SHOPPING CART.png"),
            ),
            label: "Shop",
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/list logo.png"),
            ),
            label: "List",
          ),
        ],
      );

  @override
  void initState() {
    super.initState();
    singleton.searchFilterController = _searchText;
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
}
