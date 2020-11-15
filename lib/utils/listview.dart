import 'package:flutter/material.dart';

createLoadMoreController(Function onLoadMore){
  ScrollController _controller = new ScrollController();
  _controller.addListener(() {
    var maxScroll = _controller.position.maxScrollExtent;
    var pixel = _controller.position.pixels;
    if (maxScroll == pixel) {
      onLoadMore();
    } else {}
  });
  return _controller;
}