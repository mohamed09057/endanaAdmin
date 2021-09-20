import 'dart:convert';
import 'dart:io';
import 'package:endanaAdmin/controller/databases.dart';
import 'package:endanaAdmin/screens/show_product.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  DateTime pickDate;
  DateTime toPickDate;
  String sellectedValue;
  bool checkValue = false;
  List productItemList = [];
  int sellectedId;
  File _image1;
  File _image2;
  File _image3;
  GlobalKey<FormState> formStateAdd = new GlobalKey<FormState>();
  DatabaseHelper databaseHelper = new DatabaseHelper();
  TextEditingController name = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController price = new TextEditingController();
  TextEditingController supplier = new TextEditingController();
  TextEditingController from = new TextEditingController();
  TextEditingController to = new TextEditingController();
  TextEditingController descound = new TextEditingController();
  TextEditingController supplierPhoneNumber = new TextEditingController();
  void onPressed(context) async {
    if (name.text.trim().isNotEmpty &&
        description.text.trim().isNotEmpty &&
        price.text.trim().isNotEmpty &&
        supplier.text.trim().isNotEmpty &&
        supplierPhoneNumber.text.trim().isNotEmpty) {
      _showProgress(context);
      await databaseHelper
          .addProductsV2(
              name.text.trim(),
              sellectedId,
              description.text.trim(),
              double.parse(price.text.trim()),
              supplier.text.trim(),
              supplierPhoneNumber.text.trim(),
              descound.text.trim(),
              _image1,
              _image2,
              _image3)
          .whenComplete(
        () {
          if (databaseHelper.status == true) {
            if (checkValue == true) {
              databaseHelper
                  .addAds(pickDate.toString(), toPickDate.toString(), databaseHelper.idd,
                      _image1)
                  .whenComplete(() {
                if (databaseHelper.status == true) {
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(
                      msg: "تمت اضافة المنتج",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER);
                   Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowProducts(),
                ),
              );
                }
              });
            } else {
              Navigator.of(context).pop();
              Fluttertoast.showToast(
                  msg: "تمت اضافة المنتج",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowProducts(),
                ),
              );
            }
          } else {
            Navigator.of(context).pop();
            _showDialog(context);
          }
        },
      );
    } else {
      Fluttertoast.showToast(
          msg: "الرجاء ملئ جميع الحقول",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER);
    }
  }

  // Start Get Categories Method
  getCategoriesSpinner() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl = "https://endana.neversd.com/api/categories/";
    final response = await http.get(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> data = map["data"];
      setState(
        () {
          productItemList = data;
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getCategoriesSpinner();
    pickDate = DateTime.now();
    toPickDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i <= productItemList.length - 1; i++) {
      if (productItemList[i]["name"] == sellectedValue) {
        setState(
          () {
            sellectedId = productItemList[i]["id"];
          },
        );
      }
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: buttomColor,
          title: Text("اضافة منتج"),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 50),
              width: double.infinity,
              child: Form(
                key: formStateAdd,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _selectImage(
                                  // ignore: deprecated_member_use
                                  ImagePicker.pickImage(
                                      source: ImageSource.gallery),
                                  1);
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 0, 20),
                              height: 120,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: textColor,
                                ),
                              ),
                              child: Card(
                                color: scaffoldBackgroundColor,
                                child: _displayImage1(),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _selectImage(
                                  // ignore: deprecated_member_use
                                  ImagePicker.pickImage(
                                      source: ImageSource.gallery),
                                  2);
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 0, 20),
                              height: 120,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: textColor,
                                ),
                              ),
                              child: Card(
                                color: scaffoldBackgroundColor,
                                child: _displayImage2(),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _selectImage(
                                  // ignore: deprecated_member_use
                                  ImagePicker.pickImage(
                                      source: ImageSource.gallery),
                                  3);
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                              height: 120,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: textColor,
                                ),
                              ),
                              child: Card(
                                color: scaffoldBackgroundColor,
                                child: _displayImage3(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    buildTextFormField("اسم المنتج", name, null),
                    SizedBox(
                      height: 10,
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
                        hint: Text("اختار القسم"),
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
                        items: productItemList.map(
                          (category) {
                            return DropdownMenuItem(
                              child: Text(category["name"]),
                              value: category["name"],
                            );
                          },
                        ).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    buildTextFormField("وصف المنتج", description, null),
                    SizedBox(
                      height: 10,
                    ),
                    buildTextFormField("سعر المنتج", price, TextInputType.number),
                    SizedBox(
                      height: 10,
                    ),
                    buildTextFormField(
                        " اسم مورد المنتج رباعي", supplier, null),
                    SizedBox(
                      height: 10,
                    ),
                    buildTextFormField("رقم هاتف المورد", supplierPhoneNumber,
                        TextInputType.number),
                        SizedBox(
                      height: 10,
                    ),
                    buildTextFormField("التخفيض (اختياري)", descound,
                        TextInputType.number),
                    CheckboxListTile(
                        title: Text("اضافة المنتج للاسلايدر"),
                        value: checkValue,
                        onChanged: (newValue) {
                          setState(() {
                            checkValue = newValue;
                          });
                        }),
                    checkValue
                        ? Column(
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
                          ],
                        )
                        : SizedBox(
                            height: 0,
                          ),
                    SizedBox(
                      width: double.infinity,
                      child: MaterialButton(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        color: buttomColor,
                        onPressed: () {
                          onPressed(context);
                        },
                        child: Text(
                          "اضافة المنتج",
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

  TextFormField buildTextFormField(
      String myHint, TextEditingController controller, myKeboard) {
    return TextFormField(
      keyboardType: myKeboard,
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

  void _selectImage(Future<File> pickImage, int imgNumber) async {
    File imgTemp = await pickImage;
    switch (imgNumber) {
      case 1:
        {
          setState(() {
            _image1 = imgTemp;
          });
        }
        break;
      case 2:
        setState(() {
          _image2 = imgTemp;
        });
        break;
      case 3:
        setState(() {
          _image3 = imgTemp;
        });
        break;
    }
  }

  Widget _displayImage1() {
    if (_image1 == null) {
      return Icon(
        Icons.add,
        color: buttomColor,
        size: 30,
      );
    } else {
      return Image.file(_image1);
    }
  }

  Widget _displayImage2() {
    if (_image2 == null) {
      return Icon(
        Icons.add,
        color: buttomColor,
        size: 30,
      );
    } else {
      return Image.file(_image2);
    }
  }

  Widget _displayImage3() {
    if (_image3 == null) {
      return Icon(
        Icons.add,
        color: buttomColor,
        size: 30,
      );
    } else {
      return Image.file(_image3);
    }
  }

  void validateAndUpload() {
    if (formStateAdd.currentState.validate()) {
      if (_image1 != null && _image2 != null && _image3 != null) {
      } else {
        Fluttertoast.showToast(msg: 'يجب ادخال جميع الصور');
      }
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


  void _showDialog(context) {
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
