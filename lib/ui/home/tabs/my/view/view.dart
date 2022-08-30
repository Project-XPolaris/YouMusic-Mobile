import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youmusic_mobile/api/entites.dart';
import 'package:youmusic_mobile/ui/artist-list/artist_list.dart';
import 'package:youmusic_mobile/ui/tag-list/view/tag-list.dart';

import '../../../../album-list/album_list.dart';
import '../bloc/my_bloc.dart';

class TabMy extends StatelessWidget {
  const TabMy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyBloc(),
      child: BlocBuilder<MyBloc, MyState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text("My"),
            ),
            body: Container(
              padding: EdgeInsets.only(left: 16,right: 16),
              child: ListView(
                children: [
                  ListTile(
                    title: Text("Follow Artist"),
                    leading: Icon(Icons.person_rounded),
                    onTap: (){
                      ArtistListPage.launch(context,extraFilter: {"follow":"1"},title: "My Artist");
                    },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))
                  ),
                  ListTile(
                      title: Text("Follow Album"),
                      leading: Icon(Icons.album_rounded),
                      onTap: (){
                        AlbumListPage.launch(context,extraFilter: {"follow":"1"},title: "My Album");
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))
                  ),
                  ListTile(
                      title: Text("Follow Tag"),
                      leading: Icon(Icons.bookmark_rounded),
                      onTap: (){
                        TagListView.launch(context,extraFilter: {"follow":"1"},title: "My Tag");
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))
                  ),
                  ListTile(
                      title: Text("Follow Genre"),
                      leading: Icon(Icons.mood_rounded),
                      onTap: (){
                        TagListView.launch(context,extraFilter: {"follow":"1"},title: "My Genre");
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
