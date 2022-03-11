import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/services/network/latestPostBloc/get_search_result_cubit.dart';
import 'package:news/utility/models/post_model.dart';
import 'package:news/utility/widgets/post_card.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late ScrollController _controller;
  int page = 1;
  late bool loadMore;
  String searchText = '';
  bool searching = false;
  bool hasBeenSearched = false;
  // List<PostModel> postList;

  _scrollListener() {
    var isEnd = _controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange;
    if (isEnd) {
      setState(() {
        page += 1;
        BlocProvider.of<GetSearchResultCubit>(context, listen: false)
            .searchPost(searchText, page);
      });
    }
  }

  @override
  void initState() {
    super.initState();
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

  void search() {
    setState(() {
      page = 1;
      searching = true;
    });
    BlocProvider.of<GetSearchResultCubit>(context, listen: false)
        .searchPost(searchText, page);
  }

  @override
  Widget build(BuildContext context) {
    List<PostModel> postList =
        BlocProvider.of<GetSearchResultCubit>(context, listen: false)
            .getAllSearchList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Type name',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.search,
                  onChanged: (text) {
                    searchText = text;
                  },
                  onFieldSubmitted: (text) {
                    search();
                  },
                  autofocus: true,
                ),
              ),
              Expanded(
                child: BlocConsumer<GetSearchResultCubit, GetSearchResultState>(
                  listener: (context, state) {
                    if (state is GetSearchResultSuccess) {
                      setState(() {
                        loadMore = false;
                        searching = false;
                        hasBeenSearched = true;
                      });
                    } else if (state is GetSearchResultLoading) {
                      setState(() {
                        loadMore = true;
                      });
                    }
                  },
                  builder: (context, state) {
                    if (state is GetSearchResultLoading &&
                        postList.length == 0 &&
                        searching) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is GetSearchResultFail) {
                      if (state.error.contains('SocketException')) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('No Internet Connection'),
                              ElevatedButton(
                                  onPressed: () {
                                    search();
                                  },
                                   child: Text('Retry', style: TextStyle(color: Colors.white))),
                            ],
                          ),
                        );
                      } else {
                        return Center(
                          child: Text(state.error),
                        );
                      }
                    } else {
                      return Column(
                        children: [
                          postList.isEmpty && hasBeenSearched
                              ? Expanded(
                                  child: Container(
                                    height: 150,
                                    child: Center(
                                      child: Text('No Data Found'),
                                    ),
                                  ),
                                )
                              : Expanded(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
