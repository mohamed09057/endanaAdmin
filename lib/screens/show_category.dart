import 'package:endanaAdmin/controller/databases.dart';
import 'package:endanaAdmin/main.dart';
import 'package:endanaAdmin/screens/add_category.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'edit_category.dart';

class ShowCategory extends StatefulWidget {
  @override
  _ShowCategoryState createState() => _ShowCategoryState();
}

class _ShowCategoryState extends State<ShowCategory> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  var roleid;
  getpref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    roleid = preferences.getInt("roleid");
    if (roleid != null) {
      setState(() {
        roleid = preferences.getInt("roleid");
      });
      print(roleid);
    }
  }

  @override
  void initState() {
    super.initState();
    getpref();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("الاقسام"),
          backgroundColor: buttomColor,
          centerTitle: true,
          actions: [
            roleid == 3
                ? IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) {
                            return AddCategory();
                          },
                        ),
                      );
                    },
                  )
                : Text(""),
          ],
        ),
        body: FutureBuilder(
          future: databaseHelper.getCategories(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? ItemList(list: snapshot.data, role: roleid)
                : new Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final List list;
  final int role;
  ItemList({this.list,this.role});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return Container(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
          child: Card(
            color: scaffoldBackgroundColor,
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        list[i]["id"].toString() + " -",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        list[i]["name"],
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  role == 3
                      ? Container(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          EditCategory(list: list, index: i)));
                                },
                                child: Text(
                                  "تعديل",
                                  style: TextStyle(
                                    color: Colors.blue[800],
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  DatabaseHelper databaseHelper =
                                      new DatabaseHelper();
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: AlertDialog(
                                            title: Text('حذف القسم'),
                                            content:
                                                Text('هل انت متأكد من الحذف !'),
                                            actions: [
                                              MaterialButton(
                                                  color: Colors.red[800],
                                                  onPressed: () async {
                                                    Navigator.of(context).pop();
                                                    _showProgress(context);
                                                    await databaseHelper
                                                        .deleteCayegory(
                                                            list[i]["id"])
                                                        .whenComplete(
                                                      () {
                                                        if (databaseHelper
                                                                .status !=
                                                            true) {
                                                          Navigator.of(context)
                                                              .pop();
                                                          _showDialog(context);
                                                        } else {
                                                          Navigator.of(context)
                                                              .pop();
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "تم الحذف بنجاح",
                                                              toastLength: Toast
                                                                  .LENGTH_LONG,
                                                              gravity:
                                                                  ToastGravity
                                                                      .CENTER);
                                                        }
                                                      },
                                                    );
                                                  },
                                                  child: Text(
                                                    "موافق",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color:
                                                            scaffoldBackgroundColor),
                                                  )),
                                              MaterialButton(
                                                  color: notificationColor,
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    "الغاء",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color:
                                                            scaffoldBackgroundColor),
                                                  )),
                                            ],
                                          ),
                                        );
                                      });
                                },
                                child: Text(
                                  "حذف",
                                  style: TextStyle(
                                    color: Colors.red[800],
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Text(""),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('فشل  الحزف'),
            content: Text('لم يتم الحزف'),
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
}
