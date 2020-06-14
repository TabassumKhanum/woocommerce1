import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../../blocs/search_bloc.dart';
import '../../models/product_model.dart';
import '../products/product_grid/product_item4.dart';

class SearchProducts extends SearchDelegate<List<Product>> {
  final Function onProductClick;
  final SearchBloc searchBloc = SearchBloc();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        searchBloc.loadMoreSearchResults(query);
      }
    });
  }

  ScrollController _scrollController = new ScrollController();

  SearchProducts(this.onProductClick);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      query != '' ? IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          }) : Container()
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(FlutterIcons.chevron_left_fea),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty) {
      searchBloc.fetchSearchResults(query);
    }
    return StreamBuilder<bool>(
      stream: searchBloc.searchLoading,
      builder: (context, snapshotLoading) {
        return StreamBuilder<List<Product>>(
          stream: searchBloc.searchResults,
          builder: (context, AsyncSnapshot<List<Product>> snapshot) {
            if(snapshotLoading.hasData && snapshotLoading.data) {
              return Center(child: CircularProgressIndicator());
            }
            else if(snapshot.hasData && query.isNotEmpty) {
              if(snapshot.data.length == 0) {
                return Center(child: Text('NO RESULTS!'));
              }
              return buildProductList(snapshot, context);
            } else if(snapshot.hasData && snapshot.data.length == 0) {
              return Center(
                  child: Text('Please type something to search')
              );
            } else return Center(child: Container());
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      searchBloc.fetchSearchResults(query);
    }
    return StreamBuilder<bool>(
      stream: searchBloc.searchLoading,
      builder: (context, snapshotLoading) {
        return StreamBuilder<List<Product>>(
          stream: searchBloc.searchResults,
          builder: (context, AsyncSnapshot<List<Product>> snapshot) {
            if(snapshotLoading.hasData && snapshotLoading.data) {
              return Center(child: CircularProgressIndicator());
            }
            else if(snapshot.hasData && query.isNotEmpty) {
              if(snapshot.data.length == 0) {
                return Center(child: Text('NO RESULTS!'));
              }
              return buildProductList(snapshot, context);
            } else if(snapshot.hasData && snapshot.data.length == 0) {
              return Center(
                  child: Text('Please type something to search')
              );
            } else return Center(child: Container());
          },
        );
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: Theme.of(context).colorScheme.background,
      primaryIconTheme: Theme.of(context).appBarTheme.iconTheme,
      primaryColorBrightness: Theme.of(context).colorScheme.brightness,
      primaryTextTheme: Theme.of(context).primaryTextTheme.apply(bodyColor: Theme.of(context).colorScheme.onBackground),
    );
  }

  Widget buildProductList(snapshot, context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [ProductGrid(products: snapshot.data)],
    );
  }

}
