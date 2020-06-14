import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../blocs/home_bloc.dart';
import '../../config.dart';
import '../../resources/api_provider.dart';
import 'order_summary.dart';
import 'dart:io';

class WebViewPage extends StatefulWidget {
  final String url;
  final String selectedPaymentMethod;
  final HomeBloc homeBloc;

  const WebViewPage({Key key, this.url, this.selectedPaymentMethod, this.homeBloc}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState(url: url);
}

class _WebViewPageState extends State<WebViewPage> {
  final String url;
  final apiProvider = ApiProvider();
  final config = Config();
  bool _isLoadingPage = true;
  String orderId;
  String orderKey;
  WebViewController controller;
  String redirectUrl;

  @override
  void initState() {
    super.initState();
    orderId = '0';
    if (url.lastIndexOf("/order-pay/") != -1 &&
        url.lastIndexOf("/?key=wc_order") != -1) {
      var pos1 = url.lastIndexOf("/order-pay/");
      var pos2 = url.lastIndexOf("/?key=wc_order");
      orderId = url.substring(pos1 + 11, pos2);
    }

    if (url.lastIndexOf("/?key=") != -1) {
      var pos1 = url.lastIndexOf("/?key=wc_order");
      var pos2 = url.length;
      orderKey = url.substring(pos1 + 6, pos2);
    }

    if (widget.selectedPaymentMethod == 'woo_mpgs' && url.lastIndexOf("sessionId=") != -1 &&
        url.lastIndexOf("&order=") != -1) {
      var pos1 = url.lastIndexOf("sessionId=");
      var pos2 = url.lastIndexOf("&order=");
      String sessionId = url.substring(pos1 + 10, pos2);
      redirectUrl = 'https://credimax.gateway.mastercard.com/checkout/pay/' + sessionId;
    } else if(widget.selectedPaymentMethod == 'paypal') {
      redirectUrl = url;
    } else {
      redirectUrl = this.config.url + '/checkout/order-pay/' + orderId + '/?key=' + orderKey;
    }
  }

  _WebViewPageState({this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 1.0, title: Text('Payment')),
      body: Container(
        child: Stack(
          children: <Widget>[
            WebView(
              onPageStarted: (String url) {
                onValue(url);
              },
              initialUrl: redirectUrl,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController wvc) {
                //
              },
              onPageFinished: (value) async {
                print('value');
                print(value.contains('checkout/order-pay'));
                if(!value.contains('checkout/order-pay')) {
                  setState(() {
                    _isLoadingPage = false;
                  });
                }
              },
            ),
            _isLoadingPage
                ? Container(
                    color: Colors.white,
                    alignment: FractionalOffset.center,
                    child: CircularProgressIndicator(),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  void _onNavigationDelegateExample(
      WebViewController controller, BuildContext context) async {
    controller.currentUrl().then(onValue);
  }

  Future onValue(String url) {
    print(url);
    if (url.contains('/order-received/')) {
      orderSummary(url);
    }

    if (url.contains('cancel_order=') ||
        url.contains('failed') ||
        url.contains('type=error') ||
        url.contains('cancelled=1') ||
        url.contains('cancelled') ||
        url.contains('cancel_order=true')) {
        Navigator.of(context).pop();
    }

    if (url.contains('?errors=true')) {
     // Navigator.of(context).pop();
    }

    // Start of PayUIndia Payment
    if (url.contains('payumoney.com/transact')) {
      // Show WebView
    }

    if (url.contains('/order-received/') &&
        url.contains('key=wc_order_') &&
        orderId != null) {
        navigateOrderSummary(url);
    }
    // End of PayUIndia Payment

    // Start of PAYTM Payment
    if (url.contains('securegw-stage.paytm.in/theia')) {
      //Show WebView
    }

    if (url.contains('type=success') && orderId != null) {
      navigateOrderSummary(url);
    }

  }

  void orderSummary(String url) {
    var str = url;
    var pos1 = str.lastIndexOf("/order-received/");
    var pos2 = str.lastIndexOf("/?key=wc_order");
    orderId = str.substring(pos1 + 16, pos2);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderSummary(
                id: orderId,
            )));
  }

  void navigateOrderSummary(String url) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderSummary(
                id: orderId,
            )));
  }
}
