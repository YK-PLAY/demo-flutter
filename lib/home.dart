import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart' as http;

// https://github.com/markgrancapal/filipino_cuisine/blob/master/lib/main.dart
class Home extends StatefulWidget {

  @override
  HomeSate createState() => HomeSate();
}

class HomeSate extends State<Home> {
  List fd;
  Map fi;


  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    http.Response r = await http.get('https://filipino-cuisine-app.firebaseio.com/data.json');
    Map body = json.decode(r.body);

    if(body != null && body.length > 0) {
      if(fd == null) fd = new List();

      for(int i = 0; i < body.length; i++) {
        if(body.containsKey(i.toString())) {
          fd.add(body[i.toString()]);
          print(body[i.toString()]['fd']);
        }
      }
    }

    setState(() {
      if(fd != null && fd.length > 0) {
        fi = fd[0];
      } else {
        print("???");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(fd == null) return defaultContainer();

    return Scaffold(
      body: Column(
        children: [
          expanded()
        ],
      ),
    );
  }

  Container defaultContainer() {
    return Container(
      color: Colors.white,
      child: Center(child: CircularProgressIndicator(),),
    );
  }

  Expanded expanded() {
    return Expanded(
      flex: 5,
      child: Swiper(
        onIndexChanged: (i) => setState(() => fi = fd[i]),
        itemCount: fd.length,
        itemBuilder: (context, i) {
          return Container(
            margin: EdgeInsets.only(top: 40, bottom: 24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Hero(tag: fd[i]['fn'], child: Image.network('https://raw.githubusercontent.com/markgrancapal/filipino_cuisine/master/assets/' + fd[i]['pf'], fit: BoxFit.cover,),),
            ),
          );
        },
        viewportFraction: .85,
        scale: .9,
      ),
    );
  }

}