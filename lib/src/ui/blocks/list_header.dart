import 'package:flutter/material.dart';
import '../../models/blocks_model.dart';

import 'hex_color.dart';


class ListHeader extends StatefulWidget {

  final Block block;
  ListHeader({Key key, this.block}) : super(key: key);

  @override
  _ListHeaderState createState() => _ListHeaderState();
}

class _ListHeaderState extends State<ListHeader> {

  @override
  Widget build(BuildContext context) {

    Color bgColor = HexColor(widget.block.bgColor);
    double textAlign = headerAlign(widget.block.headerAlign);
    TextStyle subhead = Theme.of(context).brightness != Brightness.dark
        ? Theme.of(context).textTheme.subhead
        .copyWith(fontWeight: FontWeight.w600, color: HexColor(
        widget.block.titleColor)) : Theme.of(context).textTheme.subhead
        .copyWith(fontWeight: FontWeight.w600);

    return textAlign != null
        ? Container(
        padding: EdgeInsets.fromLTRB(
            widget.block.paddingBetween + 4,
            double.parse(
                widget.block.paddingTop.toString()),
            widget.block.paddingBetween + 4,
            16.0),
        color: Theme.of(context).brightness != Brightness.dark
            ? bgColor
            : Theme.of(context).canvasColor,
        alignment: Alignment(textAlign, 0),
        child: Text(
          widget.block.title,
          textAlign: TextAlign.start,
          style: subhead,
        ))
        : Container(
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.fromLTRB(
          widget.block.paddingBetween,
          double.parse(
              widget.block.paddingTop.toString()),
          widget.block.paddingBetween,
          0.0),
      color: Theme.of(context).brightness != Brightness.dark
          ? bgColor
          : Theme.of(context).canvasColor,
    );;
  }

  double headerAlign(String align) {
    switch (align) {
      case 'top_left':
        return -1;
      case 'top_right':
        return 1;
      case 'top_center':
        return 0;
      case 'floating':
        return 2;
      case 'none':
        return null;
      default:
        return -1;
    }
  }
}

