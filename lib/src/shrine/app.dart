// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import './../models/app_state_model.dart';
import './../ui/home/home.dart';
import 'package:flutter/material.dart';
import './../data/gallery_options.dart';
import './../layout/adaptive.dart';
import './backdrop.dart';
import 'menu/category_menu_page.dart';
import './expanding_bottom_sheet2.dart';
import './home.dart';
import './login.dart';
import './page_status.dart';
import './scrim.dart';
import './supplemental/layout_cache.dart';
import './theme.dart';
import 'package:scoped_model/scoped_model.dart';

class ShrineApp extends StatefulWidget {
  const ShrineApp({Key key}) : super(key: key);
  @override
  _ShrineAppState createState() => _ShrineAppState();
}

class _ShrineAppState extends State<ShrineApp> with TickerProviderStateMixin {
  // Controller to coordinate both the opening/closing of backdrop and sliding
  // of expanding bottom sheet
  AnimationController _controller;

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
    return Backdrop(
      frontLayer: Home(),
      backLayer: CategoryMenuPage(onCategoryTap: () => _controller.forward()),
      frontTitle: const Text('WOOCOMMERCE'),
      backTitle: Text('Menu'),
      controller: _controller,
    );
  }

  Widget desktopBackdrop() {
    return DesktopBackdrop(
      frontLayer: Home(),
      backLayer: CategoryMenuPage(),
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
        child: MaterialApp(
          title: 'WOOCOMMERCE',
          debugShowCheckedModeBanner: false,
          home: LayoutCache(
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
          initialRoute: '/',
          onGenerateRoute: _getRoute,
          theme: shrineTheme.copyWith(
            platform: GalleryOptions.of(context).platform,
          ),
          // L10n settings.
          //localizationsDelegates: AppLocalizations.localizationsDelegates,
          //supportedLocales: AppLocalizations.supportedLocales,
          locale: GalleryOptions.of(context).locale,
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
