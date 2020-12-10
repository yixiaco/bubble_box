[![pub package](https://img.shields.io/badge/pub-v0.0.3-blue.svg)](https://pub.dev/packages/bubble_box)

[English](https://pub.dev/packages/bubble_box) [中文](https://github.com/18905059768/bubble_box/blob/master/README_zh.md)
# bubble_box

A powerful bubble box, which implements basic bubble, border, dotted line, gradient color, angle, adaptive width and height, bubble direction, offset, etc.

This project was writed with pure dart code，which means it's support both iOS and Android.

## Screenshot
<img src="https://raw.githubusercontent.com/18905059768/bubble_box/master/01.jpg" width="300">

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
        'However, I am not only unable to customize the borders and sharp corners of the bubbles. I can also define the border as a dashed line and a gradient of border color. \nI am adaptive to the content, there is no need to set the width and height. Of course, you can limit the maximum width and height of the component. \nMy content can also be faded. \nIn addition, you may need some shadows, and the shadows may also need some of their own colors.'),
  )
```
