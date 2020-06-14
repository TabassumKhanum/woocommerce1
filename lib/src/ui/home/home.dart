import './../../shrine/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../data/gallery_options.dart';
//import '../../../l10n/gallery_localizations.dart';
import '../../models/app_state_model.dart';
import '../products/product_grid/product_item4.dart';
import '../../models/product_model.dart';
import '../blocks/banner_slider.dart';
import '../blocks/banner_slider2.dart';
import '../blocks/banner_slider3.dart';
import '../blocks/banner_grid_list.dart';
import '../blocks/banner_scroll_list.dart';
import '../blocks/banner_slider1.dart';
import '../blocks/category_grid_list.dart';
import '../blocks/category_scroll_list.dart';
import '../blocks/product_grid_list.dart';
import '../blocks/product_scroll_list.dart';
import '../../models/category_model.dart';
import '../products/product_detail/product_detail.dart';
import '../products/products.dart';
import '../../models/blocks_model.dart' hide Image, Key, Theme;
import 'package:flutter/rendering.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController _scrollController = new ScrollController();
  AppStateModel appStateModel = AppStateModel();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        appStateModel.loadMoreRecentProducts();
      }
    });
  }
//ScopedModel.of<AppStateModel>(context).selectedCategory.name == 'home' ? Home() : ProductPage()
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
        return RefreshIndicator(
          onRefresh: () async {
            await model.fetchAllBlocks();
            return;
          },
          child: ScopedModelDescendant<AppStateModel>(
            builder: (context, child, model) {
              return model.blocks != null
                  ? Container(
                color: Theme.of(context).brightness == Brightness.light ? Colors.grey[50] : Colors.black,
                    child: CustomScrollView(
                controller: _scrollController,
                slivers: buildLisOfBlocks(model.blocks),
              ),
                  )
                  : Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        );
      }
    );
  }

  List<Widget> buildLisOfBlocks(BlocksModel snapshot) {
    List<Widget> list = new List<Widget>();

    for (var i = 0; i < snapshot.blocks.length; i++) {
      if (snapshot.blocks[i].blockType == 'banner_block') {
        if (snapshot.blocks[i].style == 'grid') {
          list.add(buildGridHeader(snapshot, i));
          list.add(BannerGridList(
              block: snapshot.blocks[i], onBannerClick: onBannerClick));
        }

        if (snapshot.blocks[i].style == 'scroll') {
          list.add(BannerScrollList(
              block: snapshot.blocks[i], onBannerClick: onBannerClick));
        }

        if (snapshot.blocks[i].style == 'slider') {
          list.add(BannerSlider(
              block: snapshot.blocks[i], onBannerClick: onBannerClick));
        }

        if (snapshot.blocks[i].style == 'slider1') {
          list.add(BannerSlider1(
              block: snapshot.blocks[i], onBannerClick: onBannerClick));
        }

        if (snapshot.blocks[i].style == 'slider2') {
          list.add(BannerSlider2(
              block: snapshot.blocks[i], onBannerClick: onBannerClick));
        }

        if (snapshot.blocks[i].style == 'slider3') {
          list.add(BannerSlider3(
              block: snapshot.blocks[i], onBannerClick: onBannerClick));
        }
      }

      if (snapshot.blocks[i].blockType == 'category_block' &&
          snapshot.blocks[i].style == 'scroll') {
        if (snapshot.blocks[i].borderRadius == 50) {
          list.add(CategoryScrollStadiumList(
              block: snapshot.blocks[i],
              categories: snapshot.categories,
              onCategoryClick: onCategoryClick));
        } else {
          list.add(CategoryScrollList(
              block: snapshot.blocks[i],
              categories: snapshot.categories,
              onCategoryClick: onCategoryClick));
        }
      }

      if (snapshot.blocks[i].blockType == 'category_block' &&
          snapshot.blocks[i].style == 'grid') {
        list.add(buildGridHeader(snapshot, i));
        if (snapshot.blocks[i].borderRadius == 50) {
          list.add(CategoryStadiumGridList(
              block: snapshot.blocks[i],
              categories: snapshot.categories,
              onCategoryClick: onCategoryClick));
        } else {
          list.add(CategoryGridList(
              block: snapshot.blocks[i],
              categories: snapshot.categories,
              onCategoryClick: onCategoryClick));
        }
      }

      if (snapshot.blocks[i].blockType == 'product_block' &&
          snapshot.blocks[i].style == 'scroll') {
        list.add(ProductScrollList(
            block: snapshot.blocks[i], onProductClick: onProductClick));
      }

      if (snapshot.blocks[i].blockType == 'product_block' &&
          snapshot.blocks[i].style == 'grid') {
        list.add(buildGridHeader(snapshot, i));
        list.add(ProductGridList(
            block: snapshot.blocks[i], onProductClick: onProductClick));
      }
    }

    if (snapshot.recentProducts != null) {
      list.add(buildRecentProductGridList(snapshot));

      list.add(SliverPadding(
          padding: EdgeInsets.all(0.0),
          sliver: SliverList(
              delegate: SliverChildListDelegate([
            Container(
                height: 60,
                child: ScopedModelDescendant<AppStateModel>(
                    builder: (context, child, model) {
                  if (model.blocks?.recentProducts != null && model.hasMoreRecentItem == false) {
                    return Center(
                      child: Text(
                        model.blocks.localeText.noMoreProducts,
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }))
          ]))));
    }

    return list;
  }

  double _headerAlign(String align) {
    switch (align) {
      case 'top_left':
        return -1;
      case 'top_right':
        return 1;
      case 'top_center':
        return 0;
      case 'floating':
        return 2;
      case 'none':
        return null;
      default:
        return -1;
    }
  }

  Widget buildRecentProductGridList(BlocksModel snapshot) {
    return ProductGrid(
        products: snapshot.recentProducts);
  }

  Widget buildListHeader(AsyncSnapshot<BlocksModel> snapshot, int childIndex) {
    Color bgColor = HexColor(snapshot.data.blocks[childIndex].bgColor);
    double textAlign =
        _headerAlign(snapshot.data.blocks[childIndex].headerAlign);
    return textAlign != null
        ? SliverToBoxAdapter(child: ScopedModelDescendant<AppStateModel>(
            builder: (context, child, model) {
            return Container(
                padding: EdgeInsets.fromLTRB(
                    snapshot.data.blocks[childIndex].paddingBetween,
                    double.parse(
                        snapshot.data.blocks[childIndex].paddingTop.toString()),
                    snapshot.data.blocks[childIndex].paddingBetween,
                    16.0),
                color: GalleryOptions.of(context).themeMode == ThemeMode.light
                    ? bgColor
                    : Theme.of(context).canvasColor,
                alignment: Alignment(textAlign, 0),
                child: Text(
                  snapshot.data.blocks[childIndex].title,
                  textAlign: TextAlign.start,
                  style: GalleryOptions.of(context).themeMode == ThemeMode.light
                      ? Theme.of(context).textTheme.title.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            color: HexColor(
                                snapshot.data.blocks[childIndex].titleColor),
                          )
                      : Theme.of(context).textTheme.title,
                ));
          }))
        : SliverToBoxAdapter(
            child: ScopedModelDescendant<AppStateModel>(
                builder: (context, child, model) {
              return Container(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.fromLTRB(
                    snapshot.data.blocks[childIndex].paddingBetween,
                    double.parse(
                        snapshot.data.blocks[childIndex].paddingTop.toString()),
                    snapshot.data.blocks[childIndex].paddingBetween,
                    0.0),
                color: GalleryOptions.of(context).themeMode == ThemeMode.light
                    ? bgColor
                    : Theme.of(context).canvasColor,
              );
            }),
          );
  }

  Widget buildGridHeader(BlocksModel snapshot, int childIndex) {
    double textAlign = _headerAlign(snapshot.blocks[childIndex].headerAlign);
    TextStyle subhead = Theme.of(context).brightness != Brightness.dark
        ? Theme.of(context).textTheme.subhead.copyWith(
            fontWeight: FontWeight.w600,
            color: HexColor(snapshot.blocks[childIndex].titleColor))
        : Theme.of(context)
            .textTheme
            .subhead
            .copyWith(fontWeight: FontWeight.w600);
    return textAlign != null
        ? SliverToBoxAdapter(
            child: Container(
                padding: EdgeInsets.fromLTRB(
                    double.parse(snapshot.blocks[childIndex].paddingLeft
                            .toString()) +
                        4,
                    double.parse(
                        snapshot.blocks[childIndex].paddingTop.toString()),
                    double.parse(snapshot.blocks[childIndex].paddingRight
                            .toString()) +
                        4,
                    16.0),
                alignment: Alignment(textAlign, 0),
                child: Text(
                  snapshot.blocks[childIndex].title,
                  textAlign: TextAlign.start,
                  style: subhead,
                )))
        : SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  snapshot.blocks[childIndex].paddingBetween,
                  double.parse(
                      snapshot.blocks[childIndex].paddingTop.toString()),
                  snapshot.blocks[childIndex].paddingBetween,
                  0.0),
            ),
          );
  }

  onProductClick(product) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ProductDetail(
        product: product
      );
    }));
  }

  onBannerClick(Child data) {
    //Naviaget yo product or product list depend on type
    if (data.url.isNotEmpty) {
      if (data.description == 'category') {
        var filter = new Map<String, dynamic>();
        filter['id'] = data.url;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductsWidget(
                    filter: filter,
                    name: data.title)));
      }
      ;
      if (data.description == 'product') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetail(
                    product: Product(
                      id: int.parse(data.url),
                      name: data.title,
                    ),
                    )));
      }
      ;
    }
  }

  onCategoryClick(Category category, List<Category> categories) {
    var filter = new Map<String, dynamic>();
    filter['id'] = category.id.toString();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductsWidget(
                filter: filter,
                name: category.name)));
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
