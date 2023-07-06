import 'dart:convert';

import 'package:barterlt/model/product.dart';
import 'package:barterlt/myConfig.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../model/user.dart';

class tab_page1 extends StatefulWidget {
  final User user;
  const tab_page1({super.key, required this.user});

  @override
  State<tab_page1> createState() => _tab_page1State();
}

class _tab_page1State extends State<tab_page1> {
  var selectedIndex;
  var color;
  var pageTotal, currentPage = 1;
  List<Product> productList = <Product>[];
  @override
  void initState() {
    super.initState();
    sendRequest(1);
  }

  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
      color: Color.fromARGB(172, 87, 41, 211),
      onRefresh: sendDefaultMethod,
      child: Center(
          child: productList.isEmpty
              ? Center(child: Text("No items found!"))
              : Center(
                  child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 9,
                        child: GridView.count(
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 0.1,
                          childAspectRatio: 0.63,
                          crossAxisCount: 2,
                          children: List.generate(productList.length,
                              (index) => buildOwnedItemCards(index, context)),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: ListView.builder(
                              itemCount: pageTotal,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                if ((currentPage - 1) == index) {
                                  color = Colors.blue;
                                } else {
                                  color = Colors.grey;
                                }
                                return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        selectedIndex = index + 1;
                                        sendRequest(index + 1);
                                        setState(() {
                                          currentPage = index + 1;
                                        });
                                      },
                                      child: CircleAvatar(
                                          backgroundColor: color,
                                          child: Text(
                                            (index + 1).toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ));
                              }))
                    ],
                  ),
                ))),
    );
  }

  Future<void> sendDefaultMethod() async {
    sendRequest(selectedIndex ?? 1);
  }

  InkWell buildOwnedItemCards(int index, BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Card(
        shadowColor: Color.fromARGB(172, 87, 41, 211),
        elevation: 12,
        color: Color.fromARGB(255, 255, 255, 255),
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Container(
                        height: 180,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(server +
                                    "/barterlt/" +
                                    productList[index].image1))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Row(
                        children: [
                          Text(productList[index].productName,
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Row(
                        children: [
                          Text("RM " + productList[index].productPrice,
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              productList[index].productCity +
                                  ", " +
                                  productList[index].productRegion,
                              style: Theme.of(context).textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255, 14, 54, 141),
                                onPrimary: Color.fromARGB(255, 255, 255, 255),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(35)),
                              ),
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.edit),
                                ],
                              )),
                        ),
                        Expanded(
                          flex: 2,
                          child: SizedBox(),
                        ),
                        Expanded(
                          flex: 4,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255, 248, 32, 32),
                                onPrimary: Color.fromARGB(255, 255, 255, 255),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(35)),
                              ),
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.delete),
                                ],
                              )),
                        ),
                      ],
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Future<void> sendRequest(pagerequest) async {
    pageTotal ?? 1;
    productList.clear();
    http.post(Uri.parse(server + '/barterlt/php/load_items.php'), body: {
      "user_id": widget.user.user_id,
      "pageno": pagerequest.toString(),
    }).then((response) async {
      print(response.statusCode); // Print the status code
      if (response.statusCode == 200 && response.body != "failed") {
        // Parse the JSON response if it is valid
        final jsonResponse = json.decode(response.body);
        print(jsonResponse);
        if (jsonResponse['status'] == "success") {
          pageTotal = jsonResponse['number_of_pages'];
          //Map the json and put it into the product class
          for (var item in jsonResponse['data']) {
            Product product = Product.fromJson(item);
            productList.add(product);
          }
          setState(() {});
        }
      } else if (response.body == "failed") {
        print("Fail");
      }
    });
  }
}
