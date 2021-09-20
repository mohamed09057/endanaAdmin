import 'dart:io';

import 'package:endanaAdmin/controller/databases.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../main.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController _nameController;
  TextEditingController _phoneController;
  TextEditingController _emailController;
  DatabaseHelper databaseHelper = new DatabaseHelper();
  File _image1;
  var image;
  var id;
  var name;
  var email;
  var phone;
  getpref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    id = preferences.getInt("id");
    if (id != null) {
      setState(() {
        id = preferences.getInt("id");
      });
      getUserData(id);
    }
  }

  getUserData(var id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl = "https://endana.neversd.com/api/users/$id";
    final response = await http.get(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    });
    var data = json.decode(response.body);
    setState(() {
      image = data["avatar"];
    });
    _nameController = new TextEditingController(text: data["name"]);
    _phoneController = new TextEditingController(text: data["phone"]);
    _emailController = new TextEditingController(text: data["email"]);
  }

  @override
  void initState() {
    super.initState();
    getpref();
  }

  _onPressed() async {
    if (_phoneController.text.trim().isNotEmpty &&
        _nameController.text.trim().isNotEmpty&&
        _emailController.text.trim().isNotEmpty) {
      _showProgress(context);
      await databaseHelper
          .editUser(_nameController.text.trim(), _phoneController.text.trim(),_emailController.text,
               id)
          .whenComplete(() {
        if (databaseHelper.status != true) {
          Navigator.of(context).pop();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => EditProfileScreen()));
          _showDialog();
        } else {
          Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg: "  التعديل تم",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER);
        }
      });
    } else {
      Fluttertoast.showToast(
          msg: "الرجاء ملئ جميع الحقول",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: buttomColor,
          title: Text("تعديل بياناتي "),
          centerTitle: true,
        ),
        backgroundColor: scaffoldBackgroundColor,
        body: ListView(
          children: [
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
                  margin: EdgeInsets.fromLTRB(20, 50, 30, 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: textColor,
                        offset: Offset(2, 0),
                        spreadRadius: 0,
                        blurRadius: 7,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Form(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _selectImage(
                                    // ignore: deprecated_member_use
                                    ImagePicker.pickImage(
                                        source: ImageSource.gallery),
                                    1);
                              },
                              child: Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 0, 20),
                                height: 130,
                                width: 130,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 5,
                                    color: buttomColor,
                                    
                                  ),
                                  borderRadius: BorderRadius.circular(130)
                                ),
                                child: _image1 == null
                                    ? Image(
                                        image: image != null
                                            ? NetworkImage(
                                                "https://endana.neversd.com/storage/$image",
                                              )
                                            : AssetImage(
                                                'assets/images/pro.jpg'),
                                        fit: BoxFit.cover)
                                    : _displayImage1(),
                              ),
                            ),
                            TextFormField(
                              controller: _nameController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.phone_android),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 20),
                              height: 40,
                              child: Text(
                                '',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[500],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: MaterialButton(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          color: buttomColor,
                          onPressed: () {
                            _onPressed();
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'تعديل',
                            style: TextStyle(
                                color: scaffoldBackgroundColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
              title: Text('فشل التعديل '),
              content: Text(' قم بتغيير الرقم !'),
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "موافق",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: buttomColor),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _selectImage(Future<File> pickImage, int imgNumber) async {
    File imgTemp = await pickImage;
    switch (imgNumber) {
      case 1:
        setState(() {
          _image1 = imgTemp;
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
}
