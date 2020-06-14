import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/blocks_model.dart';
import '../../models/category_model.dart';
import 'hex_color.dart';
import 'package:html/parser.dart';

class CategoryGridList extends StatefulWidget {
  final Block block;
  final List<Category> categories;
  final Function onCategoryClick;
  CategoryGridList({Key key, this.block, this.categories, this.onCategoryClick}) : super(key: key);
  @override
  _CategoryGridListState createState() => _CategoryGridListState();
}

class _CategoryGridListState extends State<CategoryGridList> {
  @override
  Widget build(BuildContext context) {
    List<Category> categories = widget.categories.where((cat) => cat.parent == widget.block.linkId).toList();
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        double.parse(widget.block.paddingLeft.toString()),
        0.0,
        double.parse(widget.block.paddingRight.toString()),
        double.parse(widget.block.paddingBottom.toString()),
      ),
      sliver: SliverGrid(
        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: int.parse(widget.block.layoutGridCol.toString()),
            childAspectRatio: widget.block.childWidth/widget.block.childHeight,
            mainAxisSpacing: widget.block.paddingBetween,
            crossAxisSpacing: widget.block.paddingBetween
        ),
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(double.parse(widget.block.borderRadius.toString())),
                color: HexColor(widget.block.bgColor),
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(double.parse(widget.block.borderRadius.toString())),
                ),
                margin: EdgeInsets.all(0.0),
                clipBehavior: Clip.antiAlias,
                elevation: widget.block.elevation.toDouble(),
                child: InkWell(
                  splashColor: HexColor(widget.block.bgColor).withOpacity(0.1),
                  onTap: () => widget.onCategoryClick(categories[index], widget.categories),
                  child: Column(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 18.0 / 14.0,
                        child: categories[index].image != null ? CachedNetworkImage(
                          imageUrl: categories[index].image,
                          imageBuilder: (context, imageProvider) => Ink.image(
                            child: InkWell(
                              splashColor: HexColor(widget.block.bgColor).withOpacity(0.1),
                              onTap: () => widget.onCategoryClick(categories[index], widget.categories),
                            ),
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                          placeholder: (context, url) =>
                              Container(color: Colors.black12),
                          errorWidget: (context, url, error) => Container(color: Colors.black12),
                        ) : Container(color: Colors.black12),
                      ),
                      SizedBox(height: 10.0),
                      new Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: new Text(
                          _parseHtmlString(categories[index].name),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          childCount: categories.length,
        ),
      ),
    );
  }
}

class CategoryStadiumGridList extends StatefulWidget {
  final Block block;
  final List<Category> categories;
  final Function onCategoryClick;
  CategoryStadiumGridList({Key key, this.block, this.categories, this.onCategoryClick}) : super(key: key);
  @override
  _CategoryStadiumGridListState createState() => _CategoryStadiumGridListState();
}

class _CategoryStadiumGridListState extends State<CategoryStadiumGridList> {
  @override
  Widget build(BuildContext context) {
    List<Category> categories = widget.categories.where((cat) => cat.parent == widget.block.linkId).toList();
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        double.parse(widget.block.paddingLeft.toString()),
        16.0,
        double.parse(widget.block.paddingRight.toString()),
        double.parse(widget.block.paddingBottom.toString()),
      ),
      sliver: SliverGrid(
        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: int.parse(widget.block.layoutGridCol.toString()),
            childAspectRatio: widget.block.childWidth/widget.block.childHeight,
            mainAxisSpacing: widget.block.paddingBetween,
            crossAxisSpacing: widget.block.paddingBetween
        ),
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            return Column(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1,
                    child: Card(
                      shape: StadiumBorder(),
                      margin: EdgeInsets.all(0.0),
                      clipBehavior: Clip.antiAlias,
                      elevation: widget.block.elevation.toDouble(),
                      child: InkWell(
                        splashColor: HexColor(widget.block.bgColor).withOpacity(0.1),
                        onTap: () => widget.onCategoryClick(categories[index], widget.categories),
                        child: categories[index].image != null ? CachedNetworkImage(
                          imageUrl: categories[index].image,
                          imageBuilder: (context, imageProvider) => Ink.image(
                            child: InkWell(
                              splashColor: HexColor(widget.block.bgColor).withOpacity(0.1),
                              onTap: () => widget.onCategoryClick(categories[index], widget.categories),

                            ),
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                          placeholder: (context, url) =>
                              Container(color: Colors.black12),
                          errorWidget: (context, url, error) => Container(color: Colors.black12),
                        ) : Container(color: Colors.black12),
                      ),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    child: new Text(
                      _parseHtmlString(categories[index].name),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
          },
          childCount: categories.length,
        ),
      ),
    );
  }
}

String _parseHtmlString(String htmlString) {
  var document = parse(htmlString);

  String parsedString = parse(document.body.text).documentElement.text;

  return parsedString;
}
