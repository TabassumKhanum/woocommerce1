import './category_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart/cart_model.dart';
import '../resources/api_provider.dart';
import 'blocks_model.dart';
import 'cart/addToCartErrorModel.dart';
import 'customer_model.dart';
import 'package:html/parser.dart';

import 'errors/error.dart';
import 'errors/register_error.dart';
import 'product_model.dart';

class AppStateModel extends Model {

  static final AppStateModel _appStateModel = new AppStateModel._internal();

  factory AppStateModel() {
    return _appStateModel;
  }

  AppStateModel._internal();

  Category _selectedCategory;

  Category get selectedCategory => _selectedCategory;

  BlocksModel blocks;
  Locale _appLocale = Locale('en');
  final apiProvider = ApiProvider();
  CartModel shoppingCart = CartModel(cartContents: new List<CartContent>(), cartTotals: CartTotals());
  int count = 0;
  bool isCartLoading = false;
  bool loggedIn = false;
  List<int> wishListIds = [];
  double maxPrice = 1000;
  String selectedCurrency = 'USD';
  int page = 1;
  var filter = new Map<String, dynamic>();
  bool hasMoreRecentItem = true;

  Locale get appLocal => _appLocale ?? Locale("en");
  fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language_code') == null) {
      _appLocale = Locale('en');
    } else _appLocale = Locale(prefs.getString('language_code'));
    notifyListeners();
    return Null;
  }

  fetchAllBlocks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String blocksString = prefs.getString('blocks');
    String storedCurrency = prefs.getString('currency');
    if (storedCurrency != null &&
        storedCurrency.isNotEmpty &&
        storedCurrency != '0') {
      selectedCurrency = storedCurrency;
      await switchCurrency(storedCurrency);
    }
    if (blocksString != null &&
        blocksString.isNotEmpty &&
        blocksString != '0') {
      try {
        blocks = BlocksModel.fromJson(json.decode(blocksString));
        notifyListeners();
      } catch (e, s) {}
    }
    final response = await apiProvider.fetchBlocks();
    blocks = BlocksModel.fromJson(json.decode(response.body));
    user = blocks.user;
    if (user?.id != null && user.id > 0) {
      loggedIn = true;
    }
    //selectedCurrency = blocks.currency; // Uncomment once backend currency switcher is working with WPML
    notifyListeners();
    getCart();
  }


  loadMoreRecentProducts() async {
    page = page + 1;
    filter['page'] = page.toString();
    final response = await apiProvider.fetchProducts(filter);
    if (response.statusCode == 200) {
      List<Product> products = productModelFromJson(response.body);
      blocks.recentProducts.addAll(products);
      if (products.length == 0) {
        hasMoreRecentItem = false;
      }
      notifyListeners();
    } else {
      throw Exception('Failed to load products');
    }
  }

  void changeLanguage(Locale type) async {
    var prefs = await SharedPreferences.getInstance();
    if (_appLocale == type) {
      return;
    }
    if (type == Locale("ar")) {
      _appLocale = Locale("ar");
      await prefs.setString('language_code', 'ar');
      await prefs.setString('countryCode', '');
    } else {
      _appLocale = Locale("en");
      await prefs.setString('language_code', 'en');
      await prefs.setString('countryCode', 'US');
    }
    notifyListeners();
  }

  // WishList
  Future<void> updateWishList(int id) async {
    if(wishListIds.contains(id)) {
      wishListIds.remove(id);
      notifyListeners();
      apiProvider.post('/wp-admin/admin-ajax.php?action=mstore_flutter-remove_wishlist' , {'product_id': id.toString()});
    } else {
      wishListIds.add(id);
      notifyListeners();
      apiProvider.post('/wp-admin/admin-ajax.php?action=mstore_flutter-add_wishlist' , {'product_id': id.toString()});
    }
  }

  //Account
  Customer user = new Customer( email: '');

  Future<bool> login(data) async {
    final response = await apiProvider.postWithCookies(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-login', data);
    if (response.statusCode == 200) {
      user = Customer.fromJson(json.decode(response.body));
      if(user.id != null && user.id > 0) {
        loggedIn = true;
      }
      notifyListeners();
      return true;
    } else if (response.statusCode == 400) {
      WpErrors error = WpErrors.fromJson(json.decode(response.body));
      Fluttertoast.showToast(msg: _parseHtmlString(error.data[0].message));
      return false;
    } else {
      return false;
    }
  }

  Future<bool> googleLogin(data) async {
    final response = await apiProvider.postWithCookies(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-google_login', data);
    if (response.statusCode == 200) {
      print(response.body);
      user = Customer.fromJson(json.decode(response.body));
      if(user.id != null && user.id > 0) {
        loggedIn = true;
      }
      notifyListeners();
      return true;
    } else if (response.statusCode == 400) {
      WpErrors error = WpErrors.fromJson(json.decode(response.body));
      Fluttertoast.showToast(msg: _parseHtmlString(error.data[0].message));
      return false;
      throw Exception('Failed to login');
    } else {
      return false;
      throw Exception('Failed to login');
    }
  }

  Future<bool> phoneLogin(data) async {
    final response = await apiProvider.postWithCookies(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-phone_number_login', data);
    if (response.statusCode == 200) {
      user = Customer.fromJson(json.decode(response.body));
      if(user.id != null && user.id > 0) {
        loggedIn = true;
      }
      notifyListeners();
      return true;
    } else if (response.statusCode == 400) {
      WpErrors error = WpErrors.fromJson(json.decode(response.body));
      Fluttertoast.showToast(msg: _parseHtmlString(error.data[0].message));
      return false;
      throw Exception('Failed to login');
    } else {
      return false;
      throw Exception('Failed to login');
    }
  }

  Future<bool> facebooklogin(token) async {
    final response = await apiProvider.postWithCookies(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-facebook_login', {'access_token': token});
    print(response.body);
    if (response.statusCode == 200) {
      user = Customer.fromJson(json.decode(response.body));
      if(user.id != null && user.id > 0) {
        loggedIn = true;
      }
      notifyListeners();
      return true;
    } else if (response.statusCode == 400) {
      WpErrors error = WpErrors.fromJson(json.decode(response.body));
      Fluttertoast.showToast(msg: _parseHtmlString(error.data[0].message));
      return false;
      throw Exception('Failed to login');
    } else {
      return false;
      throw Exception('Failed to login');
    }
  }

  Future<bool> register(data) async {
    print(data);
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-create-user', data);
    if (response.statusCode == 200) {
      Customer user = Customer.fromJson(json.decode(response.body));
      if(user.id != null && user.id > 0) {
        loggedIn = true;
      }
      notifyListeners();
      return true;
    } else if (response.statusCode == 400) {
      RegisterError error = RegisterError.fromJson(json.decode(response.body));
      Fluttertoast.showToast(msg: _parseHtmlString(error.data[0].message));
      return false;
      throw Exception('Failed to register');
    } else {
      return false;
      throw Exception('Failed to register');
    }
  }

  Future logout() async {
    user = new Customer(id: 0);
    wishListIds = [];
    loggedIn = false;
    notifyListeners();
    final response = await apiProvider.get(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-logout');

  }

  //Shopping Cart
  Future<bool> addToCart(data) async {
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-add_to_cart', data);
    if (response.statusCode == 200) {
      shoppingCart = CartModel.fromJson(json.decode(response.body));
      updateCartCount();
      return true;
    } else {
      AddToCartErrorModel addToCartError = addToCartErrorModelFromJson(response.body);
      Fluttertoast.showToast(msg: addToCartError.data.notice);
    }
  }

  void getCart() async {
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-cart', Map());
    isCartLoading = false;
    notifyListeners();
    if (response.statusCode == 200) {
      shoppingCart = CartModel.fromJson(json.decode(response.body));
      updateCartCount();
    } else {
      throw Exception('Failed to load cart');
    }
  }

  void updateCartCount() {
    count = 0;
    if(shoppingCart.cartContents != null) {
      for (var i = 0; i < shoppingCart.cartContents.length; i++) {
        count = count + shoppingCart.cartContents[i].quantity;
      }
    }
    isCartLoading = false;
    notifyListeners();
  }

  Future<void> applyCoupon(String couponCode) async {
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-apply_coupon', {"coupon_code": couponCode});
    if (response.statusCode == 200) {
      getCart();
      Fluttertoast.showToast(msg: _parseHtmlString(response.body));
    } else {
      throw Exception('Failed to load cart');
    }
  }

  Future increaseQty(String key, int quantity) async {
    quantity = quantity + 1;
    var formData = new Map<String, String>();
    formData['cart[' + key + '][qty]'] = quantity.toString();
    formData['key'] = key;
    formData['quantity'] = quantity.toString();
    formData['_wpnonce'] = shoppingCart.cartNonce;
    final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=mstore_flutter-update-cart-item-qty', formData);
    if (response.statusCode == 200) {
      shoppingCart = CartModel.fromJson(json.decode(response.body));
      updateCartCount();
    } else {
      return false;
      //throw Exception('Failed to load cart');
    }
    return true;
  }

  Future decreaseQty(String key, int quantity) async {
    quantity = quantity - 1;
    var formData = new Map<String, String>();
    formData['cart[' + key + '][qty]'] = quantity.toString();
    formData['key'] = key;
    formData['quantity'] = quantity.toString();
    formData['_wpnonce'] = shoppingCart.cartNonce;
    final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=mstore_flutter-update-cart-item-qty', formData);
    if (response.statusCode == 200) {
      shoppingCart = CartModel.fromJson(json.decode(response.body));
      updateCartCount();
    } else {
      throw Exception('Failed to load cart');
    }
    return true;
  }

  // Removes an item from the cart.
  void removeCartItem(CartContent cartContent) {
    if (shoppingCart.cartContents.contains(cartContent)) {
      shoppingCart.cartContents.remove(cartContent);
      if(cartContent.key != null)
        removeItemFromCart(cartContent.key);
    }
    updateCartCount();
  }

  Future removeItemFromCart(String key) async {
    shoppingCart.cartContents.removeWhere((item) => item.key == key);
    notifyListeners();
    final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=mstore_flutter-remove_cart_item&item_key=' + key, Map());
    if (response.statusCode == 200) {
      shoppingCart = CartModel.fromJson(json.decode(response.body));
      updateCartCount();
    } else {
      throw Exception('Failed to load cart');
    }
    updateCartCount();
  }

  // Removes everything from the cart.
  void clearCart() {
    shoppingCart.cartContents.clear();
    notifyListeners();
  }

  Future<bool> switchCurrency(String s) async {
    final response = await apiProvider.post('/wp-admin/admin-ajax.php',
        {'action': 'wcml_switch_currency', 'currency': s, 'force_switch': '0'});
    return true;
  }

  getCustomerDetails() async {
    final response = await apiProvider.postWithCookies(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-customer', new Map());
    Customer customers = Customer.fromJson(json.decode(response.body));
    //TODO Set is Loggedin if logged in
  }

  getProducts() {

  }

  getProductById(int productId) {
    return shoppingCart.cartContents.firstWhere((p) => p.productId == productId);
  }

  void setCategory(Category newCategory) {
    _selectedCategory = newCategory;
    notifyListeners();
  }



  //Checkout


}

String _parseHtmlString(String htmlString) {
  var document = parse(htmlString);

  String parsedString = parse(document.body.text).documentElement.text;

  return parsedString;
}

