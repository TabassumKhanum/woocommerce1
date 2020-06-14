import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../models/app_state_model.dart';
import '../../models/category_model.dart';
import './../../ui/checkout/cart/cart.dart';
import '../../models/product_model.dart';
import '../../blocs/products_bloc.dart';
import './../../ui/products/product_detail/product_detail.dart';
import './../../ui/products/product_filter/filter_product.dart';
import 'package:html/parser.dart';
import './../../ui/products/product_grid/product_item.dart';

class ProductsWidget extends StatefulWidget {
  final ProductsBloc productsBloc;
  final Map<String, dynamic> filter;
  final String name;
  AppStateModel model = AppStateModel();

  ProductsWidget({Key key, this.filter, this.name, this.productsBloc})
      : super(key: key);

  @override
  _ProductsWidgetState createState() => _ProductsWidgetState();
}

class _ProductsWidgetState extends State<ProductsWidget>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController = new ScrollController();
  TabController _controller;
  Category selectedCategory;
  List<Category> subCategories;
  var theme = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17];

  @override
  void initState() {
    super.initState();
    //theme..shuffle();

    widget.productsBloc.filter = widget.filter;
    subCategories = widget.model.blocks.categories
        .where(
            (cat) => cat.parent.toString() == widget.productsBloc.filter['id'])
        .toList();
    _controller = TabController(vsync: this, length: subCategories.length);
    _controller.index = 0;
    if (subCategories.length != 0) {
      widget.productsBloc.filter['id'] =
          subCategories[_controller.index].id.toString();
    }
    widget.productsBloc.fetchAllProducts();
    widget.productsBloc.fetchProductsAttributes();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.productsBloc.loadMore();
      }
    });
    _controller.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    widget.productsBloc.filter['id'] =
        subCategories[_controller.index].id.toString();
    widget.productsBloc.fetchAllProducts();
    _scrollController.jumpTo(0.0);
    setState(() {
      selectedCategory = subCategories[_controller.index];
    });
  }

  _onSelectSubcategory(int id) {
    widget.productsBloc.filter['id'] = id.toString();
    widget.productsBloc.fetchAllProducts();
    _scrollController.jumpTo(0.0);
    setState(() {
      selectedCategory = subCategories[_controller.index];
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.productsBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.productsBloc.allProducts,
        builder: (context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length != 0) {
              return CustomScrollView(
                controller: _scrollController,
                slivers: buildLisOfBlocks(snapshot),
              );
            } else {
              return StreamBuilder<bool>(
                  stream: widget.productsBloc.isLoadingProducts,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data == true) {
                      return Center(child: CircularProgressIndicator());
                    } else
                      return Center(
                        child:
                        Text(widget.model.blocks.localeText.noMoreProducts),
                      );
                  });
            }
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  List<Widget> buildLisOfBlocks(AsyncSnapshot<List<Product>> snapshot) {
    List<Widget> list = new List<Widget>();

    /// UnComment this if you use rounded corner category list in body.
    //list.add(buildSubcategories());
    if (snapshot.data != null) {
      list.add(ProductGrid(products: snapshot.data));

      list.add(SliverPadding(
          padding: EdgeInsets.all(0.0),
          sliver: SliverList(
              delegate: SliverChildListDelegate([
            Container(
                height: 60,
                child: StreamBuilder(
                    stream: widget.productsBloc.hasMoreItems,
                    builder: (context, AsyncSnapshot<bool> snapshot) {
                      return snapshot.hasData && snapshot.data == false
                          ? Center(child: Text('No more products!', style: Theme.of(context).textTheme.caption.copyWith(
                        color: Theme.of(context).primaryTextTheme.caption.color
                      )))
                          : Center(child: CircularProgressIndicator());
                    }
                    //child: Center(child: CircularProgressIndicator())
                    ))
          ]))));
    }

    return list;
  }

  Widget buildVerticalGridBlock(AsyncSnapshot<List<Product>> snapshot) {
    return SliverPadding(
        padding: EdgeInsets.all(0.0),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  ProductItem(
                      product: snapshot.data[index],
                      onProductClick: onProductClick),
                  Divider(height: 0.0),
                ],
              );
            },
            childCount: snapshot.data.length,
          ),
        ));
  }

  Widget buildSubcategories() {
    return subCategories.length != 0
        ? SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
              height: 140,
              width: 120,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: subCategories.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                      height: 100,
                      width: 100,
                      child: Column(
                        children: <Widget>[
                          Card(
                            shape: StadiumBorder(),
                            margin: EdgeInsets.all(5.0),
                            clipBehavior: Clip.antiAlias,
                            elevation: 0.5,
                            child: InkWell(
                              onTap: () {
                                var filter = new Map<String, dynamic>();
                                filter['id'] =
                                    subCategories[index].id.toString();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductsWidget(
                                            filter: filter,
                                            name: subCategories[index].name)));
                              },
                              child: Column(
                                children: <Widget>[
                                  AspectRatio(
                                    aspectRatio: 18 / 18,
                                    child: subCategories[index].image != null
                                        ? Image.network(
                                            subCategories[index].image,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          InkWell(
                            onTap: () {
                              var filter = new Map<String, dynamic>();
                              filter['id'] = subCategories[index].id.toString();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductsWidget(
                                          filter: filter,
                                          name: subCategories[index].name)));
                            },
                            child: Text(
                              subCategories[index].name,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          )
        : SliverToBoxAdapter();
  }

  onProductClick(data) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ProductDetail(product: data);
    }));
  }
}

String _parseHtmlString(String htmlString) {
  var document = parse(htmlString);

  String parsedString = parse(document.body.text).documentElement.text;

  return parsedString;
}


List<ThemeData> themeData = [
  ThemeData(
      primarySwatch: Colors.blue,
      backgroundColor: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      indicatorColor: Colors.white,
      accentColor: Colors.black,
      appBarTheme: AppBarTheme(
          elevation: 0.0
      )
  ),
  ThemeData(
      primarySwatch: Colors.red,
      backgroundColor: Colors.red,
      scaffoldBackgroundColor: Colors.white,
      accentColor: Colors.white,
      appBarTheme: AppBarTheme(
          elevation: 0.0
      )
  ),
  ThemeData(
      primarySwatch: Colors.pink,
      backgroundColor: Colors.pink,
      scaffoldBackgroundColor: Colors.pink,
      accentColor: Colors.white,
      appBarTheme: AppBarTheme(
          elevation: 0.0
      )
  ),
  ThemeData(
      primarySwatch: Colors.purple,
      backgroundColor: Colors.purple,
      scaffoldBackgroundColor: Colors.purple,
      accentColor: Colors.white,
      appBarTheme: AppBarTheme(
          elevation: 0.0
      )
  ),
  ThemeData(
      primarySwatch: Colors.amber,
      backgroundColor: Colors.amber,
      scaffoldBackgroundColor: Colors.amber,
      accentColor: Colors.black,
      appBarTheme: AppBarTheme(
          elevation: 0.0
      )
  ),
  ThemeData(
      primarySwatch: Colors.lime,
      backgroundColor: Colors.lime,
      scaffoldBackgroundColor: Colors.lime,
      accentColor: Colors.black,
      appBarTheme: AppBarTheme(
          elevation: 0.0
      )
  ),
  ThemeData(
      primarySwatch: Colors.yellow,
      backgroundColor: Colors.yellow,
      scaffoldBackgroundColor: Colors.yellow,
      accentColor: Colors.black,
      appBarTheme: AppBarTheme(
          elevation: 0.0
      )
  ),
  ThemeData(
      primarySwatch: Colors.lightBlue,
      backgroundColor: Colors.lightBlue,
      scaffoldBackgroundColor: Colors.lightBlue,
      accentColor: Colors.black,
      appBarTheme: AppBarTheme(
          elevation: 0.0
      )
  ),
  ThemeData(
      primarySwatch: Colors.green,
      backgroundColor: Colors.green,
      scaffoldBackgroundColor: Colors.green,
      accentColor: Colors.white,
      appBarTheme: AppBarTheme(
          elevation: 0.0
      ),
  ),
  ThemeData(
    primarySwatch: Colors.lightGreen,
    backgroundColor: Colors.lightGreen,
    scaffoldBackgroundColor: Colors.lightGreen,
    accentColor: Colors.black,
    appBarTheme: AppBarTheme(
        elevation: 0.0
    ),
  ),
  ThemeData(
    primarySwatch: Colors.orange,
    backgroundColor: Colors.orange,
    scaffoldBackgroundColor: Colors.orange,
    accentColor: Colors.black,
    appBarTheme: AppBarTheme(
        elevation: 0.0
    ),
  ),
  ThemeData(
    primarySwatch: Colors.deepOrange,
    backgroundColor: Colors.deepOrange,
    scaffoldBackgroundColor: Colors.deepOrange,
    accentColor: Colors.white,
    appBarTheme: AppBarTheme(
        elevation: 0.0
    ),
  ),
  ThemeData(
    primarySwatch: Colors.brown,
    backgroundColor: Colors.brown,
    scaffoldBackgroundColor: Colors.brown,
    accentColor: Colors.white,
    appBarTheme: AppBarTheme(
        elevation: 0.0
    ),
  ),
  ThemeData(
    primarySwatch: Colors.blueGrey,
    backgroundColor: Colors.blueGrey,
    scaffoldBackgroundColor: Colors.blueGrey,
    accentColor: Colors.white,
    appBarTheme: AppBarTheme(
        elevation: 0.0
    ),
  ),
  ThemeData(
      primarySwatch: Colors.deepPurple,
      backgroundColor: Colors.deepPurple,
      scaffoldBackgroundColor: Colors.deepPurple,
      accentColor: Colors.white,
      appBarTheme: AppBarTheme(
          elevation: 0.0
      )
  ),
  ThemeData(
      primarySwatch: Colors.indigo,
      backgroundColor: Colors.indigo,
      scaffoldBackgroundColor: Colors.indigo,
      accentColor: Colors.white,
      appBarTheme: AppBarTheme(
          elevation: 0.0
      )
  ),
  ThemeData(
      primarySwatch: Colors.cyan,
      backgroundColor: Colors.cyan,
      scaffoldBackgroundColor: Colors.cyan,
      accentColor: Colors.black,
      appBarTheme: AppBarTheme(
          elevation: 0.0
      )
  ),
  ThemeData(
      primarySwatch: Colors.teal,
      backgroundColor: Colors.teal,
      scaffoldBackgroundColor: Colors.teal,
      accentColor: Colors.white,
      appBarTheme: AppBarTheme(
          elevation: 0.0
      )
  ),
];
