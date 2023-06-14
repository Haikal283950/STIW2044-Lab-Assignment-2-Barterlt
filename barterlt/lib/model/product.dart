class Product {
  final String productName;
  final String productDescription;
  final String productQuantity;
  final String productPrice;
  final String productRegion;
  final String productCity;
  final String productPostcode;
  final String productCountry;
  final String productLongitude;
  final String productLatitude;
  final String image1;
  final String image2;
  final String image3;
  final String image4;
  final String image5;

  Product({
    required this.productName,
    required this.productDescription,
    required this.productQuantity,
    required this.productPrice,
    required this.productRegion,
    required this.productCity,
    required this.productPostcode,
    required this.productCountry,
    required this.productLongitude,
    required this.productLatitude,
    required this.image1,
    required this.image2,
    required this.image3,
    required this.image4,
    required this.image5,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productName: json['product_name'],
      productDescription: json['product_description'],
      productQuantity: json['product_quantity'],
      productPrice: json['product_price'],
      productRegion: json['product_region'],
      productCity: json['product_city'],
      productPostcode: json['product_postcode'],
      productCountry: json['product_country'],
      productLongitude: json['product_longitude'],
      productLatitude: json['product_latitude'],
      image1: json['image1'],
      image2: json['image2'],
      image3: json['image3'],
      image4: json['image4'] ?? '',
      image5: json['image5'] ?? '',
    );
  }
}
