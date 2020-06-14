import './../../models/store_model.dart';
import 'package:scoped_model/scoped_model.dart';
import './../../../resources/api_provider.dart';

class StoreStateModel extends Model {

  static final StoreStateModel _storeStateModel = new StoreStateModel._internal();

  factory StoreStateModel() {
    return _storeStateModel;
  }

  StoreStateModel._internal();
  final apiProvider = ApiProvider();
  List<StoreModel> stores;
  int page = 1;

  var filter = new Map<String, String>();
  bool hasMoreItems;

  getAllStores() async {
    if (stores == null) {
      filter['page'] = page.toString();
      final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=mstore_flutter-vendors', filter);
      stores = storeModelFromJson(response.body);
      hasMoreItems = stores.length > 10;
      notifyListeners();
    }
  }

  loadMoreDelasProduct() async {
    page = page + 1;
    filter['page'] = page.toString();
    final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=mstore_flutter-vendors',filter);
    List<StoreModel> moreStore = storeModelFromJson(response.body);
    stores.addAll(moreStore);
    hasMoreItems = stores.length > 10;
    notifyListeners();
  }

  refresh() async {
    page = 1;
    filter['page'] = page.toString();
    final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=mstore_flutter-vendors', filter);
    stores = storeModelFromJson(response.body);
    hasMoreItems = stores.length > 10;
    notifyListeners();
    return true;
  }

}