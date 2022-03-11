part of 'history_bloc.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class HistoryFetched extends HistoryEvent {}

class HistoryReload extends HistoryEvent {}