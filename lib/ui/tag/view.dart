import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/ui/tag/provider.dart';
import 'package:youmusic_mobile/ui/tag/tab_music.dart';

import '../home/play_bar.dart';
import 'tab_album.dart';

class TagView extends StatelessWidget {
  final String id;

  const TagView({Key? key, required this.id}) : super(key: key);

  static launch(BuildContext context, String? tagId) {
    var id = tagId;
    if (id == null) {
      return;
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TagView(
                  id: id,
                )));
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return ChangeNotifierProvider<TagProvider>(
        create: (_) => TagProvider(id),
        child: Consumer<TagProvider>(builder: (context, provider, child) {
          provider.loadData();
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_rounded),
                  onPressed: () => Navigator.pop(context)),
              title: Text(
                provider.displayTagName,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Container(
                child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ActionChip(
                            label: Text("Albums"),
                            onPressed: () {
                              provider.changeTab(0);
                              controller.animateToPage(0,
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.easeInOut);
                            },
                            backgroundColor: provider.tabIdx == 0
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Colors.transparent),
                      ),
                      ActionChip(
                          label: Text("Music"),
                          onPressed: () {
                            provider.changeTab(1);
                            controller.animateToPage(1,
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeInOut);
                          },
                          backgroundColor: provider.tabIdx == 1
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Colors.transparent),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView(
                    onPageChanged: (idx) {
                      provider.changeTab(idx);
                    },
                    controller: controller,
                    children: <Widget>[
                      Container(
                        child:TagTabAlbum(),
                      ),
                      Center(
                        child: TagTabMusic(),
                      ),
                    ],
                  ),
                ),
              ],
            )),
            bottomNavigationBar: Container(
                color: Theme
                    .of(context)
                    .colorScheme
                    .background
                    .withOpacity(0.3),
                child: PlayBar()),
          );
        }));
  }
}
