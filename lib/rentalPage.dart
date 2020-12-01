import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:rapidd/bookingPage.dart';
import 'package:rapidd/singleton.dart';

class RentalPage extends StatefulWidget {
  final pageId;

  const RentalPage({Key key, this.pageId}) : super(key: key);

  @override
  _RentalPageState createState() => _RentalPageState();
}

class _RentalPageState extends State<RentalPage> {
  List<Facility> facilities = List<Facility>();
  var singleton = Singleton.instance;
  String searchFilterText = '';

  Future<String> getStorageRef(String imgUrl) async {
    var storage = FirebaseStorage.instance;
    Reference reference = storage.refFromURL(imgUrl);
    String url = await reference.getDownloadURL();
    return Future.value(url);
  }

  Future getFireStore() async {
    var fireStore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await fireStore.collection("Rental").orderBy("name", descending: false).get();
    return querySnapshot.docs;
  }

  Future dataLoading() async {
    getFireStore().then((data) async {
      for (int i = 0; i < data.length; i++) {
        String url = await getStorageRef(data[i].get('img url'));
        setState(() {
          facilities.add(Facility(data[i].get('name'), url, data[i].documentID, data[i].get('type'), data[i].get('details')));
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
                "Facilities",
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),
          Expanded(
            child: listBuilder(size),
          ),
        ],
      ),
    );
  }

  Widget listBuilder(var size) {
    if (facilities != null) {
      List<Facility> filteredList = List<Facility>();
      if (searchFilterText.isNotEmpty) {
        for (int i = 0; i < facilities.length; i++) {
          if (facilities[i].vendorName.toLowerCase().contains(searchFilterText.toLowerCase())) {
            filteredList.add(facilities[i]);
          }
        }
      } else {
        filteredList = facilities;
      }
      return ListView.builder(
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      BookingPage(filteredList[index].vendorName, filteredList[index].docID, filteredList[index].type, filteredList[index].details),
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
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 50),
                    child: Text(
                      filteredList[index].vendorName,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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

class Facility {
  String vendorName;
  String imgUrl;
  String docID;
  List type;
  Map<String, dynamic> details;

  Facility(this.vendorName, this.imgUrl, this.docID, this.type, this.details);
}
