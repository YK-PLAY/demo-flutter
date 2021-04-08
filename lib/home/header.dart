import 'dart:io' as io;

import 'package:flutter/material.dart';

class HeaderScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HeaderScreenState();
}

class _HeaderScreenState extends State<HeaderScreen> {
  static const String MY_PROFILE_PATH = "images/myProfile.png";
  static const String DEFAULT_PROFILE_PATH = 'assets/images/default-profile.png';

  bool load = false;
  List<Widget> profileList = [];


  @override
  void initState() {
    super.initState();
    loadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        height: 50,
        alignment: Alignment.bottomLeft,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: profileList.length,
            itemBuilder: (context, index) {
              return Card(
                child: Center(child: profileList[index],),
              );
            }
        ),
      ),
    );
  }

  void loadImage() {
    if(profileList.isNotEmpty) {
      profileList.clear();
    }

    final myProfileFile = io.File(MY_PROFILE_PATH);

    myProfileFile
        .exists()
        .then((exists) {
          for(int i = 0; i < 10; i++) {
            var profile;
            if(!exists) {
              profile = Image.asset(DEFAULT_PROFILE_PATH);
            } else {
              profile = Image.file(myProfileFile);
            }

            print('list size: ${profileList.length}');
            profileList.add(profile);
          }

          setState(() {
            print('list size: ${profileList.length}');
          });
        });
  }
}