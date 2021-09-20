import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:endanaAdmin/controller/databases.dart';
import 'package:endanaAdmin/main.dart';
import 'package:endanaAdmin/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowProducts extends StatefulWidget {
  @override
  _ShowProductsState createState() => _ShowProductsState();
}

class _ShowProductsState extends State<ShowProducts> {
  List listSearch = [];
  getData() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl = "https://endana.neversd.com/api/products";
    var response = await http.get(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    });
    Map map = json.decode(response.body);
    List data = map["data"];
    for (int i = 0; i < data.length; i++) {
      listSearch.add(data[i]);
    }
  }

  DatabaseHelper databaseHelper = new DatabaseHelper();
  int selectedItem = 0;
  var categoryId = 0;
  getCatId() async {
    await databaseHelper.getCategories().whenComplete(() {
      setState(() {
        categoryId = databaseHelper.categoryId;
      });
    });
  }

  @override
  void initState() {
    getCatId();
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    databaseHelper.getProducts();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("ادارة المنتجات"),
          backgroundColor: buttomColor,
          centerTitle: true,
          actions: [
            IconButton(
                icon: Icon(
                  Icons.search,
                  color: scaffoldBackgroundColor,
                  size: 30,
                ),
                onPressed: () {
                  showSearch(
                      context: context, delegate: DataSearch(list: listSearch));
                }),
          ],
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              height: 50,
              child: FutureBuilder(
                  future: databaseHelper.getCategories(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    return snapshot.hasData
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int i) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedItem = i;
                                    categoryId = snapshot.data[i]["id"];
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 0),
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    snapshot.data[i]["name"],
                                    style: TextStyle(
                                      fontSize: selectedItem == i ? 19 : 18,
                                      fontWeight: selectedItem == i
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      color: selectedItem == i
                                          ? textColor
                                          : buttomColor,
                                    ),
                                  ),
                                ),
                              );
                            })
                        : new Center(
                            child: CircularProgressIndicator(),
                          );
                  }),
            ),
            Divider(
              height: 1,
              color: buttomColor,
            ),
            Expanded(
              child: FutureBuilder(
                future: databaseHelper.getProductsCat(categoryId),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? ProductList(list: snapshot.data)
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductList extends StatelessWidget {
  final List list;
  ProductList({this.list});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, index) {
        if (list.isNotEmpty) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      ProductDetails(list: list, index: index)));
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
              child: Card(
                color: scaffoldBackgroundColor,
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        list[index]["id"].toString() + "  -",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text(
                        list[index]["title"],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text(
                        list[index]["price"],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 17),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return Center(
            child: Text("لا توجد منتجات بهذا القسم"),
          );
        }
      },
    );
  }
}

class DataSearch extends SearchDelegate<dynamic> {
  List list;
  DataSearch({this.list});
  Future getSearchData() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl = "https://endana.neversd.com/api/products";
    var response = await http.get(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    });
    var responseBody = jsonDecode(response.body);
    return responseBody;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: getSearchData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, i) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: ProductList(list: snapshot.data),
              );
            },
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var searchList = query.isEmpty
        ? list
        : list
            .where((element) => element["title"].startsWith(query))
            .toList(); 
    return ListView.builder(
        itemCount: searchList.length,
        itemBuilder: (context, i) {
          return ListTile(
            leading: Icon(Icons.home),
            title: Text(searchList[i]["title"]),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      ProductDetails(list: list, index: i)));
            },
          );
        });
  }
}
