import 'package:flutter/material.dart';

import '../../api/loader/genre_loader.dart';

const GenreFilterKeys = [
  "id asc", "id desc", "name asc", "name desc","random"
];


class GenreFilterView extends StatefulWidget {
  final GenreFilter filter;
  final Function(GenreFilter filter) onChange;
  GenreFilterView({required this.filter,required this.onChange});
  @override
  _GenreFilterViewState createState() => _GenreFilterViewState(order: filter.order);
}

class _GenreFilterViewState extends State<GenreFilterView> {
  String order;
  _GenreFilterViewState({required this.order});
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
                ...GenreFilterKeys.map((key) {
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