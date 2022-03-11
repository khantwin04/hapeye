import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/services/offline/readBloc.dart';
import 'package:news/services/offline/recently_read_cubit.dart';
import 'package:news/ui/detail/detail_screen.dart';
import 'package:news/utility/models/post_model.dart';
import 'package:news/utility/utility.dart' as utility;

import 'header_widget.dart';

class RecentlyReadPostShortcut extends StatefulWidget {
  const RecentlyReadPostShortcut({Key? key}) : super(key: key);

  @override
  _RecentlyReadPostShortcutState createState() =>
      _RecentlyReadPostShortcutState();
}

class _RecentlyReadPostShortcutState extends State<RecentlyReadPostShortcut> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return postList();
  }

  Widget postList() {
    return BlocBuilder<RecentlyReadCubit, RecentlyReadState>(
      builder: (context, state) {
        if (state is RecentlyReadSuccess) {
          if (state.postList.length == 0) return Container();
          var list = state.postList;
          list.sort((a, b) => b.date.compareTo(a.date));
          return Container(
            height: 150,
            child: Column(
              children: [
                HeaderWidget('ဖတ်ဖူးခဲ့သောပို့စ်များ'),
                SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(left: 7.0),
                    scrollDirection: Axis.horizontal,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          int viewCount =
                              await utility.Utility.getView(list[index].id);
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DetailScreen(
                                list[index].id.toString(),
                                list[index],
                                viewCount),
                          ));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                          child: Stack(
                            children: [
                              Hero(
                                tag: list[index].id,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: CachedNetworkImage(
                                    imageUrl: list[index].imageUrl!,
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        Center(
                                      child: Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                  child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                alignment: Alignment.center,
                                height: 120,
                                width: 120,
                                color: Colors.black26,
                                child: Text(
                                  list[index].title,
                                  style: TextStyle(
                                      color: Colors.white, height: 1.2),
                                  textAlign: TextAlign.center,
                                ),
                              )),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (state is RecentlyReadFail) {
          return Container(
              height: 500,
              alignment: Alignment.center,
              child: Text("${state.error}"));
        }
        return Container(
          alignment: Alignment.center,
          height: 400,
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
