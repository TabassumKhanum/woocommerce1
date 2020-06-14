import 'package:cached_network_image/cached_network_image.dart';

import './../../../../models/app_state_model.dart';
import './../../../../models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';

import 'grouped_products.dart';
import 'variations_products.dart';

class AddToCart extends StatefulWidget {

  AddToCart({
    Key key,
    @required this.product,
    @required this.model,
  }) : super(key: key);

  final Product product;
  final AppStateModel model;
  
  @override
  _AddToCartState createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  
  var isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    if(getQty() != 0 || isLoading)
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: Theme.of(context).textTheme.bodyText1.color.withOpacity(0.6)),
            tooltip: 'Increase quantity by 1',
            onPressed: () {
              if(widget.product.type == 'variable' || widget.product.type == 'grouped') {
                _bottomSheet(context);
              } else increaseQty();
            },
          ),
          isLoading ? SizedBox(
            child: Theme(
              data: Theme.of(context).copyWith(
                accentColor: Theme.of(context).buttonColor
              ),
                child: CircularProgressIndicator(strokeWidth: 2)
            ),
            height: 20.0,
            width: 20.0,
          ) :  SizedBox(
            width: 20.0,
            child: Text(getQty().toString(), textAlign: TextAlign.center,),
          ),
          IconButton(
            icon: Icon(Icons.remove_circle_outline, color: Theme.of(context).textTheme.bodyText1.color.withOpacity(0.6)),
            tooltip: 'Decrease quantity by 1',
            onPressed: () {
              if(widget.product.type == 'variable' || widget.product.type == 'grouped') {
                _bottomSheet(context);
              } else decreaseQty();
            },
          ),
        ],
      );
    else return RaisedButton(
      elevation: 0,
      shape: StadiumBorder(),
      child: Padding(
        padding: EdgeInsets.all(0.0),
        child: Text(widget.model.blocks.localeText.add.toUpperCase()),
      ),
      onPressed: widget.product.stockStatus == 'outofstock' ? null : () {
        if(widget.product.type == 'variable' || widget.product.type == 'grouped') {
          _bottomSheet(context);
        } else {
          addToCart();
        }
      },
    );
  }

  addToCart() async {
    var data = new Map<String, dynamic>();
    data['product_id'] = widget.product.id.toString();
    data['quantity'] = '1';
    setState(() {
      isLoading = true;
    });
    await widget.model.addToCart(data);
    setState(() {
      isLoading = false;
    });
  }

  decreaseQty() async {
    if (widget.model.shoppingCart?.cartContents != null) {
      if (widget.model.shoppingCart.cartContents
          .any((cartContent) => cartContent.productId == widget.product.id)) {
        final cartContent = widget.model.shoppingCart.cartContents
            .singleWhere((cartContent) => cartContent.productId == widget.product.id);
        setState(() {
          isLoading = true;
        });
        await widget.model.decreaseQty(cartContent.key, cartContent.quantity);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  increaseQty() async {
    if (widget.model.shoppingCart?.cartContents != null) {
      if (widget.model.shoppingCart.cartContents
          .any((cartContent) => cartContent.productId == widget.product.id)) {
        final cartContent = widget.model.shoppingCart.cartContents
            .singleWhere((cartContent) => cartContent.productId == widget.product.id);
        setState(() {
          isLoading = true;
        });
        bool status = await widget.model.increaseQty(cartContent.key, cartContent.quantity);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  getQty() {
    var count = 0;
    if(widget.model.shoppingCart.cartContents.any((element) => element.productId == widget.product.id)) {
      if(widget.product.type == 'variable') {
        widget.model.shoppingCart.cartContents.where((variation) => variation.productId == widget.product.id).toList().forEach((e) => {
          count = count + e.quantity
        });
        return count;
      } else return widget.model.shoppingCart.cartContents.firstWhere((element) => element.productId == widget.product.id).quantity;
    } else return count;
  }

  void _bottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          //color: Colors.amber,
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.product.name,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                widget.product.type == 'variable' ? Expanded(
                  child: ListView.builder
                    (
                      itemCount: widget.product.availableVariations.length,
                      itemBuilder: (BuildContext ctxt, int Index) {
                        return VariationProduct(id: widget.product.id, variation: widget.product.availableVariations[Index]);
                      }
                  ),
                ) : Expanded(
                  child: ListView.builder
                    (
                      itemCount: widget.product.children.length,
                      itemBuilder: (BuildContext ctxt, int Index) {
                        return GroupedProduct(id: widget.product.id, product: widget.product.children[Index]);
                      }
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
