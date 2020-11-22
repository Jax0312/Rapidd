import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:rapidd/shopItemPage.dart';
import 'package:rapidd/singleton.dart';
import 'package:firebase_core/firebase_core.dart';

class ShopPage extends StatefulWidget {
  final pageId;

  const ShopPage({Key key, this.pageId}) : super(key: key);

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<ItemList> itemList = List<ItemList>();
  var singleton = Singleton.instance;
  String searchFilterText = '';

  Future<String> getStorageRef(String imgUrl) async {
    var storage = FirebaseStorage.instance;
    Reference reference = storage.refFromURL(imgUrl);
    String url = await reference.getDownloadURL();
    return Future.value(url);
  }

  Future getFireStore() async {
    await Firebase.initializeApp();
    var fireStore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await fireStore
        .collection("Shop")
        .orderBy("Shop Name", descending: false)
        .get();
    return querySnapshot.docs;
  }

  Future dataLoading() async {
    getFireStore().then((data) async {
      for (int i = 0; i < data.length; i++) {
        String url = await getStorageRef(data[i].get('img url'));
        setState(() {
          itemList.add(ItemList(data[i].get('Shop Name'), url,
              data[i].documentID, data[i].get('categories')));
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    dataLoading();
    singleton.searchFilterController.addListener(() {
      if (singleton.currentPage == widget.pageId) {
        setState(() {
          searchFilterText = singleton.searchFilterController.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            height: size.height * 0.1,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Shops",
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),
          Expanded(
            child: itemListBuilder(size),
          ),
        ],
      ),
    );
  }

  Widget itemListBuilder(var size) {
    if (itemList != null) {
      List<ItemList> filteredList = List<ItemList>();
      if (searchFilterText.isNotEmpty) {
        for (int i = 0; i < itemList.length; i++) {
          if (itemList[i]
              .vendorName
              .toLowerCase()
              .contains(searchFilterText.toLowerCase())) {
            filteredList.add(itemList[i]);
          }
        }
      } else {
        filteredList = itemList;
      }
      return ListView.builder(
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShopItemPage(
                    filteredList[index].docID,
                    List.from(filteredList[index].categories),
                  ),
                ),
              );
            },
            child: Container(
              height: size.height * 0.15,
              margin: EdgeInsets.all(6),
              color: Colors.white,
              child: Row(
                children: [
                  Container(
                    height: size.height * 0.25,
                    width: size.width * 0.5,
                    child: Image.network(
                      filteredList[index].imgUrl,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 2, bottom: 50),
                    child: Text(
                      filteredList[index].vendorName,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          );
        },
      );
    } else {
      return CircularProgressIndicator();
    }
  }
}

class ItemList {
  String vendorName;
  String imgUrl;
  String docID;
  List<dynamic> categories;

  ItemList(this.vendorName, this.imgUrl, this.docID, this.categories);
}
