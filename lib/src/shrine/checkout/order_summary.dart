import 'package:flutter/material.dart';
import '../../../src/models/app_state_model.dart';
import '../../../src/ui/accounts/login/buttons.dart';
import '../../blocs/home_bloc.dart';
import '../../blocs/order_summary_bloc.dart';
import '../../models/orders_model.dart';
import 'package:intl/intl.dart';

import '../expanding_bottom_sheet.dart';

class OrderSummary extends StatefulWidget {
  final HomeBloc homeBloc;
  final TabController tabController;
  final BuildContext context;
  final appStateModel = AppStateModel();
  //final OrderSummaryBloc orderSummary = OrderSummaryBloc();

  OrderSummary({Key key, this. homeBloc, this.tabController, this.context}) : super(key: key);
  @override
  _OrderSummaryState createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {

  @override
  void initState(){
    super.initState();
    widget.homeBloc.getOrder();
    widget.appStateModel.clearCart();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Order>(
        stream: widget.homeBloc.order,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.id != null) {
            final NumberFormat formatter = NumberFormat.currency(
                decimalDigits: snapshot.data.decimals, name: snapshot.data.currency);
            return CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    child: buildHeaderRow(),
                  )),
              buildOrderDetails(snapshot.data, context, formatter),
              buildItemDetails(snapshot.data, context, formatter),
              buildTotalDetails(snapshot.data, context, formatter),
            ],
          );
          } else {
            return Center(child: CircularProgressIndicator(),);
          }
        }
      );
  }

  Widget buildOrderDetails(Order order, BuildContext context, NumberFormat formatter) {
    return SliverList(
        delegate: SliverChildListDelegate([
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10.0),
                Text(widget.appStateModel.blocks.localeText.order + (" - " + order.id.toString()),
                  //'ID - ' + order.id.toString(),
                  style: Theme.of(context).textTheme.title,
                ),
                Divider(),
                SizedBox(height: 10.0),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.appStateModel.blocks.localeText.billing,
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                          '''${order.billing.firstName} ${order.billing.lastName} ${order.billing.address1} ${order.billing.address2} ${order.billing.city} ${order.billing.country} ${order.billing.postcode}'''),
                    ]),
                Divider(),
                SizedBox(height: 10.0),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.appStateModel.blocks.localeText.shipping,
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                          '''${order.shipping.firstName} ${order.shipping.lastName} ${order.shipping.address1} ${order.shipping.address2} ${order.shipping.city} ${order.shipping.country} ${order.shipping.postcode}'''),
                    ]),
                Divider(),
                SizedBox(height: 10.0),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.appStateModel.blocks.localeText.payment,
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(order.paymentMethodTitle),
                    ]),
                Divider(),
                SizedBox(height: 10.0),
                order.lineItems != null
                    ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.appStateModel.blocks.localeText.items,
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ])
                    : Container(),
              ],
            ),
          )
        ]));
  }

  buildTotalDetails(Order order, BuildContext context, NumberFormat formatter) {
    return SliverList(
        delegate: SliverChildListDelegate([
          Container(
            padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                Widget>[
              Divider(),
              SizedBox(height: 10.0),
              Text(
                widget.appStateModel.blocks.localeText.total,
                style: Theme.of(context).textTheme.subtitle,
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(widget.appStateModel.blocks.localeText.shipping),
                  ),
                  Text(formatter.format((double.parse('${order.shippingTotal}')))),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(widget.appStateModel.blocks.localeText.tax),
                  ),
                  Text(formatter.format((double.parse('${order.totalTax}')))),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(widget.appStateModel.blocks.localeText.discount),
                  ),
                  Text(formatter.format((double.parse('${order.discountTotal}')))),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      widget.appStateModel.blocks.localeText.total,
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                  Text(
                    formatter.format(
                      double.parse(order.total),
                    ),
                    style: Theme.of(context).textTheme.title,
                  ),
                ],
              ),
              SizedBox(height: 100,),
            ]),
          )
        ]));
  }

  buildItemDetails(Order order, BuildContext context, NumberFormat formatter) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            return Column(
              children: <Widget>[
                Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(order.lineItems[index].name +
                              ' x ' +
                              order.lineItems[index].quantity.toString(),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(formatter.format(
                            (double.parse('${order.lineItems[index].total}')))),
                      ],
                    ),
                    height: 25.0),
              ],
            );
          },
          childCount: order.lineItems.length,
        ),
      ),
    );
  }

  void onSuccessMessage(Order order) {
    showDialog(context: context,
        barrierDismissible: false,
        // ignore: deprecated_member_use
        child: AlertDialog(
          title: new Text(widget.appStateModel.blocks.localeText.youOrderHaveBeenReceived),
          content: new Text(widget.appStateModel.blocks.localeText.thankYouForShoppingWithUs+'!'+widget.appStateModel.blocks.localeText.thankYouOrderIdIs+':'+' #${order.id.toString()}. '+ widget.appStateModel.blocks.localeText.youWillReceiveAConfirmationMessage+'.'),
          actions: <Widget>[
            FlatButton(
                child: Text(widget.appStateModel.blocks.localeText.localeTextContinue),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
                }
            )
          ],
        )
    );
  }

  Row buildHeaderRow() {
    final localTheme = Theme.of(widget.context);
    return Row(
      children: [
        SizedBox(
          width: 60.0,
          child: IconButton(
              icon: const Icon(Icons.keyboard_arrow_down),
              onPressed: () {
                ExpandingBottomSheet.of(widget.context).close();
              }
          )
        ),
        Text(
          'Order Detail',
          style: localTheme.textTheme.headline6
              .copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

}

