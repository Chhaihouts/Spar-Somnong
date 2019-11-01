import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class OrderWidget extends StatefulWidget {
  final Function increaseOnPress;
  final Function decreaseOnPress;
  final Function inputOnPress;

  final int quantity;
  final TextFormField textFormField;

  OrderWidget(
      {this.increaseOnPress, this.decreaseOnPress, this.quantity, this.inputOnPress, this.textFormField});

  @override
  State<StatefulWidget> createState() {
    return _OrderState();
  }
}

class _OrderState extends State<OrderWidget> {

  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    textEditingController.text = widget.quantity.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width / 4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: widget.decreaseOnPress,
            child: Container(
                width: 25,
                height: 25,
                margin: EdgeInsets.only(right: 5),
                color: Theme
                    .of(context)
                    .accentColor,
                alignment: Alignment.center,
                child: Icon(
                  Icons.remove,
                  color: Colors.white,
                )
            ),
          ),
          Container(
              width: 20,
              child: TextFormField(
                controller: textEditingController,
                textAlign: TextAlign.center,
              )
          ),
          InkWell(
            onTap: widget.increaseOnPress,
            child: Container(
                width: 25,
                height: 25,
                margin: EdgeInsets.only(left: 5),
                color: Theme
                    .of(context)
                    .accentColor,
                alignment: Alignment.center,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                )
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}
