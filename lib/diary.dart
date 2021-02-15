import 'package:flutter/material.dart';

class Diary extends StatelessWidget {
  final List a = [
    'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_960_720.jpg',
    'https://cdn.pixabay.com/photo/2016/05/05/02/37/sunset-1373171_960_720.jpg',
    'https://cdn.pixabay.com/photo/2017/02/01/22/02/mountain-landscape-2031539_960_720.jpg',
    'https://cdn.pixabay.com/photo/2014/09/14/18/04/dandelion-445228_960_720.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Displaying Images"),
      ),
      body: ListView.builder(
          itemBuilder: (BuildContext ctx, int index) {
            return Image.network(a[index]);
          },
        itemCount: a.length,
      ),
    );
  }

}