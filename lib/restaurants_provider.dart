import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:async';

import 'models/restaurants_model.dart';

class RestaurantsProvider {
  String _url = 'apirobinfood.azurewebsites.net';

  Future<List<Restaurant>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final restaurants = new Restaurants.fromJsonList(decodedData['results']);

    return restaurants.items;
  }

  Future<List<Restaurant>> getFiltrat(String tipus, int preu) async {
    final url =
        Uri.https(_url, 'api/Restaurants/' + tipus + '/' + preu.toString());
    return await _procesarRespuesta(url);
  }
}
