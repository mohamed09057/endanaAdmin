import 'package:endanaAdmin/controller/databases.dart';
import 'package:endanaAdmin/screens/show_category.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../main.dart';

class EditCategory extends StatefulWidget {
  final List list;
  final int index;
  EditCategory({this.list, this.index});
  @override
  _EditCategoryState createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  GlobalKey<FormState> formStateAddCategory = new GlobalKey<FormState>();
  TextEditingController _nameController;
  @override
  void initState() {
    super.initState();
    _nameController =
        new TextEditingController(text: widget.list[widget.index]["name"]);
  }

  DatabaseHelper databaseHelper = new DatabaseHelper();
  onPressed() {
    if (_nameController.text.trim().isNotEmpty) {
      _showProgress(context);
      databaseHelper.editCategory(
          widget.list[widget.index]["id"], _nameController.text.trim());
      _showProgress(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ShowCategory()));
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
          title: Text("تعديل القسم"),
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
                          "تعديل",
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
