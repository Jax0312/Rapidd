import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rapidd/foodMenuPage.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({Key key}) : super(key: key);

  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  List<String> imgUrls = List<String>();
  String url = "";
  Future _data;

  Future<String> getStorageRef(String imgUrl) async {
    var storage = FirebaseStorage.instance;
    Reference reference = storage.refFromURL(imgUrl);
    url = await reference.getDownloadURL();
    return Future.value(url);
  }

  Future getFireStore() async {
    await Firebase.initializeApp();
    var fireStore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await fireStore
        .collection("Food")
        .orderBy("Res Name", descending: false)
        .get();
    setState(() {});
    return querySnapshot.docs;
  }

  Future imageLoading() async {
    getFireStore().then((data) async {
      List<String> urls = new List(data.length);
      for (int i = 0; i < data.length; i++) {
        urls[i] = await getStorageRef(data[i].get('img url'));
      }
      setState(() {
        this.imgUrls = List.from(urls);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _data = getFireStore();
    imageLoading();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: FutureBuilder(
              future: _data,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error.toString());
                }
                if (snapshot.connectionState == ConnectionState.waiting ||
                    !snapshot.hasData) {
                  return Center(
                    child: Text("Loading......"),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FoodMenuPage(
                                      snapshot.data[index].documentID,
                                      List.from(snapshot.data[index]
                                          .get('categories')))));
                        },
                        child: Container(
                          height: size.height * 0.15,
                          margin: EdgeInsets.all(6),
                          color: Colors.white,
                          child: Row(
                            children: [
                              imageWithErrorHandling(index, size),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 2, bottom: 50),
                                child: Text(
                                  snapshot.data[index].data()['Res Name'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // ignore: missing_return
  Widget imageWithErrorHandling(int index, var size) {
    try {
      if (imgUrls[index].isNotEmpty) {
        return Container(
          height: size.height * 0.25,
          width: size.width * 0.5,
          child: Image.network(
            imgUrls[index],
            fit: BoxFit.fill,
          ),
        );
      }
    } on RangeError {
      return Container(
        height: size.height * 0.25,
        width: size.width * 0.5,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
