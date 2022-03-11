import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/services/offline/readBloc.dart';
import 'package:news/services/offline/recently_read_cubit.dart';
import 'package:news/utility/models/post_model.dart';
import 'package:news/utility/widgets/post_card.dart';

class RecentlyReadScreen extends StatefulWidget {
  @override
  _RecentlyReadScreenState createState() => _RecentlyReadScreenState();
}

class _RecentlyReadScreenState extends State<RecentlyReadScreen> {
  final ReadPostBloc ReadpostBloc = ReadPostBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("ဖတ်ဖူးခဲ့သောပို့စ်များ"),
        elevation: 0,
        actions: [
          TextButton(
              child: Text('Clear List  '),
              onPressed: () {
                BlocProvider.of<RecentlyReadCubit>(context).deleteAll();
              })
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical, child: categoryPosts()),
      ),
    );
  }

  Widget categoryPosts() {
    return BlocBuilder<RecentlyReadCubit, RecentlyReadState>(
      builder: (context, state) {
        if (state is RecentlyReadSuccess) {
          if (state.postList.length == 0) return Container();
          return Column(
              children: state.postList.map((item) {
            return PostCard(context, item);
          }).toList());
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
