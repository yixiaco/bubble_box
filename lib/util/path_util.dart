import 'dart:ui';

class PathUtil {
  /// 获取虚线路径
  /// [path] 路径
  /// [length] 线条长度
  /// [gap] 间隙长度
  /// [distance] 初始偏移
  static Path dashPath(final Path path, double length,
      [double gap, double distance]) {
    if (gap == null) {
      gap = length;
    }
    PathMetrics pathMetrics = path.computeMetrics();
    Path dest = Path();
    for (var metric in pathMetrics) {
      double _distance = distance ?? 0;
      bool draw = true;
      while (_distance < metric.length) {
        if (draw) {
          dest.addPath(
            metric.extractPath(_distance, _distance + length),
            Offset.zero,
          );
          _distance += length;
        } else {
          _distance += gap;
        }
        draw = !draw;
      }
    }
    return dest;
  }
}
