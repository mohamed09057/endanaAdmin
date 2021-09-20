import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class ProductReports extends StatefulWidget {
  @override
  _ProductReportsState createState() => _ProductReportsState();
}

class _ProductReportsState extends State<ProductReports> {
  List<String> productItemList = <String>["title", "price", "supplier_name"];
  String sellectedValue = "title";
  DateTime pickDate;
  DateTime toPickDate;
  static List mainDataList = [];
  List newDataList = [];
  getData1() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl = "https://endana.neversd.com/api/products";
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
            .where((element) =>
                element["$sellectedValue"].toLowerCase().contains(value))
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
          title: Text("تقارير المنتجات"),
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
                    String n;
                    if (value == "title") {
                      n = "اسم المنتج";
                    } else if (value == "price") {
                      n = "سعر المنتج";
                    } else {
                      n = "اسم المورد";
                    }
                    return DropdownMenuItem<String>(
                      child: Text(n),
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
                      hintText: 'بحث عن منتج ...',
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
                              showCheckboxColumn: true,
                              columns: [
                                DataColumn(
                                    label: Text(
                                  'الرقم',
                                  style: TextStyle(color: buttomColor),
                                )),
                                DataColumn(
                                    label: Text(
                                  'الاسم',
                                  style: TextStyle(color: buttomColor),
                                )),
                                DataColumn(
                                    label: Text(
                                  'السعر',
                                  style: TextStyle(color: buttomColor),
                                )),
                                DataColumn(
                                    label: Text(
                                  'اسم المورد',
                                  style: TextStyle(color: buttomColor),
                                )),
                              ],
                              rows: newDataList
                                  .map(
                                    ((element) => DataRow(
                                          cells: <DataCell>[
                                            DataCell(
                                                Text(element["id"].toString())),
                                            DataCell(Text(element["title"])),
                                            DataCell(Text(element["price"])),
                                            DataCell(Text(
                                                element["supplier_name"]
                                                    .toString())),
                                          ],
                                        )),
                                  )
                                  .toList(),
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
