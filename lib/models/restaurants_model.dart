class Restaurants {
  List<Restaurant> items = new List();

  Restaurants();

  Restaurants.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    jsonList.forEach((item) {
      final restaurant = Restaurant.fromJsonMap(item);
      items.add(restaurant);
    });
  }
}

class Restaurant {
  int id;
  String nom;
  String tipus;
  double latitud;
  double longitud;
  String adreca;
  String horari;
  String telefon;
  String foto;
  String qR;

  Restaurant({
    this.id,
    this.nom,
    this.tipus,
    this.latitud,
    this.longitud,
    this.adreca,
    this.horari,
    this.telefon,
    this.foto,
    this.qR,
  });

  Restaurant.fromJsonMap(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    tipus = json['tipus'];
    latitud = json['latitud'];
    longitud = json['longitud'];
    adreca = json['adreca'];
    horari = json['horari'];
    telefon = json['telefon'];
    foto = json['foto'];
    qR = json['qr'];
  }
}
