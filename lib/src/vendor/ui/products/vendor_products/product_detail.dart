import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../../models/app_state_model.dart';
import '../variation_products/vatiation_product_list.dart';
import '../../../blocs/vendor_bloc.dart';
import '../../../../models/product_model.dart';
import '../../../models/vendor_product_model.dart';
import 'package:intl/intl.dart';

import 'edit_product.dart';

double expandedAppBarHeight = 350;

class VendorProductDetail extends StatefulWidget {
  final vendorBloc = VendorBloc();
  final VendorProduct product;

  VendorProductDetail({
    Key key,
    this.product,
  }) : super(key: key);
  @override
  _VendorProductDetailState createState() =>
      _VendorProductDetailState(product);
}

class _VendorProductDetailState extends State<VendorProductDetail> {
  AppStateModel _appStateModel = AppStateModel();

  final VendorProduct products;

  _VendorProductDetailState(this.products);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  widget.vendorBloc.deleteProduct(products);
                }),
          ],
          //  title: Text(widget.products.name),
        ),
        body: buildList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EditVendorProduct(
                vendorBloc: widget.vendorBloc,
                product: widget.product,
              )),
        ),
        tooltip: 'Edit',
        child: Icon(Icons.edit),
      ),
    );

  }

  Widget buildList() {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        decimalDigits: 3, name: _appStateModel.selectedCurrency);
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      children: ListTile.divideTiles(
        context: context,
        tiles: [
          ListTile(
              title: Text("images"),
              subtitle: GridView.builder(
                  shrinkWrap: true,
                  itemCount: products.images.length + 1,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4),
                  itemBuilder: (BuildContext context, int index) {
                    if (products.images.length != index) {
                      return Card(
                          clipBehavior: Clip.antiAlias,
                          elevation: 1.0,
                          margin: EdgeInsets.all(4.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Image.network(products.images[index].src,
                              fit: BoxFit.cover));
                    } else {
                      return Container();
                    }
                  })),
          ListTile(
            title: Text("id"),
            subtitle: Text(products.id.toString()),
          ),
          ListTile(
            title: Text("Product Name"),
            subtitle: Text(products.name),
          ),
          ListTile(
            title: Text("Regular Price"),
            subtitle: Text(products.regularPrice),
          ),
          ListTile(
            title: Text("Sale Price"),
            subtitle: Text(products.salePrice),
          ),
          ListTile(
            title: Text("status"),
            subtitle: Text(products.status),
          ),
          ListTile(
            title: Text("sku"),
            subtitle: Text(products.sku),
          ),
          ListTile(
            title: Text("type"),
            subtitle: Text(products.type),
          ),
          ListTile(
            title: Text("Short Description"),
            subtitle: Html(data: products.shortDescription),
          ),
          ListTile(
            title: Text("Description"),
            subtitle: Html(data: products.description),
          ),
          widget.product.type == "variable"
              ? ListTile(
                  contentPadding: EdgeInsets.all(10),
                  title: Text('Variations'),
                  trailing: Icon(CupertinoIcons.forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VariationProductList(
                          vendorBloc: widget.vendorBloc,
                          product: widget.product,
                        ),
                      ),
                    );
                  })
              : Container(),
        ],
      ).toList(),
    );
  }
}
