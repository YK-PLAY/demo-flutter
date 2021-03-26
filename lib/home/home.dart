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

  getData(String token) async {
    Map<String, String> header = {
      "Authorization": " Bearer $token",
    };
    final AppConfig config = Provider.of<AppConfig>(context);
    http.Response r = await http.get('http://${config.host}/api/v1.0/diary/my/list?page=1&per-page=15', headers: header);
    Map body = json.decode(r.body);

    print(body);
    if(body['total'] > 0) {
      List list = body['list'];
      if(list != null && list.length > 0) {
        if(fd == null) fd = new List();
        for(int i = 0; i < list.length; i++) {
          fd.add(list[i]);
        }
      }
    }

    if(!load) {
      load = true;
      setState(() {
        if(fd != null && fd.length > 0) {
          fi = fd[0];
        }
      });
    }

    // if(body != null && body.length > 0) {
    //   if(fd == null) fd = new List();
    //
    //   for(int i = 0; i < body.length; i++) {
    //     if(body.containsKey(i.toString())) {
    //       fd.add(body[i.toString()]);
    //       print(body[i.toString()]['fd']);
    //     }
    //   }
    // }

    // setState(() {
    //   if(fd != null && fd.length > 0) {
    //     fi = fd[0];
    //   } else {
    //     print("???");
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    LoginInfo _bloc = Provider.of<LoginInfo>(context);
    if(_bloc != null) {
      print('Home sessionKey: ${_bloc.sessionKey}');
      getData(_bloc.sessionKey);
    }

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
              // child: Hero(tag: fd[i]['fn'], child: Image.network('https://raw.githubusercontent.com/markgrancapal/filipino_cuisine/master/assets/' + fd[i]['pf'], fit: BoxFit.cover,),),
              child: Hero(tag: 'test', child: Image.network(fd[i]['imageUrl'], fit: BoxFit.cover,),),
            ),
          );
        },
        viewportFraction: .85,
        scale: .9,
      ),
    );
  }

}