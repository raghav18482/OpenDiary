import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class NetworkHandler
{
  String baseurl = "https://gentle-ridge-26756.herokuapp.com"; //this is a base url of deployed server on heroku
  var log = Logger();
FlutterSecureStorage storage = FlutterSecureStorage();

  //get methord
  Future get(String url)async
  {
    String token = await storage.read(key: "token");
    url=formater(url);
    // /user/register
    var response = await http.get(url,
     headers: {
      "Authorization": "Bearer $token"},
    );
    if(response.statusCode==200 || response.statusCode==201)
    {
      log.i(response.body);
      return json.decode(response.body);
    }
    log.i(response.body); // it will log the response body which we getting from url
    log.i(response.statusCode);
  }


  //post methord
  Future<http.Response> post(String url,Map<String,String> body) async
  {
    String token = await storage.read(key: "token");
    url=formater(url);
    log.d(body);
    var response = await http.post(url,
        headers: {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
        },
        body: json.encode(body),
    );
    return response;
  }

  Future<http.Response> patch(String url, Map<String, String> body) async {
    String token = await storage.read(key: "token");
    url = formater(url);
    log.d(body);
    var response = await http.patch(
      url,
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: json.encode(body),
    );
    return response;
  }


//we are using this post methord for model classes
  Future<http.Response> post1(String url, var body) async {
    String token = await storage.read(key: "token");
    url = formater(url);
    log.d(body);
    var response = await http.post(
      url,
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: json.encode(body),
    );
    return response;
  }


  Future<http.StreamedResponse> patchImage(String url, String filepath) async {
    url = formater(url);
    String token = await storage.read(key: "token");
    var request = http.MultipartRequest('PATCH', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath("img", filepath));
    request.headers.addAll({
      "Content-type": "multipart/form-data",
      "Authorization": "Bearer $token"
    });
    var response = request.send();
    return response;
  }


  String formater(String url)// it take url as input
  {
    return baseurl+url;
  }

  NetworkImage getImage(String imageName) {
    String url = formater("/uploads//$imageName.jpg");
    return NetworkImage(url);
  }

}