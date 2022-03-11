part of 'get_all_post_bloc.dart';

abstract class GetAllPostEvent extends Equatable {
  const GetAllPostEvent();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GetAllPostFetched extends GetAllPostEvent {}

class GetAllPostReload extends GetAllPostEvent {}