import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rapidd/foodPage.dart';
import 'package:rapidd/rentalPage.dart';
import 'package:rapidd/shopPage.dart';
import 'package:rapidd/walletPage.dart';

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
    WalletPage(
      key: PageStorageKey('RentalPage'),
    ),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              icon: ImageIcon(
                AssetImage("assets/images/SETTINGS LOGO 1.png"),
                color: Colors.black,
              ),
              iconSize: 40,
              onPressed: null),
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: Colors.black,
          ),
          Expanded(
            child: TextField(
              cursorColor: Colors.white,
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
              onPressed: null),
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
              onPressed: null),
        ],
      ),
      bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
      body: PageStorage(
        child: pages[_selectedIndex],
        bucket: bucket,
      ),
    );
  }
}
