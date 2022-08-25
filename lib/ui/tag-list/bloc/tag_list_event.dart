part of 'tag_list_bloc.dart';

class TagListEvent extends Equatable {
  const TagListEvent();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class OnLoadEvent extends TagListEvent {
  final bool force;
  OnLoadEvent({this.force = false});
  @override
  List<Object?> get props => [force];
}

class OnLoadMoreEvent extends TagListEvent {
  OnLoadMoreEvent();
  @override
  List<Object?> get props => [];
}

class FilterUpdateEvent extends TagListEvent {
  final TagFilter updatedFilter;
  FilterUpdateEvent({required this.updatedFilter});
  @override
  List<Object?> get props => [updatedFilter];
}