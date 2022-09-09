import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youmusic_mobile/api/client.dart';
import 'package:youmusic_mobile/api/entites.dart';
import 'package:youmusic_mobile/ui/meta-navigation/add-playlist/bloc/add_playlist_dialog_bloc.dart';

class AddPlaylistDialog extends StatelessWidget {
  final Music music;

  const AddPlaylistDialog({Key? key, required this.music}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddPlaylistDialogBloc()..add(LoadDataEvent()),
      child: BlocBuilder<AddPlaylistDialogBloc, AddPlaylistDialogState>(
        builder: (context, state) {
          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      border: Border.all(

                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                  padding: EdgeInsets.only(left: 8,right: 8),

                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Create playlist',
                        ),
                        onChanged: (value) {
                          context
                              .read<AddPlaylistDialogBloc>()
                              .add(InputNameChanged(name: value));
                        },
                      )),
                      IconButton(
                        icon: Icon(Icons.add_rounded),
                        onPressed: () async {
                          context.read<AddPlaylistDialogBloc>().add(
                              CreateAndAddMusic(
                                  musicId: this.music.id!,
                                  name: state.inputName!)
                          );
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: ListView.builder(
                        itemCount: state.playlists.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(state.playlists[index].displayName),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            onTap: () async {
                              await ApiClient().addMusicToPlaylist(
                                  state.playlists[index].id!, [this.music.id!]);
                              Navigator.pop(context);
                            },
                          );
                        })),
              )
            ],
          );
        },
      ),
    );
  }
}
