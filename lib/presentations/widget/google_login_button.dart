import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kickstart/service/facebook_service.dart';

enum Method {
  google,
  facebook,
}
class GoogleLoginButton extends StatelessWidget{
  final String icon;
  final String title;
  final String social;
  final Function onPress;

  GoogleLoginButton({Key key, this.icon , this.title, this.social, this.onPress}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(5)
      ),
      color: Color(0xffF4F4F4),
      child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
          child: Builder(
            builder: (context){
              if(icon != null){
                return Row(
                  children: <Widget>[
                    Image.asset(
                        icon,
                      width: 21,
                      height: 21,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return Row(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Raleway',
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          )
      ),
      onPressed: this.onPress,
    );
  }

}