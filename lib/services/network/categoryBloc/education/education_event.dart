part of 'education_bloc.dart';

abstract class EducationEvent extends Equatable {
  const EducationEvent();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class EducationFetched extends EducationEvent {}

class EducationReload extends EducationEvent {}