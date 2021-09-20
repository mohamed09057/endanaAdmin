import 'dart:io';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  String serverUrl = "https://endana.neversd.com/api";
  var status;
  var categoryId;
  var countp;
  var countc;
  var counts;
  var counto;
  var idd;
  var userId;
  var userRole;

  // Start Save Prefrance Method
  Future<void> savePrefrance(var token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    prefs.setInt(key, value);
  }

  // Start Save Token Method
  Future<void> _savePref(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    prefs.setString(key, value);
  }

  // Start Save Data Method
  saveData(String name, String phone, String email, int id, int roleid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("id", id);
    preferences.setString("name", name);
    preferences.setString("phone", phone);
    preferences.setString("email", email);
    preferences.setInt("roleid", roleid);
  }

  // Start Login Method
  Future<void> login(String phone, String password) async {
    String myUrl = "$serverUrl/auth/login";
    final response = await http.post(myUrl,
        headers: {'Accept': 'application/json'},
        body: {"phone": "$phone", "password": "$password"});

    status = response.body.contains("message");

    var data = json.decode(response.body);

    if (status) {
    } else {
      if (data["data"]["user"]["role_id"] == 2) {
        status = true;
      } else {
        saveData(
            data["data"]["user"]["name"],
            data["data"]["user"]["phone"],
            data["data"]["user"]["email"],
            data["data"]["user"]["id"],
            data["data"]["user"]["role_id"]);
        _savePref(data["data"]["token"]);
        userId = data["data"]["user"]["id"];
        userRole = data["data"]["user"]["role_id"];
        // savePrefrance(data["data"]["token"]);
      }
    }
  }

  // Start Add Products Method
  addProductsV2(
      String title,
      int categoryId,
      String description,
      double price,
      String supplierName,
      String supplierPhone,
      String discount,
      file,
      file1,
      file2) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String filename = basename(file.path);
    String filename1 = basename(file1.path);
    String filename2 = basename(file2.path);
    print("file basename= $filename");
    print("file basename= $filename1");
    print("file basename= $filename2");
    try {
      Dio dio = new Dio();
      dio.options.headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $value'
      };
      FormData formData = FormData.fromMap({
        "title": "$title",
        "category": "$categoryId",
        "description": "$description",
        "price": "$price",
        "supplier_name": "$supplierName",
        "discount": "$discount",
        "supplier_phone": "$supplierPhone",
        "images": [
          await MultipartFile.fromFile(file.path, filename: filename),
          await MultipartFile.fromFile(file1.path, filename: filename1),
          await MultipartFile.fromFile(file2.path, filename: filename2)
        ]
      });
      Response response = await dio.post("$serverUrl/products", data: formData);
      if (response.statusCode == 201 || response.statusCode == 200) {
        idd = response.data["data"]["id"];
        status = true;
      } else {
        status = false;
      }
    } catch (e) {}
  }

  // Start Add Products Options Method
  Future addProductsOptions(
      String title,
      String title1,
      String title2,
      String price,
      String price1,
      String price2,
      int categoryId,
      String description,
      String supplierName,
      String supplierPhone,
      String discount,
      File file,
      File file1,
      File file2,
      File file3,
      File file4,
      File file5,
      File file6,
      File file7,
      File file8) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String filename = basename(file.path);
    String filename1 = basename(file1.path);
    String filename2 = basename(file2.path);
    String filename3 = basename(file3.path);
    String filename4 = basename(file4.path);
    String filename5 = basename(file5.path);
    String filename6 = basename(file6.path);
    String filename7 = basename(file7.path);
    String filename8 = basename(file8.path);
    try {
      Dio dio = new Dio();
      dio.options.headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $value'
      };
      FormData formData = FormData.fromMap({
        "title": "$title",
        "category": "$categoryId",
        "description": "$description",
        "price": "$price",
        "supplier_name": "$supplierName",
        "supplier_phone": "$supplierPhone",
        "discount": "$discount",
        "options[0][title]": "$title1",
        "options[0][price]": "$price1",
        "options[1][title]": "$title2",
        "options[1][price]": "$price2",
        "images": [
          await MultipartFile.fromFile(file.path, filename: filename),
          await MultipartFile.fromFile(file1.path, filename: filename1),
          await MultipartFile.fromFile(file2.path, filename: filename2)
        ],
        "options[0][images]": [
          await MultipartFile.fromFile(file3.path, filename: filename3),
          await MultipartFile.fromFile(file4.path, filename: filename4),
          await MultipartFile.fromFile(file5.path, filename: filename5)
        ],
        "options[1][images]": [
          await MultipartFile.fromFile(file6.path, filename: filename6),
          await MultipartFile.fromFile(file7.path, filename: filename7),
          await MultipartFile.fromFile(file8.path, filename: filename8)
        ]
      });
      await dio.post("$serverUrl/products", data: formData).whenComplete(() {
        status = true;
      });
    } catch (e) {}
  }

  // Start Get Products Method
  Future<List> getProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/global/products/";
    final response = await http.get(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value',
      'Content-Type': 'application/json',
    });
    Map<String, dynamic> map = json.decode(response.body);
    List<dynamic> data = map["data"];
    print(data);
    countp = data.length;
    return data;
  }

  // Start Get Products With Category Method
  Future<List> getProductsCat(int catId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/categories/$catId";
    final response = await http.get(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value',
      'Content-Type': 'application/json',
    });
    Map<String, dynamic> map = jsonDecode(response.body);
    List<dynamic> data = map["data"];
    return data;
  }

  // Start edit Products Method
  editProductsV2(
      int id,
      String title,
      int categoryId,
      String description,
      double price,
      String supplierName,
      String supplierPhone,
      String discount,
      file,
      file1,
      file2) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String filename = basename(file.path);
    String filename1 = basename(file1.path);
    String filename2 = basename(file2.path);
    print("file basename= $filename");
    print("file basename= $filename1");
    print("file basename= $filename2");
    try {
      Dio dio = new Dio();
      dio.options.headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $value'
      };
      FormData formData = FormData.fromMap({
        "title": "$title",
        "category": "$categoryId",
        "description": "$description",
        "price": "$price",
        "supplier_name": "$supplierName",
        "supplier_phone": "$supplierPhone",
        "discount": "$discount",
        "images": [
          await MultipartFile.fromFile(file.path, filename: filename),
          await MultipartFile.fromFile(file1.path, filename: filename1),
          await MultipartFile.fromFile(file2.path, filename: filename2)
        ]
      });
      Response response =
          await dio.put("$serverUrl/products/$id", data: formData);

      print(response.data);
      if (response.statusCode == 201 || response.statusCode == 200) {
        idd = response.data["data"]["id"];
        status = true;
      } else {
        status = false;
      }
    } catch (e) {}
  }

// Start Add Products Options Method
  Future editProductsOptions(
      int id,
      String title,
      String title1,
      String title2,
      String price,
      String price1,
      String price2,
      int categoryId,
      String description,
      String supplierName,
      String supplierPhone,
      String discount,
      File file,
      File file1,
      File file2,
      File file3,
      File file4,
      File file5,
      File file6,
      File file7,
      File file8) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String filename = basename(file.path);
    String filename1 = basename(file1.path);
    String filename2 = basename(file2.path);
    String filename3 = basename(file3.path);
    String filename4 = basename(file4.path);
    String filename5 = basename(file5.path);
    String filename6 = basename(file6.path);
    String filename7 = basename(file7.path);
    String filename8 = basename(file8.path);
    try {
      Dio dio = new Dio();
      dio.options.headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $value'
      };
      FormData formData = FormData.fromMap({
        "title": "$title",
        "category": "$categoryId",
        "description": "$description",
        "price": "0",
        "discount": "$discount",
        "supplier_name": "$supplierName",
        "supplier_phone": "$supplierPhone",
        "options[0][title]": "$title1",
        "options[0][price]": "$price1",
        "options[1][title]": "$title2",
        "options[1][price]": "$price2",
        "images": [
          await MultipartFile.fromFile(file.path, filename: filename),
          await MultipartFile.fromFile(file1.path, filename: filename1),
          await MultipartFile.fromFile(file2.path, filename: filename2)
        ],
        "options[0][images]": [
          await MultipartFile.fromFile(file.path, filename: filename3),
          await MultipartFile.fromFile(file1.path, filename: filename4),
          await MultipartFile.fromFile(file2.path, filename: filename5)
        ],
        "options[1][images]": [
          await MultipartFile.fromFile(file.path, filename: filename6),
          await MultipartFile.fromFile(file1.path, filename: filename7),
          await MultipartFile.fromFile(file2.path, filename: filename8)
        ]
      });
      Response response =
          await dio.put("$serverUrl/products/$id", data: formData);
      print(response.data);
      if (response.statusCode == 201 || response.statusCode == 200) {
        idd = response.data["data"]["id"];
        status = true;
      } else {
        status = false;
      }
    } catch (e) {}
  }

  // Start Delete Product Method
  Future<void> deleteProduct(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/products/$id";
    http.delete(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    }).then((response) {});
  }

  // Start Add Category Method
  Future<void> addCategory(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/categories";
    final response = await http.post(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "name": "$name"
    });
    print(response.body);
    status = response.body.contains("message");
  }

  // Start Get Category Method
  Future<List> getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/categories";
    final response = await http.get(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    });
    Map<String, dynamic> map = jsonDecode(response.body);
    List<dynamic> data = map["data"];
    categoryId = data[0]["id"];
    countc = data.length;
    return data;
  }

  // Start Edit Category Method
  Future<void> editCategory(int id, String name) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/categories/$id";
    http.put(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "name": "$name",
    }).then((response) {});
  }

  // Start Delete Categories Method
  Future<void> deleteCayegory(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/categories/$id";
    final response = await http.delete(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    });
    if (response.statusCode == 200) {
      status = true;
    }
  }

  // Start Add Ads Method
  addAds(String from, String to, int product, image) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String filename = basename(image.path);
    print("file basename= $filename");
    try {
      Dio dio = new Dio();
      dio.options.headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $value'
      };
      FormData formData = FormData.fromMap(
        {
          "from": "$from",
          "to": "$to",
          "product": "$product",
          "image": await MultipartFile.fromFile(image.path, filename: filename),
        },
      );
      Response response = await dio.post("$serverUrl/ads", data: formData);
      print(ResponseBody);
      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        status = true;
      }
    } catch (e) {}
  }

  // Start Get ads Method
  Future<List> getAds() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/ads";
    final response = await http.get(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    });
    Map<String, dynamic> map = json.decode(response.body);
    List<dynamic> data = map["data"];
    counts = data.length;
    return data;
  }

  // Start Delete Ads Method
  Future<void> deleteAds(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/ads/$id";
    final response = await http.delete(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    });
    if (response.statusCode == 200 || response.statusCode == 201) {
      status = true;
    }
  }

  // Start Add Admin / Sub Admin Method
  Future<void> addSubadmin(
      String name, String phone, String password, var role) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/auth/sign-up";
    var response = await http.post(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "role_id": "$role",
      "name": "$name",
      "password": "$password",
      "phone": "$phone",
    });
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 200) {
      status = true;
    }
  }

  // Start Delete Admin / Sub Admin Method
  Future<void> deleteAdmin(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/sign-up/$id";
    final response = await http.delete(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    });
    if (response.statusCode == 200) {
      status = true;
    }
  }

// Start Edit Admin / Sub Admin Method
  Future<void> editUser(String name, String phone, email, var id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/users/$id";
    //String filename = basename(file.path);

    final response = await http.put(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "name": "$name",
      "phone": "$phone",
      "email": "$email",
     // "avatar": "$filename"
    });
    if (response.statusCode == 200) {
      status = true;
    }
  }

  // Start Get Orders Method
  Future<List> getOrders(String state) async {
    var pendingist = [];
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/orders";
    final response = await http.get(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    });
    Map<dynamic, dynamic> map = json.decode(response.body);
    List<dynamic> data = map["data"];
    counto = data.length;
    for (int i = 0; i < data.length; i++) {
      if (data[i]["status"] == state) {
        pendingist.add(data[i]);
      }
    }
    print(pendingist);
    return pendingist;
  }

  // Start Accept Order Method
  Future acceptOrder(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/orders/$id";
    final response = await http.put(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "status": "accepted",
    });
    if (response.statusCode == 200) {
      status = true;
    }
  }

// Start Complete Order Method
  completeOrder(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/orders/$id";
    final response = await http.put(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "status": "completed",
    });
    if (response.statusCode == 200) {
      status = true;
    }
  }

  // Start Cancel Orders Method
  cancelOrder(int id, int state) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/orders/$id";
    final response = await http.put(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "status": "canceled",
    });
    if (response.statusCode == 200) {
      status = true;
    }
  }
}
