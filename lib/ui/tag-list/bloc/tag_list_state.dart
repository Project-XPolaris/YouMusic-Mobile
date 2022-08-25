part of 'tag_list_bloc.dart';

class TagListState extends Equatable {
  final List<Tag> tagList;
  final TagFilter filter;

  const TagListState({required this.tagList,required this.filter});

  TagListState copyWith ({
    List<Tag>? tagList,
    TagFilter? filter
  }) {
    return TagListState(
        tagList: tagList ?? this.tagList,
        filter: filter ?? this.filter
    );
  }

  @override
  List<Object?> get props => [tagList,filter];
}

class TagListInitial extends TagListState {
  TagListInitial({required List<Tag> tagList}) : super(tagList: tagList,filter: TagFilter(order: "id desc"));
}
