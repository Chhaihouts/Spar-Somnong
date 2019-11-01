import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_kickstart/environment/config.dart';
import 'package:flutter_kickstart/environment/dev.dart';
import 'package:flutter_kickstart/model/product_in_category_model.dart';

import '../../language_wrapper.dart';
import '../../languge_config.dart';

class ProductItem extends StatefulWidget {
  final ProductCategory productCategory;

  const ProductItem({this.productCategory});

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  var appConfig = Config.fromJson(config);
  var dis = false;

  @override
  void initState() {
    if (widget.productCategory != null &&
        widget.productCategory.prices != null && widget.productCategory.prices.length > 0) {
      double discount = widget.productCategory.prices[0].discount_dollar;
      if (discount > 0)
        setState(() {
          dis = true;
        });
      else
        setState(() {
          dis = false;
        });
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    LanguageConfig languageConfig = LanguageWrapper.of(context);
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(bottom: 4, top: 4, left: 4, right: 4),
                  child: FadeInImage(
                    width: 95,
//                    height: 95,
                    fit: BoxFit.fill,
                    image: (widget.productCategory.item_img != null &&
                            widget.productCategory.item_img != "" &&
                            !widget.productCategory.item_img.contains("base64"))
                        ? NetworkImage(widget.productCategory.item_img
                                .contains("http")
                            ? widget.productCategory.item_img
                            : "${appConfig.baseUrl}/${widget.productCategory.item_img}")
                        : Container(child: Image(
                        width: 95,
                        fit: BoxFit.fill,
                        image: AssetImage("assets/images/placeholder.png"))),
                    placeholder: AssetImage("assets/images/placeholder.png"),
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(left: 5, right: 5),
            margin: EdgeInsets.only(bottom: 4),
            child: Text(
              "${languageConfig.getTextByKey(widget.productCategory.toJson(), "name")}",
              style: TextStyle(
                fontSize: 12,

              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
              "\$ ${(widget.productCategory.prices.length != 0 && widget.productCategory.prices != null) ? "${widget.productCategory.prices[0].price} / ${widget.productCategory.prices[0].uom.name_en}" : "N/A"}",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  decoration:
                      (dis == true) ? TextDecoration.lineThrough : null)),
          (dis)
              ? Text(
              "${(widget.productCategory.prices.length != 0 &&
                  widget.productCategory.prices != null)
                  ? "${languageConfig.getCurrencyValue(widget.productCategory.prices[0].price - widget.productCategory.prices[0].discount_dollar)} / ${languageConfig.getTextByKey(widget.productCategory.prices[0].uom.toJson(), "name")}"
                  : "N/A"}",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500))
              : SizedBox.shrink()
        ],
      ),
    );
  }
}
