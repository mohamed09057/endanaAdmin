import 'dart:io';
import 'package:endanaAdmin/controller/databases.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'admin_home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  final TextEditingController _phoneController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    if (value != 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AdminHome(),
        ),
      );
    }
  }

  _onPressed() async {
    if (_phoneController.text.trim().isNotEmpty &&
        _passwordController.text.trim().isNotEmpty) {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          _showProgress(context);
          await databaseHelper
              .login(
                  _phoneController.text.trim(), _passwordController.text.trim())
              .whenComplete(
            () {
              if (databaseHelper.status) {
                Navigator.of(context).pop();
                _showDialog();
              } else {
                Navigator.of(context).pop();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => AdminHome()));
              }
            },
          );
        }
      } on SocketException catch (_) {
        _showInternetDialog();
      }
    } else {
      Fluttertoast.showToast(
          msg: "الرجاء ملئ جميع الحقول",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER);
    }
  }

  @override
  void initState() {
    super.initState();
    read();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: Text(""),
          backgroundColor: buttomColor,
          title: Text("تسجل دخول المدير"),
          centerTitle: true,
        ),
        backgroundColor: scaffoldBackgroundColor,
        body: ListView(
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(30),
                  width: 200,
                  height: 200,
                  child: Image(
                    image: AssetImage('assets/images/logo.png'),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Form(
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller: _phoneController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(5),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: textColor,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: buttomColor,
                                    style: BorderStyle.solid,
                                    width: 1,
                                  ),
                                ),
                                hintText: "رقم الهاتف",
                                prefixIcon: Icon(Icons.phone_android),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(5),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: textColor,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: buttomColor,
                                    style: BorderStyle.solid,
                                    width: 1,
                                  ),
                                ),
                                hintText: "كلمة السر",
                                prefixIcon: Icon(Icons.lock),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              width: double.infinity,
                              child: MaterialButton(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                color: buttomColor,
                                onPressed: () {
                                  _onPressed();
                                },
                                child: Text(
                                  "تسجيل الدخول",
                                  style: TextStyle(
                                    color: scaffoldBackgroundColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
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
      },
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('فشل تسجيل الدخول'),
            content: Text('خطأ في رقم الهاتف او الباسوورد !'),
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
      },
    );
  }

  void _showInternetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('فشل  الاتصال'),
            content: Text('الرجاء الاتصال بالانترنت'),
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
      },
    );
  }
}
