import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:news/services/network/categoryBloc/ganbiya/ganbiya_bloc.dart';
import 'package:news/utility/widgets/post_card.dart';

class GanbiyaScreen extends StatefulWidget {
  const GanbiyaScreen({Key? key}) : super(key: key);

  @override
  _GanbiyaScreenState createState() => _GanbiyaScreenState();
}

class _GanbiyaScreenState extends State<GanbiyaScreen> {
  late ScrollController _controller;
  late GanbiyaBloc bloc;

  bool get isEnd {
    if (!_controller.hasClients) return false;
    final maxScroll = _controller.position.maxScrollExtent;
    final currentScroll = _controller.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  _scrollListener() {
    if (isEnd) {
      bloc.add(GanbiyaFetched());
    }
  }

  @override
  void initState() {
    _controller =
        ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    bloc = context.read<GanbiyaBloc>();
    bloc.add(GanbiyaFetched());
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ဂမ်ဘီရ'),
      ),
      body: BlocBuilder<GanbiyaBloc, GanbiyaState>(
        builder: (context, state) {
          switch (state.status) {
            case GanbiyaStatus.failure:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Failed to fetch Post List'),
                    TextButton(
                        onPressed: () {
                          BlocProvider.of<GanbiyaBloc>(context).setPage = 0;
                          BlocProvider.of<GanbiyaBloc>(context)
                              .add(GanbiyaReload());
                        },
                        child: Text('Retry', style: TextStyle(color: Colors.white))),
                  ],
                ),
              );
            case GanbiyaStatus.success:
              if (state.postList.isEmpty) {
                return Center(
                  child: Text('No Post'),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: AnimationLimiter(
                  child: ListView.builder(
                      controller: _controller,
                      itemCount: state.hasReachedMax
                          ? state.postList.length
                          : state.postList.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index >= state.postList.length) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: ScaleAnimation(
                              child: FadeInAnimation(
                                child: PostCard(context, state.postList[index]),
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
      ),
    );
  }
}
