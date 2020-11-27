import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

class FoodMenuPage extends StatefulWidget {
  final doc;
  final List<String> categories;

  FoodMenuPage(this.doc, this.categories);

  @override
  _FoodMenuPageState createState() => _FoodMenuPageState();
}

class _FoodMenuPageState extends State<FoodMenuPage> {
  List<int> topBarIndex;
  int buttonID = -1;
  final db = FirebaseFirestore.instance;
  List<dynamic> topBarButton;
  GroupedItemScrollController _itemScrollController =
      GroupedItemScrollController();
  List<Element> _elements = List<Element>();

  @override
  void initState() {
    super.initState();
    topBarIndex = List.filled(widget.categories.length, 0);
    widget.categories.sort((a, b) => a.toString().compareTo(b.toString()));
    topBarButton = widget.categories.map(
      (category) {
        this.buttonID++;
        return topButton(category, this.buttonID);
      },
    ).toList();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: size.height * 0.02, maxHeight: size.height * 0.05),
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: topBarButton,
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
                      groupSeparatorBuilder: (Element element) => Container(
                        height: size.height * 0.1,
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: size.width * 0.5,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              border: Border.all(
                                color: Colors.red,
                              ),
                              borderRadius:
                              BorderRadius.all(Radius.circular(20.0)),
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
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              title: Text(element.name),
                              trailing: Text(element.price),
                            ),
                          ),
                        );
                      },

                    )
                  : CircularProgressIndicator(),
            )
          ],
        ),
      ),
    );
  }

  void scrollToIndex(int i) {
    _itemScrollController.scrollTo(
        index: i, duration: Duration(milliseconds: 300));
  }

  Future readData() async {
    int index = 0;
    String currentCategory = widget.categories[index];
    Future<QuerySnapshot> getMenu = db
        .collection('Food')
        .doc(widget.doc)
        .collection('Menu')
        .orderBy('category')
        .get();
    getMenu.then((data) {
      for (int i = 0; i < data.size; i++) {
        if (currentCategory != data.docs[i].get('category')) {
          index++;
          currentCategory = widget.categories[index];
          topBarIndex[index] = i;
        }
        setState(() {
          _elements.add(Element(data.docs[i].get('name'),
              data.docs[i].get('price'), data.docs[i].get('category')));
        });
      }
    });
  }

  Widget topButton(String _text, int _buttonID) {
    return FlatButton(
        onPressed: () {
          scrollToIndex(topBarIndex[_buttonID]);
        },
        child: Text(_text));
  }

}

class Element {
  String price;
  String name;
  String category;

  Element(this.name, this.price, this.category);
}
