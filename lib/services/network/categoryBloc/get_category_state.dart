part of 'get_category_cubit.dart';

abstract class GetCategoryState extends Equatable {
  const GetCategoryState();
  @override
  List<Object> get props => [];
}

class GetCategoryInitial extends GetCategoryState{}

class GetCategoryLoading extends GetCategoryState{}

class GetCategorySuccess extends GetCategoryState{
  final List<CategoryModel> category;
  GetCategorySuccess(this.category);


  @override
  // TODO: implement props
  List<Object> get props => [category];
}

class GetCategoryFail extends GetCategoryState{
  final String error;
  GetCategoryFail(this.error);

  @override
  // TODO: implement props
  List<Object> get props => [error];
}
