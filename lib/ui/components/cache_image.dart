
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CacheImage extends StatelessWidget {
  final String? url;
  final IconData failedIcon;
  CacheImage({this.url,required this.failedIcon});
  @override
  Widget build(BuildContext context) {
    var url = this.url;
    if (url != null) {
      return CachedNetworkImage(
        imageUrl: url,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        progressIndicatorBuilder:
            (context, url, downloadProgress) =>
            Icon(failedIcon,color: Colors.white,),
        errorWidget: (context, url, error) =>
            Icon(Icons.error,color:Colors.white),
      );
    }
    return Container(
      color: Colors.pinkAccent,
      child: Center(
        child: Icon(
          failedIcon,
            color:Colors.white
        ),
      ),
    );
  }
}
