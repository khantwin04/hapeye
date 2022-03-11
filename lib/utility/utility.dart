import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class Utility {
  static Future<int> getView(int postId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int viewData = 0;
    if (pref.getInt('$postId') != null) {
      int viewCount = pref.getInt('$postId')!;
      viewData = viewCount;
    }
    return viewData;
  }

  static Future<void> saveView(int postId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getInt('$postId') == null) {
      pref.setInt('$postId', 1);
    } else {
      int viewCount = pref.getInt('$postId')!;
      print(viewCount);
      pref.setInt('$postId', ++viewCount);
    }
  }

  static Future<void> launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  static routeTo(BuildContext context, Widget widget) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => widget,
    ));
  }

  static openImage(String imageUrl, BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            body: PhotoView(
              imageProvider: CachedNetworkImageProvider(
                imageUrl,
              ),
            ),
          );
        },
      ),
    );
  }
}
