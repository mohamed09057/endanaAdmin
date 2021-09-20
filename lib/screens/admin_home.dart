import 'package:endanaAdmin/comon/my_drower.dart';
import 'package:endanaAdmin/controller/databases.dart';
import 'package:endanaAdmin/screens/add_admin.dart';
import 'package:endanaAdmin/screens/reports.dart';
import 'package:endanaAdmin/screens/show_ads.dart';
import 'package:endanaAdmin/screens/show_category.dart';
import 'package:endanaAdmin/screens/show_orders.dart';
import 'package:endanaAdmin/screens/show_product.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'add_category.dart';
import 'add_product.dart';
import 'add_product_options.dart';
import 'login_screen.dart';

Future<dynamic> myBackgroundMessageHandelar(
    Map<String, dynamic> message) async {
  FlutterAppBadger.updateBadgeCount(1);
}

class AdminHome extends StatefulWidget {
  const AdminHome({Key key}) : super(key: key);

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  int counter = 0;
  var categoriesCount = 0;
  var sliderCount = 0;
  var ordersCount = 0;
  var productsCount = 0;
  String _outputText = '';

  getCount() {
    databaseHelper.getProducts().whenComplete(() {
      setState(() {
        productsCount = databaseHelper.countp;
      });
    });
    databaseHelper.getCategories().whenComplete(() {
      setState(() {
        categoriesCount = databaseHelper.countc;
      });
    });
    databaseHelper.getAds().whenComplete(() {
      setState(() {
        sliderCount = databaseHelper.counts;
      });
    });
    databaseHelper.getOrders("").whenComplete(() {
      setState(() {
        ordersCount = databaseHelper.counto;
      });
    });
  }

  // ignore: unused_field
  String _messageText = "Waiting for message...";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Future<dynamic> onSelectNotification(String payload) async {
    /*Do whatever you want to do on notification click. In this case, I'll show an alert dialog*/
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(payload),
        content: Text("Payload: $payload"),
      ),
    );
  }

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

  String homeScreenText = 'token';
  Future<void> _showNotification(
    int notificationId,
    String notificationTitle,
    String notificationContent,
    String payload, {
    String channelId = '1234',
    String channelTitle = 'Android Channel',
    String channelDescription = 'Default Android Channel for notifications',
    Priority notificationPriority = Priority.high,
    Importance notificationImportance = Importance.max,
  }) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      channelId,
      channelTitle,
      channelDescription,
      playSound: false,
      importance: notificationImportance,
      priority: notificationPriority,
    );
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      notificationId,
      notificationTitle,
      notificationContent,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    getCount();
    getpref();
    _firebaseMessaging.subscribeToTopic('all');

    _firebaseMessaging.configure(
      
      onMessage: (Map<String, dynamic> message) async {
        setState(() {
          counter = counter + 1;
        });
        print("onResume: $message");
        showOverlayNotification(
          (context) {
            counter = counter + 1;
            _messageText = "Push Messaging message: $message";
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: SafeArea(
                  child: ListTile(
                leading: SizedBox.fromSize(
                  size: Size(40, 40),
                  child: ClipOval(
                    child: Container(
                      color: Colors.black,
                    ),
                  ),
                ),
                title: Text(message['notification']['title']),
                trailing: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      OverlaySupportEntry.of(context).dismiss();
                    }),
              )),
            );
          },
          duration: Duration(milliseconds: 4000),
        );
        print(message['notification']['title']);
        _showNotification(
            1234,
            message['notification']['title'],
            message['notification']['description'],
            message['notification']['PAYLOAD']);
        return;
      },
      onLaunch: (Map<String, dynamic> message) async {
        setState(() {
          counter = counter + 1;
          _messageText = "Push Messaging message: $message";
        });
        print("onResume: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        setState(() {
          counter = counter + 1;
          _messageText = "Push Messaging message: $message";
        });
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        homeScreenText = "Push Messaging token: $token";
      });
      homeScreenText = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    // getCount();
    return DefaultTabController(
      length: 2,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          drawer: MyDrawer(),
          appBar: AppBar(
            actions: [
              IconBadge(
                icon: Icon(Icons.shopping_basket),
                //icon: Icon(Icons.notifications_none),
                itemCount: counter,
                badgeColor: Colors.red,
                itemColor: Colors.white,
                maxCount: counter,
                top: 5,
                right: 10,
                hideZero: true,
                onTap: () {
                  setState(() {
                    counter = 0;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrdersView(),
                    ),
                  );
                },
              ),
            ],
            centerTitle: true,
            title: Text("المدير"),
            backgroundColor: buttomColor,
            bottom: TabBar(
              indicatorColor: scaffoldBackgroundColor,
              unselectedLabelColor: Colors.black87,
              labelColor: scaffoldBackgroundColor,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.settings),
                      Text(
                        " الادارة",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.equalizer),
                      Text(
                        " الاحصائيات",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ListView(
                children: [
                  control(),
                ],
              ),
              ListView(
                children: [
                  statistics(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget statistics() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ShowCategory();
                      },
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 180,
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Card(
                    color: scaffoldBackgroundColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.category,
                              color: textColor,
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              "الاقسام",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          categoriesCount.toString(),
                          style: TextStyle(
                            color: buttomColor,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ShowProducts();
                      },
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 180,
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Card(
                    color: scaffoldBackgroundColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.productHunt,
                              color: textColor,
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              "المنتجات",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          productsCount.toString(),
                          style: TextStyle(
                            color: buttomColor,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ShowAds();
                      },
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 180,
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Card(
                    color: scaffoldBackgroundColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.slideshow_outlined,
                              color: textColor,
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              "الاسلايدر",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          sliderCount.toString(),
                          style: TextStyle(
                            color: buttomColor,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return OrdersView();
                      },
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 180,
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Card(
                    color: scaffoldBackgroundColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_cart,
                              color: textColor,
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              "الطلبات",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          ordersCount.toString(),
                          style: TextStyle(
                            color: buttomColor,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget control() {
    return Card(
      margin: EdgeInsets.all(20),
      color: scaffoldBackgroundColor,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(40, 0, 40, 30),
        child: Column(
          children: [
            roleid == 3
                ? Column(children: [
                    Text(_outputText),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddProduct(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: textColor,
                          ),
                          Text(
                            "  اضافة منتج",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 20,
                      color: textColor,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddProductOptions(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: textColor,
                          ),
                          Text(
                            "  اضافة منتج بخيارات",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 20,
                      color: textColor,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddCategory(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: textColor,
                          ),
                          Text(
                            " اضافة قسم",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 20,
                      color: textColor,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return RegisterScreen();
                            },
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: textColor,
                          ),
                          Text(
                            " اضافة مدير",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 20,
                      color: textColor,
                    ),
                  ])
                : Text(""),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ShowProducts();
                    },
                  ),
                );
              },
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.productHunt,
                    size: 20,
                    color: textColor,
                  ),
                  Text(
                    " عرض المنتجات",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 20,
              color: textColor,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ShowCategory();
                    },
                  ),
                );
              },
              child: Row(
                children: [
                  Icon(
                    Icons.category,
                    color: textColor,
                    size: 20,
                  ),
                  Text(
                    " عرض الاقسام",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 20,
              color: textColor,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ShowAds(),
                  ),
                );
              },
              child: Row(
                children: [
                  Icon(
                    Icons.slideshow,
                    color: textColor,
                  ),
                  Text(
                    " منتجات السلايدر",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 20,
              color: textColor,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return OrdersView();
                    },
                  ),
                );
              },
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.firstOrder,
                    color: textColor,
                    size: 20,
                  ),
                  Text(
                    " عرض الطلبات",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 19,
              color: textColor,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Reports();
                    },
                  ),
                );
              },
              child: Row(
                children: [
                  Icon(
                    Icons.report,
                    color: textColor,
                  ),
                  Text(
                    " التقارير",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 19,
              color: textColor,
            ),
            GestureDetector(
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
                    builder: (_) => LoginScreen(),
                  ),
                );
              },
              child: Row(
                children: [
                  Icon(
                    Icons.exit_to_app,
                    size: 20,
                    color: textColor,
                  ),
                  Text(
                    " تسجيل خروج",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
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
}
