import 'dart:convert';
import 'dart:io';

import 'package:barterlt/model/user.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:lottie/lottie.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;

class add_item extends StatefulWidget {
  final User user;
  const add_item({super.key, required this.user});

  @override
  State<add_item> createState() => _add_itemState();
}

class _add_itemState extends State<add_item> {
  int storage = 0;
  File? selectedFile;
  late String selectedPath;
  void initializeSelectedPath() {
    selectedPath = "assets/images/image$storage.png";
  }

  void addTheItem() {
    files.add({'file': selectedFile, 'path': "assets/images/camera$storage"});
  }

  List<Map<String, dynamic>> files = [];
  bool locationTracked = false;
  bool _isLoading = false;
  late Position _currentPosition;
  String? city;
  String? region;
  String? postcode;
  String? country;
  String? geocodeLong;
  String? geocodeLat;
  Map<String, TextEditingController> _textEditingControllers = {
    'product_name': TextEditingController(),
    'product_price': TextEditingController(),
    'product_quantity': TextEditingController(),
    'product_description': TextEditingController(),
  };
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.onUserInteraction;
  @override
  void dispose() {
    super.dispose();
    _textEditingControllers.forEach((key, controller) {
      controller.dispose();
    });
  }

  @override
  void initState() {
    super.initState();
    storage = 0;
    files.clear();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: CustomScrollView(slivers: [
      SliverAppBar(
        floating: false,
        expandedHeight: MediaQuery.of(context).size.height * 0.05,
      ),
      SliverToBoxAdapter(
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add your items \nright here!",
                  style: Theme.of(context).textTheme.displayLarge,
                )
              ],
            )),
      ),
      SliverToBoxAdapter(
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Stack(children: [
              Card(
                shadowColor: Color.fromARGB(157, 176, 210, 238),
                elevation: 15,
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _selectImageFromCamera();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(255, 75, 58, 95)
                                          .withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate,
                                      size: 48,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Container(
                                height: 200,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: files.length,
                                  itemBuilder: (context, index) {
                                    return AspectRatio(
                                      aspectRatio: 1.0,
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Image.file(
                                          files[index]['file'],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: buildTextField(
                            _textEditingControllers['product_name']!,
                            "Please insert the product name!",
                            Icon(Icons.shopping_bag_outlined),
                            "Product Name",
                            1,
                            ''),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: buildTextField(
                            _textEditingControllers['product_description']!,
                            "Please insert the product description!",
                            Icon(Icons.question_mark_outlined),
                            "Product description",
                            5,
                            ''),
                      ),
                      Row(
                        children: [
                          Flexible(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: buildTextField(
                                  _textEditingControllers['product_quantity']!,
                                  "Please insert the product quantity!",
                                  Icon(Icons.shopping_bag_outlined),
                                  "Quantity",
                                  1,
                                  ''),
                            ),
                          ),
                          Flexible(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: buildTextField(
                                  _textEditingControllers['product_price']!,
                                  "Please insert the product price!",
                                  Icon(Icons.attach_money),
                                  "Price",
                                  1,
                                  'RM'),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: size.width,
                        child: ElevatedButton(
                          onPressed: () {
                            _checkPosition();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.location_pin),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text("Pin point my location!"),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (region != null)
                              Icon(
                                Icons.location_city,
                                color: Color.fromARGB(255, 8, 9, 87),
                              ),
                            Expanded(
                              child: Text(
                                "${region != null ? region : ''}, ${city != null ? city : ''} ${postcode != null ? postcode : ''}\n${country != null ? country : ''}",
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: size.width,
                        child: ElevatedButton(
                          onPressed: locationTracked
                              ? () {
                                  add_item();
                                }
                              : null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text("Submit my item!"),
                              ),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 8, 9, 87),
                              foregroundColor: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ])),
      ),
    ]));
  }

  void add_item() {
    TextEditingController productNameController =
        _textEditingControllers['product_name']!;
    TextEditingController productPriceController =
        _textEditingControllers['product_price']!;
    TextEditingController productQuantityController =
        _textEditingControllers['product_quantity']!;
    TextEditingController productDescriptionController =
        _textEditingControllers['product_description']!;

    String productName = _textEditingControllers['product_name']!.text;
    String productPrice = _textEditingControllers['product_price']!.text;
    String productQuantity = _textEditingControllers['product_quantity']!.text;
    String productDescription =
        _textEditingControllers['product_description']!.text;

    List<String> base64ed = [];
    for (var fileData in files) {
      File? file = fileData['file'];
      if (file != null) {
        List<int> bytes = file.readAsBytesSync();
        String base64 = base64Encode(bytes);
        base64ed.add(base64);
      } else {
        base64ed.add('');
      }
    }

    print('Base64 Encoded Files:');
    for (int i = 0; i < base64ed.length; i++) {
      print('Image ${i + 1}: ${base64ed[i]}');
    }

    http.post(Uri.parse('http://10.0.2.2/barterlt/php/post_item.php'), body: {
      'product_name': productName,
      'product_description': productDescription,
      'product_quantity': productQuantity,
      'product_price': productPrice,
      'product_region': region,
      'product_city': city,
      'product_postcode': postcode,
      'product_country': country,
      'product_longitude': geocodeLong,
      'product_latitude': geocodeLat,
      'image1': base64ed.length >= 1 ? base64ed[0] : '',
      'image2': base64ed.length >= 2 ? base64ed[1] : '',
      'image3': base64ed.length >= 3 ? base64ed[2] : '',
      'image4': base64ed.length >= 4 ? base64ed[3] : '',
      'image5': base64ed.length >= 5 ? base64ed[4] : '',
      'user_id': widget.user.user_id,
    }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          _showRoundedSnackbar(context, "Item added!");
        } else {
          _showRoundedSnackbar(context, "Item was not added!");
        }
        Navigator.pop(context);
      } else {
        _showRoundedSnackbar(context, "Error connecting to the database!");
      }
    });
  }

  Future<void> _selectImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery, maxHeight: 1000, maxWidth: 1000);

    if (pickedFile != null) {
      files.add({
        'file': File(pickedFile.path),
        'path': "assets/images/camera$storage"
      });
      _cropImage();
    }
  }

  void _showRoundedSnackbar(BuildContext context, String userText) {
    final snackBar = SnackBar(
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      content: Text(
        "Welcome back $userText",
        style: TextStyle(color: Colors.white, fontFamily: "gotham"),
      ),
      duration: Duration(seconds: 3),
    );

    Future.delayed(Duration(milliseconds: 500), () {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  Future<void> _selectImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource.camera, maxHeight: 1000, maxWidth: 1000);
    if (files.length < 5) {
      if (pickedFile != null) {
        selectedFile = File(pickedFile.path);
        selectedPath = "assets/images/camera$storage";
        _cropImage();
      }
    }
  }

  Future<void> _cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: selectedFile!.path,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      uiSettings: [
        AndroidUiSettings(toolbarTitle: "Image Cropper"),
        IOSUiSettings(title: 'Image cropper')
      ],
    );
    if (croppedFile != null) {
      File cropped = File(croppedFile.path);
      files.add({'file': cropped, 'path': "assets/images/camera$storage"});
      setState(() {});
    }
  }

  TextFormField buildTextField(
      TextEditingController controller,
      String validateText,
      Icon icon,
      String labelText,
      int number,
      String prefixText) {
    double number2 = 0;
    if (number == 5) {
      number2 = 10;
    } else {
      number2 = 30;
    }
    return TextFormField(
      maxLines: number,
      controller: controller,
      validator: (value) => value!.isEmpty ? validateText : null,
      decoration: InputDecoration(
          prefixText: prefixText,
          prefixIcon: icon,
          contentPadding: EdgeInsets.all(20),
          labelText: labelText,
          filled: true,
          fillColor: Color.fromARGB(255, 214, 226, 240),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(number2))),
    );
  }

  void _checkPosition() async {
    _isLoading = true;
    if (_isLoading) {
      _showDialog(context);
    }
    bool serviceEnabled;
    LocationPermission permit;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error('Location services are disabled');

    permit = await Geolocator.checkPermission();
    if (permit == LocationPermission.denied) {
      permit = await Geolocator.requestPermission();
      if (permit == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permit == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently disabled.');
    }

    _currentPosition = await Geolocator.getCurrentPosition();
    _isLoading = false;
    if (!_isLoading) {
      Navigator.pop(context);
    }
    _getAddress(_currentPosition);
    locationTracked = true;
  }

  _getAddress(Position pos) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    print(placemarks[0].locality.toString());
    print(placemarks[0].administrativeArea.toString());
    print(placemarks[0].postalCode.toString());
    print(_currentPosition.latitude.toString());
    print(_currentPosition.longitude.toString());
    setState(() {
      city = placemarks[0].locality.toString();
      region = placemarks[0].administrativeArea.toString();
      postcode = placemarks[0].postalCode.toString();
      country = placemarks[0].country.toString();
      geocodeLat = _currentPosition.latitude.toString();
      geocodeLong = _currentPosition.longitude.toString();
    });
  }

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Hold your horses!"),
            content: Container(
              width: MediaQuery.of(context).size.height * 0.4,
              height: MediaQuery.of(context).size.height * 0.25,
              child: Column(
                children: [
                  LottieBuilder.network(
                      'https://assets3.lottiefiles.com/private_files/lf30_noclpt6t.json'),
                  Text(
                    "Hold up while we track your footsteps!\n(We might sell you next)",
                    style: Theme.of(context).textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          );
        });
  }
}
