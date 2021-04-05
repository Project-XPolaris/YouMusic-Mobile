import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/ui/home/play_bar.dart';
import 'package:youmusic_mobile/ui/setting/setting.dart';

import '../provider.dart';
import 'tabs/album/tab_album.dart';
import 'tabs/all/tab_all.dart';
import 'tabs/artist/tab_artist.dart';
import 'tabs/home/tab_home.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeProvider>(
        create: (_) => HomeProvider(),
        child: Consumer<HomeProvider>(
          builder: (context, provider, child) {
            return Scaffold(
              backgroundColor: Colors.black87,
              appBar: AppBar(
                title: Text(
                  "YouMusic",
                  style: TextStyle(color: Colors.pink),
                ),
                backgroundColor: Colors.transparent,

                elevation: 0,
                // actions: [
                //   PopupMenuButton(
                //     color: Color(0xFF2B2B2B),
                //     // initialValue: choices[_selection],
                //     itemBuilder: (BuildContext context) {
                //       return [
                //         PopupMenuItem<String>(
                //           value: "1",
                //           child: Row(
                //             children: <Widget>[
                //               Icon(Icons.settings, color: Colors.white),
                //               Padding(
                //                 padding: EdgeInsets.only(left: 8),
                //                 child: Text(
                //                   'Setting',
                //                   style: TextStyle(color: Colors.white),
                //                 ),
                //               ),
                //             ],
                //           ),
                //         )
                //       ];
                //     },
                //   )
                // ],
              ),
              drawer: Drawer(
                child: Container(
                  color: Colors.black,
                  child: ListView(
                    // Important: Remove any padding from the ListView.
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 16, top: 72, bottom: 16),
                        child: Text(
                          'YouMusic',
                          style: TextStyle(color: Colors.pink, fontSize: 28),
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Setting',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingPage()
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              body: Scaffold(
                backgroundColor: Colors.black87,
                body: IndexedStack(
                  index: provider.activeTab,
                  children: <Widget>[
                    HomeTabPage(),
                    AlbumTabPage(),
                    ArtistTabPage(),
                    AllTabPage()
                  ],
                ),
                bottomNavigationBar: PlayBar(),
              ),
              bottomNavigationBar: Container(
                child: Padding(
                  padding: EdgeInsets.only(),
                  child: BottomNavigationBar(
                    currentIndex: provider.activeTab,
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: Colors.black,
                    unselectedItemColor: Colors.grey[600],
                    onTap: provider.setActiveTab,
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.album),
                        label: 'Album',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: 'Artist',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.music_note),
                        label: 'All',
                      ),
                    ],
                    selectedItemColor: Colors.pink,
                  ),
                ),
              ),
            );
          },
        ));
  }
}
