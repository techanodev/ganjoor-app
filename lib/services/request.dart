import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ganjoor/services/ganjoor_service.dart';

class Request {
  final String url;
  final Function callback;

  Request(this.url, this.callback);

  get() {
    Uri uri = Uri.parse(GanjoorService.baseUrl + url);
    http
        .get(uri)
        .then((value) => callback(json.decode(value.body)))
        .onError((error, stackTrace) => callback(null));
  }
}
