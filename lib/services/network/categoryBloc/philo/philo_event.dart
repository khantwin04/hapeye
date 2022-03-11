part of 'philo_bloc.dart';

abstract class PhiloEvent extends Equatable {
  const PhiloEvent();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class PhiloFetched extends PhiloEvent {}

class PhiloReload extends PhiloEvent {}