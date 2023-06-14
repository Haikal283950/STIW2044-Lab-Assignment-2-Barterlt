import 'dart:convert';

import 'package:barterlt/model/product.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../model/user.dart';

class tab_page1 extends StatefulWidget {
  final User user;
  const tab_page1({super.key, required this.user});

  @override
  State<tab_page1> createState() => _tab_page1State();
}

class _tab_page1State extends State<tab_page1> {
  List<Product> productList = <Product>[];
  @override
  void initState() {
    super.initState();
    sendRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: productList.isEmpty
            ? const Center(
                child: Text("Found nothing"),
              )
            : Center(
                child: Text("Found stuff!"),
              ));
  }

  Future<void> sendRequest() async {
    http.post(Uri.parse('http://10.0.2.2/barterlt/php/load_items.php'),
        body: {"user_id": widget.user.user_id}).then((response) async {
      print(response.statusCode); // Print the status code
      print(response.body); // Print the full response

      if (response.statusCode == 200 && response.body != "failed") {
        // Parse the JSON response if it is valid
        final jsonResponse = json.decode(response.body);
        print(jsonResponse);
        if (jsonResponse['status'] == "success") {
          var extractdata = jsonResponse['data'];
          extractdata['items'].forEach((x) {
            productList.add(Product.fromJson(x));
          });
          print(productList[0].productName);
          setState(() {});
        }
      } else if (response.body == "failed") {
        print("Fail");
      }
    });
  }
}
