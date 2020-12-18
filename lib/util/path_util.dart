import 'dart:ui';

class PathUtil {
  /// 获取虚线路径
  /// [path] 路径
  /// [length] 线条长度
  /// [gap] 间隙长度
  /// [distance] 初始偏移
  static Path dashPath(final Path path, double length,
      [double? gap, double? distance = 0]) {
    gap ??= length;
    PathMetrics pathMetrics = path.computeMetrics();
    Path dest = Path();
    for (var metric in pathMetrics) {
      bool draw = true;
      while (distance! < metric.length) {
        if (draw) {
          dest.addPath(
            metric.extractPath(distance, distance + length),
            Offset.zero,
          );
          distance += length;
        } else {
          distance += gap;
        }
        draw = !draw;
      }
    }
    return dest;
  }
}
