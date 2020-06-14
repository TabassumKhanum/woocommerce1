import '../../../../models/product_model.dart';
import '../../../../ui/blocks/banner_grid_list.dart';
import '../../../../ui/blocks/banner_scroll_list.dart';
import '../../../../ui/blocks/banner_slider.dart';
import '../../../../ui/blocks/banner_slider1.dart';
import '../../../../ui/blocks/banner_slider2.dart';
import '../../../../ui/blocks/banner_slider3.dart';
import '../../../../ui/blocks/product_grid_list.dart';
import '../../../../ui/blocks/product_scroll_list.dart';
import '../../../../ui/products/product_detail/product_detail.dart';
import '../../../../ui/products/product_grid/product_item.dart';
import '../../../../ui/products/products.dart';
import '../../../../vendor/blocs/vendor_detail_bloc.dart';
import '../../../../vendor/models/vendor_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../../models/category_model.dart';
import '../../../../models/blocks_model.dart' hide Image, Key, Theme;
import 'package:flutter/rendering.dart';

class VendorHome extends StatefulWidget {
  final VendorDetailBloc vendorDetailsBloc;
  VendorHome({Key key, this. vendorDetailsBloc}) : super(key: key);

  @override
  _VendorHomeState createState() => _VendorHomeState();
}

class _VendorHomeState extends State<VendorHome> {
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.vendorDetailsBloc.loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await widget.vendorDetailsBloc.getDetails();
        return;
      },
      child: StreamBuilder<VendorDetailsModel>(
        stream: widget.vendorDetailsBloc.allVendorDetails,
        builder: (context, snapshot) {
          return snapshot.hasData ? CustomScrollView(
            controller: _scrollController,
            slivers: buildLisOfBlocks(snapshot),
          )
              : Center(
            child: CircularProgressIndicator(),
          );
        }
      )
    );
  }

  List<Widget> buildLisOfBlocks(AsyncSnapshot<VendorDetailsModel> snapshot) {
    List<Widget> list = new List<Widget>();

    for (var i = 0; i < snapshot.data.blocks.length; i++) {
      if (snapshot.data.blocks[i].blockType == 'banner_block' && snapshot.data.blocks[i].children.length != 0) {
        if (snapshot.data.blocks[i].style == 'grid') {
         // list.add(buildGridHeader(snapshot, i));
          list.add(BannerGridList(
              block: snapshot.data.blocks[i], onBannerClick: onBannerClick));
        }

        if (snapshot.data.blocks[i].style == 'scroll') {
          list.add(BannerScrollList(
              block: snapshot.data.blocks[i], onBannerClick: onBannerClick));
        }

        if (snapshot.data.blocks[i].style == 'slider') {
          list.add(BannerSlider(block: snapshot.data.blocks[i], onBannerClick: onBannerClick));
        }

        if (snapshot.data.blocks[i].style == 'slider1') {
          list.add(BannerSlider1(
              block: snapshot.data.blocks[i], onBannerClick: onBannerClick));
        }

        if (snapshot.data.blocks[i].style == 'slider2') {
          list.add(BannerSlider2(
              block: snapshot.data.blocks[i], onBannerClick: onBannerClick));
        }

        if (snapshot.data.blocks[i].style == 'slider3') {
          list.add(BannerSlider3(
              block: snapshot.data.blocks[i], onBannerClick: onBannerClick));
        }
      }

      if (snapshot.data.blocks[i].blockType == 'product_block' &&
          snapshot.data.blocks[i].style == 'scroll' && snapshot.data.blocks[i].products.length != 0) {
        list.add(ProductScrollList(
            block: snapshot.data.blocks[i], onProductClick: onProductClick));
      }

      if (snapshot.data.blocks[i].blockType == 'product_block' &&
          snapshot.data.blocks[i].style == 'grid') {
        //list.add(buildGridHeader(snapshot.data.blocks[i], i));
        list.add(ProductGridList(
            block: snapshot.data.blocks[i], onProductClick: onProductClick));
      }
    }

    if (snapshot.data.recentProducts != null) {
      list.add(ProductGrid(
          products: snapshot.data.recentProducts));
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

  Widget buildGridHeader(Block block, int childIndex) {
    double textAlign = _headerAlign(block.headerAlign);
    TextStyle subhead = Theme.of(context).brightness != Brightness.dark
        ? Theme.of(context).textTheme.subhead.copyWith(
        fontWeight: FontWeight.w600,
        color: HexColor(block.titleColor))
        : Theme.of(context)
        .textTheme
        .subhead
        .copyWith(fontWeight: FontWeight.w600);
    return textAlign != null
        ? SliverToBoxAdapter(
        child: Container(
            padding: EdgeInsets.fromLTRB(
                double.parse(block.paddingLeft
                    .toString()) +
                    4,
                double.parse(
                    block.paddingTop.toString()),
                double.parse(block.paddingRight
                    .toString()) +
                    4,
                16.0),
            color: Theme.of(context).scaffoldBackgroundColor,
            alignment: Alignment(textAlign, 0),
            child: Text(
              block.title,
              textAlign: TextAlign.start,
              style: subhead,
            )))
        : SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.fromLTRB(
            block.paddingBetween,
            double.parse(
                block.paddingTop.toString()),
            block.paddingBetween,
            0.0),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }

  Widget buildRecentProductGridList(VendorDetailsModel snapshot) {
    return ProductGrid(
        products: snapshot.recentProducts);
  }



  onProductClick(product) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ProductDetail(
        product: product);
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

  Widget buildFeaturedGridList(BlocksModel snapshot) {
    return ProductFeaturedGrid(products: snapshot.featured);
  }


  Widget buildOnSaleList(BlocksModel snapshot) {
    return ProductOnSale(products: snapshot.onSale);
  }

  Widget ProductOnSale({List<Product> products, String title}) {
    if (products.length > 0) {
      return Container(
        child: SliverList(
          delegate: SliverChildListDelegate(
            [
              products.length != null
                  ? Container(
                  height: 20,
                  padding: EdgeInsets.symmetric(horizontal: 18.0),
                  child: Text('On Sale',
                      style: Theme.of(context).textTheme.body2.copyWith(
                          fontSize: 16, fontWeight: FontWeight.w800)))
                  : Container(),
              Container(
                  height: 310,
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 14.0),
                  decoration: new BoxDecoration(
                    //color: Colors.pink,
                  ),
                  child: ListView.builder(
                      padding: EdgeInsets.all(12.0),
                      scrollDirection: Axis.horizontal,
                      itemCount: products.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                            width: 200,
                            child: ProductItem(product: products[index], onProductClick: onProductClick)
                        );
                      })),
            ],
          ),
        ),
      );
    } else {
      return Container(
        child: SliverToBoxAdapter(),
      );
    }
  }

  Widget ProductFeaturedGrid({List<Product> products}) {
    if (products.length > 0) {
      return Container(
        child: SliverList(
          delegate: SliverChildListDelegate(
            [
              products.length != null
                  ? Container(
                  height: 20,
                  padding: EdgeInsets.symmetric(horizontal: 18.0),
                  child: Text('Featured',
                      style: Theme.of(context).textTheme.body2.copyWith(
                          fontSize: 16, fontWeight: FontWeight.w800,)))
                  : Container(),
              Container(
                  height: 310,
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 14.0),
                  decoration: new BoxDecoration(
                    //color: Colors.pink,
                  ),
                  child: ListView.builder(
                      padding: EdgeInsets.all(12.0),
                      scrollDirection: Axis.horizontal,
                      itemCount: products.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                            width: 200,
                            child: ProductItem(product: products[index], onProductClick: onProductClick)
                        );
                      })),
            ],
          ),
        ),
      );
    } else {
      return Container(
        child: SliverToBoxAdapter(),
      );
    }
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
