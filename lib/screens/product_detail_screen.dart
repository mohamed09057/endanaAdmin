import 'package:endanaAdmin/controller/databases.dart';
import 'package:endanaAdmin/screens/edit_product_options.dart';
import 'package:endanaAdmin/screens/show_product.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'edit_product.dart';

class ProductDetails extends StatefulWidget {
  final List list;
  final int index;
  ProductDetails({this.list, this.index});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  List<String> _status = [];
  List<String> status() {
    for (int j = 0; j < widget.list[widget.index]["options"].length; j++) {
      _status.add(widget.list[widget.index]["options"][j]["title"]);
    }
    //_price = double.parse(widget.list[widget.index]["options"][0]["price"]);
    return _status;
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

  @override
  void initState() {
    super.initState();
    getpref();
    widget.list[widget.index]["options"].length != 0 ? status() : Text("");
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("تفاصيل المنتج"),
          backgroundColor: buttomColor,
          centerTitle: true,
        ),
        body: buildBodyListView(),
      ),
    );
  }

  ListView buildBodyListView() {
    return ListView(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
          child: Card(
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 0, 20),
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: textColor,
                              ),
                            ),
                            child: Card(
                              color: scaffoldBackgroundColor,
                              child: Image(
                                  image: widget.list[widget.index]["images"]
                                              .length >
                                          0
                                      ? NetworkImage(
                                          "https://endana.neversd.com/${widget.list[widget.index]["images"][0]["image"]}",
                                        )
                                      : AssetImage('assets/imgages/1.png'),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 0, 20),
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: textColor,
                              ),
                            ),
                            child: Card(
                              color: scaffoldBackgroundColor,
                              child: Image(
                                  image: widget.list[widget.index]["images"]
                                              .length >
                                          0
                                      ? NetworkImage(
                                          "https://endana.neversd.com/${widget.list[widget.index]["images"][1]["image"]}",
                                        )
                                      : AssetImage('assets/imgages/1.png'),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: textColor,
                              ),
                            ),
                            child: Card(
                              color: scaffoldBackgroundColor,
                              child: Image(
                                  image: widget.list[widget.index]["images"]
                                              .length >
                                          0
                                      ? NetworkImage(
                                          "https://endana.neversd.com/${widget.list[widget.index]["images"][2]["image"]}",
                                        )
                                      : AssetImage('assets/imgages/1.png'),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "رقم المنتج    :  " +
                        widget.list[widget.index]["id"].toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: buttomColor,
                    ),
                  ),
                  Text(
                    "اسم المنتج   :  " +
                        (widget.list[widget.index]["title"] != null
                            ? widget.list[widget.index]["title"]
                            : "لا يوجد"),
                    style: TextStyle(
                      color: buttomColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "وصف المنتج :  " +
                        (widget.list[widget.index]["description"] != null
                            ? widget.list[widget.index]["description"]
                            : "لا يوجد"),
                    style: TextStyle(
                      color: buttomColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "سعر المنتج   :  " +
                        (widget.list[widget.index]["price"] != null
                            ? widget.list[widget.index]["price"]
                            : "لا يوجد"),
                    style: TextStyle(
                      color: buttomColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "اسم المورد   :  " +
                        (widget.list[widget.index]["supplier_name"] != null
                            ? widget.list[widget.index]["supplier_name"]
                            : "لا يوجد"),
                    style: TextStyle(
                      color: buttomColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "هاتف المورد  :  " +
                        (widget.list[widget.index]["supplier_phone"] != null
                            ? widget.list[widget.index]["supplier_phone"]
                            : "لا يوجد"),
                    style: TextStyle(
                      color: buttomColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "التخفيض     :  " +
                        (widget.list[widget.index]["discount"] != null
                            ? widget.list[widget.index]["discount"]
                            : "لا يوجد"),
                    style: TextStyle(
                      color: buttomColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  widget.list[widget.index]["options"].length != 0
                      ? Container(
                          height: 500,
                          child: ListView.builder(
                              itemCount: _status == null ? 0 : _status.length,
                              itemBuilder: (context, i) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  10, 0, 0, 20),
                                              height: 100,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 1,
                                                  color: textColor,
                                                ),
                                              ),
                                              child: Card(
                                                color: scaffoldBackgroundColor,
                                                child: Image(
                                                    image: widget
                                                                .list[widget
                                                                        .index]
                                                                    ["options"]
                                                                    [i]
                                                                    ["images"]
                                                                .length >
                                                            0
                                                        ? NetworkImage(
                                                            "https://endana.neversd.com/${widget.list[widget.index]["options"][i]["images"][0]["image"]}",
                                                          )
                                                        : AssetImage(
                                                            'assets/imgages/1.png'),
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  10, 0, 0, 20),
                                              height: 100,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 1,
                                                  color: textColor,
                                                ),
                                              ),
                                              child: Card(
                                                color: scaffoldBackgroundColor,
                                                child: Image(
                                                    image: widget
                                                                .list[widget
                                                                        .index]
                                                                    ["images"]
                                                                .length >
                                                            0
                                                        ? NetworkImage(
                                                            "https://endana.neversd.com/${widget.list[widget.index]["options"][i]["images"][1]["image"]}",
                                                          )
                                                        : AssetImage(
                                                            'assets/imgages/1.png'),
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 20),
                                              height: 100,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 1,
                                                  color: textColor,
                                                ),
                                              ),
                                              child: Card(
                                                color: scaffoldBackgroundColor,
                                                child: Image(
                                                    image: widget
                                                                .list[widget
                                                                        .index]
                                                                    ["images"]
                                                                .length >
                                                            0
                                                        ? NetworkImage(
                                                            "https://endana.neversd.com/${widget.list[widget.index]["options"][i]["images"][2]["image"]}",
                                                          )
                                                        : AssetImage(
                                                            'assets/imgages/1.png'),
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "اسم المنتج   :  " +
                                          (widget.list[widget.index]["options"]
                                                      [i]["title"] !=
                                                  null
                                              ? widget.list[widget.index]
                                                  ["options"][i]["title"]
                                              : "لا يوجد"),
                                      style: TextStyle(
                                        color: buttomColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "سعر المنتج   :  " +
                                          (widget.list[widget.index]["options"]
                                                      [i]["price"] !=
                                                  null
                                              ? widget.list[widget.index]
                                                  ["options"][i]["price"]
                                              : "لا يوجد"),
                                      style: TextStyle(
                                        color: buttomColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        )
                      : Text(""),
                  roleid == 3
                      ? Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MaterialButton(
                                color: notificationColor,
                                onPressed: () {
                                  widget.list[widget.index]["options"].length !=
                                          0
                                      ? Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  EditProductOptions(
                                                      list: widget.list,
                                                      index: widget.index)))
                                      : Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  EditProduct(
                                                      list: widget.list,
                                                      index: widget.index)));
                                },
                                child: Text(
                                  "تعديل",
                                  style: TextStyle(
                                    color: scaffoldBackgroundColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              MaterialButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: AlertDialog(
                                            title: Text('حذف المنتج'),
                                            content:
                                                Text('هل انت متأكد من الحذف !'),
                                            actions: [
                                              MaterialButton(
                                                  color: Colors.red[800],
                                                  onPressed: () async {
                                                    Navigator.of(context).pop();
                                                    _showProgress(context);
                                                    await databaseHelper
                                                        .deleteProduct(widget
                                                                .list[
                                                            widget.index]["id"])
                                                        .whenComplete(() {
                                                      Navigator.of(context)
                                                          .pop();
                                                      Navigator.of(context)
                                                          .pop();
                                                      Fluttertoast.showToast(
                                                          msg: "تم حذف المنتج",
                                                          toastLength:
                                                              Toast.LENGTH_LONG,
                                                          gravity: ToastGravity
                                                              .CENTER);
                                                      Navigator.of(context)
                                                          .pushReplacement(
                                                        MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              ShowProducts(),
                                                        ),
                                                      );
                                                    });
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
                                color: Colors.red[800],
                                child: Text(
                                  "حذف",
                                  style: TextStyle(
                                    color: scaffoldBackgroundColor,
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
        ),
      ],
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
