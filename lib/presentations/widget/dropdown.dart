
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kickstart/model/position_model.dart';
import 'package:flutter_kickstart/service/position_service.dart';
import 'package:rxdart/rxdart.dart';

import '../../language_wrapper.dart';
var controls;
class CountriesField extends StatefulWidget {
  final TextEditingController myController;
  final Function validator;
  final Function onPositionSelected;

  const CountriesField({Key key, this.myController, this.validator, this.onPositionSelected}) : super(key: key);
  @override
  _CountriesFieldState createState() => _CountriesFieldState();
}

class _CountriesFieldState extends State<CountriesField> {
  final FocusNode _focusNode = FocusNode();
  OverlayEntry _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  TextEditingController myController;

  var positionsStream = BehaviorSubject<List<Position>>();

  @override
  void dispose() {
    positionsStream.close();
    _focusNode.dispose();
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    myController = widget.myController;
    positionClient().then((onValue){
      positionsStream.add(onValue);
    }).catchError((onError) {
      print("error ${onError.toString()}");
    });

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        this._overlayEntry = this._createOverlayEntry();
        Overlay.of(context).insert(this._overlayEntry);

      } else {
        this._overlayEntry.remove();
      }
    });
    super.initState();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;
    return OverlayEntry(
        builder: (context) => Positioned(
          width: size.width,
          height: 180,
          child: CompositedTransformFollower(
            link: this._layerLink,
            showWhenUnlinked: false,
            offset: Offset(0.0, size.height + 5.0),
            child: Material(
              elevation: 4.0,
              child:
              StreamBuilder(
                stream: positionsStream.stream,
                builder: (context, AsyncSnapshot<List<Position>> snapshot){
                  if(snapshot.hasData && !snapshot.hasError && snapshot.data != null){
                    var positions = snapshot.data;
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: positions.length,
                      itemBuilder: (BuildContext context, int index){
                        return ListTile(
                          title: Text(
                            LanguageWrapper.of(context).getTextByKey(positions[index].toJson(), "name"),
                          ),
                          onTap: () {
                            this._focusNode.unfocus();
                            myController.text = LanguageWrapper.of(context).getTextByKey(positions[index].toJson(), "name");
                            widget.onPositionSelected(positions[index].id);
                          },
                        );
                      },
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                    );
                  }
                  return ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: <Widget>[

                    ],
                  );
                },
              ),
            ),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: this._layerLink,
      child: TextFormField(
        focusNode: this._focusNode,
        readOnly: true,
        controller: myController,
        validator: widget.validator,
        decoration: InputDecoration(
            labelText: LanguageWrapper.of(context).text("position_"),
//            hintText: "Position",
            prefix: Container(
              width: 15,
              height: 15,
              margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Image.asset("assets/images/arrow_down.png"),
            )
        ),
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
