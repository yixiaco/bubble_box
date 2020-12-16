library bubble_box;

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'util/path_util.dart';

enum BubbleDirection { top, bottom, right, left, none }

/// 气泡盒子定位参数
class BubblePosition {
  /// 对齐顶部位置偏移，当[BubbleDirection.left]和[BubbleDirection.right]生效
  double top;

  /// 对齐底部位置偏移，当[BubbleDirection.left]和[BubbleDirection.right]生效
  double bottom;

  /// 对齐左边位置偏移，当[BubbleDirection.top]和[BubbleDirection.bottom]生效
  double left;

  /// 对齐右边位置偏移，当[BubbleDirection.top]和[BubbleDirection.bottom]生效
  double right;

  /// 对齐中间位置偏移,所有位置生效,除了[BubbleDirection.none]
  double center;

  /// 同时只能声明一个方向
  BubblePosition({this.top, this.bottom, this.left, this.right, this.center});
}

enum BubbleBoxBorderStyle { none, solid, dashed }

/// 气泡盒子边框参数
class BubbleBoxBorder {
  /// 设置线条颜色
  final Color color;

  /// 设置线条宽度
  final double width;

  /// 设置虚线、实现、无线条
  final BubbleBoxBorderStyle style;

  /// 如果是虚线，设置虚线线条的长度
  final double dashedWidth;

  /// 如果是虚线，设置虚线的空白间隙
  final double dashedGap;

  /// 渐变,应用于边框颜色，[color]将无效
  final Gradient gradient;

  BubbleBoxBorder({
    this.color = const Color(0xFF000000),
    this.width = 1,
    this.style = BubbleBoxBorderStyle.solid,
    this.dashedGap,
    this.dashedWidth = 5,
    this.gradient,
  });
}

/// 气泡框组件
/// 注意，在[ListView]中，每一个子组件都强制充满宽度，需要用其他可确认宽度的组件包裹该组件，例如[Row]和[Column]，否则该组件也将被强制填充宽度
class BubbleBox extends StatelessWidget {
  /// 子组件
  final Widget child;

  /// 气泡背景颜色
  final Color backgroundColor;

  /// 气泡圆角
  final double radius;

  /// 基于基础内边距的距离边框内边距
  final EdgeInsets padding;

  /// 基于基础内边距的距离边框外边距
  final EdgeInsets margin;

  /// 气泡方向
  final BubbleDirection direction;

  /// 气泡尖角高度
  final double arrowHeight;

  /// 气泡尖角角度
  final double arrowAngle;

  /// 气泡尖角钝角长度
  final double arrowQuadraticBezierLength;

  /// 如果外层是一个不确定宽度的父组件，则设置基于[LimitedBox]最大宽度大小
  final double maxWidth;

  /// 如果外层是一个不确定高度的父组件，则设置基于[LimitedBox]最大高大小
  final double maxHeight;

  /// 如果外层是一个固定宽度的父组件，则设置基于[FractionallySizedBox]最大宽度因子
  final double widthFactor;

  /// 这是一个[FractionallySizedBox]对象属性的快捷方式
  final double heightFactor;

  /// 尖角定位偏移
  final BubblePosition position;

  /// 阴影
  final double elevation;

  /// 边框，可设置颜色、线条宽度、虚线、实线
  final BubbleBoxBorder border;

  /// 阴影颜色
  final Color shadowColor;

  /// 渐变,基于混合模式，可以设置背景或者内容
  final Gradient gradient;

  /// 渐变合成模式,默认叠加于背景颜色之上，内容之下
  final BlendMode blendMode;

  /// 边框圆角
  final BorderRadius borderRadius;

  BubbleBox({
    @required this.child,
    this.backgroundColor,
    this.radius = 4,
    this.padding = const EdgeInsets.all(8),
    this.direction = BubbleDirection.none,
    this.arrowAngle = 6,
    this.arrowHeight = 6,
    this.maxWidth,
    this.maxHeight,
    this.widthFactor,
    this.heightFactor,
    this.position,
    this.elevation = 0.0,
    this.border,
    this.shadowColor,
    this.gradient,
    this.blendMode = BlendMode.dstATop,
    this.margin,
    this.arrowQuadraticBezierLength,
    this.borderRadius,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EdgeInsets _margin;
    if (direction == BubbleDirection.left) {
      _margin = EdgeInsets.only(left: arrowHeight);
    } else if (direction == BubbleDirection.top) {
      _margin = EdgeInsets.only(top: arrowHeight);
    } else if (direction == BubbleDirection.right) {
      _margin = EdgeInsets.only(right: arrowHeight);
    } else if (direction == BubbleDirection.bottom) {
      _margin = EdgeInsets.only(bottom: arrowHeight);
    } else {
      _margin = EdgeInsets.zero;
    }
    if (border != null && border.style != BubbleBoxBorderStyle.none) {
      _margin += EdgeInsets.all(border.width / 2);
    }
    // 不能比尖角高度长
    double _aqbl = arrowQuadraticBezierLength != null &&
            arrowQuadraticBezierLength > arrowHeight
        ? arrowHeight
        : arrowQuadraticBezierLength;

    Widget current = Padding(
      padding: (padding ?? EdgeInsets.all(0)) + _margin,
      child: child,
    );
    // 渐变
    if (gradient != null) {
      current = ShaderMask(
        shaderCallback: (Rect rect) {
          return gradient.createShader(rect);
        },
        blendMode: blendMode,
        child: current,
      );
    }
    // 气泡框裁剪
    current = Material(
      shape: BubbleShapeBorder(
        radius: borderRadius ?? BorderRadius.circular(radius ?? 0),
        direction: direction,
        arrowAngle: arrowAngle,
        arrowHeight: arrowHeight,
        position: position,
        border: border,
        arrowQuadraticBezierLength: _aqbl,
      ),
      clipBehavior: Clip.antiAlias,
      color: backgroundColor,
      shadowColor: shadowColor,
      elevation: elevation,
      child: current,
    );
    if (margin != null) {
      current = Padding(
        padding: margin,
        child: current,
      );
    }
    if (maxWidth != null || maxHeight != null) {
      current = LimitedBox(
        maxWidth: maxWidth ?? double.infinity,
        maxHeight: maxHeight ?? double.infinity,
        child: current,
      );
    }
    if (widthFactor != null || heightFactor != null) {
      current = FractionallySizedBox(
        widthFactor: widthFactor ?? 1,
        heightFactor: heightFactor ?? 1,
        child: current,
      );
    }
    return current;
  }
}

/// 气泡边框渲染
class BubbleShapeBorder extends ShapeBorder {
  final BubbleDirection direction;
  final double arrowHeight;
  final double arrowAngle;

  /// 气泡尖角钝角长度
  final double arrowQuadraticBezierLength;
  final BubblePosition position;
  final BubbleBoxBorder border;
  final BorderRadius radius;

  BubbleShapeBorder({
    this.direction,
    this.arrowAngle,
    this.arrowHeight,
    this.position,
    this.border,
    this.arrowQuadraticBezierLength,
    this.radius,
  });

  @override
  EdgeInsetsGeometry get dimensions => null;

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return null;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    Size size = Size(rect.width, rect.height);
    var path = Path();
    //高度
    double ah = arrowHeight;
    //角度
    double leftMargin = 0, rightMargin = 0, topMargin = 0, bottomMargin = 0;
    if (direction == BubbleDirection.left) {
      leftMargin += ah;
    } else if (direction == BubbleDirection.top) {
      topMargin += ah;
    } else if (direction == BubbleDirection.right) {
      rightMargin += ah;
    } else if (direction == BubbleDirection.bottom) {
      bottomMargin += ah;
    }

    /// 左上角半径
    path.moveTo(
        leftMargin,
        topMargin +
            _min(position?.top, radius.topLeft.y, BubbleDirection.left));
    path.quadraticBezierTo(
        leftMargin,
        topMargin,
        leftMargin +
            _min(position?.left, radius.topLeft.x, BubbleDirection.top),
        topMargin);

    /// 上尖角
    if (direction == BubbleDirection.top) {
      double p = _getTopBottomPosition(size);
      path.lineTo(p - arrowAngle, topMargin);
      if (arrowQuadraticBezierLength != null) {
        var x = arrowAngle * arrowQuadraticBezierLength / ah;
        path.lineTo(p - x, arrowQuadraticBezierLength);
        path.quadraticBezierTo(p, 0, p + x, arrowQuadraticBezierLength);
      } else {
        path.lineTo(p, 0);
      }
      path.lineTo(p + arrowAngle, topMargin);
    }

    /// 右上角半径
    path.lineTo(
        size.width -
            rightMargin -
            _min(position?.right, radius.topRight.x, BubbleDirection.top),
        topMargin);
    path.quadraticBezierTo(
        size.width - rightMargin,
        topMargin,
        size.width - rightMargin,
        topMargin +
            _min(position?.top, radius.topRight.y, BubbleDirection.right));

    /// 右尖角
    if (direction == BubbleDirection.right) {
      double p = _getLeftRightPosition(size);
      path.lineTo(size.width - rightMargin, p - arrowAngle);
      if (arrowQuadraticBezierLength != null) {
        var x = ah * arrowQuadraticBezierLength / arrowAngle;
        path.lineTo(size.width - arrowQuadraticBezierLength, p - x);
        path.quadraticBezierTo(
            size.width, p, size.width - arrowQuadraticBezierLength, p + x);
      } else {
        path.lineTo(size.width, p);
      }
      path.lineTo(size.width - rightMargin, p + arrowAngle);
    }

    /// 右下角半径
    path.lineTo(
        size.width - rightMargin,
        size.height -
            bottomMargin -
            _min(
                position?.bottom, radius.bottomRight.y, BubbleDirection.right));
    path.quadraticBezierTo(
        size.width - rightMargin,
        size.height - bottomMargin,
        size.width -
            rightMargin -
            _min(position?.right, radius.bottomRight.x, BubbleDirection.bottom),
        size.height - bottomMargin);

    /// 下尖角
    if (direction == BubbleDirection.bottom) {
      double p = _getTopBottomPosition(size);
      path.lineTo(p + arrowAngle - rightMargin, size.height - bottomMargin);
      if (arrowQuadraticBezierLength != null) {
        var x = arrowAngle * arrowQuadraticBezierLength / ah;
        path.lineTo(
            p + x - rightMargin, size.height - arrowQuadraticBezierLength);
        path.quadraticBezierTo(p - rightMargin, size.height,
            p - rightMargin - x, size.height - arrowQuadraticBezierLength);
      } else {
        path.lineTo(p, size.height);
      }
      path.lineTo(p - arrowAngle - rightMargin, size.height - bottomMargin);
    }

    /// 左下角半径
    path.lineTo(
        leftMargin +
            _min(position?.left, radius.bottomLeft.x, BubbleDirection.bottom),
        size.height - bottomMargin);
    path.quadraticBezierTo(
        leftMargin,
        size.height - bottomMargin,
        leftMargin,
        size.height -
            bottomMargin -
            _min(position?.bottom, radius.bottomLeft.y, BubbleDirection.left));

    /// 左尖角
    if (direction == BubbleDirection.left) {
      double p = _getLeftRightPosition(size);
      path.lineTo(leftMargin, p + arrowAngle);
      if (arrowQuadraticBezierLength != null) {
        var x = ah * arrowQuadraticBezierLength / arrowAngle;
        path.lineTo(arrowQuadraticBezierLength, p + x);
        path.quadraticBezierTo(0, p, arrowQuadraticBezierLength, p - x);
      } else {
        path.lineTo(0, p);
      }
      path.lineTo(leftMargin, p - arrowAngle);
    }

    /// 收尾
    path.lineTo(
        leftMargin,
        topMargin +
            _min(position?.top, radius.topRight.y, BubbleDirection.left));
    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {
    Path path;
    if (border != null && border.style != BubbleBoxBorderStyle.none) {
      if (border.style == BubbleBoxBorderStyle.dashed) {
        path = PathUtil.dashPath(
          getOuterPath(rect),
          border.dashedWidth,
          border.dashedGap,
        );
      } else {
        path = getOuterPath(rect);
      }
      canvas.drawPath(
          path,
          Paint()
            ..shader = border?.gradient?.createShader(rect)
            ..isAntiAlias = true
            ..color = border.color
            ..strokeWidth = border.width
            ..style = PaintingStyle.stroke);
    }
  }

  @override
  ShapeBorder scale(double t) {
    return this;
  }

  /// 左右定位
  double _getLeftRightPosition(Size size) {
    double p = size.height / 2;
    if (position?.top != null) {
      p = position.top + arrowAngle;
    } else if (position?.bottom != null) {
      p = size.height - arrowAngle - position.bottom;
    } else if (position?.center != null) {
      p = p + position.center;
    }
    assert(p >= arrowAngle && p <= size.height - arrowAngle);
    return p;
  }

  /// 上下定位
  double _getTopBottomPosition(Size size) {
    double p = size.width / 2;
    if (position?.left != null) {
      p = position.left + arrowAngle;
    } else if (position?.right != null) {
      p = size.width - position.right - arrowAngle;
    } else if (position?.center != null) {
      p = p + position.center;
    }
    assert(p >= arrowAngle && p <= size.width - arrowAngle);
    return p;
  }

  double _min(double v1, double v2, BubbleDirection direction) {
    if (this.direction != direction) {
      return v2;
    }
    if (v1 == null) {
      return v2;
    }
    if (v2 == null) {
      return v1;
    }
    return min(v1, v2);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BubbleShapeBorder &&
          direction == other.direction &&
          arrowHeight == other.arrowHeight &&
          arrowAngle == other.arrowAngle &&
          arrowQuadraticBezierLength == other.arrowQuadraticBezierLength &&
          position == other.position &&
          border == other.border &&
          radius == other.radius;

  @override
  int get hashCode =>
      direction.hashCode ^
      arrowHeight.hashCode ^
      arrowAngle.hashCode ^
      arrowQuadraticBezierLength.hashCode ^
      position.hashCode ^
      border.hashCode ^
      radius.hashCode;
}
