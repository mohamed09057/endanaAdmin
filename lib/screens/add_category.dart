import 'package:endanaAdmin/controller/databases.dart';
import 'package:endanaAdmin/screens/show_category.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../main.dart';

class AddCategory extends StatefulWidget {
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  GlobalKey<FormState> formStateAddCategory = new GlobalKey<FormState>();

  TextEditingController _nameController = new TextEditingController();
  DatabaseHelper databaseHelper = new DatabaseHelper();

  onPressed() {
    if (_nameController.text.trim().isNotEmpty) {
      _showProgress(context);
      databaseHelper.addCategory(_nameController.text.trim()).whenComplete(() {
        if (databaseHelper.status) {
          Navigator.of(context).pop();
          _showDialog();
        } else {
          Navigator.of(context).pop();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ShowCategory()));
              Fluttertoast.showToast(
          msg: "تمت الاضافة",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER);
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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: buttomColor,
          title: Text("اضافة قسم"),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 50),
              width: double.infinity,
              child: Form(
                key: formStateAddCategory,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'اسم القسم',
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
                          "اضافة القسم",
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
              content: Text('اسم القسم لا يمكن ان يكون اقل من اربعة حروف'),
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
