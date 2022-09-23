import 'package:flutter/material.dart';

import '../../api/loader/tag_loader.dart';

const TagFilterKeys = [
  "id asc", "id desc", "name asc", "name desc","random"
];


class TagFilterView extends StatefulWidget {
  final TagFilter filter;
  final Function(TagFilter filter) onChange;
  TagFilterView({required this.filter,required this.onChange});
  @override
  _TagFilterViewState createState() => _TagFilterViewState(order: filter.order);
}

class _TagFilterViewState extends State<TagFilterView> {
  String order;
  _TagFilterViewState({required this.order});
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
                ...TagFilterKeys.map((key) {
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