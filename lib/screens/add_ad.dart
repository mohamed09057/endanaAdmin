import 'dart:convert';
import 'dart:io';
import 'package:endanaAdmin/screens/show_ads.dart';
import 'package:http/http.dart' as http;
import 'package:endanaAdmin/controller/databases.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class AddAd extends StatefulWidget {
  @override
  _AddAdState createState() => _AddAdState();
}

class _AddAdState extends State<AddAd> {
  DateTime pickDate;
  DateTime toPickDate;

  GlobalKey<FormState> formStateAddSubAdmin = new GlobalKey<FormState>();
  TextEditingController fromDate = new TextEditingController();
  TextEditingController toDate = new TextEditingController();
  TextEditingController productNumber = new TextEditingController();
  int group = 1;
  File file;

  Future pickergellary() async {
    final myfile = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      file = File(myfile.path);
    });
  }

  DatabaseHelper databaseHelper = new DatabaseHelper();
  onPressed() async {
    _showProgress(context);
    await databaseHelper
        .addAds(pickDate.toString(), toPickDate.toString(), sellectedId, file)
        .whenComplete(() {
      if (databaseHelper.status == true) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: "  الاضافة تمت",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER);
        Navigator.of(context).pop();
        Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ShowAds()));
      } else {
        Navigator.of(context).pop();
        _showDialog();
      }
    });
  }

  List productItemList = [];
  int sellectedId;
  // Start Get Categories Method
  getCategoriesSpinner() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl = "https://endana.neversd.com/api/products";
    final response = await http.get(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> data = map["data"];
      setState(() {
        productItemList = data;
      });
      print(productItemList);
    }
  }

  @override
  void initState() {
    getCategoriesSpinner();
    super.initState();
    pickDate = DateTime.now();
    toPickDate = DateTime.now();
  }

  String sellectedValue;
  String file1="";

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i <= productItemList.length - 1; i++) {
      if (productItemList[i]["title"] == sellectedValue) {
        setState(() {
          sellectedId = productItemList[i]["id"];
          file1 = productItemList[i]["images"][0]["image"];
        });
        print(file1);
      }
    }
    databaseHelper.getAds();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: buttomColor,
          title: Text("اضافة منتج للاسلايدر"),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 50),
              width: double.infinity,
              child: Form(
                key: formStateAddSubAdmin,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "من تاريخ",
                      style: TextStyle(fontSize: 20),
                    ),
                    ListTile(
                      title: Text(
                          "${pickDate.year} - ${pickDate.month} - ${pickDate.day}"),
                      leading: Icon(
                        Icons.date_range_outlined,
                        color: buttomColor,
                      ),
                      onTap: _pickDate,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "الى تاريخ",
                      style: TextStyle(fontSize: 20),
                    ),
                    ListTile(
                      title: Text(
                          "${toPickDate.year} - ${toPickDate.month} - ${toPickDate.day}"),
                      leading: Icon(
                        Icons.date_range_outlined,
                        color: buttomColor,
                      ),
                      onTap: _toPickDate,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.fromLTRB(0, 3, 5, 0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(width: 1, color: textColor),
                      ),
                      child: DropdownButton(
                        autofocus: true,
                        value: sellectedValue,
                        isExpanded: true,
                        isDense: true,
                        hint: Text("اختار المنتج"),
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 40,
                        dropdownColor: buttomColor,
                        iconEnabledColor: buttomColor,
                        onChanged: (newValue) {
                          setState(() {
                            sellectedValue = newValue;
                          });
                        },
                        items: productItemList.map((product) {
                          return DropdownMenuItem(
                            child: Text(product["title"]),
                            value: product["title"],
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: pickergellary,
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 1.0),
                        ),
                        child: Center(
                            child: file == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: Colors.blue,
                                        size: 35,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text('اضغط هنا لاضافة صورة ')
                                    ],
                                  )
                                : Image.file(file)),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    /* Row(
                      children: [
                        Radio(
                          focusColor: buttomColor,
                          activeColor: buttomColor,
                          value: 1,
                          groupValue: group,
                          onChanged: (value) => setState(() {
                            group = value;
                          }),
                        ),
                        Text("ٌADMIN"),
                        SizedBox(
                          width: 30,
                        ),
                        Radio(
                           focusColor: buttomColor,
                          activeColor: buttomColor,
                          value: 2,z
                          groupValue: group,
                          onChanged: (value) => setState(() {
                            group = value;
                          }),
                        ),
                        Text("ٌSUB ADMIN"),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),*/
                    SizedBox(
                      width: double.infinity,
                      child: MaterialButton(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        color: buttomColor,
                        onPressed: () {
                          onPressed();
                        },
                        child: Text(
                          "اضافة",
                          style: TextStyle(
                            fontSize: 18,
                            color: scaffoldBackgroundColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _pickDate() async {
    DateTime date = await showDatePicker(
        context: context,
        initialDate: DateTime(DateTime.now().year),
        firstDate: DateTime(DateTime.now().year),
        lastDate: pickDate);
    if (date != null) {
      setState(() {
        pickDate = date;
      });
    }
  }

  _toPickDate() async {
    DateTime date = await showDatePicker(
        context: context,
        initialDate: DateTime(DateTime.now().year),
        firstDate: DateTime(DateTime.now().year),
        lastDate: toPickDate);
    if (date != null) {
      setState(() {
        toPickDate = date;
      });
    }
  }

  TextFormField buildTextFormField(
      String myHint, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: myHint,
        contentPadding: EdgeInsets.all(3),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: textColor,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: notificationColor,
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
      ),
    );
  }

  void validateAndUpload() {
    if (formStateAddSubAdmin.currentState.validate()) {
      Fluttertoast.showToast(msg: 'تمت اضافة المدير');
    }
  }

  void _showProgress(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CircularProgressIndicator(),
                Text(
                  'الرجاء الانتظار',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        });
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: Text('خطأ'),
              content: Text('لم تتم الاضافة'),
              actions: [
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "موافق",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: buttomColor),
                    )),
              ],
            ),
          );
        });
  }
}
