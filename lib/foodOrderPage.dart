import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

class FoodOrderPage extends StatefulWidget {
  final documentId;

  FoodOrderPage(this.documentId);

  @override
  _FoodOrderPageState createState() => _FoodOrderPageState();
}

class _FoodOrderPageState extends State<FoodOrderPage> {
  List<int> topBarIndex;
  int buttonID = -1;
  final db = FirebaseFirestore.instance;
  List<dynamic> topBarButton;
  GroupedItemScrollController _itemScrollController = GroupedItemScrollController();
  List<Element> _elements = List<Element>();

  @override
  void initState() {
    super.initState();
    // get Category Count and Menu
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: size.height * 0.02, maxHeight: size.height * 0.05),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: topBarButton == null ? List<Widget>() : topBarButton,
                ),
              ),
              Divider(
                thickness: 5,
              ),
              Expanded(
                child: _elements != null
                    ? StickyGroupedListView<Element, String>(
                  elements: _elements,
                  order: StickyGroupedListOrder.ASC,
                  itemScrollController: _itemScrollController,
                  groupBy: (Element element) => element.category,
                  groupSeparatorBuilder: (Element element) =>
                      Container(
                        height: size.height * 0.07,
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: size.width * 0.5,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              border: Border.all(
                                color: Colors.red,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                element.category,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                  itemBuilder: (context, Element element) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      elevation: 8.0,
                      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                      child: Stack(
                        overflow: Overflow.visible,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                            leading: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  element.name,
                                  maxLines: 2,
                                ),
                                Text(element.price),
                              ],
                            ),
                            trailing: Container(
                              width: size.width * 0.2,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.add,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        if (element.quantity > 0) {
                                          setState(() {
                                            element.quantity -= 1;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.add,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          element.quantity += 1;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: element.quantity != 0,
                            child: Positioned(
                              right: -5,
                              top: -5.0,
                              child: CircleAvatar(
                                radius: 15,
                                child: Text(
                                  element.quantity.toString(),
                                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
                    : CircularProgressIndicator(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget topButton(String _text, int _buttonID) {
    return FlatButton(
        onPressed: () {
          scrollToIndex(topBarIndex[_buttonID]);
        },
        child: Text(_text));
  }

  void scrollToIndex(int i) {
    _itemScrollController.scrollTo(index: i, duration: Duration(milliseconds: 300));
  }

  Future getData() async {
    var fireStore = FirebaseFirestore.instance;

    // get Category Count
    DocumentSnapshot documentSnapshot = await fireStore.collection("Food").doc(widget.documentId).get();
    List<dynamic> categories = documentSnapshot.get("categories");
    topBarIndex = List.filled(categories.length, 0);
    categories.sort((a, b) => a.toString().compareTo(b.toString()));
    setState(() {
      topBarButton = categories.map(
            (category) {
          this.buttonID++;
          return topButton(category, this.buttonID);
        },
      ).toList();
    });
    // get Menu Data
    int index = 0;
    String currentCategory = categories[index];
    Future<QuerySnapshot> getMenu = db.collection('Food').doc(widget.documentId).collection('Menu').orderBy('category').get();
    getMenu.then((data) {
      for (int i = 0; i < data.size; i++) {
        if (currentCategory != data.docs[i].get('category')) {
          index++;
          currentCategory = categories[index];
          topBarIndex[index] = i;
        }
        setState(() {
          _elements.add(Element(data.docs[i].get('name'), data.docs[i].get('price'), data.docs[i].get('category')));
        });
      }
    });
    print("Done");
  }
}

class Element {
  String price;
  String name;
  String category;
  int quantity = 0;

  Element(this.name, this.price, this.category);
}
