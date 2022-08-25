[![pub package](https://img.shields.io/badge/pub-v0.5.3-blue)](https://pub.dev/packages/bubble_box)

[English](https://pub.dev/packages/bubble_box) [中文](https://github.com/yixiaco/bubble_box/blob/master/README_zh.md)
# bubble_box

一个强大的气泡盒子，实现了基础的气泡、边框、虚线、渐变色、角度，自适应宽，方向、偏移等等功能

该项目是用纯flutter代码编写的，这意味着它同时支持iOS和Android以及Web、Windows、Linux、macOS等。

修改了很多API，请注意升级
## Screenshot
<img src="https://raw.githubusercontent.com/yixiaco/bubble_box/master/01.png" style="width:450px" >

# 基础的组件
```dart
BubbleBox(
  maxWidth: MediaQuery.of(context).size.width * 0.8,
  child: Text('我是一个基础的组件应用示例'),
)
```

# 自定义边框颜色、宽度，组件的背景色
```dart
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
```

# 定义边框为虚线、边框颜色渐变
```dart
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
  )
```

#  背景色渐变
```dart
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
```

# 钝角
```dart
BubbleBox(
    maxWidth: MediaQuery.of(context).size.width * 0.85,
    shape: BubbleShapeBorder(
      direction: BubbleDirection.left,
      position: const BubblePosition.start(12),
      arrowQuadraticBezierLength: 2,
    ),
    backgroundColor: Color(0xff98E165),
    margin: EdgeInsets.all(4),
    child: Text(
      '我添加了新的钝角，使三角形不再那么的尖锐',
    ),
  ),
```

# 加强的radius
```dart
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
```