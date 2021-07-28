import 'dart:io';

import 'package:bubble_box/bubble_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  if (Platform.isAndroid) {
    //设置Android头部的导航栏透明
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, //全局设置透明
        //light:白色图标 dark：黑色图标
        //在此处设置statusBarIconBrightness为全局设置
        statusBarIconBrightness: Brightness.dark));
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Demo(),
    );
  }
}

class Demo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      appBar: AppBar(
        brightness: Brightness.light,
        toolbarHeight: 40,
        backgroundColor: Color(0xffF5F5F5),
        elevation: 0,
        centerTitle: true,
        shape: BorderDirectional(bottom: BorderSide(width: 0.1)),
        title: Text(
          '演示',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BubbleBox(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
              child: Text('我是一个基础的组件应用示例'),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BubbleBox(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
              shape: BubbleShapeBorder(
                border: BubbleBoxBorder(
                  color: Colors.blue,
                  width: 3,
                ),
                position: const BubblePosition.center(0),
                direction: BubbleDirection.right,
              ),
              backgroundColor: Colors.green.withOpacity(0.8),
              child: Text('我可以自定义边框颜色、宽度，组件的背景色，气泡的尖角位置及尖角的偏移'),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BubbleBox(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
              gradient: LinearGradient(
                colors: [
                  Colors.pink,
                  Colors.orange[700],
                ],
              ),
              blendMode: BlendMode.srcATop,
              shape: BubbleShapeBorder(
                border: BubbleBoxBorder(
                  gradient: LinearGradient(
                    colors: [
                      Colors.pink,
                      Colors.orange[700],
                    ],
                  ),
                  width: 3,
                  style: BubbleBoxBorderStyle.dashed,
                ),
                direction: BubbleDirection.left,
                position: const BubblePosition.start(12),
              ),
              margin: EdgeInsets.all(4),
              elevation: 5,
              shadowColor: Colors.redAccent,
              child: Text(
                  '然而我不仅仅可以自定气泡的边框和尖角。我还可以定义边框为虚线、边框颜色渐变。\n我对内容是自适应的，不需要设置宽高，当然，你可以限制组件的最大宽高。\n我的内容也可以渐变色。\n此外，你可能需要一些阴影,阴影可能也需要一些自己的颜色。'),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BubbleBox(
              maxWidth: MediaQuery.of(context).size.width * 0.85,
              elevation: 5,
              gradient: LinearGradient(colors: [
                Colors.red,
                Colors.orange[700],
                Colors.orange[500],
              ]),
              shape: BubbleShapeBorder(
                border: BubbleBoxBorder(
                  gradient: LinearGradient(
                    colors: [
                      Colors.pink,
                      Colors.orange[700],
                    ],
                  ),
                  color: Colors.blue,
                  width: 3,
                  style: BubbleBoxBorderStyle.dashed,
                ),
                direction: BubbleDirection.none,
                position: const BubblePosition.start(12),
              ),
              margin: EdgeInsets.all(4),
              child: Text(
                '我的背景其实也能够渐变',
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BubbleBox(
              maxWidth: MediaQuery.of(context).size.width * 0.85,
              elevation: 5,
              gradient: LinearGradient(colors: [
                Colors.red,
                Colors.orange[700],
                Colors.orange[500],
              ]),
              shape: BubbleShapeBorder(
                direction: BubbleDirection.left,
                position: const BubblePosition.start(12),
              ),
              margin: EdgeInsets.all(4),
              child: Text(
                '然而你更常用的可能是它',
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BubbleBox(
              maxWidth: MediaQuery.of(context).size.width * 0.85,
              shape: BubbleShapeBorder(
                border: BubbleBoxBorder(color: Color(0xffEDEDED)),
                direction: BubbleDirection.left,
                position: const BubblePosition.start(12),
                arrowQuadraticBezierLength: 1,
              ),
              margin: EdgeInsets.all(4),
              child: Text(
                '然而对于微信，你可能更熟悉它',
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BubbleBox(
              maxWidth: MediaQuery.of(context).size.width * 0.85,
              shape: BubbleShapeBorder(
                direction: BubbleDirection.right,
                position: const BubblePosition.start(12),
                arrowQuadraticBezierLength: 1,
              ),
              margin: EdgeInsets.all(4),
              backgroundColor: Color(0xff98E165),
              child: Text(
                '然而对于微信，你可能更熟悉它',
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BubbleBox(
              maxWidth: MediaQuery.of(context).size.width * 0.85,
              shape: BubbleShapeBorder(
                direction: BubbleDirection.left,
                arrowQuadraticBezierLength: 2,
              ),
              backgroundColor: Color(0xff98E165),
              margin: EdgeInsets.all(4),
              child: Text(
                '我添加了新的钝角，使三角形不再那么的尖锐',
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BubbleBox(
              maxWidth: MediaQuery.of(context).size.width * 0.85,
              backgroundColor: Color(0xff98E165),
              margin: EdgeInsets.all(4),
              shape: BubbleShapeBorder(
                radius: BorderRadius.only(
                    topRight: Radius.elliptical(30, 15),
                    bottomLeft: Radius.elliptical(30, 15)),
              ),
              child: Text(
                '我对边框radius进行了一些改造,让它更加自由',
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
