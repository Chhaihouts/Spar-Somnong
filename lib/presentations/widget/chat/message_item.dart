import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kickstart/data_provider/user_provider.dart';
import 'package:flutter_kickstart/environment/config.dart';
import 'package:flutter_kickstart/environment/dev.dart';
import 'package:flutter_kickstart/model/chat_model.dart';
import 'package:flutter_kickstart/model/user.dart';
import 'package:flutter_kickstart/presentations/widget/audio_widget.dart';
import 'package:flutter_kickstart/presentations/widget/photo_viewer.dart';
import 'package:provider/provider.dart';

class MessageItem extends StatefulWidget {
  final Message message;
  final int id;

  MessageItem(this.message, this.id);

  @override
  State<StatefulWidget> createState() {
    return _ChatItemState();
  }
}

class _ChatItemState extends State<MessageItem> {
  var appConfig = Config.fromJson(config);

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context, listen: false).getUser();
    return Container(
      child: dynamicContent(context, widget.message, user),
    );
  }

  dynamicContent(BuildContext context, Message message, UserModel user) {
    switch (message.type) {
      case 1:
        {
          return textItem(message, user, context);
        }
        break;
      case 2:
        {
          return imageItem(message, user, context);
        }
        break;
      case 3:
        {
          return audioItem(message, user, context);
        }
        break;
    }
  }

  textItem(Message message, UserModel user, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 10, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
              width: 35,
              height: 35,
              child:
              CircleAvatar(
                  radius: 50.0,
                  backgroundImage: widget.id == user.id ? NetworkImage(
                    "${appConfig.baseUrl}/${user.photo}",
                  ) : AssetImage("assets/icons/account.png")
              )
          ),
          Card(
            margin: EdgeInsets.only(right: 15),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Text("${message.data}",
                  overflow: TextOverflow.ellipsis, softWrap: true,),
            ),
          )
        ],
      ),
    );
  }

  imageItem(Message message, UserModel user, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PhotoViewer(image: message.data,),
            ));
      },
      child: Container(
          margin: EdgeInsets.only(left: 5, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  width: 35,
                  height: 35,
                  child:
                  CircleAvatar(
                      radius: 50.0,
                      backgroundImage: widget.id == user.id ? NetworkImage(
                        "${appConfig.baseUrl}/${user.photo}",
                      ) : AssetImage("assets/icons/account.png")
                  )
              ),
              Card(
                child: FadeInImage(
                  width: 250,
                  height: 150,
                  fit: BoxFit.cover,
                  image: (message.data != null && message.data != "" &&
                      !message.data.contains("base64")) ? NetworkImage(
                      message.data.contains("http")
                          ? message.data
                          : "${appConfig
                          .baseUrl}/${message.data}") : AssetImage(
                      "assets/images/placeholder.png"),
                  placeholder: AssetImage("assets/images/placeholder.png"),
                ),
              )
            ],
          )
      ),
    );
  }

  audioItem(Message message, UserModel user, BuildContext context) {

    return Container(
        margin: EdgeInsets.only(left: 5, right: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                width: 35,
                height: 35,
                child:
                CircleAvatar(
                    radius: 50.0,
                    backgroundImage: widget.id == user.id ? NetworkImage(
                      "${appConfig.baseUrl}/${user.photo}",
                    ) : AssetImage("assets/icons/account.png")
                )
            ),
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width - 100,
              child: Card(
                child: AudioWidget(message.data),
              ),
            )
          ],
        ));
  }
}
