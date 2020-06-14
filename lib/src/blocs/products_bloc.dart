import 'dart:convert';
import 'package:flutter/material.dart';

import './../models/attributes_model.dart';
import './../resources/api_provider.dart';

import 'package:rxdart/rxdart.dart';
import '../models/product_model.dart';

class ProductsBloc {

  Map<String, List<Product>> products;
  var page = new Map<String, int>();

  var filter = new Map<String, dynamic>();
  var selectedRange = RangeValues(0, 10000);

  final apiProvider = ApiProvider();
  final _productsFetcher = PublishSubject<List<Product>>();
  final _attributesFetcher = BehaviorSubject<List<AttributesModel>>();
  final _hasMoreItemsFetcher = BehaviorSubject<bool>();
  final _isLoadingProductsFetcher = BehaviorSubject<bool>();

  ProductsBloc() : products = Map() {

  }

  String search="";

  Observable<List<Product>> get allProducts => _productsFetcher.stream;
  Observable<List<AttributesModel>> get allAttributes => _attributesFetcher.stream;
  Observable<bool> get hasMoreItems => _hasMoreItemsFetcher.stream;
  Observable<bool> get isLoadingProducts => _isLoadingProductsFetcher.stream;

  List<AttributesModel> attributes;

  fetchAllProducts([String query]) async {
    _hasMoreItemsFetcher.sink.add(true);
    if(products.containsKey(filter['id'])) {
      _productsFetcher.sink.add(products[filter['id']]);
    } else {
      _productsFetcher.sink.add([]);
      products[filter['id']] = [];
      page[filter['id']] = 1;
      filter['page'] = page[filter['id']].toString();
      _isLoadingProductsFetcher.sink.add(true);
      print(filter);
      List<Product> newProducts = await apiProvider.fetchProductList(filter);
      products[filter['id']].addAll(newProducts);
      _productsFetcher.sink.add(products[filter['id']]);
      _isLoadingProductsFetcher.sink.add(false);
      if(newProducts.length < 10) {
        _hasMoreItemsFetcher.sink.add(false);
      }
    }
  }

  loadMore() async {
    page[filter['id']] = page[filter['id']] + 1;
    filter['page'] = page[filter['id']].toString();
    List<Product> moreProducts = await apiProvider.fetchProductList(filter);
    products[filter['id']].addAll(moreProducts);
    _productsFetcher.sink.add(products[filter['id']]);
    if(moreProducts.length < 10){
      _hasMoreItemsFetcher.sink.add(false);
    }
  }

  dispose() {
    _productsFetcher.close();
    _attributesFetcher.close();
    _hasMoreItemsFetcher.close();
    _isLoadingProductsFetcher.close();
  }

  Future fetchProductsAttributes() async {
    final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=mstore_flutter-product-attributes', {'category': filter['id'].toString()});
    print(response.body);
    if (response.statusCode == 200) {
      attributes = filterModelFromJson(response.body);
      _attributesFetcher.sink.add(attributes);
    } else {
      throw Exception('Failed to load attributes');
    }
  }

  void clearFilter() {
    for(var i = 0; i < attributes.length; i++) {
      for(var j = 0; j < attributes[i].terms.length; j++) {
        attributes[i].terms[j].selected = false;
      }
    }
    _attributesFetcher.sink.add(attributes);
    fetchAllProducts();
  }

  void applyFilter(double minPrice, double maxPrice) {
    products[filter['id']].clear();
    filter = new Map<String, dynamic>();
    filter['min_price'] = minPrice.toString();
    filter['max_price'] = maxPrice.toString();
    for(var i = 0; i < attributes.length; i++) {
      for(var j = 0; j < attributes[i].terms.length; j++) {
        if(attributes[i].terms[j].selected) {
          filter['attribute_term' + j.toString()] = attributes[i].terms[j].termId.toString();
          filter['attributes' + j.toString()] = attributes[i].terms[j].taxonomy;
        }
      }
    }
    fetchAllProducts();
  }
}