import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/config.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';
import 'package:youmusic_mobile/ui/home/home.dart';

class IndexPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApplicationConfig().loadConfig(),
      builder: (context,data) {
        if (data.hasData){
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<PlayProvider>(
                create: (_) => PlayProvider(),
              ),
            ],
            child: HomePage(),
          );
        }
        return Container();
      },
    );
  }
}
