part of 'it_bloc.dart';

abstract class ItEvent extends Equatable {
  const ItEvent();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ItFetched extends ItEvent {}

class ItReload extends ItEvent {}