import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/services/network/categoryBloc/get_category_cubit.dart';
import 'package:news/ui/detail/category_detail.dart';
import 'package:news/ui/detail/favoutite_screen.dart';
import 'package:news/ui/detail/recently_read_post_screen.dart';
import 'package:news/utility/models/category_model.dart';
import 'package:news/utility/utility.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
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
          title: Text('Menu'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              onTap: () {
                Utility.routeTo(context, FavouriteScreen());
              },
              leading: Icon(
                Icons.favorite,
              ),
              title: Text(
                'မှတ်ထားသောပို့စ်များ',
              ),
            ),
            Divider(),
            ListTile(
              onTap: () {
                Utility.routeTo(context, RecentlyReadScreen());
              },
              leading: Icon(
                Icons.article,
              ),
              title: Text(
                'ဖတ်ဖူးခဲ့သောပို့စ်များ',
              ),
            ),
            Divider(),
            ListTile(
              onTap: () {
                Utility.launchURL('https://hapeye.net');
              },
              leading: Icon(Icons.web),
              title: Text('ဝက်ဘ်ဆိုဒ်ကြည့်ရန်'),
            ),
            Divider(),
            Spacer(),
            Text('Powered By\nHap Eye Co., Ltd.\nDigitalMarketing.com.mm',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 10))
          ],
        ),
      ),
    );
  }
}
