[![pub package](https://img.shields.io/badge/pub-v0.2.0-blue.svg)](https://pub.dev/packages/bubble_box)

[English](https://pub.dev/packages/bubble_box) [中文](https://github.com/18905059768/bubble_box/blob/master/README_zh.md)
# bubble_box

A powerful bubble box, which implements basic bubble, border, dotted line, gradient color, angle, adaptive width and height, bubble direction, offset, etc.

This project was writed with pure dart code，which means it's support both iOS and Android.

## Screenshot
<img src="https://raw.githubusercontent.com/18905059768/bubble_box/master/01.png">

# Basic Components
```dart
BubbleBox(
    maxWidth: MediaQuery.of(context).size.width * 0.8,
    child: Text('I am a basic component application example'),
)
```

# Customize the border color, width, and component background color
```dart
BubbleBox(
    maxWidth: MediaQuery.of(context).size.width * 0.8,
    border: BubbleBoxBorder(color: Colors.blue, width: 3),
    position: BubblePosition(center: 0),
    direction: BubbleDirection.right,
    backgroundColor: Colors.green.withOpacity(0.8),
    child: Text('I can customize the color and width of the border, the background color of the component, the position of the sharp corner of the bubble and the offset of the sharp corner'),
  )
```

# Define the border as a dashed line and the border color gradient
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
    direction: BubbleDirection.left,
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
    margin: EdgeInsets.all(4),
    position: BubblePosition(top: 9),
    elevation: 5,
    shadowColor: Colors.redAccent,
    child: Text(
        'However, I can not only customize the border and sharp corners of the bubble. I can also define the border as a dashed line and a gradient of border color. \nI am adaptive to the content, there is no need to set the width and height. Of course, you can limit the maximum width and height of the component. \nMy content can also be faded. \nIn addition, you may need some shadows, and the shadows may also need some of their own colors.'),
  )
```

#  background color gradient
```dart
BubbleBox(
    maxWidth: MediaQuery.of(context).size.width * 0.85,
    elevation: 5,
    gradient: LinearGradient(colors: [
      Colors.red,
      Colors.orange[700],
      Colors.orange[500],
    ]),
    border: BubbleBoxBorder(
      color: Colors.blue,
      width: 3,
      style: BubbleBoxBorderStyle.dashed,
    ),
    direction: BubbleDirection.none,
    position: BubblePosition(top: 9),
    margin: EdgeInsets.all(4),
    child: Text(
      'my background can actually fade',
    ),
  )
```

# obtuse angle
```dart
BubbleBox(
    maxWidth: MediaQuery.of(context).size.width * 0.85,
    direction: BubbleDirection.left,
    position: BubblePosition(top: 9),
    backgroundColor: Color(0xff98E165),
    margin: EdgeInsets.all(4),
    arrowQuadraticBezierLength: 2,
    child: Text(
      'We added new obtuse angles so that the triangles are no longer so sharp',
    ),
  )
```

# enhanced radius
```dart
BubbleBox(
    maxWidth: MediaQuery.of(context).size.width * 0.85,
    backgroundColor: Color(0xff98E165),
    margin: EdgeInsets.all(4),
    borderRadius: BorderRadius.only(
        topRight: Radius.elliptical(30, 15),
        bottomLeft: Radius.elliptical(30, 15)),
    child: Text(
      'We have made some modifications to the border radius to make it more free',
    ),
  )
```