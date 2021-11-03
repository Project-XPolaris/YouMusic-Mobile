import 'package:flutter/material.dart';

const OrderFilterKeys = [
  "id asc", "id desc", "name asc", "name desc"
];

class ArtistFilter {
  String order;
  ArtistFilter({required this.order});
}

class ArtistFilterView extends StatefulWidget {
  final ArtistFilter filter;
  final Function(ArtistFilter filter) onChange;
  ArtistFilterView({required this.filter,required this.onChange});

  @override
  _ArtistFilterViewState createState() => _ArtistFilterViewState(order: filter.order);
}

class _ArtistFilterViewState extends State<ArtistFilterView> {
  String order;
  _ArtistFilterViewState({required this.order});
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