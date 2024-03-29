import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/ui/home/play_bar.dart';
import 'package:youmusic_mobile/ui/home/tabs/category/view/category.dart';
import 'package:youmusic_mobile/ui/home/tabs/my/view/view.dart';

import 'provider.dart';
import 'tabs/album/tab_album.dart';
import 'tabs/home/tab_home.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeProvider>(
        create: (_) => HomeProvider(),
        child: Consumer<HomeProvider>(
          builder: (context, provider, child) {
            return Scaffold(
              // drawer: Drawer(
              //   child: Container(
              //     color: Colors.black,
              //     child: ListView(
              //       // Important: Remove any padding from the ListView.
              //       padding: EdgeInsets.zero,
              //       children: <Widget>[
              //         Container(
              //           margin: EdgeInsets.only(left: 16, top: 72, bottom: 16),
              //           child: Text(
              //             'YouMusic',
              //             style: TextStyle(color: Colors.pink, fontSize: 28),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              body: Scaffold(
                body: IndexedStack(
                  index: provider.activeTab,
                  children: <Widget>[
                    HomeTabPage(),
                    AlbumTabPage(),
                    CategoryTab(),
                    TabMy()
                  ],
                ),
                bottomNavigationBar: PlayBar(),
              ),
              bottomNavigationBar: Container(
                child: Padding(
                  padding: EdgeInsets.only(),
                  child: NavigationBar(
                    selectedIndex: provider.activeTab,
                    onDestinationSelected: provider.setActiveTab,
                    destinations: const <NavigationDestination>[
                      NavigationDestination(
                        icon: Icon(Icons.home_rounded),
                        label: 'Home',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.album_rounded),
                        label: 'Album',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.category_rounded),
                        label: 'Category',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.person_rounded),
                        label: 'My',
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}
