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

class EditProduct extends StatefulWidget {
  final List list;
  final int index;

  EditProduct({this.list, this.index});
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  GlobalKey<FormState> formStateAdd = new GlobalKey<FormState>();

  TextEditingController name;
  TextEditingController description;
  TextEditingController price;
  TextEditingController discount;
  TextEditingController supplier;
  TextEditingController supplierPhoneNumber;
  String sellectedValue;
  List productItemList = [];
  int sellectedId;
  File _image1;
  File _image2;
  File _image3;
  @override
  void initState() {
    name = new TextEditingController(text: widget.list[widget.index]["title"]);
    description = new TextEditingController(
        text: widget.list[widget.index]["description"]);
    price = new TextEditingController(text: widget.list[widget.index]["price"]);
    discount =
        new TextEditingController(text: widget.list[widget.index]["discount"]);
    supplier = new TextEditingController(
        text: widget.list[widget.index]["supplier_name"]);
    supplierPhoneNumber = new TextEditingController(
        text: widget.list[widget.index]["supplier_phone"]);
    //sellectedValue = widget.list[widget.index]["category"];
    super.initState();
  }

  DatabaseHelper databaseHelper = new DatabaseHelper();
  onPressed() {
    if (name.text.trim().isNotEmpty &&
        description.text.trim().isNotEmpty &&
        price.text.trim().isNotEmpty &&
        supplier.text.trim().isNotEmpty &&
        supplierPhoneNumber.text.trim().isNotEmpty) {
      _showProgress(context);
      databaseHelper
          .editProductsV2(
              widget.list[widget.index]["id"],
              name.text.trim(),
              sellectedId,
              description.text.trim(),
              double.parse(price.text.trim()),
              supplier.text.trim(),
              supplierPhoneNumber.text.trim(),
              discount.text.trim(),
              _image1,
              _image2,
              _image3)
          .whenComplete(() {
        if (databaseHelper.status == true) {
          Navigator.of(context).pop();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ShowProducts()));

          Fluttertoast.showToast(
              msg: "تم التحديث ",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER);
        } else {
          Navigator.of(context).pop();
          _showDialog();
        }
      });
    } else {
      _showDialog();
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
      setState(() {
        productItemList = data;
      });
    }
  }

  // End Get Categories Method

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i <= productItemList.length - 1; i++) {
      if (productItemList[i]["name"] == sellectedValue) {
        setState(() {
          sellectedId = productItemList[i]["id"];
        });
      }
    }
    getCategoriesSpinner();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: buttomColor,
          title: Text("تعديل منتج"),
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
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: textColor,
                                ),
                              ),
                              child: Card(
                                color: scaffoldBackgroundColor,
                                child: _image1 == null
                                    ? Image(
                                        image: widget
                                                    .list[widget.index]
                                                        ["images"]
                                                    .length >
                                                0
                                            ? NetworkImage(
                                                "https://endana.neversd.com/${widget.list[widget.index]["images"][0]["image"]}",
                                              )
                                            : AssetImage(
                                                'assets/imgages/1.png'),
                                        fit: BoxFit.cover)
                                    : _displayImage1(),
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
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: textColor,
                                ),
                              ),
                              child: Card(
                                color: scaffoldBackgroundColor,
                                child: _image1 == null
                                    ? Image(
                                        image: widget
                                                    .list[widget.index]
                                                        ["images"]
                                                    .length >
                                                0
                                            ? NetworkImage(
                                                "https://endana.neversd.com/${widget.list[widget.index]["images"][1]["image"]}",
                                              )
                                            : AssetImage(
                                                'assets/imgages/1.png'),
                                        fit: BoxFit.cover)
                                    : _displayImage2(),
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
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: textColor,
                                ),
                              ),
                              child: Card(
                                color: scaffoldBackgroundColor,
                                child: _image1 == null
                                    ? Image(
                                        image: widget
                                                    .list[widget.index]
                                                        ["images"]
                                                    .length >
                                                0
                                            ? NetworkImage(
                                                "https://endana.neversd.com/${widget.list[widget.index]["images"][2]["image"]}",
                                              )
                                            : AssetImage(
                                                'assets/imgages/1.png'),
                                        fit: BoxFit.cover)
                                    : _displayImage3(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    buildTextFormField("اسم المنتج", name),
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
                        hint: Text("القسم"),
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 40,
                        dropdownColor: buttomColor,
                        iconEnabledColor: buttomColor,
                        onChanged: (newValue) {
                          setState(() {
                            sellectedValue = newValue;
                          });
                        },
                        items: productItemList.map((category) {
                          return DropdownMenuItem(
                            child: Text(category["name"]),
                            value: category["name"],
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    buildTextFormField("وصف المنتج", description),
                    SizedBox(
                      height: 10,
                    ),
                    buildTextFormField("سعر المنتج", price),
                    SizedBox(
                      height: 10,
                    ),
                    /* buildTextFormField(" قيمة التخفيض اختياري", discount),
                    SizedBox(
                      height: 10,
                    ),*/
                    buildTextFormField("اسم مورد المنتج", supplier),
                    SizedBox(
                      height: 10,
                    ),
                    buildTextFormField("رقم هاتف المورد", supplierPhoneNumber),
                    SizedBox(
                      height: 20,
                    ),
                    buildTextFormField("التخفيض", discount),
                    SizedBox(
                      height: 20,
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
                          onPressed();
                        },
                        child: Text(
                          "تعديل المنتج",
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

  void _selectImage(Future<File> pickImage, int imgNumber) async {
    File imgTemp = await pickImage;
    switch (imgNumber) {
      case 1:
        setState(() {
          _image1 = imgTemp;
        });
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

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: Text('خطأ'),
              content: Text('لم يتم التعديل '),
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
