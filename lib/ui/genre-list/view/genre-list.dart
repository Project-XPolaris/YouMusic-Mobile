import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../api/entites.dart';
import '../../../utils/listview.dart';
import '../../components/genre-filter.dart';
import '../../genre/view/view.dart';
import '../../home/play_bar.dart';
import '../bloc/genre_list_bloc.dart';


class GenreListView extends StatelessWidget {
  final Map<String, String> extraFilter;
  final String title;
  const GenreListView({Key? key,this.extraFilter = const {},this.title = "Genre List"}) : super(key: key);
  static launch(BuildContext context, {Map<String, String> extraFilter =const  {},String title = "Genre List"}) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              GenreListView(
                extraFilter: extraFilter,
                title: title,
              )),
    );
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      GenreListBloc()
        ..add(OnLoadEvent(force: false)),
      child: BlocBuilder<GenreListBloc, GenreListState>(
        builder: (context, state) {
          ScrollController _controller = createLoadMoreController(() =>
              context.read<GenreListBloc>().add(OnLoadMoreEvent()));
          _onFilterButtonClick(){
            showModalBottomSheet(
                context: context,
                builder: (ctx) {
                  return GenreFilterView(
                    filter: state.filter,
                    onChange: (filter) {
                      context.read<GenreListBloc>().add(FilterUpdateEvent(updatedFilter: filter));
                      if (_controller.hasClients && _controller.offset > 0){
                        _controller.jumpTo(0);
                      }
                    },
                  );
                });
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(title),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_rounded),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                IconButton(onPressed: _onFilterButtonClick, icon: Icon(Icons.filter_alt_rounded))
              ],
            ),
            body: Container(
                child: RefreshIndicator(
                  onRefresh: () async {
                    GenreListBloc()
                      ..add(OnLoadEvent(force: true));
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: RefreshIndicator(
                      onRefresh: ()async{
                        context.read<GenreListBloc>().add(OnLoadEvent(force: true));
                        return ;
                      },
                      child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        controller: _controller,
                        itemCount: state.tagList.length,
                        itemBuilder: (context, index) {
                          Genre genre = state.tagList[index];
                          return ListTile(
                            title: Text(genre.displayName),
                            leading: Icon(Icons.mood_rounded),
                            onTap: (){
                              GenreView.launch(context, genre.id?.toString(),title: genre.displayName);
                            },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))
                          );
                        },
                      ),
                    ),
                  ),
                )),
            bottomNavigationBar: PlayBar(),
          );
        },
      ),
    );
  }
}
