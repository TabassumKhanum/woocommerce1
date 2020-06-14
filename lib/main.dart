// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';
import './src/shrine/app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'src/app.dart';
import 'src/models/app_state_model.dart';
import 'src/splash.dart';
import 'src/constants.dart';
import 'src/data/gallery_options.dart';
import 'src/resources/api_provider.dart';
import 'src/themes/gallery_theme_data_white.dart';


void setOverrideForDesktop() {
  if (kIsWeb) return;

  if (Platform.isMacOS) {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
  } else if (Platform.isLinux || Platform.isWindows) {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
  } else if (Platform.isFuchsia) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void main() {
  setOverrideForDesktop();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  AppStateModel model = AppStateModel();
  MyApp({Key key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final apiProvider = ApiProvider();
  @override
  void initState() {
    super.initState();
    widget.model.fetchLocale();
    apiProviderInt();
  }

  void apiProviderInt() async {
    await apiProvider.init();
    widget.model.fetchAllBlocks();
    widget.model.getCustomerDetails();
  }

  @override
  Widget build(BuildContext context) {
    return ModelBinding(
      initialModel: GalleryOptions(
        themeMode: ThemeMode.system,
        textScaleFactor: 1,
        locale: null,
        platform: defaultTargetPlatform,
      ),
      child: Builder(
        builder: (context) {
          return ScopedModel<AppStateModel>(
              model: widget.model,
              child: MaterialApp(
                title: 'WooCommerce',
                debugShowCheckedModeBanner: false,
                themeMode: GalleryOptions.of(context).themeMode,
                theme: GalleryOptions.of(context).locale == Locale('ar') ? GalleryThemeData.lightArabicThemeData.copyWith(
                  platform: GalleryOptions.of(context).platform,
                ) : GalleryThemeData.lightThemeData.copyWith(
                  platform: GalleryOptions.of(context).platform,
                ),
                darkTheme: GalleryOptions.of(context).locale == Locale('ar') ? GalleryThemeData.darkArabicThemeData.copyWith(
                  platform: GalleryOptions.of(context).platform,
                ) : GalleryThemeData.darkThemeData.copyWith(
                  platform: GalleryOptions.of(context).platform,
                ),
                /*localizationsDelegates: [
                  ...AppLocalizations.localizationsDelegates,
                  LocaleNamesLocalizationsDelegate()
                ],
                supportedLocales: AppLocalizations.supportedLocales,
                locale: GalleryOptions.of(context).locale,
                localeResolutionCallback: (locale, supportedLocales) {
                  deviceLocale = locale;
                  return locale;
                },*/
                home: ScopedModelDescendant<AppStateModel>(
                    builder: (context, child, model) {
                    return model.blocks == null ? Material(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ) : App();
                  }
                ),/*ShrineApp()*//*ApplyTextOptions(
                  child: App()),*//*SplashPage(
                  child: App(),
                ),*/
              ));
        },
      ),
    );
  }
}
