import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'orderCompletePage.dart';

class BookingPage extends StatefulWidget {
  final docID;
  final vendorName;
  final List type;
  final Map<String, dynamic> details;

  BookingPage(this.vendorName, this.docID, this.type, this.details);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  var size;
  String typeValue;
  String dateValue;
  String timeValue;
  String price;
  String selectedDate;
  List<String> dates;
  List time = List();
  List<bool> checkBoxes = List<bool>();
  Map<String, dynamic> details;
  TextEditingController _paxFieldController = TextEditingController();

  @override
  void initState() {
    details = widget.details;
    typeValue = widget.type[0];
    updateOptions();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.all(40),
                      child: Text(
                        widget.vendorName,
                        style: TextStyle(fontSize: 25),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Type:"),
                      Container(
                        height: size.height * 0.1,
                        width: size.width * 0.75,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  )),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ))),
                          value: typeValue,
                          items: widget.type.map<DropdownMenuItem<String>>((dynamic value) {
                            value = value.toString();
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String newValue) {
                            setState(() {
                              typeValue = newValue;
                              selectedDate = null;
                              timeValue = null;
                              updateOptions();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Date:"),
                      Container(
                        height: size.height * 0.1,
                        width: size.width * 0.75,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  )),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ))),
                          value: selectedDate,
                          items: dates.map<DropdownMenuItem<String>>((dynamic value) {
                            value = value.toString();
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String newValue) {
                            setState(() {
                              selectedDate = newValue;
                              timeValue = null;
                              updateOptions();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: selectedDate != null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Time:"),
                        multiSelectOptionMenu(),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: selectedDate != null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Pax:"),
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          height: size.height * 0.07,
                          width: size.width * 0.75,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                              color: Colors.red,
                            ),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderSide: BorderSide.none),
                            ),
                            controller: _paxFieldController,
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: size.height * 0.1,
              color: Colors.red,
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Price: ${getTotalPrice()}",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        price,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => OrderCompletePage())),
                    child: Text(
                      "Confirm Booking",
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget multiSelectOptionMenu() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      height: size.height * 0.1,
      width: size.width * 0.75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: Colors.red,
        ),
      ),
      child: ListTile(
        trailing: Icon(Icons.arrow_drop_down),
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: StatefulBuilder(builder: (BuildContext context, StateSetter updateState) {
                    return Container(
                      height: size.height * 0.6,
                      width: size.width * 0.6,
                      child: Column(
                        children: [
                          Text(
                            "Available Time",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: ListView.builder(
                                itemCount: time.length,
                                itemBuilder: (context, index) {
                                  return CheckboxListTile(
                                    activeColor: Colors.red,
                                    title: Text(time[index]),
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    value: checkBoxes[index],
                                    onChanged: (bool newValue) {
                                      updateState(() {
                                        checkBoxes[index] = newValue;
                                      });
                                      setState(() {});
                                    },
                                  );
                                }),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  checkBoxes = List.filled(time.length, false);
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Cancel",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Confirm",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }),
                );
              });
        },
      ),
    );
  }

  String getTotalPrice() {
    double actualPrice = double.parse(price.substring(2, price.length - 3));
    int totalHour = 0;
    for (bool check in checkBoxes) {
      if (check) {
        totalHour += 1;
      }
    }
    return "RM ${(actualPrice * totalHour).toStringAsFixed(2)}";
  }

  void updateOptions() {
    Map<String, dynamic> dateMap = details[typeValue];
    dates = dateMap['date'].keys.toList();
    price = dateMap['price'];
    if (selectedDate != null) {
      time = dateMap['date'][selectedDate];
      checkBoxes = List.filled(time.length, false);
    }
  }
}
