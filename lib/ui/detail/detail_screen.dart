import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:news/services/locator.dart';
import 'package:news/services/offline/readBloc.dart';
import 'package:news/services/offline/recently_read_cubit.dart';
import 'package:news/services/repo/repo.dart';
import 'package:news/utility/models/category_model.dart';
import 'package:news/utility/models/post_detail_model.dart';
import 'package:news/utility/models/post_model.dart';
import 'package:news/utility/models/tag_model.dart';
import 'package:news/utility/utility.dart';
import 'package:share/share.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:news/services/offline/favBloc.dart';

class DetailScreen extends StatefulWidget {
  String _heroId;
  PostModel _post;
  int viewCount;

  DetailScreen(this._heroId, this._post, this.viewCount);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late WpRepsitory wpRepsitory;
  late ScrollController _controller;
  late Future<PostDetailModel> postDetail;
  late Future<List<TagModel>> tagList;
  final FavPostBloc favpostBloc = FavPostBloc();
  final ReadPostBloc readPostBloc = ReadPostBloc();

  late Future<dynamic> favpost;
  bool savedViewCount = false;
  bool isPostViewed = false;

  bool get isEnd {
    if (!_controller.hasClients) return false;
    final maxScroll = _controller.position.maxScrollExtent;
    final currentScroll = _controller.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void checkView() async {
    int view = await Utility.getView(widget._post.id);
    if (view != 0) {
      setState(() {
        isPostViewed = true;
      });
    }
  }

  _scrollListener() {
    if (isEnd && !savedViewCount) {
      Utility.saveView(widget._post.id);
      if (!isPostViewed)
        BlocProvider.of<RecentlyReadCubit>(context).addReadPost(widget._post);
      setState(() {
        savedViewCount = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkView();
    _controller =
        ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    wpRepsitory = getIt.call();
    postDetail = wpRepsitory.getPostDetail(widget._post.id);
    tagList = wpRepsitory.getTagByPostId(widget._post.id);
    favpost = favpostBloc.getFavPost(widget._post.id);
    _controller.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget._post.title
              .replaceAll('&#8220;', '')
              .replaceAll('&#8221;', '')
              .replaceAll('&#8211;', '-'),
          style:
              TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.3),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.share,
              color: Colors.green,
            ),
            onPressed: () {
              Share.share(widget._post.link);
            },
          ),
        ],
      ),
      body: FutureBuilder<PostDetailModel>(
        future: postDetail,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SafeArea(
              child: ListView(
                controller: _controller,
                children: [
                  Stack(
                    children: <Widget>[
                      Container(
                        child: Hero(
                          tag: widget._heroId,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(60.0)),
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.3),
                                  BlendMode.overlay),
                              child: CachedNetworkImage(
                                imageUrl: widget._post.imageUrl!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                placeholder: (context, url) =>
                                    Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Center(
                                  child: Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Positioned(
                      //   top: MediaQuery.of(context).padding.top,
                      //   child: IconButton(
                      //     icon: Icon(Icons.arrow_back),
                      //     color: Colors.white,
                      //     onPressed: () {
                      //       Navigator.of(context).pop();
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                  ListTile(
                    trailing: FutureBuilder<dynamic>(
                        future: favpost,
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data.id != 0000) {
                              return Container(
                                decoration: BoxDecoration(),
                                child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  icon: Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 24.0,
                                  ),
                                  onPressed: () {
                                    // Favourite post
                                    favpostBloc
                                        .deleteFavPostById(widget._post.id);
                                    setState(() {
                                      favpost = favpostBloc
                                          .getFavPost(widget._post.id);
                                    });
                                  },
                                ),
                              );
                            }
                          }
                          return Container(
                            decoration: BoxDecoration(),
                            child: IconButton(
                              padding: EdgeInsets.all(0),
                              icon: Icon(
                                Icons.favorite_border,
                                color: Colors.red,
                                size: 24.0,
                              ),
                              onPressed: () {
                                favpostBloc.addFavPost(widget._post);
                                setState(() {
                                  favpost =
                                      favpostBloc.getFavPost(widget._post.id);
                                });
                              },
                            ),
                          );
                        }),
                    title: Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        "Author - " + widget._post.authorName!,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 1.3),
                      ),
                    ),
                    subtitle: FutureBuilder<List<TagModel>>(
                      future: tagList,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          print(snapshot.data);
                          List<String> tagList =
                              snapshot.data!.map((e) => e.name).toList();
                          if (widget.viewCount == 0) {
                            return Text(
                              timeago.format(
                                      DateTime.parse(widget._post.date)) +
                                  " | " +
                                  getFixedCategoryName(
                                      widget._post.categories[0]) +
                                  " - " +
                                  tagList.join(', '),
                              style: Theme.of(context).textTheme.caption,
                            );
                          } else {
                            return Text(
                              timeago.format(
                                      DateTime.parse(widget._post.date)) +
                                  " | " +
                                  getFixedCategoryName(
                                      widget._post.categories[0]) +
                                  " - " +
                                  tagList.join(', ') +
                                  "\nဖတ်ပြီးသောအကြိမ် - ${widget.viewCount} ကြိမ်",
                              style: Theme.of(context).textTheme.caption,
                            );
                          }
                        } else if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        } else {
                          return LinearProgressIndicator();
                        }
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(18, 10, 22, 50),
                    child: HtmlWidget(snapshot.data!.content,
                        customWidgetBuilder: (element) {},
                        onTapImage: (imageData) {
                      Utility.openImage(imageData.sources.first.url, context);
                    }, onTapUrl: (String? url) async {
                      print(url);
                      await Utility.launchURL(url!);
                      return true;
                    }, webView: true, textStyle: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            if (snapshot.error.toString().contains('SocketException')) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No Internet Connection'),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            postDetail =
                                wpRepsitory.getPostDetail(widget._post.id);
                            tagList =
                                wpRepsitory.getTagByPostId(widget._post.id);
                          });
                        },
                        child: Text('Retry',
                            style: TextStyle(color: Colors.white))),
                  ],
                ),
              );
            } else {
              return Center(child: Text(snapshot.error.toString()));
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
