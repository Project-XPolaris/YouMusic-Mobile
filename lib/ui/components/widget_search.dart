import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              "Search...",
              style: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer, fontSize: 16),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(16))),
    );
  }
}
