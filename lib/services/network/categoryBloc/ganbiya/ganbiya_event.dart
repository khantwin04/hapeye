part of 'ganbiya_bloc.dart';

abstract class GanbiyaEvent extends Equatable {
  const GanbiyaEvent();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GanbiyaFetched extends GanbiyaEvent {}

class GanbiyaReload extends GanbiyaEvent {}