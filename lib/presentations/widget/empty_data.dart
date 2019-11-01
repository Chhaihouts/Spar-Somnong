import 'package:flutter/material.dart';

class EmptyData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(
              width: 40,
              height: 40.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/icons/no_data.png")),
              )),
          Container(
            margin: EdgeInsets.all(16),
            child: Text(
              "NO DATA",
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black26,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
