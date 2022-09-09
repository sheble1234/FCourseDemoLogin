import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:http/http.dart';

class APIServiceClass {
  Uri _makeUri(String path, {Map<String, String?>? queryParams}) {
    return Uri.https(
        "webhooktest54.advanceprotech.com", "/api$path", queryParams);
  }

  Future get(String path, {Map<String, String?>? queryParams}) async {
    var uri = _makeUri(path, queryParams: queryParams);
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String token = prefs.getString('Token') ?? '';
    Response result = await http.get(uri, headers: {
      'Authorization': 'Bearer ' +
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IjQ1NDIiLCJyb2xlIjoiQVBUWF9BZG1pbiIsIlJlZnJlc2hUb2tlbiI6IkhsMlFHenNRcmF5SDd5WlIzS2lWY0VYcUUzZUo1a1o3dWVYbVlWSVg4OGsiLCJuYmYiOjE2NjIyMTg5NzMsImV4cCI6MTY2MjM5MTc3MywiaWF0IjoxNjYyMjE4OTczfQ.-Z2vvxUwdFAEgceZkAGzPpLSu4oHozAamS3AkQUKQI8"
    });
    return result;
  }

  Future post(
    String path, {
    Object? body,
    Map<String, String?>? queryParams,
  }) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String token = prefs.getString('Token') ?? '';
    var uri = _makeUri(path, queryParams: queryParams);

    var result = await http.post(
      uri,
      body: convert.jsonEncode(body),
      headers: {
        'Authorization': 'Bearer ' + "",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print(uri);
    // print("api post Result : ${result.body}");
    return result;
  }

  Future put(
    String path, {
    required Object body,
  }) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String token = prefs.getString('Token') ?? '';
    var result = await http.put(
      _makeUri(path),
      body: convert.jsonEncode(body),
      headers: {
        'Authorization': 'Bearer ' + "",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return result;
  }

  Future delete(String path, {Object? body}) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String token = prefs.getString('Token') ?? '';
    var result = await http.delete(
      _makeUri(path),
      body: convert.jsonEncode(body),
      headers: {
        'Authorization': 'Bearer ' + "",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return result;
  }
}
