import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:news/ui/detail/detail_screen.dart';
import 'package:news/utility/models/category_model.dart';
import 'package:news/utility/models/post_model.dart';
import 'package:news/utility/utility.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

Widget PostCard(BuildContext context, PostModel post) {
  final heroId = post.id.toString() + UniqueKey().toString();
  return InkWell(
    onTap: () async {
      int viewCount = await Utility.getView(post.id);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DetailScreen(heroId, post, viewCount),
      ));
    },
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            children: [
              Hero(
                tag: heroId,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: CachedNetworkImage(
                    imageUrl: post.imageUrl!,
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Center(
                      child: Icon(Icons.error),
                    ),
                  ),
                ),
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black26,
                    child: Text(
                      getFixedCategoryName(post.categories[0]),
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  )),
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 23.0),
                  child: Text(
                    post.title
                        .replaceAll('&#8220;', '')
                        .replaceAll('&#8221;', '')
                        .replaceAll('&#8211;', '-'),
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600, height: 1.3),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Html(
                      data: post.excerpt.length > 60
                          ? '${post.excerpt.substring(0, 60)}....'
                          : post.excerpt),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.timer,
                        color: Colors.black45,
                        size: 12.0,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        timeago.format(
                          DateTime.parse(post.date),
                        ),
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.person,
                        color: Colors.black45,
                        size: 12.0,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        post.authorName ?? '',
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
