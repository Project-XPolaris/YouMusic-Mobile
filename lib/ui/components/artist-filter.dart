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
                          color: order == key ? Theme.of(context).colorScheme.onSecondary : Theme.of(context).colorScheme.onSecondaryContainer,
                        ),
                      ),
                      checkmarkColor: order == key ? Theme.of(context).colorScheme.onSecondary : Theme.of(context).colorScheme.onSecondaryContainer,
                      onSelected: (selected) {
                        widget.filter.order = key;
                        widget.onChange(widget.filter);
                        setState(() {
                          order = key;
                        });
                      },
                      selected: order == key,
                      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                      selectedColor: Theme.of(context).colorScheme.secondary,
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