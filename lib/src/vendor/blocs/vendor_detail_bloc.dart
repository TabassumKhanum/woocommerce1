import 'dart:convert';
import './../models/vendor_reviews_model.dart';

import '../../models/product_model.dart';
import './../models/vendor_details_model.dart';
import '../../models/checkout/checkout_form_model.dart';
import '../../models/orders_model.dart';
import '../models/product_variation_model.dart';
import '../models/vendor_product_model.dart';
import '../../resources/wc_api.dart';
import '../../resources/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class VendorDetailBloc {

  Map<String, List<Product>> products;
  VendorDetailsModel vendorDetails;


  var page = new Map<String, int>();
  var filter = new Map<String, dynamic>();

  var formData = new Map<String, String>();

  VendorDetailBloc() : products = Map() {}

  final apiProvider = ApiProvider();
  final _productsFetcher = BehaviorSubject<List<Product>>();
  final _vendorDetailFetcher = BehaviorSubject<VendorDetailsModel>();
 final _reviewFetcher = BehaviorSubject <List<VendorReviews>> ();

  Observable<List<Product>> get allProducts => _productsFetcher.stream;
  Observable<VendorDetailsModel> get allVendorDetails => _vendorDetailFetcher.stream;
 Observable<List<VendorReviews>> get allReviews => _reviewFetcher.stream;

  Future<bool> fetchHomeProducts() async {
    if(products.containsKey(filter['vendor'])) {
      _productsFetcher.sink.add(products[filter['vendor']]);
    } else {
      _productsFetcher.sink.add([]);
      products[filter['vendor']] = [];
      page[filter['vendor']] = 1;
      filter['page'] = page[filter['vendor']].toString();
      List<Product> newProducts = await apiProvider.fetchProductList(filter);
      products[filter['vendor']].addAll(newProducts);
      _productsFetcher.sink.add(products[filter['vendor']]);
      if(newProducts.length < 10) {
        return false;
      } else return true;
    }
    return true;
  }

  void getDetails() async {
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-vendor_details', filter);
    if (response.statusCode == 200) {
      VendorDetailsModel vendorDetails = vendorDetailsModelFromJson(response.body);
      print(vendorDetails.store.phone);
   _vendorDetailFetcher.sink.add(vendorDetails);
    } else {
      throw Exception('Failed to load details');
    }
  }

  void getReviews() async {
    print(filter);
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-vendor_reviews', filter);
    if (response.statusCode == 200) {
    List<VendorReviews> reviews = vendorReviewsFromJson(response.body);
      print(response.body);
      _reviewFetcher.sink.add(reviews);
    } else {
      throw Exception('Failed to load reviews');
    }
  }


  submitLocation(loginData) async {
    print(loginData);
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-contact_vendor', loginData);
  }



  Future<bool> loadMore() async {
    page[filter['vendor']] = page[filter['vendor']] + 1;
    filter['page'] = page[filter['vendor']].toString();
    List<Product> moreProducts = await apiProvider.fetchProductList(filter);
    if(moreProducts.length != 0) {
      products[filter['vendor']].addAll(moreProducts);
      _productsFetcher.sink.add(products[filter['vendor']]);
      return true;
    } else return false;
  }

  dispose() {
    _productsFetcher.close();
    _vendorDetailFetcher.close();
  }


}

