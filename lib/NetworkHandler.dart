import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

class NetworkHandler {
  String baseUrl = "provide base url";
  var logger = Logger();

  Future get(String url) async {
    url = formater(url);
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200 || response.statusCode == 201) {
      logger.d(response.body);
      return json.decode(response.body);
    }
    logger.i(url);
    logger.i(response.body);
    logger.i(response.statusCode);
  }

  Future<http.Response> post(String url, Map<String, String> body) async {
    url = formater(url);
    var response = await http.post(Uri.parse(url),
        headers: {"Content-type": "application/json"}, body: json.encode(body));
    return response;
  }

  String formater(String url) {
    return baseUrl + url;
  }
}
