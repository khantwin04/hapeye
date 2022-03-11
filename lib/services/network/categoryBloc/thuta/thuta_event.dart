part of 'thuta_bloc.dart';

abstract class ThutaEvent extends Equatable {
  const ThutaEvent();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ThutaFetched extends ThutaEvent {}

class ThutaReload extends ThutaEvent {}