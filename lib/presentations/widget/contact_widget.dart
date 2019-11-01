import 'package:flutter/cupertino.dart';

class ContactWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ContactState();
  }
}

class _ContactState extends State<ContactWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            return Text("Hello $index");
          }),
    );
  }
}
