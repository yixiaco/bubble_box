import 'dart:math' as math;

import 'package:bubble_box/src/util/path_util.dart';
import 'package:flutter/material.dart';

/// 气泡方向
enum BubbleDirection {
  /// 气泡尖角在上方
  top,

  /// 气泡尖角在下方
  bottom,

  /// 气泡尖角在右侧
  right,

  /// 气泡尖角在左侧
  left,

  /// 不显示气泡尖角
  none
}

/// 气泡盒子定位参数
class BubblePosition {
  /// [BubbleDirection.top]、[BubbleDirection.bottom],左边距
  /// [BubbleDirection.left]、[BubbleDirection.right],上边距
  final double? start;

  /// [BubbleDirection.top]、[BubbleDirection.bottom],右边距
  /// [BubbleDirection.left]、[BubbleDirection.right],下边距
  final double? end;

  /// 对齐中间位置偏移,所有位置生效,除了[BubbleDirection.none]
  final double? center;

  /// 使用开始偏移
  const BubblePosition.start(this.start)
      : end = null,
        center = null;

  /// 使用结束偏移
  const BubblePosition.end(this.end)
      : start = null,
        center = null;

  /// 使用中间偏移
  const BubblePosition.center(this.center)
      : start = null,
        end = null;

  const BubblePosition._(this.start, this.end, this.center);

  /// 定位参数有值的倍数相乘
  operator *(double scale) {
    double? start;
    double? end;
    double? center;
    if (this.start != null) {
      start = this.start! * scale;
    }
    if (this.end != null) {
      end = this.end! * scale;
    }
    if (this.center != null) {
      center = this.center! * scale;
    }
    return BubblePosition._(start, end, center);
  }
}

/// 气泡边框线条的样式
enum BubbleBoxBorderStyle {
  /// 无线条
  none,

  /// 实线
  solid,

  /// 虚线
  dashed
}

/// 气泡盒子边框参数
class BubbleBoxBorder {
  /// 设置线条颜色
  final Color color;

  /// 设置线条宽度
  final double width;

  /// 设置虚线、实线、无线条
  final BubbleBoxBorderStyle style;

  /// 如果是虚线，设置虚线线条的长度
  final double dashedWidth;

  /// 如果是虚线，设置虚线的空白间隙
  final double? dashedGap;

  /// 渐变,应用于边框颜色，[color]将无效
  final Gradient? gradient;

  BubbleBoxBorder({
    this.color = const Color(0xFF000000),
    this.width = 1,
    this.style = BubbleBoxBorderStyle.solid,
    this.dashedGap,
    this.dashedWidth = 5,
    this.gradient,
  });

  /// 放大倍率
  BubbleBoxBorder scale(double t) {
    return BubbleBoxBorder(
      color: color,
      style: style,
      width: width * t,
      dashedGap: (dashedGap ?? dashedWidth) * t,
      gradient: gradient?.scale(t),
      dashedWidth: dashedWidth * t,
    );
  }
}

/// 气泡边框渲染
class BubbleShapeBorder extends ShapeBorder {
  /// 气泡的方向
  final BubbleDirection direction;

  /// 气泡高度
  final double arrowHeight;

  /// 气泡尖角底部长度
  final double arrowAngle;

  /// 气泡尖角钝角长度
  final double arrowQuadraticBezierLength;

  /// 尖角定位偏移
  final BubblePosition position;

  /// 边框
  final BubbleBoxBorder? border;

  /// 半径
  final BorderRadius radius;

  /// 三角形底部圆润的角度
  final double smooth;

  BubbleShapeBorder({
    this.direction = BubbleDirection.none,
    this.arrowAngle = 6,
    this.arrowHeight = 6,
    this.position = const BubblePosition.center(0),
    this.border,
    this.arrowQuadraticBezierLength = 0,
    BorderRadius? radius,
    this.smooth = 1,
  }) : radius = radius ?? BorderRadius.circular(4);

  @override
  EdgeInsetsGeometry get dimensions {
    EdgeInsets _margin;
    switch (direction) {
      case BubbleDirection.left:
        _margin = EdgeInsets.only(left: arrowHeight);
        break;
      case BubbleDirection.top:
        _margin = EdgeInsets.only(top: arrowHeight);
        break;
      case BubbleDirection.right:
        _margin = EdgeInsets.only(right: arrowHeight);
        break;
      case BubbleDirection.bottom:
        _margin = EdgeInsets.only(bottom: arrowHeight);
        break;
      default:
        _margin = EdgeInsets.zero;
    }
    if (border != null && border!.style != BubbleBoxBorderStyle.none) {
      _margin += EdgeInsets.all(border!.width / 2);
    }
    return _margin;
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path();
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    // 修正塞贝尔曲线高度
    var arrowQuadraticBezierLength =
        this.arrowQuadraticBezierLength > arrowHeight
            ? arrowHeight
            : this.arrowQuadraticBezierLength;

    Size size = Size(rect.width, rect.height);

    //修改radius安全范围
    BorderRadius radius = _radius(size);

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
          math.min(_min(position.start, radius.topLeft.y, BubbleDirection.left),
              size.height),
    );
    path.quadraticBezierTo(
      leftMargin,
      topMargin,
      leftMargin +
          math.min(_min(position.start, radius.topLeft.x, BubbleDirection.top),
              size.width),
      topMargin,
    );

    /// 上尖角
    if (direction == BubbleDirection.top) {
      double p = _getTopBottomPosition(size);

      path.lineTo(p - arrowAngle - smooth, topMargin);

      var x = arrowAngle * arrowQuadraticBezierLength / ah;

      path.quadraticBezierTo(p - arrowAngle + smooth, topMargin, p - x,
          arrowQuadraticBezierLength);
      // path.lineTo(p - x, arrowQuadraticBezierLength);

      path.quadraticBezierTo(p, 0, p + x, arrowQuadraticBezierLength);

      path.quadraticBezierTo(p + arrowAngle - smooth, topMargin,
          p + arrowAngle + smooth, topMargin);
      // path.lineTo(p + arrowAngle, topMargin);
    }

    /// 右上角半径
    path.lineTo(
      size.width -
          rightMargin -
          math.min(_min(position.end, radius.topRight.x, BubbleDirection.top),
              size.width),
      topMargin,
    );
    path.quadraticBezierTo(
      size.width - rightMargin,
      topMargin,
      size.width - rightMargin,
      topMargin +
          math.min(
              _min(position.start, radius.topRight.y, BubbleDirection.right),
              size.height),
    );

    /// 右尖角
    if (direction == BubbleDirection.right) {
      double p = _getLeftRightPosition(size);

      path.lineTo(size.width - rightMargin, p - arrowAngle - smooth);

      var x = ah * arrowQuadraticBezierLength / arrowAngle;

      path.quadraticBezierTo(size.width - rightMargin, p - arrowAngle + smooth,
          size.width - arrowQuadraticBezierLength, p - x);
      // path.lineTo(size.width - arrowQuadraticBezierLength, p - x);

      path.quadraticBezierTo(
          size.width, p, size.width - arrowQuadraticBezierLength, p + x);

      path.quadraticBezierTo(size.width - rightMargin, p + arrowAngle - smooth,
          size.width - rightMargin, p + arrowAngle + smooth);
      // path.lineTo(size.width - rightMargin, p + arrowAngle);
    }

    /// 右下角半径
    path.lineTo(
      size.width - rightMargin,
      size.height -
          bottomMargin -
          math.min(
              _min(position.end, radius.bottomRight.y, BubbleDirection.right),
              size.height),
    );
    path.quadraticBezierTo(
        size.width - rightMargin,
        size.height - bottomMargin,
        size.width -
            rightMargin -
            math.min(
                _min(
                    position.end, radius.bottomRight.x, BubbleDirection.bottom),
                size.width),
        size.height - bottomMargin);

    /// 下尖角
    if (direction == BubbleDirection.bottom) {
      double p = _getTopBottomPosition(size);

      path.lineTo(
          p + arrowAngle - rightMargin + smooth, size.height - bottomMargin);

      var x = arrowAngle * arrowQuadraticBezierLength / ah;

      // path.lineTo(p + x - rightMargin, size.height - arrowQuadraticBezierLength);
      path.quadraticBezierTo(
          p + arrowAngle - rightMargin - smooth,
          size.height - bottomMargin,
          p + x - rightMargin,
          size.height - arrowQuadraticBezierLength);

      path.quadraticBezierTo(p - rightMargin, size.height, p - rightMargin - x,
          size.height - arrowQuadraticBezierLength);

      // path.lineTo(p - arrowAngle - rightMargin, size.height - bottomMargin);
      path.quadraticBezierTo(
          p - arrowAngle - rightMargin + smooth,
          size.height - bottomMargin,
          p - arrowAngle - rightMargin - smooth,
          size.height - bottomMargin);
    }

    /// 左下角半径
    path.lineTo(
        leftMargin +
            math.min(
                _min(position.start, radius.bottomLeft.x,
                    BubbleDirection.bottom),
                size.width),
        size.height - bottomMargin);
    path.quadraticBezierTo(
      leftMargin,
      size.height - bottomMargin,
      leftMargin,
      size.height -
          bottomMargin -
          math.min(
              _min(position.end, radius.bottomLeft.y, BubbleDirection.left),
              size.height),
    );

    /// 左尖角
    if (direction == BubbleDirection.left) {
      double p = _getLeftRightPosition(size);
      path.lineTo(leftMargin, p + arrowAngle + smooth);
      var x = ah * arrowQuadraticBezierLength / arrowAngle;

      path.quadraticBezierTo(leftMargin, p + arrowAngle - smooth,
          arrowQuadraticBezierLength, p + x);
      // path.lineTo(arrowQuadraticBezierLength, p + x);

      path.quadraticBezierTo(0, p, arrowQuadraticBezierLength, p - x);

      // path.lineTo(leftMargin, p - arrowAngle);
      path.quadraticBezierTo(leftMargin, p - arrowAngle + smooth, leftMargin,
          p - arrowAngle - smooth);
    }

    /// 收尾
    path.lineTo(
        leftMargin,
        topMargin +
            math.min(
                _min(position.start, radius.topRight.y, BubbleDirection.left),
                size.height));
    path = path.shift(rect.topLeft);
    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (border != null && border!.style != BubbleBoxBorderStyle.none) {
      Path path;
      if (border!.style == BubbleBoxBorderStyle.dashed) {
        path = PathUtil.dashPath(
          getOuterPath(rect),
          border!.dashedWidth,
          border!.dashedGap,
        );
      } else {
        path = getOuterPath(rect);
      }
      canvas.drawPath(
          path,
          Paint()
            ..shader = border?.gradient?.createShader(rect)
            ..isAntiAlias = true
            ..color = border!.color
            ..strokeWidth = border!.width
            ..style = PaintingStyle.stroke);
    }
  }

  @override
  ShapeBorder scale(double t) {
    return copyWith(
      radius: radius * t,
      border: border?.scale(t),
      smooth: smooth * t,
      arrowAngle: arrowAngle * t,
      arrowHeight: arrowHeight * t,
      arrowQuadraticBezierLength: arrowQuadraticBezierLength * t,
      position: position * t,
    );
  }

  /// 左右定位
  double _getLeftRightPosition(Size size) {
    double p = size.height / 2;
    if (position.start != null) {
      p = position.start! + arrowAngle;
    } else if (position.end != null) {
      p = size.height - arrowAngle - position.end!;
    } else if (position.center != null) {
      p = p + position.center!;
    }
    assert(p >= arrowAngle && p <= size.height - arrowAngle);
    return p;
  }

  /// 上下定位
  double _getTopBottomPosition(Size size) {
    double p = size.width / 2;
    if (position.start != null) {
      p = position.start! + arrowAngle;
    } else if (position.end != null) {
      p = size.width - position.end! - arrowAngle;
    } else if (position.center != null) {
      p = p + position.center!;
    }
    assert(p >= arrowAngle && p <= size.width - arrowAngle);
    return p;
  }

  /// 获取最小值
  double _min(double? v1, double v2, BubbleDirection direction) {
    if (this.direction != direction) {
      return v2;
    }
    if (v1 == null) {
      return v2;
    }
    return math.min(v1, v2);
  }

  /// 对radius值做处理,防越界
  BorderRadius _radius(Size size) {
    double topLeftX = 0,
        topLeftY = 0,
        topRightX = 0,
        topRightY = 0,
        bottomLeftX = 0,
        bottomLeftY = 0,
        bottomRightX = 0,
        bottomRightY = 0;
    switch (direction) {
      case BubbleDirection.left:
        topLeftY =
            size.height - _getLeftRightPosition(size) - arrowAngle / 2 + smooth;
        bottomLeftY = _getLeftRightPosition(size) - arrowAngle / 2 + smooth;
        break;
      case BubbleDirection.right:
        topRightY =
            size.height - _getLeftRightPosition(size) - arrowAngle / 2 + smooth;
        bottomRightY = _getLeftRightPosition(size) - arrowAngle / 2 + smooth;
        break;
      case BubbleDirection.top:
        topLeftX =
            size.width - _getTopBottomPosition(size) - arrowAngle / 2 + smooth;
        topRightX = _getTopBottomPosition(size) - arrowAngle / 2 + smooth;
        break;
      case BubbleDirection.bottom:
        bottomLeftX =
            size.width - _getTopBottomPosition(size) - arrowAngle / 2 + smooth;
        bottomRightX = _getTopBottomPosition(size) - arrowAngle / 2 + smooth;
        break;
      default:
    }
    BorderRadius _radius = radius.copyWith(
      topLeft: Radius.elliptical(
        _s(radius.topLeft.x, radius.topRight.x, size.width - topLeftX),
        _s(radius.topLeft.y, radius.bottomLeft.y, size.height - topLeftY),
      ),
      topRight: Radius.elliptical(
        _s(radius.topRight.x, radius.topLeft.x, size.width - topRightX),
        _s(radius.topRight.y, radius.bottomRight.y, size.height - topRightY),
      ),
      bottomLeft: Radius.elliptical(
        _s(radius.bottomLeft.x, radius.bottomRight.x, size.width - bottomLeftX),
        _s(radius.bottomLeft.y, radius.topLeft.y, size.height - bottomLeftY),
      ),
      bottomRight: Radius.elliptical(
        _s(radius.bottomRight.x, radius.bottomLeft.x,
            size.width - bottomRightX),
        _s(radius.bottomRight.y, radius.topRight.y, size.height - bottomRightY),
      ),
    );
    return _radius;
  }

  /// 比例最小值
  double _s(double s1, double s2, double length) {
    return math.min(math.min(s1, s1 / (s1 + s2) * length), length);
  }

  /// copyWith the border
  BubbleShapeBorder copyWith({
    final BubbleDirection? direction,
    final double? arrowHeight,
    final double? arrowAngle,
    final double? arrowQuadraticBezierLength,
    final BubblePosition? position,
    final BubbleBoxBorder? border,
    final BorderRadius? radius,
    final double? smooth,
    final double? dashedWidth,
    final double? dashedGap,
    final Gradient? gradient,
  }) {
    return BubbleShapeBorder(
      direction: direction ?? this.direction,
      arrowHeight: arrowHeight ?? this.arrowHeight,
      arrowAngle: arrowAngle ?? this.arrowAngle,
      arrowQuadraticBezierLength:
          arrowQuadraticBezierLength ?? this.arrowQuadraticBezierLength,
      position: position ?? this.position,
      border: border ?? this.border,
      radius: radius ?? this.radius,
      smooth: smooth ?? this.smooth,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BubbleShapeBorder &&
          runtimeType == other.runtimeType &&
          direction == other.direction &&
          arrowHeight == other.arrowHeight &&
          arrowAngle == other.arrowAngle &&
          arrowQuadraticBezierLength == other.arrowQuadraticBezierLength &&
          position == other.position &&
          border == other.border &&
          radius == other.radius &&
          smooth == other.smooth;

  @override
  int get hashCode =>
      direction.hashCode ^
      arrowHeight.hashCode ^
      arrowAngle.hashCode ^
      arrowQuadraticBezierLength.hashCode ^
      position.hashCode ^
      border.hashCode ^
      radius.hashCode ^
      smooth.hashCode;
}
