import 'dart:ui';

import 'package:flutter/material.dart';
import 'shape/bubble_shape_border.dart';

/// 气泡框组件
/// 注意，在[ListView]中，每一个子组件都强制充满宽度，需要用其他可确认宽度的组件包裹该组件，例如[Row]和[Column]，否则该组件也将被强制填充宽度
class BubbleBox extends StatelessWidget {
  /// 子组件
  final Widget child;

  /// 气泡背景颜色
  final Color? backgroundColor;

  /// 基于基础内边距的距离边框内边距
  final EdgeInsets padding;

  /// 基于基础内边距的距离边框外边距
  final EdgeInsets? margin;

  /// 如果外层是一个不确定宽度的父组件，则设置基于[LimitedBox]最大宽度大小
  final double? maxWidth;

  /// 如果外层是一个不确定高度的父组件，则设置基于[LimitedBox]最大高大小
  final double? maxHeight;

  /// 如果外层是一个固定宽度的父组件，则设置基于[FractionallySizedBox]最大宽度因子
  final double? widthFactor;

  /// 这是一个[FractionallySizedBox]对象属性的快捷方式
  final double? heightFactor;

  /// 阴影
  final double elevation;

  /// 阴影颜色
  final Color? shadowColor;

  /// 渐变,基于混合模式，可以设置背景或者内容
  final Gradient? gradient;

  /// 渐变合成模式,默认叠加于背景颜色之上，内容之下
  final BlendMode blendMode;

  /// 定义材质的形状
  /// 如果为空，则默认使用[BubbleShapeBorder]
  final ShapeBorder? shape;

  BubbleBox({
    Key? key,
    required this.child,
    this.backgroundColor,
    this.maxWidth,
    this.maxHeight,
    this.widthFactor,
    this.heightFactor,
    this.elevation = 0.0,
    this.shadowColor,
    this.gradient,
    this.blendMode = BlendMode.dstATop,
    this.margin,
    this.padding = const EdgeInsets.all(8),
    ShapeBorder? shape,
  })  : this.shape = shape ?? BubbleShapeBorder(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget current = Padding(
      padding: padding.add(shape?.dimensions ?? EdgeInsets.zero),
      child: child,
    );
    // 渐变
    if (gradient != null) {
      current = ShaderMask(
        shaderCallback: (Rect rect) {
          return gradient!.createShader(rect);
        },
        blendMode: blendMode,
        child: current,
      );
    }
    // 气泡框裁剪
    current = Material(
      shape: shape,
      clipBehavior: Clip.antiAlias,
      color: backgroundColor,
      shadowColor: shadowColor,
      elevation: elevation,
      child: current,
    );
    if (margin != null) {
      current = Padding(
        padding: margin!,
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
