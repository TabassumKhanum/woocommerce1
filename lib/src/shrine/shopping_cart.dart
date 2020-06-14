// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import './../blocs/home_bloc.dart';
import './checkout/address.dart';
import './../ui/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import './../ui/accounts/login/login.dart';
import './checkout/checkout.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

import 'checkout/order_summary.dart';
import 'colors.dart';
import 'expanding_bottom_sheet2.dart';
import 'home.dart';
import './../models/app_state_model.dart';
import './../models/cart/cart_model.dart';
import './../models/product_model.dart';
import 'package:html/parser.dart';

const _leftColumnWidth = 60.0;

class CartPage extends StatefulWidget {
  final appStateModel = AppStateModel();
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with SingleTickerProviderStateMixin {

  TabController _tabController;
  final homeBloc = HomeBloc();

  @override
  void initState() {
    widget.appStateModel.getCart();
    homeBloc.getCheckoutForm();
    homeBloc.updateOrderReview();
    _tabController = new TabController(vsync: this, length: 4);
    super.initState();
  }

  List<Widget> _createShoppingCartRows(AppStateModel model) {
    return model.shoppingCart.cartContents
        .map(
          (cartContents) => ShoppingCartRow(
            product: cartContents,
            onPressed: () {
              model.removeCartItem(cartContents);
            },
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final localTheme = Theme.of(context);

    return Scaffold(
      backgroundColor: shrinePink50,
      body: SafeArea(
        child: Container(
          child: ScopedModelDescendant<AppStateModel>(
            builder: (context, child, model) {
              return DefaultTabController(
                length: 4,
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    buildCartStack(context, localTheme, model),
                    buildBillingStack(context, localTheme, model),
                    buildOrderSummary(context, localTheme, model),
                    buildAddressStack(context, localTheme, model),
                  ],
                ),
              );//widget(child: buildCartStack(context, localTheme, model));
            },
          ),
        ),
      ),
    );
  }

  Stack buildCartStack(BuildContext context, ThemeData localTheme, AppStateModel model) {
    return Stack(
              children: [
                ListView(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: _leftColumnWidth,
                          child: IconButton(
                              icon: const Icon(Icons.keyboard_arrow_down),
                              onPressed: () =>
                                  ExpandingBottomSheet.of(context).close()),
                        ),
                        Text(
                          'CART',
                          style: localTheme.textTheme.subhead
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 16.0),
                        Text('${model.count} ITEMS'),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    model.shoppingCart.cartContents.length != 0 ? Column(
                      children: <Widget>[
                        Column(
                          children: _createShoppingCartRows(model),
                        ),
                        ShoppingCartSummary(model: model)
                      ],
                    ) : Container(child: Center(child: Text('Your shopping bag in empty!'),),),
                    const SizedBox(height: 100.0),
                  ],
                ),
                Positioned(
                  bottom: 16.0,
                  left: 16.0,
                  right: 16.0,
                  child: model.shoppingCart.cartContents.length != 0 ? RaisedButton(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(2.0)),
                    ),
                    color: shrinePink100,
                    //splashColor: shrineBrown600,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Text('CHECKOUT'),
                    ),
                    onPressed: () {
                      _tabController.animateTo(1);
                    },
                  ) : Container(),
                ),
              ],
            );
  }

  Widget buildBillingStack(BuildContext context, ThemeData localTheme, AppStateModel model) {
    return CheckoutOnePage(homeBloc: homeBloc, tabController: _tabController);
  }

  buildOrderStack(BuildContext context, ThemeData localTheme, AppStateModel model) {
    return Stack(
      children: [
        ListView(
          children: [
            Row(
              children: [
                SizedBox(
                  width: _leftColumnWidth,
                  child: IconButton(
                      icon: const Icon(Icons.keyboard_arrow_left),
                      onPressed: () =>
                          _tabController.animateTo(1)),
                ),
                Text(
                  'CHECKOUT',
                  style: localTheme.textTheme.subhead
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            model.shoppingCart.cartContents.length != 0 ? Column(
              children: <Widget>[
                Column(
                  children: _createShoppingCartRows(model),
                ),
                ShoppingCartSummary(model: model)
              ],
            ) : Container(child: Center(child: Text('Your shopping bag in empty!'),),),
            const SizedBox(height: 100.0),
          ],
        ),
        Positioned(
          bottom: 16.0,
          left: 16.0,
          right: 16.0,
          child: model.shoppingCart.cartContents.length != 0 ? RaisedButton(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2.0)),
            ),
            color: shrinePink100,
            //splashColor: shrineBrown600,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Text('CONTINUE'),
            ),
            onPressed: () {
              _tabController.animateTo(0);
            },
          ) : Container(),
        ),
      ],
    );
  }

  buildAddressStack(BuildContext context, ThemeData localTheme, AppStateModel model) {
    return Address(homeBloc: homeBloc, tabController: _tabController);
  }

  buildOrderSummary(BuildContext context, ThemeData localTheme, AppStateModel model) {
    return Stack(
      children: [
        OrderSummary(context: context, homeBloc: homeBloc, tabController: _tabController),
        Positioned(
          bottom: 16.0,
          left: 16.0,
          right: 16.0,
          child: RaisedButton(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2.0)),
            ),
            color: shrinePink100,
            //splashColor: shrineBrown600,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Text('CONTINUE'),
            ),
            onPressed: () {
              ExpandingBottomSheet.of(context).close();
            },
          ),
        ),
      ],
    );// OrderSummary(homeBloc: homeBloc, tabController: _tabController);
  }
}

class ShoppingCartSummary extends StatelessWidget {
  ShoppingCartSummary({this.model});

  final AppStateModel model;

  @override
  Widget build(BuildContext context) {
    final smallAmountStyle =
        Theme.of(context).textTheme.body1.copyWith(color: shrineBrown600);
    final largeAmountStyle = Theme.of(context).textTheme.display1;
    final formatter = NumberFormat.simpleCurrency(
        decimalDigits: 2, locale: Localizations.localeOf(context).toString());

    return Row(
      children: [
        SizedBox(width: _leftColumnWidth),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: Text('TOTAL'),
                    ),
                    Text(
                      _parseHtmlString(model.shoppingCart.cartTotals.total),
                      style: largeAmountStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    const Expanded(
                      child: Text('Subtotal:'),
                    ),
                    Text(
                      _parseHtmlString(model.shoppingCart.cartTotals.subtotal),
                      style: smallAmountStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    const Expanded(
                      child: Text('Shipping:'),
                    ),
                    Text(
                      _parseHtmlString(model.shoppingCart.cartTotals.shippingTotal),
                      style: smallAmountStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    const Expanded(
                      child: Text('Tax:'),
                    ),
                    Text(
                      _parseHtmlString(model.shoppingCart.cartTotals.totalTax),
                      style: smallAmountStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ShoppingCartRow extends StatefulWidget {
  ShoppingCartRow(
      {@required this.product, this.onPressed});

  final CartContent product;
  final VoidCallback onPressed;
  final appStateModel = AppStateModel();

  @override
  _ShoppingCartRowState createState() => _ShoppingCartRowState();
}

class _ShoppingCartRowState extends State<ShoppingCartRow> {

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.simpleCurrency(
        decimalDigits: 0, locale: Localizations.localeOf(context).toString());
    final localTheme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        key: ValueKey(widget.product.productId),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: _leftColumnWidth,
            child: IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: widget.onPressed,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.product.thumb,
                        imageBuilder: (context, imageProvider) => Container(
                          width: 75.0,
                          height: 75.0,
                          margin: const EdgeInsets.only(left: 16.0),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                            image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover),
                          ),
                        ),
                        placeholder: (context, url) => Container(color: Colors.black12),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text('Quantity: ' + widget.product.quantity.toString()),
                                ),
                                Text('x ${_parseHtmlString(widget.product.formattedPrice)}'),
                              ],
                            ),
                            Text(
                              widget.product.name,
                              style: localTheme.textTheme.subhead
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.remove_circle_outline),
                                  onPressed: _onDecreaseQty,
                                ),
                                isLoading
                                    ? Container(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                    ))
                                    : Container(
                                    width: 20,
                                    height: 16,
                                    child: Center(
                                        child: Text(
                                            widget.product.quantity.toString()))),
                                IconButton(
                                  icon: Icon(Icons.add_circle_outline),
                                  onPressed: _onIncreaseQty,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  const Divider(
                    color: shrineBrown900,
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _removeItem() {
    widget.appStateModel.removeItemFromCart(widget.product.key);
  }

  _onIncreaseQty() async {
    setState(() {
      isLoading = true;
    });
    await widget.appStateModel.increaseQty(widget.product.key, widget.product.quantity);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _onDecreaseQty() async {
    setState(() {
      isLoading = true;
    });
    await widget.appStateModel.decreaseQty(widget.product.key, widget.product.quantity);
    setState(() {
      isLoading = false;
    });
  }
}

String _parseHtmlString(String htmlString) {
  htmlString = htmlString != null ? htmlString : '';
  var document = parse(htmlString);

  String parsedString = parse(document.body.text).documentElement.text;

  return parsedString;
}