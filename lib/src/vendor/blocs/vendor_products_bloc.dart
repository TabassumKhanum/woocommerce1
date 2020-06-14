import 'dart:convert';
import '../../models/attributes_model.dart';
import '../../resources/api_provider.dart';

import 'package:rxdart/rxdart.dart';
import '../../models/product_model.dart';

class VendorProductsBloc {

  Map<String, List<Product>> products;
  var page = new Map<String, int>();

  var filter = new Map<String, dynamic>();
  var selectedRange;

  final apiProvider = ApiProvider();
  final _productsFetcher = BehaviorSubject<List<Product>>();
  final _attributesFetcher = BehaviorSubject<List<AttributesModel>>();
  //final _hasMoreItemsFetcher = BehaviorSubject<bool>();
  //final _isLoadingProductsFetcher = BehaviorSubject<bool>();

  VendorProductsBloc() : products = Map() {}

  String search="";

  Observable<List<Product>> get allProducts => _productsFetcher.stream;
  Observable<List<AttributesModel>> get allAttributes => _attributesFetcher.stream;
  //Observable<bool> get hasMoreItems => _hasMoreItemsFetcher.stream;
  //Observable<bool> get isLoadingProducts => _isLoadingProductsFetcher.stream;

  List<AttributesModel> attributes;

  fetchAllProducts([String query]) async {
    //_hasMoreItemsFetcher.sink.add(true);
    if(products.containsKey(filter['vendor'])) {
      _productsFetcher.sink.add(products[filter['vendor']]);
    } else {
      _productsFetcher.sink.add([]);
      products[filter['vendor']] = [];
      page[filter['vendor']] = 1;
      filter['page'] = page[filter['vendor']].toString();
      //_isLoadingProductsFetcher.sink.add(true);
      List<Product> newProducts = await apiProvider.fetchProductList(filter);
      products[filter['vendor']].addAll(newProducts);
      _productsFetcher.sink.add(products[filter['vendor']]);
      //_isLoadingProductsFetcher.sink.add(false);
    }
  }

  loadMore() async {
    page[filter['vendor']] = page[filter['vendor']] + 1;
    filter['page'] = page[filter['vendor']].toString();
    List<Product> moreProducts = await apiProvider.fetchProductList(filter);
    products[filter['vendor']].addAll(moreProducts);
    _productsFetcher.sink.add(products[filter['vendor']]);
  }

  dispose() {
    _productsFetcher.close();
    _attributesFetcher.close();
    //_hasMoreItemsFetcher.close();
    //_isLoadingProductsFetcher.close();
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