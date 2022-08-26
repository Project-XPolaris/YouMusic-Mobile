part of 'genre_list_bloc.dart';

class GenreListState extends Equatable {
  final List<Genre> tagList;
  final GenreFilter filter;

  const GenreListState({required this.tagList,required this.filter});

  GenreListState copyWith ({
    List<Genre>? tagList,
    GenreFilter? filter
  }) {
    return GenreListState(
        tagList: tagList ?? this.tagList,
        filter: filter ?? this.filter
    );
  }

  @override
  List<Object?> get props => [tagList,filter];
}

class GenreListInitial extends GenreListState {
  GenreListInitial({required List<Genre> tagList}) : super(tagList: tagList,filter: GenreFilter(order: "id desc"));
}
