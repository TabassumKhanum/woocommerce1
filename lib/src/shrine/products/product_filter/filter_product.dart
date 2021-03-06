import './../../../models/app_state_model.dart';
import 'package:flutter/material.dart';
import '../../../ui/accounts/login/buttons.dart';
import '../../../models/attributes_model.dart';
import '../../../models/category_model.dart';
import '../../../blocs/products_bloc.dart';
import 'package:intl/intl.dart';

import '../../colors.dart';

enum DismissDialogAction {
  cancel,
  discard,
  save,
}

class FilterProduct extends StatefulWidget {
  final ProductsBloc productsBloc;
  //final List<Category> categories;
  //final Function onSelectSubcategory;

  FilterProduct({Key key, this.productsBloc}) : super(key: key);

  @override
  _FilterProductState createState() => _FilterProductState();
}

class _FilterProductState extends State<FilterProduct> {
  ScrollController _scrollController = new ScrollController();

  var filter = new Map<String, dynamic>();
  final appStateModel = AppStateModel();
  List<Category> subCategories = [];

  @override
  void initState() {
    widget.productsBloc.selectedRange = RangeValues(0, appStateModel.maxPrice);
    subCategories = appStateModel.blocks.categories
        .where(
            (cat) => cat.parent.toString() == widget.productsBloc.filter['id'])
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: shrinePink100,
      child: StreamBuilder(
        stream: widget.productsBloc.allAttributes,
        builder: (context, AsyncSnapshot<List<AttributesModel>> snapshot) {
          if (snapshot.hasData && snapshot.data.length != 0) {
            return Stack(children: <Widget>[
              CustomScrollView(
                controller: _scrollController,
                slivers: buildFilterList(snapshot),
              ),
              Positioned(
                bottom: 16.0,
                left: 10.0,
                right: 10.0,
                child: SizedBox(
                    width: 80.0,
                    child: AccentButton(
                      onPressed: () {
                        widget.productsBloc.applyFilter(
                            widget.productsBloc.selectedRange.start,
                            widget.productsBloc.selectedRange.end);
                        Navigator.pop(context);
                      },
                      showProgress: false,
                      text: appStateModel.blocks.localeText.apply,
                    )),
              ),
            ]);
          } else if (snapshot.hasData && snapshot.data.length == 0) {
            return Center(
              child: Text('No filters available'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  buildFilterList(AsyncSnapshot<List<AttributesModel>> snapshot) {
    List<Widget> list = new List<Widget>();

    /*if (widget.subcategories.length != 0) {
      list.add(buildHeader('Categories'));
      list.add(buildSubcategories());
    }*/

    list.add(buildHeader('Price'));
    list.add(priceSlider());

    for (var i = 0; i < snapshot.data.length; i++) {
      if (snapshot.data[i].terms.length != 0) {
        list.add(buildHeader(snapshot.data[i].name));
        list.add(buildFilter(snapshot, i));
      }
    }
    list.add(SliverPadding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 60),
    ));
    return list;
  }

  Widget priceSlider() {
    final NumberFormat formatter = NumberFormat.currency(
        decimalDigits: 2, name: appStateModel.selectedCurrency);
    return SliverPadding(
      padding: EdgeInsets.all(16.0),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 30),
              child: RangeSlider(
                  min: 0,
                  max: appStateModel.maxPrice,
                  divisions: appStateModel.maxPrice.toInt(),
                  values: widget.productsBloc.selectedRange,
                  labels: RangeLabels(
                      '${formatter.format(widget.productsBloc.selectedRange.start)}',
                      '${formatter.format(widget.productsBloc.selectedRange.end)}'),
                  onChanged: (RangeValues newRange) {
                    setState(() {
                      widget.productsBloc.selectedRange = newRange;
                    });
                  }),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(16, 0.0, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                      '${formatter.format(widget.productsBloc.selectedRange.start)}'),
                  Text(
                      '${formatter.format(widget.productsBloc.selectedRange.end)}'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildFilter(
      AsyncSnapshot<List<AttributesModel>> snapshot, int filterIndex) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Checkbox(
              value: snapshot.data[filterIndex].terms[index].selected,
              onChanged: (bool value) {
                setState(() {
                  snapshot.data[filterIndex].terms[index].selected = value;
                });
              },
            ),
            Text(snapshot.data[filterIndex].terms[index].name),
          ],
        );
      }, childCount: snapshot.data[filterIndex].terms.length),
    );
  }

  Widget buildSubcategories() {
    return SliverPadding(
      padding: EdgeInsets.all(16.0),
      sliver: SliverGrid(
        gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 110.0,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 3.5,
        ),
        delegate:
            new SliverChildBuilderDelegate((BuildContext context, int index) {
          return Container(
            child: RaisedButton(
              onPressed: () {
                //widget.onSelectSubcategory(widget.categories[index].id);
                Navigator.pop(context);
              },
              child: Text(
                subCategories[index].name,
                style: TextStyle(fontSize: 11.0),
                maxLines: 2,
              ),
            ),
          );
        }, childCount: subCategories.length),
      ),
    );
  }

  Widget buildHeader(String name) {
    return SliverToBoxAdapter(
      child: Container(
        height: 42.0,
        padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
        child: Text(
          name,
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
      ),
    );
  }
}
