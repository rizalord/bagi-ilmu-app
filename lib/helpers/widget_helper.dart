import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class WidgetHelper {
  // ignore: non_constant_identifier_names
  static Widget ImageLoader(String url) {
    try {
      return CachedNetworkImage(
        useOldImageOnUrlChange: true,
        imageUrl: url,
        placeholder: (context, url) => Container(),
        errorWidget: (context, url, error) {
          return Image.asset('assets/images/404.jpg');
        },
        fit: BoxFit.cover,
      );
    } catch (e) {
      return Image.asset('assets/images/404.jpg');
    }
  }
}
