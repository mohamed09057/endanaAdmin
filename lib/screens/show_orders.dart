import 'package:endanaAdmin/controller/databases.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart' as urlLunch;
import '../main.dart';
import 'location.dart';

class OrdersView extends StatefulWidget {
  @override
  _OrdersViewState createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  DatabaseHelper databaseHelper = new DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: buttomColor,
            centerTitle: true,
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                Tab(
                  icon: Icon(FontAwesomeIcons.firstOrder),
                  child: Text(
                    "الجديدة",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  icon: Icon(Icons.directions_car),
                  child: Text(
                    "قيد التنفيذ ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  icon: Icon(Icons.cancel),
                  child: Text(
                    "الملغية",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  icon: Icon(Icons.done),
                  child: Text(
                    "المكتملة",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            title: Text('الطلبات'),
          ),
          body: TabBarView(
            children: [
              FutureBuilder(
                future: databaseHelper.getOrders("pending"),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? NewOrders(list: snapshot.data, tab: 1)
                      : new Center(
                          child: CircularProgressIndicator(),
                        );
                },
              ),
              FutureBuilder(
                future: databaseHelper.getOrders("accepted"),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? NewOrders(list: snapshot.data, tab: 2)
                      : new Center(
                          child: CircularProgressIndicator(),
                        );
                },
              ),
              FutureBuilder(
                future: databaseHelper.getOrders("canceled"),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? NewOrders(list: snapshot.data, tab: 3)
                      : new Center(
                          child: CircularProgressIndicator(),
                        );
                },
              ),
              FutureBuilder(
                future: databaseHelper.getOrders("completed"),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? NewOrders(list: snapshot.data, tab: 3)
                      : new Center(
                          child: CircularProgressIndicator(),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewOrders extends StatefulWidget {
  final int tab;
  final List list;

  NewOrders({this.list, this.tab});

  @override
  _NewOrdersState createState() => _NewOrdersState();
}

class _NewOrdersState extends State<NewOrders> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  List items = [];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.list == null ? 0 : widget.list.length,
      itemBuilder: (context, i) {
        for (int j = 0; j < widget.list[i]["products"].length; j++) {
          items.add(widget.list[i]["products"][j]["title"]);
        }
        double total = 0.0;
        for (int j = 0; j < widget.list[i]["products"].length; j++) {
          total = total +
              (double.parse(widget.list[i]["products"][j]["price"]) *
                  widget.list[i]["products"][j]["pivot"]["quantity"]);
        }
        return GestureDetector(
          onTap: () {},
          child: Card(
            margin: EdgeInsets.all(10),
            color: buttomColor,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "رقم الطلب :   " + widget.list[i]["id"].toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "سعر الطلب   :  " + total.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "حالة الطلب   :  " + widget.list[i]["status"].toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "العنوان :   " + widget.list[i]["address"].toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    " اسم صاحب الطلب :   " +
                        widget.list[i]["user"]["name"].toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      urlLunch
                          .launch('tel:${widget.list[i]["user"]["phone"].toString()}');
                    /*  setState(() {
                        _launchCaller(
                            widget.list[i]["user"]["phone"].toString());
                      });*/
                    },
                    child: Row(
                      children: [
                         Text(
                          "  رقم صاحب الطلب :  " ,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                              widget.list[i]["user"]["phone"].toString(),
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.blue[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 150,
                    padding: EdgeInsets.all(10),
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.list[i]["products"].length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: scaffoldBackgroundColor,
                            child: Column(
                              children: [
                                Text(
                                  widget.list[i]["products"][index]["title"]
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.list[i]["products"][index]["price"]
                                          .toString() +
                                      " ج.س ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "الكمية : " +
                                      widget.list[i]["products"][index]["pivot"]
                                              ["quantity"]
                                          .toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                  Container(
                    width: 140,
                    child: MaterialButton(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      color: scaffoldBackgroundColor,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TheLocation(
                                    latitude:
                                        double.parse(widget.list[i]["lat"]),
                                    longitude:
                                        double.parse(widget.list[i]["lng"]))));
                      },
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.blue),
                          Text("  الموقع على الخريطة  "),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.tab == 1
                            ? MaterialButton(
                                padding: EdgeInsets.all(10),
                                color: Colors.green[800],
                                onPressed: () async {
                                  _showProgress(context);
                                  await databaseHelper
                                      .acceptOrder(widget.list[i]["id"])
                                      .whenComplete(() {
                                    if (databaseHelper.status == true) {
                                      Navigator.of(context).pop();
                                      Fluttertoast.showToast(
                                          msg: "تم قبول الطلب",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.CENTER);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OrdersView()));
                                    } else {
                                      Navigator.of(context).pop();
                                      _showDialog();
                                    }
                                  });
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.all_inbox,
                                        color: scaffoldBackgroundColor),
                                    Text(
                                      "قبول الطلب",
                                      style: TextStyle(
                                          color: scaffoldBackgroundColor),
                                    ),
                                  ],
                                ),
                              )
                            : widget.tab == 2
                                ? MaterialButton(
                                    padding: EdgeInsets.all(10),
                                    color: Colors.green[800],
                                    onPressed: () async {
                                      _showProgress(context);
                                      await databaseHelper
                                          .completeOrder(widget.list[i]["id"])
                                          .whenComplete(() {
                                        if (databaseHelper.status == true) {
                                          Navigator.of(context).pop();
                                          Fluttertoast.showToast(
                                              msg: "اكتمل الطلب",
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.CENTER);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrdersView()));
                                        } else {
                                          Navigator.of(context).pop();
                                          _showDialog();
                                        }
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.all_inbox,
                                            color: scaffoldBackgroundColor),
                                        Text(
                                          "تم التسليم ",
                                          style: TextStyle(
                                              color: scaffoldBackgroundColor),
                                        ),
                                      ],
                                    ),
                                  )
                                : Text(""),
                        widget.tab != 3
                            ? MaterialButton(
                                padding: EdgeInsets.all(10),
                                color: Colors.red[800],
                                onPressed: () async {
                                  _showProgress(context);
                                  await databaseHelper
                                      .cancelOrder(widget.list[i]["id"], 2)
                                      .whenComplete(() {
                                    if (databaseHelper.status == true) {
                                      Navigator.of(context).pop();
                                      Fluttertoast.showToast(
                                          msg: "تم الغاء الطلب",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.CENTER);
                                    } else {
                                      Navigator.of(context).pop();
                                      _showDialog();
                                    }
                                  });
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.close,
                                        color: scaffoldBackgroundColor),
                                    Text(
                                      "الغاء الطلب",
                                      style: TextStyle(
                                          color: scaffoldBackgroundColor),
                                    ),
                                  ],
                                ),
                              )
                            : Text(""),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: Text('خطأ'),
              content: Text('لم تتم  العملية '),
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
/*
  _launchCaller(String phone) async {
    if (await canLaunch(phone)) {
      await launch(phone);
    } else {
      throw 'can\'t launch $phone';
    }
  }*/
}
