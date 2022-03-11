import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/services/network/categoryBloc/get_category_cubit.dart';
import 'package:news/ui/detail/category_detail.dart';
import 'package:news/ui/detail/favoutite_screen.dart';
import 'package:news/ui/detail/recently_read_post_screen.dart';
import 'package:news/ui/home/tag_webview.dart';
import 'package:news/utility/models/category_model.dart';
import 'package:news/utility/utility.dart';

class EndDrawer extends StatefulWidget {
  const EndDrawer({Key? key}) : super(key: key);

  @override
  _EndDrawerState createState() => _EndDrawerState();
}

class _EndDrawerState extends State<EndDrawer> {
  late ScrollController controller;

  int page = 1;

  late bool loadMore;

  _scrollListener() {
    var isEnd = controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange;
    if (isEnd) {
      setState(() {
        page += 1;
        BlocProvider.of<GetCategoryCubit>(context, listen: false)
            .getCategory(page);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    controller =
        ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    controller.addListener(_scrollListener);
    loadMore = false;
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<CategoryModel> categoryList =
        BlocProvider.of<GetCategoryCubit>(context, listen: false)
            .getAllCategory();

    return Drawer(
      child: Scaffold(
        appBar: AppBar(
          // leading: IconButton(
          //   icon: Icon(Icons.cancel_outlined),
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //   },
          // ),
          title: Text('ကဏ္ဍများ'),
        ),
        body: ListView(
          children: [
            Column(
              children: localCategoryList.map((c) {
                if (c.id != 10) {
                  return ExpansionTile(
                      title: Text(c.name),
                      children: getSubList(c.id)
                          .map((e) => ListTile(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        TagWebView(name: e.name, url: e.link),
                                  ));
                                },
                                title: Text(e.name),
                              ))
                          .toList());
                } else {
                  return Container();
                }
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
