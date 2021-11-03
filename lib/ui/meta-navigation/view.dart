import 'package:flutter/material.dart';

class MetaNavigation extends StatelessWidget {
  final List<Widget> items;
  final String? cover;
  final String title;
  final String title2;
  final String title3;
  const MetaNavigation({Key? key, this.items = const [], this.cover, this.title = "", this.title2 = "", this.title3 = ""}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var coverUrl = cover;
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Column(
          children: [
            Container(
              height: 64,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  coverUrl != null ? Image.network(coverUrl,fit: BoxFit.cover, width: 64,height: 64,):Container(),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Container(
                      width: 260,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                            softWrap: false,
                            overflow: TextOverflow.fade,
                          ),
                          Text(
                            title2,
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                            softWrap: false,
                            overflow: TextOverflow.fade,
                          ),
                          Text(
                            title3,
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                            softWrap: false,
                            overflow: TextOverflow.fade,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ListView(
                  children: items,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MetaItem extends StatelessWidget {
  const MetaItem({
    Key? key, required this.title, this.icon, this.onTap,
  }) : super(key: key);
  final String title;
  final IconData? icon;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              child: Center(
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            )
            ,
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Container(
                width: 260,
                child: Text(
                  title,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  softWrap: false,
                  overflow: TextOverflow.clip,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
