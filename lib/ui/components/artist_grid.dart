import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youmusic_mobile/ui/artist/view/artist.dart';

import '../../api/entites.dart';
import '../meta-navigation/artist.dart';
import 'item_artist.dart';

class ArtistGrid extends StatelessWidget {
  final ScrollController? scrollController;
  final List<Artist> artists;
  const ArtistGrid({Key? key,this.scrollController,this.artists = const[]}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: AlwaysScrollableScrollPhysics(),
      controller: scrollController,
      childAspectRatio: 9 / 13,
      crossAxisCount: 3,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children: artists.map((e) {
        return ArtistItem(
            artist: e,
            onTap: (artist) {
              ArtistPage.launch(context, e.id);
            },
            onLongPress: (artist) {
              HapticFeedback.selectionClick();
              showModalBottomSheet(
                  context: context,
                  builder: (context) => ArtistMetaInfo(
                    artist: artist,
                  ));
            });
      }).toList(),
    );
  }
}
