import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../src/models/app_state_model.dart';
import '../../../src/ui/accounts/login/login.dart';
import '../../models/blocks_model.dart';
import 'hex_color.dart';
import 'package:html/parser.dart';

import 'list_header.dart';

class ProductScrollList extends StatefulWidget {
  final Block block;
  final Function onProductClick;
  ProductScrollList({Key key, this.block, this.onProductClick})
      : super(key: key);
  @override
  _ProductScrollListState createState() => _ProductScrollListState();
}

class _ProductScrollListState extends State<ProductScrollList> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          ListHeader(block: widget.block),
          Container(
              height: (widget.block.childHeight + widget.block.paddingBottom)
                  .toDouble(),
              margin: EdgeInsets.fromLTRB(
                  double.parse(widget.block.marginLeft.toString()),
                  double.parse(widget.block.marginTop.toString()),
                  double.parse(widget.block.marginRight.toString()),
                  double.parse(widget.block.marginBottom.toString())),
              decoration: new BoxDecoration(
                color: Theme.of(context).brightness != Brightness.dark ? HexColor(widget.block.bgColor) : Theme.of(context).scaffoldBackgroundColor,
                borderRadius: new BorderRadius.all(
                  Radius.circular(0),
                ),
              ),
              child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(
                      double.parse(widget.block.paddingLeft.toString()),
                      0.0,
                      double.parse(widget.block.paddingRight.toString()),
                      double.parse(widget.block.paddingBottom.toString())),
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.block.products.length,
                  itemBuilder: (BuildContext context, int index) {
                    double paddingLeft = widget.block.paddingBetween / 2;
                    double paddingRight = widget.block.paddingBetween / 2;
                    if (index == 0) {
                      paddingLeft = widget.block.paddingBetween;
                    }
                    if (index == widget.block.products.length - 1) {
                      paddingRight = widget.block.paddingBetween;
                    }
                    return Container(
                        padding: EdgeInsets.fromLTRB(
                            paddingLeft, 0.0, paddingRight, 0.0),
                        width: double.parse(widget.block.childWidth.toString()),
                        child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            clipBehavior: Clip.antiAlias,
                            elevation: widget.block.elevation.toDouble(),
                            child: InkWell(
                              splashColor: HexColor(widget.block.bgColor)
                                  .withOpacity(0.1),
                              onTap: () {
                                widget.onProductClick(
                                    widget.block.products[index]);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  AspectRatio(
                                      aspectRatio: 22 / 19,
                                      child: Stack(
                                        children: <Widget>[
                                          CachedNetworkImage(
                                            imageUrl: widget.block.products[index]
                                                .images[0].src,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                Ink.image(
                                                  child: InkWell(
                                                    splashColor:
                                                    HexColor(widget.block.bgColor)
                                                        .withOpacity(0.1),
                                                    onTap: () {
                                                      widget.onProductClick(
                                                          widget.block.products[index]);
                                                    },
                                                  ),
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                            placeholder: (context, url) =>
                                                Container(
                                                    color: HexColor(
                                                        widget.block.bgColor)
                                                        .withOpacity(0.5)),
                                            errorWidget: (context, url, error) =>
                                                Container(color: Colors.black12),
                                          ),
                                          ScopedModelDescendant<AppStateModel>(builder: (context, child, model) {
                                            return Positioned(
                                              top: 0.0,
                                              right: 0.0,
                                              child: IconButton(
                                                  icon: model.wishListIds.contains(widget.block.products[index].id) ? Icon(Icons.favorite, color: Theme.of(context).accentColor) :
                                                  Icon(Icons.favorite_border, color: Theme.of(context).accentColor.withOpacity(0.6)),
                                                  onPressed: () {
                                                    if (!model.loggedIn) {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  Login()));
                                                    } else {
                                                      model.updateWishList(widget.block.products[index].id);
                                                    }
                                                  }
                                              ),
                                            );
                                          })
                                        ],
                                      )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(4.0, 0, 4, 4),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          widget.block.products[index].name,
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 4.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.baseline,
                                          textBaseline: TextBaseline.alphabetic,
                                          children: <Widget>[
                                            Text(
                                                (widget.block.products[index]
                                                                .formattedPrice !=
                                                            null &&
                                                        widget
                                                            .block
                                                            .products[index]
                                                            .formattedPrice
                                                            .isNotEmpty)
                                                    ? _parseHtmlString(widget
                                                        .block
                                                        .products[index]
                                                        .formattedPrice)
                                                    : '',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18,
                                                )),
                                            SizedBox(width: 4.0),
                                            Text(
                                                (widget.block.products[index]
                                                                .salePrice !=
                                                            null &&
                                                        widget
                                                                .block
                                                                .products[index]
                                                                .salePrice !=
                                                            0)
                                                    ? _parseHtmlString(widget
                                                        .block
                                                        .products[index]
                                                        .formattedSalesPrice)
                                                    : '',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .copyWith(
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      RatingBar(
                                        initialRating: double.parse(widget.block.products[index].averageRating),
                                        itemSize: 15,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        ignoreGestures: true,
                                        itemCount: 5,
                                        //unratedColor: Theme.of(context).accentColor.withOpacity(0.4),
                                        itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          
                                        },
                                      ),
                                      widget.block.products[index].averageRating != '0.00' ? Row(
                                        children: <Widget>[
                                          SizedBox(width: 4.0),
                                          Text('(' + widget.block.products[index].ratingCount.toString() + ')',
                                              maxLines: 2,
                                              style: TextStyle(
                                                color:
                                                Theme.of(context).hintColor.withOpacity(0.4),
                                                fontSize: 12,
                                              )),
                                        ],
                                      ) : Container(),
                                    ],
                                  )
                                ],
                              ),
                            )));
                  })),
        ],
      ),
    );
  }
}

String _parseHtmlString(String htmlString) {
  var document = parse(htmlString);

  String parsedString = parse(document.body.text).documentElement.text;

  return parsedString;
}
