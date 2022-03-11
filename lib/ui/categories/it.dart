import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:news/services/network/categoryBloc/it/it_bloc.dart';
import 'package:news/utility/widgets/post_card.dart';

class ItScreen extends StatefulWidget {
  const ItScreen({Key? key}) : super(key: key);

  @override
  _ItScreenState createState() => _ItScreenState();
}

class _ItScreenState extends State<ItScreen> {
  late ScrollController _controller;
  late ItBloc bloc;

  bool get isEnd {
    if (!_controller.hasClients) return false;
    final maxScroll = _controller.position.maxScrollExtent;
    final currentScroll = _controller.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  _scrollListener() {
    if (isEnd) {
      bloc.add(ItFetched());
    }
  }

  @override
  void initState() {
    _controller =
        ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    bloc = context.read<ItBloc>();
    bloc.add(ItFetched());
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
        title: Text('အိုင်တီ'),
      ),
      body: BlocBuilder<ItBloc, ItState>(
        builder: (context, state) {
          switch (state.status) {
            case ItStatus.failure:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Failed to fetch Post List'),
                    TextButton(
                        onPressed: () {
                          BlocProvider.of<ItBloc>(context).setPage = 0;
                          BlocProvider.of<ItBloc>(context).add(ItReload());
                        },
                         child: Text('Retry', style: TextStyle(color: Colors.white))),
                  ],
                ),
              );
            case ItStatus.success:
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
