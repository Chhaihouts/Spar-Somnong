import 'package:flutter/cupertino.dart';
import 'package:flutter_kickstart/environment/config.dart';
import 'package:flutter_kickstart/environment/dev.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewer extends StatelessWidget {
  final String image;

  PhotoViewer({this.image});
  
  @override
  Widget build(BuildContext context) {
    var appConfig = Config.fromJson(config);
    print("image is ${this.image}");
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 300,
        child: PhotoView(
          imageProvider: NetworkImage(
              "${this.image != null ? "${appConfig.baseUrl}/${this.image}" : "assets/images/placeholder.png"}"),
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 1.1,
          initialScale: PhotoViewComputedScale.covered * 1.1,
        )
    );
  }
}
