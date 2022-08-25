import 'package:flutter/material.dart';
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
            )
          ],
        ),
      ),
    );
  }
}
