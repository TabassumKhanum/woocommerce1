// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import './../../models/app_state_model.dart';
import './../../models/category_model.dart';
import './../../shrine/products/products.dart';
import './../../shrine/products/products_main.dart';
import './../../ui/accounts/login/login.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './../../data/gallery_options.dart';
import './../../layout/adaptive.dart';
import './../../layout/text_scale.dart';
import './../colors.dart';
//import './../login.dart';
//import './../model/app_state_model.dart';
//import './../model/product.dart';
import './../page_status.dart';
import './../triangle_category_indicator.dart';
import 'package:html/parser.dart';

double desktopCategoryMenuPageWidth({
  BuildContext context,
}) {
  return 232 * reducedTextScale(context);
}

class CategoryMenuPage extends StatefulWidget {
  const CategoryMenuPage({
    Key key,
    this.onCategoryTap,
  }) : super(key: key);

  final VoidCallback onCategoryTap;

  @override
  _CategoryMenuPageState createState() => _CategoryMenuPageState();
}

class _CategoryMenuPageState extends State<CategoryMenuPage> {
  Category selectedCategory;
  List<Category> mainCategories;
  Widget _buttonText(String caption, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        caption,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _divider({BuildContext context}) {
    return Container(
      width: 56 * GalleryOptions.of(context).textScaleFactor(context),
      height: 1,
      color: Color(0xFF8F716D),
    );
  }

  Widget _buildCategory(Category category, BuildContext context) {
    final bool isDesktop = isDisplayDesktop(context);

    final String categoryString = _parseHtmlString(category.name);

    final TextStyle selectedCategoryTextStyle = Theme.of(context)
        .textTheme
        .bodyText1
        .copyWith(fontSize: isDesktop ? 17 : 19);

    final TextStyle unselectedCategoryTextStyle = selectedCategoryTextStyle
        .copyWith(color: shrineBrown900.withOpacity(0.6));

    final double indicatorHeight = (isDesktop ? 28 : 30) *
        GalleryOptions.of(context).textScaleFactor(context);
    final double indicatorWidth = indicatorHeight * 34 / 28;

    return ScopedModelDescendant<AppStateModel>(
      builder: (context, child, model) => Semantics(
          selected: model.selectedCategory == category,// Selected Category
        button: true,
        child: GestureDetector(
          onTap: () {
            model.setCategory(category);
            if (widget.onCategoryTap != null) {
              widget.onCategoryTap();
            }
            onCategoryClick(category);
          },
          child: model.selectedCategory == category // Selected Category
              ? _buttonText(categoryString, selectedCategoryTextStyle)
              : _buttonText(categoryString, unselectedCategoryTextStyle),
        ),
      ),
    );
  }

  void onCategoryClick(Category category) {
    var filter = new Map<String, dynamic>();
    filter['id'] = category.id.toString();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ShrineProducts(
                filter: filter, name: category.name)));
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = isDisplayDesktop(context);

    final TextStyle selectedCategoryTextStyle = Theme.of(context)
        .textTheme
        .bodyText1
        .copyWith(fontSize: isDesktop ? 17 : 19);

    final TextStyle unselectedCategoryTextStyle = selectedCategoryTextStyle
        .copyWith(color: shrineBrown900.withOpacity(0.6));

    final TextStyle logoutTextStyle =
    Theme.of(context).textTheme.bodyText1.copyWith(
      fontSize: isDesktop ? 17 : 19,
      color: shrineBrown900.withOpacity(0.6),
    );

    if (isDesktop) {
      return ScopedModelDescendant<AppStateModel>(
          builder: (context, child, model) {
            if (model.blocks?.categories != null) {
              mainCategories = model.blocks.categories.where((cat) => cat.parent == 0).toList();
              if(selectedCategory == null) {
                selectedCategory = mainCategories.first;
              }
              return AnimatedBuilder(
            animation: PageStatus.of(context).cartController,
            builder: (context, child) => ExcludeSemantics(
              excluding: !menuPageIsVisible(context),
              child: Material(
                child: Container(
                  color: shrinePink100,
                  width: desktopCategoryMenuPageWidth(context: context),
                  child: Column(
                    children: [
                      const SizedBox(height: 64),
                      Image.asset(
                        'packages/shrine_images/diamond.png',
                        excludeFromSemantics: true,
                      ),
                      const SizedBox(height: 16),
                      Semantics(
                        container: true,
                        child: Text(
                          'SHRINE',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      const Spacer(),
                      for (final category in mainCategories)
                        _buildCategory(category, context),
                      _divider(context: context),
                      Semantics(
                        button: true,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (context) => Login(),
                              ),
                            );
                          },
                          child: _buttonText(
                            model.blocks.localeText.signIn,
                            logoutTextStyle,
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {},
                      ),
                      const SizedBox(height: 72),
                    ],
                  ),
                ),
              ),
            ),
          );
            } else {
              return Container();
            }
        }
      );
    } else {
      return ScopedModelDescendant<AppStateModel>(
          builder: (context, child, model) {
          if (model.blocks?.categories != null) {
            mainCategories = model.blocks.categories.where((cat) => cat.parent == 0).toList();
            if(selectedCategory == null) {
              selectedCategory = mainCategories.first;
            }
            return AnimatedBuilder(
            animation: PageStatus.of(context).cartController,
            builder: (context, child) => AnimatedBuilder(
              animation: PageStatus.of(context).menuController,
              builder: (context, child) => ExcludeSemantics(
                excluding: !menuPageIsVisible(context),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.only(top: 40),
                    color: shrinePink100,
                    child: ListView(
                      children: [
                        for (final category in mainCategories)
                          _buildCategory(category, context),
                        Center(
                          child: _divider(context: context),
                        ),
                        Semantics(
                          button: true,
                          child: GestureDetector(
                            onTap: () {
                              if (widget.onCategoryTap != null) {
                                widget.onCategoryTap();
                              }
                              Navigator.push<void>(
                                context,
                                MaterialPageRoute<void>(
                                    builder: (context) => Login()),
                              );
                            },
                            child: _buttonText(
                              model.blocks.localeText
                                  .signIn,
                              logoutTextStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
          } else {
            return Container();
          }
        }
      );
    }
  }
}

String _parseHtmlString(String htmlString) {
  var document = parse(htmlString);

  String parsedString = parse(document.body.text).documentElement.text;

  return parsedString;
}
