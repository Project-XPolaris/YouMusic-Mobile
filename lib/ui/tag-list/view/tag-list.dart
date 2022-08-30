import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youmusic_mobile/ui/tag-list/bloc/tag_list_bloc.dart';
import 'package:youmusic_mobile/ui/tag/view.dart';

import '../../../api/entites.dart';
import '../../../utils/listview.dart';
import '../../components/tag-filter.dart';
import '../../home/play_bar.dart';

class TagListView extends StatelessWidget {
  final Map<String, String> extraFilter;
  final String title;
  const TagListView({Key? key,this.extraFilter = const {},this.title = "Tag List"}) : super(key: key);
  static launch(BuildContext context, {Map<String, String> extraFilter =const  {},String title = "Tag List"}) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              TagListView(
                extraFilter: extraFilter,
                title: title,
              )),
    );
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      TagListBloc()
        ..add(OnLoadEvent(force: false)),
      child: BlocBuilder<TagListBloc, TagListState>(
        builder: (context, state) {
          ScrollController _controller = createLoadMoreController(() =>
              context.read<TagListBloc>().add(OnLoadMoreEvent()));
          _onFilterButtonClick(){
            showModalBottomSheet(
                context: context,
                builder: (ctx) {
                  return TagFilterView(
                    filter: state.filter,
                    onChange: (filter) {
                      context.read<TagListBloc>().add(FilterUpdateEvent(updatedFilter: filter));
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
                    TagListBloc()
                      ..add(OnLoadEvent(force: true));
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: RefreshIndicator(
                      onRefresh: ()async{
                        context.read<TagListBloc>().add(OnLoadEvent(force: true));
                        return ;
                      },
                      child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        controller: _controller,
                        itemCount: state.tagList.length,
                        itemBuilder: (context, index) {
                          Tag tag = state.tagList[index];
                          return ListTile(
                            title: Text(tag.displayName),
                            leading: Icon(Icons.bookmark_rounded),
                            onTap: (){
                              TagView.launch(context, tag.id?.toString());
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
