import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:news/services/network/get_all_post_bloc/get_all_post_bloc.dart';
import 'package:news/services/network/latestPostBloc/get_latest_post_cubit.dart';
import 'package:news/ui/categories/buddha.dart';
import 'package:news/ui/categories/business.dart';
import 'package:news/ui/categories/education.dart';
import 'package:news/ui/categories/ganbiya.dart';
import 'package:news/ui/categories/history.dart';
import 'package:news/ui/categories/it.dart';
import 'package:news/ui/categories/live.dart';
import 'package:news/ui/categories/philo.dart';
import 'package:news/ui/categories/thuta.dart';
import 'package:news/ui/categories/yatha.dart';
import 'package:news/ui/detail/category_detail.dart';
import 'package:news/ui/detail/detail_screen.dart';
import 'package:news/ui/detail/search_screen.dart';
import 'package:news/utility/models/category_model.dart';
import 'package:news/utility/models/post_model.dart';
import 'package:news/utility/utility.dart';
import 'package:news/utility/widgets/header_widget.dart';
import 'package:news/utility/widgets/post_card.dart';
import 'package:news/utility/widgets/recently_read_post_card.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'end_drawer.dart';
import 'my_drawer.dart';

class NewHomeScreen extends StatefulWidget {
  const NewHomeScreen({Key? key}) : super(key: key);

  @override
  _NewHomeScreenState createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen> {
  late ScrollController _controller;
  late GetAllPostBloc bloc;

  bool get isEnd {
    if (!_controller.hasClients) return false;
    final maxScroll = _controller.position.maxScrollExtent;
    final currentScroll = _controller.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  _scrollListener() {
    if (isEnd) {
      bloc.add(GetAllPostFetched());
    }
  }

  @override
  void initState() {
    _controller =
        ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    bloc = context.read<GetAllPostBloc>();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    List<PostModel> postList =
        BlocProvider.of<GetLatestPostCubit>(context, listen: false).getAllPost;

    return Scaffold(
      key: _scaffoldkey,
      drawer: MyDrawer(),
      endDrawer: EndDrawer(),
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 20,
            ),
            SizedBox(
              width: 10,
            ),
            Text('HapEye.net'),
          ],
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(),
                  ),
                );
              }),
          IconButton(
              icon: Icon(Icons.subdirectory_arrow_right_sharp),
              onPressed: () {
                _scaffoldkey.currentState!.openEndDrawer();
              }),
        ],
      ),
      body: BlocBuilder<GetLatestPostCubit, GetLatestPostState>(
        builder: (context, state) {
          if (state is GetLatestPostSuccess) {
            return SingleChildScrollView(
              controller: _controller,
              child: Column(
                children: [
                  // Container(
                  //   height: 50,
                  //   child: ListView.builder(
                  //     itemCount: categoryList.length,
                  //     scrollDirection: Axis.horizontal,
                  //     itemBuilder: (context, index) {
                  //       CategoryModel category = categoryList[index];
                  //       return Padding(
                  //         padding: const EdgeInsets.only(left: 15.0),
                  //         child: Chip(label: Text(category.name)),
                  //       );
                  //     },
                  //   ),
                  // ),
                  SizedBox(
                    height: 10,
                  ),

                  CarouselSlider(
                    options: CarouselOptions(
                      height: 200.0,
                      autoPlay: false,
                      disableCenter: true,
                      autoPlayInterval: Duration(seconds: 5),
                      autoPlayAnimationDuration: Duration(milliseconds: 4000),
                      autoPlayCurve: Curves.ease,
                      enlargeCenterPage: false,
                      pauseAutoPlayOnTouch: true,
                      pageSnapping: true,
                      viewportFraction: 0.98,
                    ),
                    items: state.postList.map((i) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () async {
                            int viewCount = await Utility.getView(i.id);
                            final heroId =
                                i.id.toString() + UniqueKey().toString();
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  DetailScreen(heroId, i, viewCount),
                            ));
                          },
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: CachedNetworkImage(
                                    imageUrl: i.imageUrl!,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        Center(
                                      child: Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  child: Container(
                                      height: 200, color: Colors.black38),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: ListTile(
                                    title: Text(
                                      timeago
                                              .format(DateTime.parse(i.date))
                                              .toString() +
                                          " • " +
                                          getFixedCategoryName(i.categories[0]),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                    subtitle: Text(
                                        i.title
                                            .replaceAll('&#8220;', '')
                                            .replaceAll('&#8221;', ''),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 5,
                  ),

                  RecentlyReadPostShortcut(),
                  HeaderWidget('ကဏ္ဍများ'),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 80,
                    padding: EdgeInsets.all(10.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: localCategoryList.length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          switch (localCategoryList[index].id) {
                            case 1:
                              Utility.routeTo(context, ThutaScreen());
                              break;
                            case 4:
                              Utility.routeTo(context, YathaScreen());
                              break;
                            case 5:
                              Utility.routeTo(context, BuddhaScreen());
                              break;
                            case 6:
                              Utility.routeTo(context, HistoryScreen());
                              break;
                            case 7:
                              Utility.routeTo(context, LiveScreen());
                              break;
                            case 8:
                              Utility.routeTo(context, EducationScreen());
                              break;
                            case 9:
                              Utility.routeTo(context, PhiloScreen());
                              break;
                            case 10:
                              Utility.routeTo(context, GanbiyaScreen());
                              break;
                            case 11:
                              Utility.routeTo(context, BusinessScreen());
                              break;
                            case 12:
                              Utility.routeTo(context, ItScreen());
                              break;
                            default:
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    CategoryDetail(localCategoryList[index]),
                              ));
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(5.0),
                          height: 80,
                          width: 120,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(3.0),
                                  child: ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                        Colors.black26, BlendMode.darken),
                                    child: new Image(
                                        image: AssetImage(
                                            localCategoryList[index].link),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    localCategoryList[index].name,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  BlocBuilder<GetAllPostBloc, GetAllPostState>(
                    builder: (context, state) {
                      switch (state.status) {
                        case GetAllPostStatus.failure:
                          return Center(
                            child: Column(
                              children: [
                                Text('Failed to fetch Post List'),
                                TextButton(
                                    onPressed: () {
                                      BlocProvider.of<GetAllPostBloc>(context)
                                          .setPage = 0;
                                      BlocProvider.of<GetAllPostBloc>(context)
                                          .add(GetAllPostReload());
                                    },
                                    child: Text('Retry')),
                              ],
                            ),
                          );
                        case GetAllPostStatus.success:
                          if (state.postList.isEmpty) {
                            return Center(
                              child: Text('No Post'),
                            );
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: AnimationLimiter(
                              child: ListView.separated(
                                  separatorBuilder: (context, index) => Divider(
                                        color: Colors.black54,
                                      ),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: state.hasReachedMax
                                      ? state.postList.length
                                      : state.postList.length + 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (index >= state.postList.length) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text('Data အသစ်များရယူ နေပါပြီ'),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child: LinearProgressIndicator(),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return AnimationConfiguration
                                          .staggeredList(
                                        position: index,
                                        duration:
                                            const Duration(milliseconds: 375),
                                        child: ScaleAnimation(
                                          child: FadeInAnimation(
                                            child: PostCard(
                                                context, state.postList[index]),
                                          ),
                                        ),
                                      );
                                    }
                                  }),
                            ),
                          );
                        default:
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                      }
                    },
                  )
                ],
              ),
            );
          } else if (state is GetLatestPostFail) {
            if (state.error.contains('SocketException')) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No Internet Connection'),
                    ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<GetLatestPostCubit>(context)
                              .getLatestPost(1);
                          BlocProvider.of<GetAllPostBloc>(context).setPage = 0;
                          BlocProvider.of<GetAllPostBloc>(context)
                              .add(GetAllPostReload());
                        },
                        child: Text(
                          'Retry',
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                ),
              );
            } else {
              return Center(
                child: Text(state.error),
              );
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
