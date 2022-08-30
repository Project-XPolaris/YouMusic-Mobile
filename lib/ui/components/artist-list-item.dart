import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../api/entites.dart';
import '../artist/view/artist.dart';
import '../meta-navigation/artist.dart';

class ArtistListItem extends StatelessWidget {
  final Artist artist;
  final Function(Artist)? onTap;
  const ArtistListItem({Key? key,required this.artist,this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(artist.displayName),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context)
              .colorScheme
              .secondaryContainer,
          child: Icon(
            Icons.person_rounded,
            color: Theme.of(context)
                .colorScheme
                .onSecondaryContainer,
          ),
        ),
        onTap: () {
          if (onTap != null) {
            onTap?.call(artist);
          }else{
            ArtistPage.launch(context, artist.id);
          }
        },
        onLongPress: () {
          HapticFeedback.selectionClick();
          showModalBottomSheet(
              context: context,
              builder: (context) => ArtistMetaInfo(
                artist: artist,
              ));
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8))
    );
  }
}
