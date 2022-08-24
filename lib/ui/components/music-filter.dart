import 'package:flutter/material.dart';

import '../../api/loader/music_loader.dart';

const OrderFilterKeys = [
  "id asc", "id desc", "title asc", "title desc"
];


class MusicFilterView extends StatefulWidget {
  final MusicFilter filter;
  final Function(MusicFilter filter) onChange;
  MusicFilterView({required this.filter,required this.onChange});

  @override
  _MusicFilterViewState createState() => _MusicFilterViewState(order: filter.order);
}

class _MusicFilterViewState extends State<MusicFilterView> {
  String order;
  _MusicFilterViewState({required this.order});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            child: Text(
              "Filter",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            child: Text("Order", style: TextStyle(),),
          ),
          Container(
            padding: EdgeInsets.only(left: 16,right: 16),
            child: Wrap(
              children: [
                ...OrderFilterKeys.map((key) {
                  return Padding(
                    padding: EdgeInsets.only(right: 8,bottom: 4),
                    child: FilterChip(
                      label: Text(
                        key,
                        style: TextStyle(
                          color: order == key ? Colors.white : Colors.black,
                        ),
                      ),
                      checkmarkColor: order == key ? Colors.white : Colors.black,
                      onSelected: (selected) {
                        widget.filter.order = key;
                        widget.onChange(widget.filter);
                        setState(() {
                          order = key;
                        });
                      },
                      selected: order == key,
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      selectedColor: Theme.of(context).colorScheme.primary,
                    ),
                  );
                })
              ],
            ),
          )
        ],
      ),
    );
  }
}