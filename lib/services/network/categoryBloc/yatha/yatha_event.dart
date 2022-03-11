part of 'yatha_bloc.dart';

abstract class YathaEvent extends Equatable {
  const YathaEvent();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class YathaFetched extends YathaEvent {}

class YathaReload extends YathaEvent {}