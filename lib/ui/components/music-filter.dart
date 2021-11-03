import 'package:flutter/material.dart';

const OrderFilterKeys = [
  "id asc", "id desc", "title asc", "title desc"
];

class MusicFilter {
  String order;
  MusicFilter({required this.order});
}

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
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            child: Text(
              "Filter",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            child: Text("Order", style: TextStyle(color: Colors.white70),),
          ),
          Wrap(
            children: [
              ...OrderFilterKeys.map((key) {
                return Padding(padding: EdgeInsets.only(left: 4,right: 4),
                  child: FilterChip(label: Text(key,style: TextStyle(color: Colors.white),),
                    backgroundColor: Colors.black54,
                    checkmarkColor: Colors.white,
                    onSelected: (selected) {
                      widget.filter.order = key;
                      widget.onChange(widget.filter);
                      setState(() {
                        order = key;
                      });
                    },
                    selected: order == key,
                    selectedColor: Colors.pink,
                  ),
                );
              })
            ],
          )
        ],
      ),
    );
  }
}