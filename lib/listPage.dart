import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rapidd/singleton.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  TextEditingController listNameController = TextEditingController();
  List<String> listName = List<String>();

  @override
  void initState() {
    super.initState();
    listName = Singleton.instance.prefs.getStringList('listName');
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: listName.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: size.height * 0.3,
                    child: Card(
                      elevation: 10,
                      margin: EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          listName[index],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
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
                            child: Icon(Icons.close),
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
                              decoration:
                                  InputDecoration(hintText: "List Name"),
                            ),
                            FlatButton(
                              child: Text("Save"),
                              onPressed: () {
                                if (listNameController.text.isNotEmpty) {
                                  listName.add(listNameController.text);
                                  Singleton.instance.prefs
                                      .setStringList('listName', listName);
                                  listNameController.clear();
                                  Navigator.of(context).pop();
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
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
