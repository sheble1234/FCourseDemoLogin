import 'package:api_login/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Auth extends ChangeNotifier {
  Auth(apiService) : _apiService = apiService;

  APIServiceClass _apiService;

  Future<Response> login(String userName, String password) async {
    Response result = await _apiService.post("/Authenticate/login",
        body: {"username": userName, "password": password});
    return result;
  }
}
