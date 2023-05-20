import 'package:flutter/material.dart';

class User {
  String? user_id;
  String? username;
  String? email;
  String? password;
  String? first_name;
  String? last_name;
  String? account_created;

  User({
    required this.user_id,
    required this.username,
    required this.email,
    required this.password,
    required this.first_name,
    required this.last_name,
    required this.account_created,
  });

  User.fromJson(Map<String, dynamic> json) {
    user_id = json['user_id'];
    username = json['username'];
    email = json['email'];
    password = json['password'];
    first_name = json['first_name'];
    last_name = json['last_name'];
    account_created = json['account_created'];
  }
}
