part of 'business_bloc.dart';

abstract class BusinessEvent extends Equatable {
  const BusinessEvent();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class BusinessFetched extends BusinessEvent {}

class BusinessReload extends BusinessEvent {}