import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class OrderReports extends StatefulWidget {
  @override
  _OrderReportsState createState() => _OrderReportsState();
}

class _OrderReportsState extends State<OrderReports> {
  List<String> productItemList = <String>[
    "created_at",
    "name"
  ];
  String sellectedValue = "created_at";
  DateTime pickDate;
  DateTime toPickDate;
  static List mainDataList = [];
  List newDataList = [];
  getData1() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl = "https://endana.neversd.com/api/orders";
    var response = await http.get(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    });
    Map map = json.decode(response.body);
    List data = map["data"];
    print(data);
    for (int i = 0; i < data.length; i++) {
      mainDataList.add(data[i]);
    }
    setState(() {
      newDataList = List.from(mainDataList);
    });
  }

  TextEditingController _textEditingController = TextEditingController();

  onItemChanged(value) async {
    setState(
      () {
        newDataList = mainDataList
            .where((element) =>sellectedValue=="name"?
                element["user"]["$sellectedValue"].toLowerCase().contains(value)
                :element["$sellectedValue"].toLowerCase().contains(value))
            .toList();
      },
    );
  }

  @override
  void initState() {
    getData1();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: buttomColor,
          centerTitle: true,
          title: Text("تقارير الطلبات"),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(20, 5, 20, 0),
              height: 50,
              padding: EdgeInsets.fromLTRB(0, 3, 5, 0),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 1, color: textColor),
              ),
              child: DropdownButton<String>(
                autofocus: true,
                elevation: 5,
                value: sellectedValue,
                isExpanded: true,
                isDense: true,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 40,
                dropdownColor: buttomColor,
                iconEnabledColor: buttomColor,
                onChanged: (newValue) {
                  setState(
                    () {
                      sellectedValue = newValue;
                    },
                  );
                },
                items: productItemList.map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem<String>(
                      child: Text(value=="created_at"?"التاريخ":"اسم الزبون"),
                      value: value,
                    );
                  },
                ).toList(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                margin: EdgeInsets.fromLTRB(20, 7, 20, 0),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1,
                      spreadRadius: 0.1,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    cursorColor: buttomColor,
                    controller: _textEditingController,
                    decoration: InputDecoration.collapsed(
                      hintText: 'بحث عن طلب ...',
                    ),
                    onChanged: onItemChanged,
                  ),
                )),
            newDataList.length > 0
                ? Expanded(
                    child: Container(
                      child: ListView(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: [
                                DataColumn(
                                    label: Text(
                                  'رقم الطلب',
                                  style: TextStyle(color: buttomColor),
                                )),
                                DataColumn(
                                    label: Text(
                                  'التاريخ',
                                  style: TextStyle(color: buttomColor),
                                )),
                                DataColumn(
                                    label: Text(
                                  'سعر الطلب',
                                  style: TextStyle(color: buttomColor),
                                )),
                                DataColumn(
                                    label: Text(
                                  'الزبون ',
                                  style: TextStyle(color: buttomColor),
                                )),
                                DataColumn(
                                    label: Text(
                                  'المنتجات ',
                                  style: TextStyle(color: buttomColor),
                                )),
                                DataColumn(
                                    label: Text(
                                  'الموردون ',
                                  style: TextStyle(color: buttomColor),
                                )),
                              ],
                              rows: newDataList.map(
                                ((element) {
                                  DateTime p =element["created_at"]!=null?
                                      DateTime.parse(element["created_at"].toString()):DateTime.parse('2019-10-30T20:30:00');
                                  double total = 0.0;
                                  for (int j = 0;
                                      j < element["products"].length;
                                      j++) {
                                    total = total +
                                        (double.parse(element["products"][j]
                                                ["price"]) *
                                            element["products"][j]["pivot"]
                                                ["quantity"]);
                                  }
                                  return DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text(
                                          "      " + element["id"].toString())),
                                      DataCell(
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                                '${p.year} - ${p.month} - ${p.day}'),
                                            Text('${p.hour}:${p.minute}'),
                                          ],
                                        ),
                                      ),
                                      DataCell(Text(total.toString())),
                                      DataCell(Text(
                                          element["user"]["name"].toString())),
                                      DataCell(
                                        element["products"].length > 0
                                            ? Container(
                                                width: 150,
                                                child: ListView.builder(
                                                  itemCount: element["products"]
                                                      .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Text(
                                                      "[${element["products"][index]["pivot"]["quantity"]}]  " +
                                                          element["products"]
                                                                      [index]
                                                                  ["title"]
                                                              .toString(),
                                                    );
                                                  },
                                                ),
                                              )
                                            : Text(""),
                                      ),
                                      DataCell(
                                        element["products"].length > 0
                                            ? Container(
                                                width: 150,
                                                child: ListView.builder(
                                                  itemCount: element["products"]
                                                      .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Text(
                                                      element["products"][index]
                                                              ["supplier_name"]
                                                          .toString(),
                                                    );
                                                  },
                                                ),
                                              )
                                            : Text(""),
                                      ),
                                    ],
                                  );
                                }),
                              ).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(
                    padding: EdgeInsets.all(50),
                    child: Center(child: CircularProgressIndicator())),
          ],
        ),
      ),
    );
  }
}
