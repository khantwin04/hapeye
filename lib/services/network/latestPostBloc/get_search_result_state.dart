part of 'get_search_result_cubit.dart';

abstract class GetSearchResultState extends Equatable {
  const GetSearchResultState();

  @override
  List<Object> get props => [];
}

class GetSearchResultInitial extends GetSearchResultState {}

class GetSearchResultLoading extends GetSearchResultState {}

class GetSearchResultFail extends GetSearchResultState {
  final String error;
  GetSearchResultFail(this.error);
 
  @override
  List<Object> get props => [error];

}

class GetSearchResultSuccess extends GetSearchResultState {}
