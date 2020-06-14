// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import './../../blocs/products_bloc.dart';
import './../../models/app_state_model.dart';
import './../../models/category_model.dart';
import './../../shrine/products/backdrop.dart';
import './../../shrine/products/filter_page.dart';
import './../../shrine/products/products.dart';
import './../../ui/home/home.dart';
import 'package:flutter/material.dart';
import './../../data/gallery_options.dart';
import './../../layout/adaptive.dart';
import './../menu/category_menu_page.dart';
import './../expanding_bottom_sheet2.dart';
import './../home.dart';
import './../login.dart';
import './../page_status.dart';
import './../scrim.dart';
import './../supplemental/layout_cache.dart';
import './../theme.dart';
import 'package:scoped_model/scoped_model.dart';

class ShrineProducts extends StatefulWidget {
  final ProductsBloc productsBloc = ProductsBloc();
  final Map<String, dynamic> filter;
  final String name;
  AppStateModel model = AppStateModel();

  ShrineProducts({Key key, this.filter, this.name})
      : super(key: key);

  @override
  _ShrineProductsState createState() => _ShrineProductsState();
}

class _ShrineProductsState extends State<ShrineProducts> with TickerProviderStateMixin {
  // Controller to coordinate both the opening/closing of backdrop and sliding
  // of expanding bottom sheet
  AnimationController _controller;
  List<Category> subCategories;

  // Animation Controller for expanding/collapsing the cart menu.
  AnimationController _expandingController;

  //TODO Delete this IF we use src/models/app_state_model
  AppStateModel _model;

  Map<String, List<List<int>>> _layouts = {};

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
      value: 1,
    );
    _expandingController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    //TODO Delete this
    _model = AppStateModel();
  }

  @override
  void dispose() {
    _controller.dispose();
    _expandingController.dispose();
    super.dispose();
  }

  Widget mobileBackdrop() {
    return ProductsBackdrop(
      frontLayer: ProductsWidget(productsBloc: widget.productsBloc,
          filter: widget.filter, name: widget.name),
      backLayer: FilterPage(productsBloc: widget.productsBloc, onCategoryTap: () => _controller.forward()),
      frontTitle: Text('Products'),
      backTitle: Text('Filter'),
      controller: _controller,
    );
  }

  Widget desktopBackdrop() {
    return DesktopBackdrop(
      frontLayer: ProductsWidget(productsBloc: widget.productsBloc,
          filter: widget.filter, name: widget.name),
      backLayer: FilterPage(productsBloc: widget.productsBloc),
    );
  }

  // Closes the bottom sheet if it is open.
  Future<bool> _onWillPop() async {
    final status = _expandingController.status;
    if (status == AnimationStatus.completed ||
        status == AnimationStatus.forward) {
      _expandingController.reverse();
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = isDisplayDesktop(context);

    final Widget backdrop = isDesktop ? desktopBackdrop() : mobileBackdrop();

    return ScopedModel<AppStateModel>(
      model: _model,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: LayoutCache(
          layouts: _layouts,
          child: PageStatus(
            menuController: _controller,
            cartController: _expandingController,
            child: HomePage(
              backdrop: backdrop,
              scrim: Scrim(controller: _expandingController),
              expandingBottomSheet: ExpandingBottomSheet(
                hideController: _controller,
                expandingController: _expandingController,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Route<dynamic> _getRoute(RouteSettings settings) {
  if (settings.name != '/login') {
    return null;
  }

  return MaterialPageRoute<void>(
    settings: settings,
    builder: (context) => LoginPage(),
    fullscreenDialog: true,
  );
}
