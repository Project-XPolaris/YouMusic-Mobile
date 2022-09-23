import 'package:flutter/material.dart';

import '../../api/loader/artist_loader.dart';

const OrderFilterKeys = [
  "id asc", "id desc", "name asc", "name desc","random"
];



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
                      ),
                      onSelected: (selected) {
                        widget.filter.order = key;
                        widget.onChange(widget.filter);
                        setState(() {
                          order = key;
                        });
                      },
                      selected: order == key,
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