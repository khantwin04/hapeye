part of 'recently_read_cubit.dart';

abstract class RecentlyReadState extends Equatable {
  const RecentlyReadState();

  @override
  List<Object> get props => [];
}

class RecentlyReadInitial extends RecentlyReadState {}

class RecentlyReadLoading extends RecentlyReadState {}

class RecentlyReadSuccess extends RecentlyReadState {
  final List<PostModel> postList;
  RecentlyReadSuccess(this.postList);

  
  @override
  List<Object> get props => [postList];
}

class RecentlyReadFail extends RecentlyReadState {
  final String error;
  RecentlyReadFail(this.error);

  @override
  List<Object> get props => [error];
}
