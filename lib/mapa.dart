import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uceda/restaurant.dart';
import 'package:uceda/restaurants_provider.dart';

import 'models/restaurants_model.dart';

class Mapa extends StatefulWidget {
  String tipusrebut;
  int preurebut;

  Mapa(this.tipusrebut, this.preurebut);
  @override
  _MapaState createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  State estat;
  Position position;
  Widget _child;
  GoogleMapController _controller;
  String buscarDireccio;
  String tipus;
  int preu;
  final restaurantprovider = new RestaurantsProvider();
  String urlini = "https://apirobinfood.azurewebsites.net/api/Restaurants/";

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _child);
  }

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
    });
  }

  void initState() {
    getLocation();
    super.initState();
  }

  Future<Set<Marker>> _createMarker() async {
    tipus = this.widget.tipusrebut;
    preu = this.widget.preurebut;
    Set<Marker> marcadorsdins = new Set<Marker>();
    List<Restaurant> llistarestaurants =
        await AconseguirRestaurants(urlini + tipus + '/' + preu.toString());

    llistarestaurants.forEach((obj) {
      Marker opcio = Marker(
          markerId: MarkerId(obj.id.toString()),
          position: LatLng(obj.latitud, obj.longitud),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
              title: obj.nom,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BasicoPage(obj)),
                );
              }));
      marcadorsdins.add(opcio);
    });

    return marcadorsdins;
  }

  Future<List<Restaurant>> AconseguirRestaurants(url) async {
    var resposta = await http.get(url);
    var restaurants;
    if (resposta.statusCode == 200) {
      var decodedData = json.decode(resposta.body);
      print(decodedData);

      restaurants = new Restaurants.fromJsonList(decodedData);
    }

    return restaurants.items;
  }

  Future<void> getLocation() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);
    if (permission == PermissionStatus.denied) {
      await PermissionHandler()
          .requestPermissions([PermissionGroup.locationAlways]);
    }
    var geolocator = Geolocator();

    GeolocationStatus geolocationStatus =
        await geolocator.checkGeolocationPermissionStatus();
    switch (geolocationStatus) {
      case GeolocationStatus.denied:
        showToast('Acces denegat');
        break;
      case GeolocationStatus.disabled:
        showToast('Acces deshabilitat');
        break;
      case GeolocationStatus.restricted:
        showToast('Acces restringit');
        break;
      case GeolocationStatus.unknown:
        showToast('Acces desconegut');
        break;
      case GeolocationStatus.granted:
        showToast('Acces concedit');
        // crearmarcadors();
        _getCurrentLocation();
    }
  }

  void crearmarcadors() {
    tipus = this.widget.tipusrebut;
    preu = this.widget.preurebut;
    Widget restaurantsmarcats(snapshot) {
      snapshot.data.forEach((obj) => markers[obj.id] = (Marker(
          markerId: MarkerId(obj.id.toString()),
          position: LatLng(obj.latitud, obj.longitud),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: obj.nom),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BasicoPage(obj)),
            );
          })));
    }

    FutureBuilder(
      future: AconseguirRestaurants(urlini + tipus + '/' + preu.toString()),
      initialData: Set<Marker>.of(markers.values),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return restaurantsmarcats(snapshot);
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  void showToast(message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Color.fromRGBO(5, 62, 71, 1),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _getCurrentLocation() async {
    Position res = await Geolocator().getCurrentPosition();
    setState(() {
      position = res;
    });
    Widget mapa = await _mapWidget();
    setState(() {
      _child = mapa;
    });
  }

  Future<Widget> _mapWidget() async {
    return GoogleMap(
      mapType: MapType.normal,
      markers: await _createMarker(),
      initialCameraPosition: CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 16.0,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller = controller;
      },
    );
  }
}
