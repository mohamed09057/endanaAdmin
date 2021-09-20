import 'package:endanaAdmin/controller/databases.dart';
import 'package:endanaAdmin/main.dart';
import 'package:endanaAdmin/screens/add_ad.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowAds extends StatefulWidget {
  @override
  _ShowAdsState createState() => _ShowAdsState();
}

class _ShowAdsState extends State<ShowAds> {
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
          title: Text("منتجات السلايدر"),
          backgroundColor: buttomColor,
          centerTitle: true,
          actions: [
            roleid == 3
                ? IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return AddAd();
                          },
                        ),
                      );
                    },
                  )
                : Text(""),
          ],
        ),
        body: FutureBuilder(
          future: databaseHelper.getAds(),
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

class ItemList extends StatefulWidget {
  final List list;
  final int role;
  ItemList({this.list, this.role});

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  DatabaseHelper databaseHelper = new DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.list == null ? 0 : widget.list.length,
      itemBuilder: (context, i) {
        return Container(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
          child: Card(
            color: scaffoldBackgroundColor,
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                children: [
                  widget.list[i]["image"] == null
                      ? Container(child: CircularProgressIndicator())
                      :
                      FadeInImage(
                          imageErrorBuilder: (BuildContext context,
                              Object exception, StackTrace stackTrace) {
                            print('Error Handler');
                            return Container(
                              width: 100.0,
                              height: 100.0,
                              child: Text("Loading Image..."),
                            );
                          },
                          placeholder: AssetImage('assets/images/1.png'),
                          image: NetworkImage(
                            "https://endana.neversd.com/${widget.list[i]["image"]}",
                          ),
                          fit: BoxFit.cover,
                          height: 150.0,
                          width: double.infinity,
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.list[i]["id"].toString() + " -",
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
                                "منتج رقم  " +
                                    widget.list[i]["product"].toString(),
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "من تاريخ  " + widget.list[i]["from"],
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
                            "الى تاريخ  " + widget.list[i]["to"].toString(),
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      widget.role==3?GestureDetector(
                        onTap: () {
                          onPressed(context, i);
                        },
                        child: Text(
                          "حذف",
                          style: TextStyle(
                            color: Colors.red[800],
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ):Text(""),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future onPressed(BuildContext context, int i) async {
    _showProgress(context);
    await databaseHelper.deleteAds(widget.list[i]["id"]).whenComplete(() {
      if (databaseHelper.status == true) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ShowAds()));
      } else {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        _showDialog(context);
      }
    });
  }

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: Text('خطأ'),
              content: Text('لم  يتم الحذف'),
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
