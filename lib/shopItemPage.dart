import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:rapidd/shoppingList.dart';
import 'package:rapidd/singleton.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

class ShopItemPage extends StatefulWidget {
  final doc;
  final List<String> categories;

  ShopItemPage(this.doc, this.categories);

  @override
  _ShopItemPageState createState() => _ShopItemPageState();
}

class _ShopItemPageState extends State<ShopItemPage> {
  final db = FirebaseFirestore.instance;
  List<SelectedItem> selectedItemList = List<SelectedItem>();
  List<TextEditingController> quantityTextControllers = List<TextEditingController>();
  GroupedItemScrollController _itemScrollController = GroupedItemScrollController();
  List<Element> _elements = List<Element>();
  bool buttonVisible = false;
  bool _multiSelectMode = false;
  int buttonID = -1;
  List<int> topBarIndex;
  List<dynamic> topBarButton;

  @override
  void initState() {
    super.initState();
    // populate topBar jump index
    topBarIndex = List.filled(widget.categories.length, 0);
    widget.categories.sort((a, b) => a.toString().compareTo(b.toString()));
    // Assign unique button id to each top button
    topBarButton = widget.categories.map(
      (category) {
        this.buttonID++;
        return topButton(category, this.buttonID);
      },
    ).toList();
    // fetch data from firebase async
    readData();
  }

  @override
  void dispose() {
    super.dispose();
    for (TextEditingController controller in quantityTextControllers) {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: Visibility(
        visible: buttonVisible,
        child: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          onPressed: () {
            List<String> listNames = Singleton.instance.prefs.getStringList('listNames');
            String dropDownValue = listNames[0];
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                      return Container(
                        height: size.height * 0.5,
                        width: size.width * 0.7,
                        child: Column(
                          children: [
                            Text("Select a List to add to"),
                            Container(
                              height: size.height * 0.1,
                              width: size.width * 0.5,
                              child: DropdownButton(
                                value: dropDownValue,
                                items: listNames.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String newValue) {
                                  setState(() {
                                    dropDownValue = newValue;
                                  });
                                },
                              ),
                            ),
                            OutlineButton(
                              child: Text("Add"),
                              highlightedBorderColor: Colors.red,
                              borderSide: BorderSide(color: Colors.red),
                              shape: StadiumBorder(),
                              splashColor: Colors.red,
                              highlightColor: Colors.white70,
                              disabledBorderColor: Colors.red,
                              onPressed: () => encodeListToJson(dropDownValue),
                            ),
                          ],
                        ),
                      );
                    }),
                  );
                });
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: size.height * 0.02, maxHeight: size.height * 0.05),
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
                      width: size.width * 0.25,
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
                  if (quantityTextControllers[element.index].text.isEmpty) {
                    quantityTextControllers[element.index].text = "0";
                  }
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    elevation: 8.0,
                    margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                    child: Container(
                      child: ListTile(
                          selected: element.isSelected,
                          selectedTileColor: Colors.grey[300],
                          onLongPress: () => toggleSelectionMode(element),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          leading: Text(
                            element.name,
                            style: TextStyle(color: element.isSelected ? Colors.red : Colors.black),
                          ),
                          title: Visibility(
                            visible: element.isSelected,
                            child: Container(
                              height: size.height * 0.04,
                              width: size.width * 0.2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: IconButton(
                                        icon: Icon(Icons.arrow_left),
                                        onPressed: () {
                                          int value = int.parse(quantityTextControllers[element.index].text);
                                          if (value > 0) {
                                            value -= 1;
                                            quantityTextControllers[element.index].text = value.toString();
                                          }
                                          selectedItemList[element.index].quantity = value;
                                        }),
                                  ),
                                  Container(
                                    width: size.width * 0.15,
                                    child: TextField(
                                      controller: quantityTextControllers[element.index],
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(3),
                                      ],
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.fromLTRB(25.0, 20.0, 0, 25.0),
                                          border: OutlineInputBorder(borderSide: BorderSide(width: 1))),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  Expanded(
                                    child: IconButton(
                                        icon: Icon(Icons.arrow_right),
                                        onPressed: () {
                                          int value = int.parse(quantityTextControllers[element.index].text) + 1;
                                          quantityTextControllers[element.index].text = value.toString();
                                          selectedItemList[element.index].quantity = value;
                                        }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          trailing: Text(
                            element.price,
                            style: TextStyle(color: element.isSelected ? Colors.red : Colors.black),
                          ),
                          onTap: () {
                            if (_multiSelectMode) {
                              toggleSelectionMode(element);
                            }
                          }),
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

  // Widget for Category Selector
  Widget topButton(String _text, int _buttonID) {
    return FlatButton(
        onPressed: () {
          scrollToIndex(topBarIndex[_buttonID]);
        },
        child: Text(_text));
  }

  // Toggle ListTile Selection Mode
  toggleSelectionMode(Element _element) {
    setState(() {
      _element.isSelected = !_element.isSelected;
      buttonVisible = true;
      if (_element.isSelected) {
        selectedItemList[_element.index].name = _element.name;
      } else {
        int index = selectedItemList.indexWhere((item) => item.name == _element.name);
        selectedItemList[index] = new SelectedItem();
        quantityTextControllers[index].text = "0";
      }
      if (selectedItemList.indexWhere((item) => item.name != null) != -1) {
        _multiSelectMode = true;
      } else {
        _multiSelectMode = false;
      }
    });
  }

  // Get data From Firebase
  // Set Size for various lists
  Future readData() async {
    int index = 0;
    String currentCategory = widget.categories[index];
    Future<QuerySnapshot> getMenu = db.collection('Shop').doc(widget.doc).collection('Items').orderBy('category').get();
    getMenu.then((data) {
      for (int i = 0; i < data.size; i++) {
        // if new category assign jump point index
        if (currentCategory != data.docs[i].get('category')) {
          index++;
          currentCategory = widget.categories[index];
          topBarIndex[index] = i;
        }
        quantityTextControllers.add(new TextEditingController());
        selectedItemList.add(new SelectedItem());
        setState(() {
          _elements.add(Element(data.docs[i].get('name'), data.docs[i].get('price'), data.docs[i].get('category'), i));
        });
      }
    });
  }

  // Scroll to specific index of StickyList
  void scrollToIndex(int i) {
    _itemScrollController.scrollTo(index: i, duration: Duration(milliseconds: 300));
  }

  // Gather selected item
  // Remove empty element
  // Encode List to Json
  void encodeListToJson(String selectedList) {
    selectedItemList.removeWhere((item) => item.name.isEmpty);
    List<String> nameList = List<String>();
    List<int> quantities = List<int>();
    for (SelectedItem item in selectedItemList) {
      nameList.add(item.name);
      if (item.quantity != null) {
        quantities.add(item.quantity);
      } else {
        quantities.add(0);
      }
    }
    ShoppingList shoppingList = ShoppingList(nameList, quantities);
    String jsonString = jsonEncode(shoppingList);
    Singleton.instance.prefs.setString(selectedList, jsonString);
    jsonString = Singleton.instance.prefs.getString(selectedList);
    print(jsonString);
  }
}

// StickyList elements
class Element {
  String price;
  String name;
  String category;
  int index;
  bool isSelected = false;

  Element(this.name, this.price, this.category, this.index);
}

// Selected Item
class SelectedItem {
  String name = "";
  int quantity = 0;
}
