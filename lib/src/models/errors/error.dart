// To parse this JSON data, do
//
//     final error = errorFromJson(jsonString);

import 'dart:convert';

WpErrors errorFromJson(String str) => WpErrors.fromJson(json.decode(str));

String errorToJson(WpErrors data) => json.encode(data.toJson());

class WpErrors {
  bool success;
  List<Datum> data;

  WpErrors({
    this.success,
    this.data,
  });

  factory WpErrors.fromJson(Map<String, dynamic> json) => new WpErrors(
    success: json["success"],
    data: new List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": new List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String code;
  String message;

  Datum({
    this.code,
    this.message,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => new Datum(
    code: json["code"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
  };
}
