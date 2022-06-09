import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ganjoor/services/ganjoor_service.dart';

class Request {
  final String url;

  Request(this.url);

  get(Function callback) {
    Uri uri = Uri.parse(GanjoorService.baseUrl + url);
    http
        .get(uri)
        .then((value) => callback(json.decode(value.body)))
        .onError((error, stackTrace) => callback(null));
  }
}
