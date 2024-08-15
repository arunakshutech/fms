import 'package:flutter/material.dart';

class RoundedTabIndicator extends Decoration {
  final BoxPainter _painter;

  RoundedTabIndicator({required Color color, required double radius})
      : _painter = _RoundedPainter(color, radius);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _painter;
}

class _RoundedPainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _RoundedPainter(Color color, this.radius)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset = Offset(
      offset.dx + cfg.size!.width / 2,
      cfg.size!.height - radius-24,
    );
    canvas.drawCircle(circleOffset, 30, _paint);
  }
}
