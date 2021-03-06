import 'package:place_picker/place_picker.dart';

import '../../config.dart';
import '../../models/app_state_model.dart';

import '../colors.dart';
import './../../ui/color_override.dart';
import './../../ui/colors.dart';
import 'package:flutter/material.dart';
import '../../ui/accounts/login/buttons.dart';
import '../../blocs/home_bloc.dart';
import '../../models/checkout/checkout_form_model.dart' hide Country;
import '../../ui/checkout/payment_method.dart';
import 'package:html/parser.dart';

const _leftColumnWidth = 60.0;

class Address extends StatefulWidget {
  final HomeBloc homeBloc;
  final TabController tabController;
  final appStateModel = AppStateModel();
  Address({Key key, this.homeBloc, this.tabController}) : super(key: key);

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {

  List<Region> regions;
  Config config = Config();
  TextEditingController _billingAddress1Controller = TextEditingController();
  TextEditingController _billingCityController = TextEditingController();
  TextEditingController _billingPostCodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    widget.homeBloc.getCheckoutForm();
    widget.homeBloc.updateOrderReview();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CheckoutFormModel>(
        stream: widget.homeBloc.checkoutForm,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Stack(
            children: [
              buildCheckoutForm(context, snapshot),
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
                    widget.homeBloc.formData['billing_country'] = snapshot.data.billingCountry;

                    //*** Remove When Shipping ADDRESS is different ***//
                    widget.homeBloc.formData['shipping_country'] = snapshot.data.billingCountry;
                    widget.homeBloc.formData['shipping_postcode'] = widget.homeBloc.formData['billing_postcode'];

                    widget.homeBloc.updateOrderReview2();
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();

                      widget.tabController.animateTo(1);
                    }
                  },
                ),
              ),
            ],
          ) : Column(
            children: <Widget>[
              buildHeaderRow(),
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          );
        });
  }

  buildCheckoutForm(BuildContext context, AsyncSnapshot<CheckoutFormModel> snapshot) {

    if(snapshot.data.countries.indexWhere((country) => country.value == snapshot.data.billingCountry) != -1) {
      regions = snapshot.data.countries.singleWhere((country) => country.value == snapshot.data.billingCountry).regions;
    } else if(snapshot.data.countries.indexWhere((country) => country.value == snapshot.data.billingCountry) == -1) {
      snapshot.data.billingCountry = snapshot.data.countries.first.value;
    } if(regions != null && regions.length != 0) {
      snapshot.data.billingState = regions.any((z) => z.value == snapshot.data.billingState) ? snapshot.data.billingState
          : regions.first.value;
      widget.homeBloc.formData['billing_state'] = snapshot.data.billingState;
    }

    if(_billingAddress1Controller.text.isEmpty)
    _billingAddress1Controller.text = snapshot.data.billingAddress1;
    if(_billingCityController.text.isEmpty)
    _billingCityController.text = snapshot.data.billingCity;
    if(_billingPostCodeController.text.isEmpty)
    _billingPostCodeController.text = snapshot.data.billingPostcode;

    return ListView(
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              buildHeaderRow(),
              Container(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FlatButton(
                        colorBrightness: Theme.of(context).brightness,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:<Widget>[
                            Icon(Icons.add_location),
                            Text(widget.appStateModel.blocks.localeText.selectLocation)
                          ], ),
                        onPressed: () {
                          showPlacePicker(snapshot);
                        },
                      ),
                      PrimaryColorOverride(
                        child: TextFormField(
                          initialValue: snapshot.data.billingFirstName,
                          decoration: InputDecoration(labelText: widget.appStateModel.blocks.localeText.firstName),
                          validator: (value) {
                            if (value.isEmpty) {
                              return widget.appStateModel.blocks.localeText.pleaseEnterFirstName;
                            }
                            return null;
                          },
                          onSaved: (value) {
                            widget.homeBloc.formData['billing_first_name'] = value;
                          },
                        ),
                      ),
                      SizedBox(height: 12.0),
                      PrimaryColorOverride(
                        child: TextFormField(
                          initialValue: snapshot.data.billingLastName,
                          decoration: InputDecoration(labelText: widget.appStateModel.blocks.localeText.lastName),
                          validator: (value) {
                            if (value.isEmpty) {
                              return widget.appStateModel.blocks.localeText.pleaseEnterLastName;
                            }
                            return null;
                          },
                          onSaved: (value) {
                            widget.homeBloc.formData['billing_last_name'] = value;
                          },
                        ),
                      ),
                      SizedBox(height: 12.0),
                      PrimaryColorOverride(
                        child: TextFormField(
                          controller: _billingAddress1Controller,
                          decoration: InputDecoration(labelText: widget.appStateModel.blocks.localeText.address),
                          validator: (value) {
                            if (value.isEmpty) {
                              return widget.appStateModel.blocks.localeText.pleaseEnterAddress;
                            }
                            return null;
                          },
                          onSaved: (value) {
                            widget.homeBloc.formData['billing_address_1'] = value;
                          },
                        ),
                      ),
                      /*SizedBox(height: 12.0),
                      PrimaryColorOverride(
                        child: TextFormField(
                          initialValue: snapshot.data.billingAddress2,
                          decoration: InputDecoration(labelText: widget.appStateModel.blocks.localeText.translate("address")+'2'),
                          onSaved: (value) {
                            widget.homeBloc.formData['billing_address_2'] = value;
                          },
                        ),
                      ),*/
                      SizedBox(height: 12.0),
                      PrimaryColorOverride(
                        child: TextFormField(
                          controller: _billingCityController,
                          decoration: InputDecoration(
                            labelText: widget.appStateModel.blocks.localeText.city,
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return widget.appStateModel.blocks.localeText.pleaseEnterCity;
                            }
                            return null;
                          },
                          onSaved: (value) {
                            widget.homeBloc.formData['billing_city'] = value;
                          },
                        ),
                      ),
                      SizedBox(height: 12.0),
                      PrimaryColorOverride(
                        child: TextFormField(
                          controller: _billingPostCodeController,
                          decoration: InputDecoration(labelText: widget.appStateModel.blocks.localeText.pincode),
                          validator: (value) {
                            if (value.isEmpty) {
                              return widget.appStateModel.blocks.localeText.pleaseEnterPincode;
                            }
                            return null;
                          },
                          onSaved: (value) {
                            widget.homeBloc.formData['billing_postcode'] = value;
                          },
                        ),
                      ),
                      SizedBox(height: 12.0),
                      PrimaryColorOverride(
                        child: TextFormField(
                          initialValue: snapshot.data.billingEmail,
                          decoration: InputDecoration(labelText: widget.appStateModel.blocks.localeText.email),
                          onSaved: (value) {
                            widget.homeBloc.formData['billing_email'] = value;
                          },
                        ),
                      ),
                      SizedBox(height: 12.0),
                      PrimaryColorOverride(
                        child: TextFormField(
                          initialValue: snapshot.data.billingPhone,
                          decoration: InputDecoration(labelText: widget.appStateModel.blocks.localeText.phoneNumber),
                          validator: (value) {
                            if (value.isEmpty) {
                              return widget.appStateModel.blocks.localeText.pleaseEnterPhoneNumber;
                            }
                            return null;
                          },
                          onSaved: (value) {
                            widget.homeBloc.formData['billing_phone'] = value;
                          },
                        ),
                      ),
                      SizedBox(height: 20,),
                      DropdownButton<String>(
                        value: snapshot.data.billingCountry,
                        hint: Text(widget.appStateModel.blocks.localeText.country),
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        underline: Container(
                          height: 2,
                          color: Theme.of(context).dividerColor,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            snapshot.data.billingCountry = newValue;
                          });
                          widget.homeBloc.formData['billing_country'] = snapshot.data.billingCountry;
                          //*** Remove When Shipping ADDRESS is different ***//
                          widget.homeBloc.formData['shipping_country'] = snapshot.data.billingCountry;
                          widget.homeBloc.updateOrderReview2();
                        },
                        items: snapshot.data.countries
                            .map<DropdownMenuItem<String>>(
                                (value) {
                              return DropdownMenuItem<String>(
                                value: value.value != null ? value.value : '',
                                child: Text(_parseHtmlString(value.label)),
                              );
                            }).toList(),
                      ),
                      (regions != null  && regions.length != 0) ? Column(
                        children: <Widget>[
                          SizedBox(height: 20,),
                          DropdownButton<String>(
                            value: snapshot.data.billingState,
                            hint: Text(widget.appStateModel.blocks.localeText.state),
                            isExpanded: true,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            underline: Container(
                              height: 2,
                              color: Theme.of(context).dividerColor,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                snapshot.data.billingState = newValue;
                              });
                              widget.homeBloc.formData['billing_state'] = snapshot.data.billingState;
                              //*** Remove When Shipping ADDRESS is different ***//
                              widget.homeBloc.formData['shipping_state'] = snapshot.data.billingState;
                              widget.homeBloc.updateOrderReview2();
                            },
                            items: regions
                                .map<DropdownMenuItem<String>>(
                                    (value) {
                                  return DropdownMenuItem<String>(
                                    value: value.value != null ? value.value : '',
                                    child: Text(_parseHtmlString(value.label)),
                                  );
                                }).toList(),
                          ),
                        ],
                      ) : PrimaryColorOverride(
                        child: TextFormField(
                          initialValue: widget.homeBloc.formData['billing_state'],
                          decoration: InputDecoration(labelText: widget.appStateModel.blocks.localeText.state),
                          validator: (value) {
                            if (value.isEmpty) {
                              return widget.appStateModel.blocks.localeText.pleaseEnterState;
                            }
                          },
                          onSaved: (val) => setState(() => widget.homeBloc.formData['billing_state'] = val),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                  child: SizedBox(height: 100,)),
            ],
          ),
        )
      ],
    );
  }

  void showPlacePicker(AsyncSnapshot<CheckoutFormModel> snapshot) async {
    LocationResult result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => Material(child: PlacePicker(config.mapApiKey))));
    if(result != null) {
      setState(() {
        _billingAddress1Controller.text = result.formattedAddress;
        _billingCityController.text = result.city.name;
        _billingPostCodeController.text = result.postalCode;
      });
      if(snapshot.data.countries.indexWhere((country) => country.value == result.country.shortName) != -1) {
        setState(() {
          snapshot.data.billingCountry = result.country.shortName;
        });
        regions = snapshot.data.countries.singleWhere((country) => country.value == result.country.shortName).regions;
      } else if(snapshot.data.countries.length != 0) {
        snapshot.data.billingCountry = snapshot.data.countries.first.value;
      } if(regions != null) {
        snapshot.data.billingState = regions.any((z) => z.value == result.administrativeAreaLevel2.shortName) ? result.administrativeAreaLevel2.shortName
            : regions.first.value;
      }
    }
  }

  Row buildHeaderRow() {
    final localTheme = Theme.of(context);
    return Row(
      children: [
        SizedBox(
          width: _leftColumnWidth,
          child: IconButton(
              icon: const Icon(Icons.keyboard_arrow_left),
              onPressed: () => widget.tabController.animateTo(1)),
        ),
        Text(
          'CHECKOUT',
          style: localTheme.textTheme.subhead
              .copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

String _parseHtmlString(String htmlString) {
  var document = parse(htmlString);

  String parsedString = parse(document.body.text).documentElement.text;

  return parsedString;
}

