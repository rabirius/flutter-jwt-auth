import 'package:flutter/material.dart';

class Token {
  String accessToken;
  String refreshToken;
  Token({@required this.accessToken, @required this.refreshToken});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(accessToken: json['token'], refreshToken: json['refresh']);
  }
}
