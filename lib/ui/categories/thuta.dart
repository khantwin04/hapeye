import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:news/services/network/categoryBloc/thuta/thuta_bloc.dart';
import 'package:news/utility/widgets/post_card.dart';

class ThutaScreen extends StatefulWidget {
  const ThutaScreen({Key? key}) : super(key: key);

  @override
  _ThutaScreenState createState() => _ThutaScreenState();
}

class _ThutaScreenState extends State<ThutaScreen> {
  late ScrollController _controller;
  late ThutaBloc bloc;

  bool get isEnd {
    if (!_controller.hasClients) return false;
    final maxScroll = _controller.position.maxScrollExtent;
    final currentScroll = _controller.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  _scrollListener() {
    if (isEnd) {
      bloc.add(ThutaFetched());
    }
  }

  @override
  void initState() {
    _controller =
        ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    bloc = context.read<ThutaBloc>();
    bloc.add(ThutaFetched());
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
        title: Text('သုတ'),
      ),
      body: BlocBuilder<ThutaBloc, ThutaState>(
        builder: (context, state) {
          switch (state.status) {
            case ThutaStatus.failure:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Failed to fetch Post List'),
                    TextButton(
                        onPressed: () {
                          BlocProvider.of<ThutaBloc>(context).setPage = 0;
                          BlocProvider.of<ThutaBloc>(context)
                              .add(ThutaReload());
                        },
                         child: Text('Retry', style: TextStyle(color: Colors.white))),
                  ],
                ),
              );
            case ThutaStatus.success:
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
