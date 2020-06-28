import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:news/Exceptions/exceptions.dart';
import 'package:news/globals/tokens.dart';
import 'package:news/models/token.dart';

String baseUrl = 'http://192.168.0.2:8000';

Future<dynamic> refreshToken(String rToken) async {
  try {
    final response = await http.get(baseUrl + '/auth/refresh',
        headers: {'Authorization': rToken, 'Content-Type': 'application/json'});

    if (response.statusCode == 401) {
      throw InvalidTokenException('Unauthorized');
    } else if (response.statusCode == 200) {
      Token tkn = Token.fromJson(json.decode(response.body));
      token = tkn;
      await storeToken(tkn);
    } else {
      throw UnknownException('Unknown Exception');
    }
  } on SocketException {
    throw NoInternetException('No Internet Connection');
  }
}

Future<dynamic> login(String userName, String password) async {
  try {
    final response = await http.post(
      baseUrl + '/auth/token',
      body: json.encode({'username': userName, 'password': password}),
    );
    if (response.statusCode == 200) {
      Token tkn = Token.fromJson(json.decode(response.body));
      token = tkn;
      await storeToken(tkn);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException('unauthorized');
    } else {
      throw UnknownException('Unknown Exception');
    }
  } on SocketException {
    throw NoInternetException('No Internet Connection');
  }
}
