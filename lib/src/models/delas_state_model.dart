import 'package:scoped_model/scoped_model.dart';
import '../../src/resources/api_provider.dart';
import 'product_model.dart';

class DealsStateModel extends Model {

  static final DealsStateModel _delasStateModel = new DealsStateModel._internal();

  factory DealsStateModel() {
    return _delasStateModel;
  }

  DealsStateModel._internal();

  final apiProvider = ApiProvider();
  List<Product> dealsProducts;
  var dealsFilter = new Map<String, dynamic>();
  int dealsPage = 0;
  bool hasMoreItems = true;

  fetchDealProducts() async {
    if (dealsProducts == null) {
      dealsPage = 1;
      dealsFilter['on_sale'] = '1';
      dealsFilter['random'] = 'rand';
      dealsFilter['page'] = dealsPage.toString();
      dealsProducts = await apiProvider.fetchProductList(dealsFilter);
      if (dealsProducts.length < 10) {
        hasMoreItems = false;
      }
      notifyListeners();
    }
  }

  loadMoreDelasProduct() async {
    dealsPage = dealsPage + 1;
    dealsFilter['page'] = dealsPage.toString();
    List<Product> moreProducts = await apiProvider.fetchProductList(dealsFilter);
    dealsProducts.addAll(moreProducts);
    if (dealsProducts.length < 10) {
      hasMoreItems = false;
    }
  }

  refresh() async {
    dealsPage = 1;
    dealsFilter['on_sale'] = '1';
    dealsFilter['random'] = 'rand';
    dealsFilter['page'] = dealsPage.toString();
    dealsProducts = await apiProvider.fetchProductList(dealsFilter);
    if (dealsProducts.length < 10) {
      hasMoreItems = false;
    }
    notifyListeners();
    return true;
  }

}