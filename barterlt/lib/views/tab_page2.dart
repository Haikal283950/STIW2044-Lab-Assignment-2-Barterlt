import 'dart:convert';

import 'package:barterlt/myConfig.dart';
import 'package:barterlt/views/item_details.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../model/product.dart';
import 'package:http/http.dart' as http;

import '../model/user.dart';

class tab_page2 extends StatefulWidget {
  final User user;
  const tab_page2({super.key, required this.user});

  @override
  State<tab_page2> createState() => _tab_page2State();
}

class _tab_page2State extends State<tab_page2> {
  TextEditingController searchController = TextEditingController();
  var selectedIndex;
  var color;
  var pageTotal, currentPage = 1;
  List<Product> productList = <Product>[];
  String searchedItem = "";

  void printControllerValue() {
    print(searchController.text);
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(printControllerValue);
    sendRequest(1);
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
      onRefresh: sendDefaultMethod,
      child: Center(
        child: productList.isEmpty
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("No items found!"),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: sendDefaultMethod,
                      child: Text("Refresh"),
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 153, 18, 194),
                        onPrimary: Color.fromARGB(255, 255, 255, 255),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35)),
                      ),
                    ),
                  )
                ],
              ))
            : Center(
                child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  children: [
                    //Make an rounded searchbar
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: searchController,
                        onChanged: (value) {
                          if (value == '') {
                            sendRequest(1);
                          } else {
                            sendSearchRequest(value, 1);
                          }
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            labelText: "Search for items",
                            filled: true,
                            fillColor: Color.fromARGB(255, 214, 226, 240),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(35))),
                      ),
                    ),
                    Text(
                      "Or",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    Text(
                      "Explore more on Barterlt",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
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
              )),
      ),
    );
  }

  Future<void> sendDefaultMethod() async {
    sendRequest(selectedIndex ?? 1);
  }

  Future<void> sendRequest(pageNo) async {
    print(server + '/barterlt/php/load_items.php');
    pageTotal ?? 1;
    productList.clear();
    http.post(Uri.parse(server + '/barterlt/php/load_items.php'), body: {
      "pageno": pageNo.toString(),
      "user_id": widget.user.user_id,
      "boolean_for_user": "0"
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
          setState(() {
            Future.delayed(Duration(milliseconds: 500), () {
              print(widget.user.user_id);
            });
          });
          ScaffoldMessenger.of(context).showSnackBar(buildSnackBar());
        }
      } else if (response.body == "failed") {
        print("Fail");
      }
    });
  }

  Future<void> sendSearchRequest(searchedItem, pageNo) async {
    pageTotal ?? 1;
    productList.clear();
    http.post(Uri.parse(server + '/barterlt/php/load_items.php'), body: {
      "pageno": pageNo.toString(),
      "searched_item": searchedItem,
    }).then((response) async {
      print(response.statusCode); // Print the status code
      if (response.statusCode == 200 && response.body != "failed") {
        // Parse the JSON response if it is valid
        final jsonResponse = json.decode(response.body);
        print(jsonResponse);
        if (jsonResponse['status'] == "success") {
          //Map the json and put it into the product class
          for (var item in jsonResponse['data']) {
            Product product = Product.fromJson(item);
            productList.add(product);
          }
          setState(() {
            Future.delayed(Duration(milliseconds: 500), () {
              print(widget.user.user_id);
            });
          });
        } else if (jsonResponse['status'] == "failed") {
          FocusScope.of(context).unfocus();
          setState(() {});
        }
      } else if (response.body == "failed") {
        print("Fail");
      }
    });
  }

  SnackBar buildSnackBar() {
    return SnackBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Text("Found " + productList.length.toString() + " items!"),
        duration: Duration(seconds: 1));
  }

  InkWell buildOwnedItemCards(int index, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return itemDetails(
            product: productList[index],
          );
        }));
      },
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
                          Icon(Icons.attach_money, size: 12),
                          Text("RM " + productList[index].productPrice,
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_city,
                            size: 12,
                          ),
                          Container(
                            width: 100,
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
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 23, 189, 78),
                          onPrimary: Color.fromARGB(255, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35)),
                        ),
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_cart),
                            Text("Add to cart")
                          ],
                        ))
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
