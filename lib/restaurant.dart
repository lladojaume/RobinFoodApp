import 'package:flutter/material.dart';
import 'package:uceda/models/restaurants_model.dart';
import 'package:url_launcher/url_launcher.dart';

class BasicoPage extends StatelessWidget {
  Restaurant restaurant;
  BasicoPage(this.restaurant);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
              width: 420,
              height: 5.0,
              child: const DecoratedBox(
                  decoration: const BoxDecoration(color: Colors.red))),
          _crearImagen(context),
          SizedBox(
              width: 420,
              height: 5.0,
              child: const DecoratedBox(
                  decoration: const BoxDecoration(color: Colors.red))),
          _crearTitulo(),
          SizedBox(
              width: 420,
              height: 5.0,
              child: const DecoratedBox(
                  decoration: const BoxDecoration(color: Colors.red))),
          SizedBox(height: 60.0),
          _crearTexto(),
          SizedBox(height: 60.0),
          telefon(restaurant.telefon),
        ],
      ),
    ));
  }

  Widget _crearImagen(BuildContext context) {
    return Container(
      width: double.infinity,
      child: GestureDetector(
        child: Image(
          image: AssetImage('assets/' + restaurant.foto),
          height: 220.0,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _crearTitulo() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(restaurant.nom.toUpperCase(),
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
                SizedBox(height: 7.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearTexto() {
    return Container(
        width: 400,
        height: 300,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.all(Radius.circular(40.0))),
          child: Column(
            children: <Widget>[
              SizedBox(height: 60.0),
              Wrap(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.location_on, color: Colors.red, size: 30.0),
                      Flexible(
                          child: Text(
                        restaurant.adreca,
                        maxLines: 5,
                        style: TextStyle(fontSize: 20.0),
                        textAlign: TextAlign.center,
                      )),
                    ],
                  )
                ],
              ),
              SizedBox(height: 80),
              Wrap(children: <Widget>[
                Icon(Icons.access_time, color: Colors.red, size: 30.0),
                Text(restaurant.horari, style: TextStyle(fontSize: 20.0)),
              ]),
              SizedBox(height: 30),
            ],
          ),
        ));
  }

  Widget telefon(numtelf) {
    return FlatButton(
        color: Colors.red[900],
        padding: EdgeInsets.all(15.0),
        onPressed: () => trucar(numtelf),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.values[0],
            children: <Widget>[
              Icon(Icons.phone, color: Colors.white, size: 30.0),
              Text(
                ' RESERVAR',
                style: TextStyle(fontSize: 20.0, color: Colors.white),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ));
  }

  trucar(telf) async {
    var url = 'tel:$telf';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
