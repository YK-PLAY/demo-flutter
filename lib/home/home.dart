import 'dart:convert';

import 'package:demo_flutter/app_config.dart';
import 'package:demo_flutter/login/login_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List fd;
  Map fi;
  bool load = false;

  @override
  void initState() {
    super.initState();
    // getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Container(
          //   alignment: Alignment.bottomLeft,
          //   child: Text('Headline', style: TextStyle(fontSize: 18),),
          // ),
          Expanded(
            flex: 1,
            child: Text('Headline', style: TextStyle(fontSize: 18),),
          ),
          Expanded(
            flex: 2,
            child: Container(
              height: 50,
              alignment: Alignment.bottomLeft,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Center(child: image(index),),
                    );
                  }
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text('Headline2', style: TextStyle(fontSize: 18),),
          ),
          Expanded(
            flex: 15,
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Card(
                  // child: ListTile(
                  //   title: Text('Motivation $index'),
                  //   subtitle: Text('This is a description of the motivation'),
                  // ),
                  child: image(index, size: 200),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget image(int index, {double size = 50}) {
    switch(index % 3) {
      case 0:
        return Image.network('https://interactive-examples.mdn.mozilla.net/media/cc0-images/grapefruit-slice-332-332.jpg', width: size, height: size,);
      case 1:
        return Image.network('https://thumbs.dreamstime.com/b/monarch-orange-butterfly-bright-summer-flowers-background-blue-foliage-fairy-garden-macro-artistic-image-monarch-167030287.jpg', width: size, height: size,);
      default:
        return Image.network('https://image.shutterstock.com/image-photo/mountains-under-mist-morning-amazing-260nw-1725825019.jpg', width: size, height: size,);
    }
  }

  Widget appBar() {
    return AppBar(
      leading: Icon(Icons.error),
      title: Text('다꾸러'),
      actions: [
        Icon(Icons.favorite),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Icon(Icons.search),
        ),
        Icon(Icons.more_vert),
      ],
      backgroundColor: Colors.blue,
    );
  }
}