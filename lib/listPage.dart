import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rapidd/shoppingList.dart';
import 'package:rapidd/singleton.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  TextEditingController listNameController = TextEditingController();
  List<String> listName = List<String>();
  var size;

  @override
  void initState() {
    super.initState();
    listName = Singleton.instance.prefs.getStringList('listNames');
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: listName.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => listPopUp(listName[index]),
                    child: SizedBox(
                      height: size.height * 0.3,
                      child: Card(
                        shape: ContinuousRectangleBorder(
                          side: BorderSide(color: Colors.red, width: 2),
                        ),
                        elevation: 10,
                        margin: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                listName[index],
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              icon: ImageIcon(
                                AssetImage(
                                  "assets/images/rubbishBin Icon.png",
                                ),
                                size: 50,
                              ),
                              onPressed: () {
                                setState(() {
                                  Singleton.instance.prefs.remove(listName[index]);
                                  Singleton.instance.prefs.remove(listName[index] + "bool");
                                  listName.removeAt(index);
                                  Singleton.instance.prefs.setStringList('listNames', listName);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                content: Container(
                  height: size.height * 0.3,
                  child: Stack(
                    overflow: Overflow.visible,
                    children: [
                      Positioned(
                        right: -40.0,
                        top: -40.0,
                        child: InkResponse(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: CircleAvatar(
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ),
                      Form(
                        child: Column(
                          children: [
                            Text(
                              "New List",
                              textAlign: TextAlign.center,
                            ),
                            Spacer(),
                            TextFormField(
                              controller: listNameController,
                              decoration: InputDecoration(
                                hintText: "List Name",
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                            Spacer(),
                            OutlineButton(
                              child: Text("Save"),
                              highlightedBorderColor: Colors.red,
                              borderSide: BorderSide(color: Colors.red),
                              shape: StadiumBorder(),
                              splashColor: Colors.red,
                              highlightColor: Colors.white70,
                              disabledBorderColor: Colors.red,
                              onPressed: () {
                                if (listNameController.text.isNotEmpty) {
                                  setState(() {
                                    listName.add(listNameController.text);
                                    Singleton.instance.prefs.setStringList('listNames', listName);
                                    Singleton.instance.prefs
                                        .setString(listNameController.text, jsonEncode(ShoppingList(List<String>(), List<int>())));
                                    Singleton.instance.prefs.setStringList(listNameController.text + "bool", List<String>());
                                    listNameController.clear();
                                    Navigator.of(context).pop();
                                  });
                                }
                              },
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  // ignore: missing_return
  Future<Widget> listPopUp(String listName) async {
    String jsonString = Singleton.instance.prefs.getString(listName);
    Map<String, dynamic> map = jsonDecode(jsonString);
    List<String> items = List<String>.from(map['items']);
    List<int> quantities = List<int>.from(map['quantities']);
    ShoppingList shoppingList = ShoppingList(items, quantities);
    List<String> cancelVisibility = Singleton.instance.prefs.getStringList(listName + "bool");
    if (cancelVisibility.length != items.length) {
      cancelVisibility = [];
      cancelVisibility = List.filled(items.length, "0");
    }
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: size.height * 0.7,
                width: size.width * 0.8,
                decoration: BoxDecoration(
                    color: Colors.transparent, image: DecorationImage(image: AssetImage("assets/images/shoppingList paper.png"), fit: BoxFit.cover)),
                child: Column(children: [
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      itemCount: shoppingList.items.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            if (cancelVisibility[index] == "1") {
                              setState(() {
                                cancelVisibility[index] = "0";
                              });
                            } else {
                              setState(() {
                                cancelVisibility[index] = "1";
                              });
                            }
                          },
                          child: Stack(
                            overflow: Overflow.visible,
                            children: [
                              Container(
                                height: size.height * 0.05,
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Text(shoppingList.items[index]),
                                  Text(shoppingList.quantities[index].toString()),
                                ]),
                              ),
                              Positioned.fill(
                                top: 2,
                                right: 0,
                                child: Visibility(
                                  visible: cancelVisibility[index] == "1",
                                  child: Divider(
                                    thickness: 2,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ]),
              );
            },
          ),
        );
      },
    ).then((value) {
      Singleton.instance.prefs.setStringList(listName + "bool", cancelVisibility);
    });
  }
}
