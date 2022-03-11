part of 'buddha_bloc.dart';

abstract class BuddhaEvent extends Equatable {
  const BuddhaEvent();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class BuddhaFetched extends BuddhaEvent {}

class BuddhaReload extends BuddhaEvent {}