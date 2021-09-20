import 'dart:convert';
import 'package:endanaAdmin/screens/admin_home.dart';
import 'package:http/http.dart' as http;
import 'package:endanaAdmin/controller/databases.dart';
import 'package:endanaAdmin/screens/edit_profile.dart';
import 'package:endanaAdmin/screens/login_screen.dart';
import 'package:endanaAdmin/screens/show_orders.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
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

  var image;
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
    name = data["name"];
    phone = data["phone"];
    email = data["email"];
  }

  @override
  void initState() {
    super.initState();
    getpref();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      color: buttomColor,
      child: Drawer(
        child: Container(
          color: buttomColor,
          child: ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                color: buttomColor,
                child: Column(
                  children: [
                    UserAccountsDrawerHeader(
                      decoration: BoxDecoration(color: buttomColor),
                      accountName: Text(
                        name == null ? " الاسم" : "" + name,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      accountEmail: Text(
                        phone == null ? " الايميل" : "" + phone,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      currentAccountPicture: CircleAvatar(
                        foregroundColor: scaffoldBackgroundColor,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: scaffoldBackgroundColor, width: 3),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: image != null
                                  ? NetworkImage(
                                      "https://endana.neversd.com/storage/$image",
                                    )
                                  : AssetImage('assets/images/pro.jpg'),
                            ),
                          ),
                        ),
                        backgroundColor: scaffoldBackgroundColor,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: scaffoldBackgroundColor,
                height: 2,
              ),
              ListTile(
                title: Text(
                  'الرئيسية',
                  style: TextStyle(
                    color: scaffoldBackgroundColor,
                  ),
                ),
                leading: Icon(
                  Icons.home,
                  size: 25,
                  color: scaffoldBackgroundColor,
                ),
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => AdminHome()));
                },
              ),
              Divider(
                color: scaffoldBackgroundColor,
                height: 2,
              ),
              ListTile(
                title: Text(
                  'قائمة الطلبات',
                  style: TextStyle(
                    color: scaffoldBackgroundColor,
                  ),
                ),
                leading: Icon(
                  FontAwesomeIcons.firstOrder,
                  color: scaffoldBackgroundColor,
                  size: 20,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => OrdersView()));
                },
              ),
              Divider(
                color: scaffoldBackgroundColor,
                height: 2,
              ),
              ListTile(
                title: Text(
                  ' حسابي',
                  style: TextStyle(
                    color: scaffoldBackgroundColor,
                  ),
                ),
                leading: Icon(
                  FontAwesomeIcons.userEdit,
                  size: 20,
                  color: scaffoldBackgroundColor,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfileScreen()));
                },
              ),
              Divider(
                color: scaffoldBackgroundColor,
                height: 2,
              ),
              ListTile(
                title: Text(
                  ' تسجيل الخروج',
                  style: TextStyle(
                    color: scaffoldBackgroundColor,
                  ),
                ),
                leading: Icon(
                  Icons.exit_to_app,
                  size: 25,
                  color: scaffoldBackgroundColor,
                ),
                onTap: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  preferences.remove("name");
                  preferences.remove("phone");
                  preferences.remove("email");
                  databaseHelper.savePrefrance(0);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
              ),
              Divider(
                color: scaffoldBackgroundColor,
                height: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
