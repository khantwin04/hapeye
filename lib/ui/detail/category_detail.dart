import 'package:news/services/network/latestPostBloc/get_latest_post_cubit.dart';
import 'package:news/utility/models/category_model.dart';
import 'package:news/utility/models/post_model.dart';
import 'package:news/utility/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryDetail extends StatefulWidget {
  final CategoryModel category;

  CategoryDetail(this.category);

  @override
  _CategoryDetailState createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {
  late ScrollController _controller;
  int page = 1;
  late bool loadMore;

  // List<PostModel> postList;

  _scrollListener() {
    var isEnd = _controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange;
    if (isEnd) {
      setState(() {
        page += 1;
        BlocProvider.of<GetLatestPostCubit>(context, listen: false)
            .getPostByCategory(widget.category.id, page);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetLatestPostCubit>(context, listen: false)
        .getPostByCategory(widget.category.id, page);
    _controller =
        ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    _controller.addListener(_scrollListener);
    loadMore = false;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<PostModel> postList =
        BlocProvider.of<GetLatestPostCubit>(context, listen: false)
            .getAllFilterPost();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
      ),
      body: BlocConsumer<GetLatestPostCubit, GetLatestPostState>(
        listener: (context, state) {
          if (state is GetLatestPostSuccess) {
            setState(() {
              loadMore = false;
            });
          } else if (state is GetLatestPostLoading) {
            setState(() {
              loadMore = true;
            });
          }
        },
        builder: (context, state) {
          if (state is GetLatestPostLoading && postList.length == 0) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GetLatestPostFail) {
            return Center(
              child: Text(state.error),
            );
          } else {
            return Column(
              children: [
                Expanded(
                  child: Scrollbar(
                    child: ListView.builder(
                      controller: _controller,
                      itemCount: postList.length,
                      itemBuilder: (context, index) =>
                          PostCard(context, postList[index]),
                    ),
                  ),
                ),
                Container(
                  child: Center(
                    child: LinearProgressIndicator(),
                  ),
                  height: loadMore ? 20 : 0,
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
