import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../models/app_state_model.dart';
import '../../../blocs/vendor_bloc.dart';
import 'package:html/parser.dart';
import '../../../models/product_variation_model.dart' hide VariationImage;
import '../../../models/vendor_product_model.dart';
import 'add_variation_product.dart';
import 'edit_variation_product.dart';
import 'package:intl/intl.dart';


class VariationProductList extends StatefulWidget {
  final VendorBloc vendorBloc;
  final VendorProduct product;

  VariationProductList({Key key, this.vendorBloc,  this.product,}) : super(key: key);

  @override
  _VariationProductListState createState() => _VariationProductListState();
}


class _VariationProductListState extends State<VariationProductList> {
  ScrollController _scrollController = new ScrollController();
  AppStateModel _appStateModel = AppStateModel();
  @override
  void initState() {
    super.initState();
    widget.vendorBloc.getVariationProducts(widget.product.id);
  }

    @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Variations'),

          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add,
                semanticLabel: 'add',
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddVariations(
                            vendorBloc: widget.vendorBloc,
                            product: widget.product,
                            )),
                );
              },
            ),
          ]),


      body: StreamBuilder(
          stream: widget.vendorBloc.allVendorVariationProducts,
          builder: (context, AsyncSnapshot<List<ProductVariation>> snapshot) {

            if (snapshot.hasData) {
              return CustomScrollView(
                  controller: _scrollController, slivers: buildList(snapshot));
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  Widget buildListTile(BuildContext context, ProductVariation variationProduct) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        decimalDigits: 3, name: _appStateModel.selectedCurrency);
    var name = '';

    variationProduct.attributes.forEach((value) {
      name = name + ' '+ value.option;
    });

    return MergeSemantics(
      child: ListTile(
  /*  onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VariationProductDetail(
               product: widget.product
                )),
          );
        },*/

        isThreeLine: true,
        leading: Image.network(
          variationProduct.image.src,
          fit: BoxFit.fill,
        ),
        title: Text(name),
        subtitle: Text(formatter.format((double.parse('${variationProduct.regularPrice}')))),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.edit,
              semanticLabel: 'edit',
              //color: Colors.red,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditVariationProduct(variationProduct: variationProduct, vendorBloc: widget.vendorBloc, product: widget.product,
                    )),
              );
            },
          ),

            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                 widget.vendorBloc.deleteVariationProduct(widget.product.id, variationProduct.id );
                }),



        ],)


        /**/
      ),
    );
  }

  Widget buildItemList(AsyncSnapshot<List<ProductVariation>> snapshot) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            return Column(
              children: <Widget>[
                buildListTile(context, snapshot.data[index]),
                Divider(height: 0.0),
              ],
            );
          },
          childCount: snapshot.data.length,
        ));
  }

  buildList(AsyncSnapshot<List<ProductVariation>> snapshot) {
    List<Widget> list = new List<Widget>();
    list.add(buildItemList(snapshot));
    if (snapshot.data != null) {
      list.add(SliverPadding(
          padding: EdgeInsets.all(0.0),
          sliver: SliverList(
              delegate: SliverChildListDelegate([
                Container(
                    height: 60,
                    child: StreamBuilder(
                       // stream: widget.vendorBloc.hasMoreProducts,
                        builder: (context, AsyncSnapshot<bool> snapshot) {
                          return snapshot.hasData && snapshot.data == false
                              ? Center(child: Text('No more products!'))
                              : Center(child: Container());
                        }))
              ]))));
    }
    return list;
  }
}


String _parseHtmlString(String htmlString) {
  var document = parse(htmlString);
  String parsedString = parse(document.body.text).documentElement.text;
  return parsedString;
}