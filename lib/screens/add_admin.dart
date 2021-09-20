import 'package:endanaAdmin/controller/databases.dart';
import 'package:endanaAdmin/screens/admin_home.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:group_radio_button/group_radio_button.dart';
import '../main.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  DatabaseHelper databaseHelper = new DatabaseHelper();

  String message = '';
  var role = 3;
  //int _index = 0;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  _onPressed() async {
    if (_phoneController.text.trim().isNotEmpty &&
        _nameController.text.trim().isNotEmpty &&
        _passwordController.text.trim().isNotEmpty) {
      _showProgress(context);
      databaseHelper
          .addSubadmin(
              _nameController.text.trim(),
              _phoneController.text.trim(),
              _passwordController.text.trim(),
              role)
          .whenComplete(() {
        if (databaseHelper.status!=true) {
          Navigator.of(context).pop();
          _showDialog();
        } else {
          Navigator.of(context).pop();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => AdminHome()));
          Fluttertoast.showToast(
              msg: "  الاضافة تمت",
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
        backgroundColor: scaffoldBackgroundColor,
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 50, 20, 30),
              width: double.infinity,
              child: Column(
                children: [
                  Form(
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          child: Text(
                            'اضافة مدير',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: buttomColor,
                              letterSpacing: 3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        TextFormField(
                          controller: _nameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "الاسم",
                            prefixIcon: Icon(Icons.person),
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
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          obscureText: true,
                          controller: _passwordController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "كلمة السر",
                            prefixIcon: Icon(Icons.vpn_key),
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
                        
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "رقم الهاتف",
                            prefixIcon: Icon(Icons.phone_android),
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
                        Row(
                          children: [
                            RadioButton(
                                value: 3,
                                description: "Admin",
                                groupValue: role,
                                onChanged: (value) {
                                  setState(() {
                                    role = value;
                                  });
                                }),
                            SizedBox(
                              width: 30,
                            ),
                            RadioButton(
                                value: 1,
                                description: "Sub Admin",
                                groupValue: role,
                                onChanged: (value) {
                                  setState(() {
                                    role = value;
                                  });
                                  
                                }),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 20),
                          height: 40,
                          child: Text(
                            '$message',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: MaterialButton(
                            padding: EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            color: buttomColor,
                            onPressed: () {
                              _onPressed();
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
                ],
              ),
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
              title: Text('فشل التسجيل '),
              content: Text('يوجد خطأ !'),
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
}
