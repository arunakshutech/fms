import 'package:flutter/material.dart';

class BubbleTabIndicator extends Decoration {
  final BoxPainter _painter;

  BubbleTabIndicator({required Color color})
      : _painter = _BubblePainter(color: color);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _painter;
}

class _BubblePainter extends BoxPainter {
  final Paint _paint;

  _BubblePainter({required Color color})
      : _paint = Paint()
          ..color = color
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final double height = cfg.size!.height;
    final double width = cfg.size!.width;

    const double radius = 45.0; // Adjust this radius to fit the bubble size
    final Offset circleOffset = Offset(offset.dx + width / 2, offset.dy + height / 2);

    // Draw the bubble
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}
