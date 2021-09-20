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

class AddProductOptions extends StatefulWidget {
  @override
  _AddProductOptionsState createState() => _AddProductOptionsState();
}

class _AddProductOptionsState extends State<AddProductOptions> {

  GlobalKey<FormState> formStateAdd = new GlobalKey<FormState>();
  TextEditingController name = new TextEditingController();
  TextEditingController name1 = new TextEditingController();
  TextEditingController name2 = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController price = new TextEditingController();
  TextEditingController price1 = new TextEditingController();
  TextEditingController price2 = new TextEditingController();
  TextEditingController discount = new TextEditingController();
  TextEditingController supplier = new TextEditingController();
  TextEditingController supplierPhoneNumber = new TextEditingController();

  String sellectedValue;
  List productItemList = [];
  int sellectedId;
  File _image1;
  File _image2;
  File _image3;
  File _image4;
  File _image5;
  File _image6;
  File _image7;
  File _image8;
  File _image9;
  DatabaseHelper databaseHelper = new DatabaseHelper();

  onPressed(context) async {
    if (name.text.trim().isNotEmpty &&
        name1.text.trim().isNotEmpty &&
        name2.text.trim().isNotEmpty &&
        price.text.trim().isNotEmpty &&
        price1.text.trim().isNotEmpty &&
        price2.text.trim().isNotEmpty &&
        description.text.trim().isNotEmpty &&
        supplier.text.trim().isNotEmpty &&
        supplierPhoneNumber.text.trim().isNotEmpty) {
      _showProgress(context);
      await databaseHelper
          .addProductsOptions(
              name.text.trim(),
              name1.text.trim(),
              name2.text.trim(),
              price.text.trim(),
              price1.text.trim(),
              price2.text.trim(),
              sellectedId,
              description.text.trim(),
              supplier.text.trim(),
              supplierPhoneNumber.text.trim(),
              discount.text.trim(),
              _image1,
              _image2,
              _image3,
              _image4,
              _image5,
              _image6,
              _image7,
              _image8,
              _image9)
          .whenComplete(() {
        if (databaseHelper.status == true) {
          Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg: "تمت اضافة المنتج",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ShowProducts()));
        }
      });
    } else {
      _showDialog(context);
      Fluttertoast.showToast(
          msg: "الرجاء ملئ جميع الحقول",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER);
    }
  }

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

  getSellectedProduct() {
    for (int i = 0; i <= productItemList.length - 1; i++) {
      if (productItemList[i]["name"] == sellectedValue) {
        setState(() {
          sellectedId = productItemList[i]["id"];
        });
      }
    }
  }

  @override
  void initState() {
    getCategoriesSpinner();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getSellectedProduct();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: buttomColor,
          title: Text("اضافة منتج بخيارات"),
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
                    buildTextFormField("اسم المنتج", name, null),
                    SizedBox(
                      height: 10,
                    ),
                    buildTextFormField(" السعر", price, TextInputType.number),
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
                    buildTextFormField("وصف المنتج", description, null),
                    SizedBox(
                      height: 10,
                    ),
                    
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
                              height: 80,
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
                              height: 80,
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
                              height: 80,
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
                     Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: name1,
                            decoration: InputDecoration(
                              hintText: "النوع",
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
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: price1,
                            decoration: InputDecoration(
                              hintText: "السعر",
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
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _selectImage(
                                  // ignore: deprecated_member_use
                                  ImagePicker.pickImage(
                                      source: ImageSource.gallery),
                                  4);
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 0, 20),
                              height: 80,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: textColor,
                                ),
                              ),
                              child: Card(
                                color: scaffoldBackgroundColor,
                                child: _displayImage4(),
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
                                  5);
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 0, 20),
                              height: 80,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: textColor,
                                ),
                              ),
                              child: Card(
                                color: scaffoldBackgroundColor,
                                child: _displayImage5(),
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
                                  6);
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                              height: 80,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: textColor,
                                ),
                              ),
                              child: Card(
                                color: scaffoldBackgroundColor,
                                child: _displayImage6(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: name2,
                            decoration: InputDecoration(
                              hintText: "النوع",
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
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: price2,
                            decoration: InputDecoration(
                              hintText: "السعر",
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
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _selectImage(
                                  // ignore: deprecated_member_use
                                  ImagePicker.pickImage(
                                      source: ImageSource.gallery),
                                  7);
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 0, 20),
                              height: 80,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: textColor,
                                ),
                              ),
                              child: Card(
                                color: scaffoldBackgroundColor,
                                child: _displayImage7(),
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
                                  8);
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 0, 20),
                              height: 80,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: textColor,
                                ),
                              ),
                              child: Card(
                                color: scaffoldBackgroundColor,
                                child: _displayImage8(),
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
                                  9);
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                              height: 80,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: textColor,
                                ),
                              ),
                              child: Card(
                                color: scaffoldBackgroundColor,
                                child: _displayImage9(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    buildTextFormField("اسم مورد المنتج", supplier, null),
                    SizedBox(
                      height: 10,
                    ),
                    buildTextFormField("رقم هاتف المورد", supplierPhoneNumber,
                        TextInputType.number),
                        SizedBox(
                      height: 10,
                    ),
                    buildTextFormField("التخفيض (اختياري)", discount,
                        TextInputType.number),
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
/*
  changeSellectedSize(String size, double pric) {
    if (sellectedSize.contains(size)) {
      setState(() {
        sellectedSize.remove(size);
        sellectedPrice.remove(pric);
        print(sellectedPrice);
        print(sellectedSize);
      });
    } else {
      setState(() {
        sellectedSize.add(size);
        sellectedPrice.add(pric);
        print(sellectedPrice);
        print(sellectedSize);
      });
    }
  }*/

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
      case 4:
        {
          setState(() {
            _image4 = imgTemp;
          });
        }
        break;
      case 5:
        setState(() {
          _image5 = imgTemp;
        });
        break;
      case 6:
        setState(() {
          _image6 = imgTemp;
        });
        break;
      case 7:
        {
          setState(() {
            _image7 = imgTemp;
          });
        }
        break;
      case 8:
        setState(() {
          _image8 = imgTemp;
        });
        break;
      case 9:
        setState(() {
          _image9 = imgTemp;
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

  Widget _displayImage4() {
    if (_image4 == null) {
      return Icon(
        Icons.add,
        color: buttomColor,
        size: 30,
      );
    } else {
      return Image.file(_image4);
    }
  }

  Widget _displayImage5() {
    if (_image5 == null) {
      return Icon(
        Icons.add,
        color: buttomColor,
        size: 30,
      );
    } else {
      return Image.file(_image5);
    }
  }

  Widget _displayImage6() {
    if (_image6 == null) {
      return Icon(
        Icons.add,
        color: buttomColor,
        size: 30,
      );
    } else {
      return Image.file(_image6);
    }
  }

  Widget _displayImage7() {
    if (_image7 == null) {
      return Icon(
        Icons.add,
        color: buttomColor,
        size: 30,
      );
    } else {
      return Image.file(_image7);
    }
  }

  Widget _displayImage8() {
    if (_image8 == null) {
      return Icon(
        Icons.add,
        color: buttomColor,
        size: 30,
      );
    } else {
      return Image.file(_image8);
    }
  }

  Widget _displayImage9() {
    if (_image9 == null) {
      return Icon(
        Icons.add,
        color: buttomColor,
        size: 30,
      );
    } else {
      return Image.file(_image9);
    }
  }

  void validateAndUpload() {
    if (formStateAdd.currentState.validate()) {
      if (_image1 != null &&
          _image2 != null &&
          _image3 != null &&
          _image4 != null &&
          _image5 != null &&
          _image6 != null &&
          _image7 != null &&
          _image8 != null &&
          _image9 != null) {
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
