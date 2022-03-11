part of 'education_bloc.dart';

enum EducationStatus { initial, success, failure }

class EducationState extends Equatable {
  const EducationState({
    this.status = EducationStatus.initial,
    this.postList = const <PostModel>[],
    this.hasReachedMax = false,
  });

  final EducationStatus status;
  final List<PostModel> postList;
  final bool hasReachedMax;

  EducationState copyWith({
    EducationStatus? status,
    List<PostModel>? postList,
    bool? hasReachedMax,
  }) {
    return EducationState(
      status: status ?? this.status,
      postList: postList ?? this.postList,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''UserState { status: $status, hasReachedMax: $hasReachedMax, posts: ${postList.length} }''';
  }

  @override
  List<Object> get props => [status, postList, hasReachedMax];
}
