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
    this.user_id,
    this.username,
    this.email,
    this.password,
    this.first_name,
    this.last_name,
    this.account_created,
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = user_id;
    data['username'] = username;
    data['email'] = email;
    data['password'] = password;
    data['first_name'] = first_name;
    data['last_name'] = last_name;
    data['account_created'] = account_created;
    return data;
  }
}
