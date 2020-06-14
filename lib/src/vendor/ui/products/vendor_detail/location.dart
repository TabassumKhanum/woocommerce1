import 'dart:async';
import 'dart:typed_data';
import './../../../models/vendor_details_model.dart';
import './../../../blocs/vendor_detail_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

import 'package:location/location.dart';

class LocationContainer extends StatefulWidget {
  final VendorDetailBloc vendorDetailsBloc;
  final Store store;
  const LocationContainer({Key key, this.vendorDetailsBloc, this.store})
      : super(key: key);
  @override
  _LocationContainerState createState() => _LocationContainerState();
}

class _LocationContainerState extends State<LocationContainer> {
  Completer<GoogleMapController> _controller = Completer();

  LatLng _lastMapPosition;
  final Set<Marker> _markers = {};

  MapType _currentMapType = MapType.normal;

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  BitmapDescriptor pinLocationIcon;
  void initState() {
    _lastMapPosition =
        LatLng(double.parse(widget.store.lat), double.parse(widget.store.lon));
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
      ));
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 1.5),
            'lib/assets/images/LocationPin.png')
        .then((onValue) {
      pinLocationIcon = onValue;
    });
  }

  Map loginData = new Map<String, dynamic>();
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController messageController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    LatLng pinPosition = LatLng(37.3797536, -122.1017334);
    return ListView(
      children: <Widget>[
        Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                double.parse(widget.store.lat) != 0 ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 1, color: Colors.grey.withOpacity(0.4))),
                  //color: Colors.teal,
                  child: Stack(
                    children: <Widget>[
                      GoogleMap(
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: _lastMapPosition,
                          zoom: 11.0,
                        ),
                        gestureRecognizers: Set()
                          ..add(Factory<PanGestureRecognizer>(
                              () => PanGestureRecognizer())),
                        scrollGesturesEnabled: true,
                        onMapCreated: _onMapCreated,
                        mapType: _currentMapType,
                        markers: _markers,
                      ),
                    ],
                  ),
                ) : Container(),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Container(
                    child: Text('Enter the Details',
                        style: Theme.of(context).textTheme.subhead),
                  ),
                ),
                Container(
                  //padding:  EdgeInsets.all(8),
                  margin: const EdgeInsets.only(top: 8.0),
                  child: new Form(
                    key: _formKey,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(FontAwesomeIcons.user,
                                color: Colors.black),
                            //filled: true,
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 0.0),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 0.0),
                            ),
                            labelText: 'Name',
                            isDense: true,
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter name';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 6.0),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              FontAwesomeIcons.envelope,
                              color: Colors.black,
                            ),
                            // filled: true,
                            isDense: true,
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 0.0),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 0.0),
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 6.0),
                        TextFormField(
                          controller: phoneController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(FontAwesomeIcons.mobileAlt,
                                color: Colors.black),
                            // filled: true,
                            isDense: true,
                            labelText: 'Phone',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 0.0),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 0.0),
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter phone';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 6.0),
                        TextFormField(
                          controller: messageController,
                          decoration: InputDecoration(
                            prefixIcon:
                                Icon(Icons.message, color: Colors.black),
                            // filled: true,
                            isDense: true,
                            labelText: 'Message',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 0.0),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 0.0),
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter message';
                            }
                            return null;
                          },
                        ),
                        //SizedBox(height: 22.0),
                        ButtonBar(children: <Widget>[
                          SizedBox(
                            width: double.maxFinite,
                            child: new RaisedButton(
                              //elevation: 2.0,
                              hoverElevation: 4.0,
                              child: const Padding(
                                padding:
                                    EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
                                child: const Text("SUBMIT"),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  loginData["Name"] = nameController.text;
                                  loginData["email"] = emailController.text;
                                  loginData["phone"] = phoneController.text;
                                  loginData["message"] = messageController.text;

                                  widget.vendorDetailsBloc
                                      .submitLocation(loginData);
                                }
                              },
                            ),
                          )
                        ]),
                      ],
                    ),
                  ),
                )
              ]),
        ),
      ],
    );
  }
}
