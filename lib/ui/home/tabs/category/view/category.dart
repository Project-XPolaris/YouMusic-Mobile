import 'package:flutter/material.dart';
import 'package:youmusic_mobile/ui/artist-list/artist_list.dart';
import 'package:youmusic_mobile/ui/genre-list/view/genre-list.dart';
import 'package:youmusic_mobile/ui/music-list/music_list.dart';

import '../../../../tag-list/view/tag-list.dart';



class CategoryTab extends StatelessWidget {
  const CategoryTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category'),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: ListView(
          children: [
            ListTile(
                title: Text("All Music"),
                leading: Icon(Icons.music_note_rounded),
                onTap: () {
                  MusicListPage.launch(
                    context,
                    extraFilter: {},
                    title: "All Music",
                  );
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
            ),
            ListTile(
              title: Text("Artist"),
              leading: Icon(Icons.person_rounded),
              onTap: () {
                ArtistListPage.launch(
                  context,
                  extraFilter: {},
                );
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),

            ListTile(
              title: Text("Tags"),
              leading: Icon(Icons.bookmark_rounded),
              onTap: () {
                TagListView.launch(
                  context,
                  extraFilter: {},
                );
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            ListTile(
              title: Text("Genre"),
              leading: Icon(Icons.mood_rounded),
              onTap: () {
                GenreListView.launch(
                  context,
                  extraFilter: {},
                );
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            )
          ],
        ),
      ),
    );
  }
}
