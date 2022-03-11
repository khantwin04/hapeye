part of 'live_bloc.dart';

abstract class LiveEvent extends Equatable {
  const LiveEvent();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LiveFetched extends LiveEvent {}

class LiveReload extends LiveEvent {}