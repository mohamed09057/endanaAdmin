import 'package:endanaAdmin/main.dart';
import 'package:endanaAdmin/screens/product_reports.dart';
import 'package:endanaAdmin/screens/show_order_reports.dart';
import 'package:flutter/material.dart';

class Reports extends StatelessWidget {
  const Reports({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("التقارير"),
          centerTitle: true,
          backgroundColor: buttomColor,
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductReports(),
                        ));
                  },
                  child: Text(
                    "تقارير المنتجات",
                    style: TextStyle(
                      fontSize: 18,
                      color: scaffoldBackgroundColor,
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderReports(),
                        ));
                  },
                  child: Text(
                    "تقارير الطلبات",
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
    );
  }
}
