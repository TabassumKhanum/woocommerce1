import 'dart:async';
import './../config.dart';
import './../models/category_model.dart';
import 'package:http/http.dart' show Client;
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class ApiProvider {

  static final ApiProvider _apiProvider = new ApiProvider._internal();

  String lan = 'en';

  factory ApiProvider() {
    return _apiProvider;
  }

  Future init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lan = prefs.getString('language_code') != null ? prefs.getString('language_code') : 'en';
  }

  ApiProvider._internal();

  Client client = Client();
  Map<String, String> headers = {
    "content-type": "application/x-www-form-urlencoded; charset=utf-8"
  };
  Map<String, dynamic> cookies = {};
  List<Cookie> cookieList = [];
  Config config = Config();



  //var url = 'http://localhost:8888/wcfm';
  //var url = 'https://shop.saudasulf.com';
  //var url = 'http://35.226.27.186/woocommerce';
  //var url = 'https://buygo.xyz/woocommerce';
  //var consumerKey = 'ck_76973960a31c0cab6dd116611693abf161de5db7';
 // var consumerSecret = 'cs_449e4f6508c90bd6a4c056a40318c6e1c6bcf532';

  //var url = 'https://dadosh.com';
  //var consumerKey = 'ck_29d2b1801b13b9be0d2a05e68d3634792162c474';
  //var consumerSecret = 'cs_c12c5406cc9ab3211499a4fa3af748f0d8d4831c';

  //var url = 'https://ghost.delivery/uygulama';
  //var consumerKey = 'ck_0484fed992809ee45afc47f1b5e0521d6f33caef';
  //var consumerSecret = 'cs_ce2fa18b044a29849a79936f908807211bac58ae';

  //var url = 'http://130.211.141.170/ionic4';
  //var consumerKey = 'ck_6ecd7d7ccd67ed65225ba0b5a16f3582fde8b24e';
  //var consumerSecret = 'cs_86f81e2c3e9e6a64a954ec006a1c9eea0d3aebb2';

  //var url = 'http://130.211.141.170/ionic4';
  //var consumerKey = 'ck_6ecd7d7ccd67ed65225ba0b5a16f3582fde8b24e';
  //var consumerSecret = 'cs_86f81e2c3e9e6a64a954ec006a1c9eea0d3aebb2';

  //var url = 'http://localhost:8888/wcfm';
  //var consumerKey = 'ck_eb39c991775162b1f80915d3ff9bced78e7275c3';
  //var consumerSecret = 'cs_2a804056884437c4962b1a201699ab7730b2f76b';

  //var url = 'http://arabvape.com';
  //var url = 'https://morslon.com';
  //var consumerKey = 'ck_eb39c991775162b1f80915d3ff9bced78e7275c3';
  //var consumerSecret = 'cs_2a804056884437c4962b1a201699ab7730b2f76b';

/*  var url = 'http://localhost:8888/dokan';
  var consumerKey = 'ck_0b80d24b7258363f1fe81c369beb621a063544c4';
  var consumerSecret = 'cs_97481e9961428dea92b49d1a34f21a2aaeabad36';*/

  /*var url = 'http://localhost:8888/wpmarket';
  var consumerKey = 'ck_e5a049f502c5957ead36a91839bd2b6cfe794f05';
  var consumerSecret = 'cs_705c618b055153e24f58ac67bb12ce0da9032c85';*/

  /*var url = 'https://erbil.online';
  var consumerKey = 'ck_b6746d2ed8389324cfa727325bb9e5ff5ed969af';
  var consumerSecret = 'cs_59484bb970c25e26ce990f120b7a4e68aae1ef13';*/


  /*var url = 'https://ekitimarket.com';
  var consumerKey = 'ck_d85743aaaa0a491c2affe528f5db81c4ee1b530d';
  var consumerSecret = 'cs_10700b26ecb2f31773c0147ad867c25835e36925';*/

  //var url = 'http://130.211.141.170/wc-marketplace';
  //var consumerKey = 'ck_1833cc4a6b6b0eaa1e25a1e2f25c111f7af24efc';
  // var consumerSecret = 'cs_1767a5bf30e3a2212cbfc264a64069c16c5f0333';


  //var url = 'http://www.isbrothers.com';
  //var url = 'http://localhost:8888/wcfm';
  //var url = 'https://awalpets.com';
  //var url = 'https://morslon.com';

  //var url = 'http://35.226.27.186/marketplace';
  //var url = 'https://dallaspresso.com';
  //var url = 'http://130.211.141.170/wc-marketplace';

  //var url = 'http://designing.website/demo';
  //var url = 'http://mythoz.com/mart';
  //var url = 'https://www.loviny.com';
  //var url = 'https://dadosh.com';
  //var url = 'https://499store.in';

  //var url = 'https://bilinapo.com';
  //var url = 'http://edragon.ae';
  //var url = 'https://ekitimarket.com';
  //var url = 'https://smartergem.com';
  //var url = 'http://demo.ozoo.in';
  //var url = 'https://okzion.com';

  Future<http.Response> fetchBlocks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cookies = prefs.getString('cookies') != null ? json.decode(prefs.getString('cookies')) : {};
    headers['content-type'] =
    'application/x-www-form-urlencoded; charset=utf-8';
    headers['cookie'] = generateCookieHeader();
    final response = await http.post(
      Uri.parse(config.url + '/wp-admin/admin-ajax.php?action=mstore_flutter-keys'),
      headers: headers,
      body: {'lang': lan, 'flutter_app': '1'},
    );
    if (response.statusCode == 200) {
      prefs.setString('blocks', response.body);
      return response;
    } else {
      throw Exception('Failed to load Blocks');
    }
  }

  Future<List<Product>>fetchProductList(filter) async {
    filter['lang'] = lan;
    filter['flutter_app'] = '1';
    headers['content-type'] =
    'application/x-www-form-urlencoded; charset=utf-8';
    final response = await http.post(
      Uri.parse(config.url + '/wp-admin/admin-ajax.php?action=mstore_flutter-products'),
      headers: headers,
      body: filter,
    );
    if (response.statusCode == 200) {
      return productModelFromJson(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<Product>> fetchRecentProducts(data) async {
    data['lang'] = lan;
    data['flutter_app'] = '1';
    final response = await http.post(
      Uri.parse(config.url + '/wp-admin/admin-ajax.php?action=mstore_flutter-products'),
      headers: headers,
      body: data,
    );
    if (response.statusCode == 200) {
      return productModelFromJson(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<dynamic> fetchProducts(data) async {
    data['lang'] = lan;
    data['flutter_app'] = '1';
    headers['content-type'] =
    'application/x-www-form-urlencoded; charset=utf-8';
    final response = await http.post(
      Uri.parse(config.url + '/wp-admin/admin-ajax.php?action=mstore_flutter-products'),
      headers: headers,
      body: data,
    );
    return response;
  }

  Future<dynamic> get(String endPoint) async {
    headers['content-type'] =
    'application/x-www-form-urlencoded; charset=utf-8';
    final response = await http.get(
      Uri.parse(config.url + endPoint + '&lang=' + lan + '&flutter_app=' + '1'),
      headers: headers,
    );
    _updateCookie(response);
    return response;
  }

  Future<dynamic> postWithCookies(String endPoint, Map data) async {
    data['lang'] = lan;
    data['flutter_app'] = '1';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cookies = prefs.getString('cookies') != null ? json.decode(prefs.getString('cookies')) : {};
    headers['cookie'] = generateCookieHeader();
    headers['content-type'] =
    'application/x-www-form-urlencoded; charset=utf-8';
    final response = await http.post(
      Uri.parse(config.url + endPoint),
      headers: headers,
      body: data,
    );
    _updateCookie(response);
    return response;
  }

  Future<dynamic> post(String endPoint, Map data) async {
    data['lang'] = lan;
    data['flutter_app'] = '1';
    headers['content-type'] =
    'application/x-www-form-urlencoded; charset=utf-8';
    print(config.url + endPoint);
    final response = await http.post(
      Uri.parse(config.url + endPoint),
      headers: headers,
      body: data,
    );
    _updateCookie(response);
    return response;
  }

  Future<dynamic> adminAjaxWithoutLanCode(String endPoint, Map data) async {
    data['lang'] = lan;
    data['flutter_app'] = '1';
    headers['content-type'] =
    'application/x-www-form-urlencoded; charset=utf-8';
    final response = await http.post(
      Uri.parse(config.url + endPoint),
      headers: headers,
      body: data,
    );
    _updateCookie(response);
    return response;
  }

  void _updateCookie(http.Response response) async {
    String allSetCookie = response.headers['set-cookie'];
    if (allSetCookie != null) {
      var setCookies = allSetCookie.split(',');
      for (var setCookie in setCookies) {
        var cookies = setCookie.split(';');
        for (var cookie in cookies) {
          _setCookie(cookie);
        }
      }
      headers['cookie'] = generateCookieHeader();
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cookies', json.encode(cookies));
  }

  void _setCookie(String rawCookie) {
    if (rawCookie.length > 0) {
      var keyValue = rawCookie.split('=');
      if (keyValue.length == 2) {
        var key = keyValue[0].trim();
        var value = keyValue[1];
        if (key == 'path') return;
        cookies[key] = value;
      }
    }
  }

  String generateCookieHeader() {
    String cookie = "";
    for (var key in cookies.keys) {
      if (cookie.length > 0) cookie += "; ";
      cookie += key + "=" + cookies[key];
    }
    return cookie;
  }

  String generateWebViewCookieHeader() {
    String cookie = "";
    for (var key in cookies.keys) {
      if( key.contains('woocommerce') ||
          key.contains('wordpress')
      ) {
        if (cookie.length > 0) cookie += "; ";
        cookie += key + "=" + cookies[key];
      }
    }
    return cookie;
  }

  List<Cookie> generateCookies() {
    for (var key in cookies.keys) {
      Cookie ck = new Cookie(key, cookies[key]);
      cookieList.add(ck);
    }
    return cookieList;
  }

  Future<dynamic> getPaymentUrl(String endPoint) async {
    headers['cookie'] = generateCookieHeader();
    headers['content-type'] =
    'application/x-www-form-urlencoded; charset=utf-8';
    final response = await http.post(
      Uri.parse(endPoint),
      headers: headers,
    );
    _updateCookie(response);
    return response;
  }

  Future<dynamic> posAjax(String url, Map data) async {
    headers['cookie'] = generateCookieHeader();
    headers['content-type'] =
    'application/x-www-form-urlencoded; charset=utf-8';
    final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: data
    );
    _updateCookie(response);
    return response;
  }

  processCredimaxPayment(redirect) async {
    headers['content-type'] =
    'application/x-www-form-urlencoded; charset=UTF-8';
    headers['Accept'] =
    'application/json, text/javascript, */*; q=0.01';
    final response = await http.post(
      Uri.parse('https://credimax.gateway.mastercard.com/api/page/version/49/pay'),
      headers: headers,
      body: redirect,
    );
    _updateCookie(response);
    return response;
  }
}
