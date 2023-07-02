import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sheidaie/services/ganjoor_service.dart';

class Request {
  final String url;

  Request(this.url);

  get(Function callback, {parse = true}) {
    Uri uri = Uri.parse(GanjoorService.baseUrl + url);
    http
        .get(uri)
        .then((value) => callback(parse ? json.decode(value.body) : value.body))
        .onError((error, stackTrace) => callback(null));
  }
}
