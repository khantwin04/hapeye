part of 'get_latest_post_cubit.dart';

abstract class GetLatestPostState extends Equatable {
  const GetLatestPostState();
  @override
  List<Object> get props => [];
}

class GetLatestPostInitial extends GetLatestPostState {}
class GetLatestPostLoading extends GetLatestPostState {}

class GetLatestPostSuccess extends GetLatestPostState {
  final List<PostModel> postList;
  GetLatestPostSuccess(this.postList);

  @override
  // TODO: implement props
  List<Object> get props => [postList];
}


class GetLatestPostFail extends GetLatestPostState{
  final String error;
  GetLatestPostFail(this.error);

  @override
  // TODO: implement props
  List<Object> get props => [error];
}
