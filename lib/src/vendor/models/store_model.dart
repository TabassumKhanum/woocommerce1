// To parse this JSON data, do
//
//     final storeModel = storeModelFromJson(jsonString);

import 'dart:convert';

List<StoreModel> storeModelFromJson(String str) => List<StoreModel>.from(json.decode(str).map((x) => StoreModel.fromJson(x)));

String storeModelToJson(List<StoreModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StoreModel {
  int id;
  String name;
  String icon;
  String banner;
  Address address;
  String description;
  String lat;
  String lon;
  double averageRating;
  int ratingCount;
  int productsCount;

  StoreModel({
    this.id,
    this.name,
    this.icon,
    this.banner,
    this.address,
    this.description,
    this.lat,
    this.lon,
    this.averageRating,
    this.ratingCount,
    this.productsCount,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) => StoreModel(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    icon: json["icon"] == null ? null : json["icon"],
    banner: json["banner"] == null ? null : json["banner"],
    address: json["address"] == null ? null : Address.fromJson(json["address"]),
    description: json["description"] == null ? null : json["description"],
    lat: json["lat"] == null ? null : json["lat"],
    lon: json["lon"] == null ? null : json["lon"],
    averageRating: json["average_rating"] == null ? null : json["average_rating"].toDouble(),
    ratingCount: json["rating_count"] == null ? null : json["rating_count"],
    productsCount: json["products_count"] == null ? null : json["products_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "icon": icon == null ? null : icon,
    "banner": banner == null ? null : banner,
    "address": address == null ? null : address,
    "description": description == null ? null : description,
    "lat": lat == null ? null : lat,
    "lon": lon == null ? null : lon,
  };
}

class Address {
  String street1;
  String street2;
  String city;
  String zip;
  String country;
  String state;

  Address({
    this.street1,
    this.street2,
    this.city,
    this.zip,
    this.country,
    this.state,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    street1: json["street_1"] == null ? null : json["street_1"],
    street2: json["street_2"] == null ? null : json["street_2"],
    city: json["city"] == null ? null : json["city"],
    zip: json["zip"] == null ? null : json["zip"],
    country: json["country"] == null ? null : json["country"],
    state: json["state"] == null ? null : json["state"],
  );

  Map<String, dynamic> toJson() => {
    "street_1": street1 == null ? null : street1,
    "street_2": street2 == null ? null : street2,
    "city": city == null ? null : city,
    "zip": zip == null ? null : zip,
    "country": country == null ? null : country,
    "state": state == null ? null : state,
  };
}
