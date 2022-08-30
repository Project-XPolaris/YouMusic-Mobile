
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../api/entites.dart';
import '../../../api/loader/genre_loader.dart';
import '../../../api/loader/tag_loader.dart';

part 'genre_list_event.dart';
part 'genre_list_state.dart';

class GenreListBloc extends Bloc<GenreListEvent, GenreListState> {
  final GenreLoader _tagLoader = GenreLoader();
  final Map<String,String>? extraFilter;
  GenreListBloc({this.extraFilter}) : super(GenreListInitial(tagList: [])) {
    on<OnLoadEvent>((event, emit) async {
      await _tagLoader.loadData(force: event.force,extraFilter: state.filter.toParam(extra: extraFilter));
      emit(state.copyWith(tagList: [..._tagLoader.list]));
    });
    on<OnLoadMoreEvent>((event, emit) async {
      if (await _tagLoader.loadMore(extraFilter: state.filter.toParam(extra: extraFilter))){
        emit(state.copyWith(tagList: [..._tagLoader.list]));
      }
    });
    on<FilterUpdateEvent>((event, emit) async {
      await _tagLoader.loadData(force: true,extraFilter: state.filter.toParam(extra: extraFilter));
      emit(state.copyWith(tagList: [..._tagLoader.list],filter: event.updatedFilter));
    });
  }
}
