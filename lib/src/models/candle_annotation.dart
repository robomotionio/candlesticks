import 'package:flutter/material.dart';

enum AnnotationAlignment {
  Top,
  Bottom,
}

abstract class Annotation {
  void paint(
    PaintingContext context,
    Offset candleTop,
    Offset candleBottom,
  );
}

class TriangleAnnotation extends Annotation {
  TriangleAnnotation({
    this.text,
    this.radius = 5,
    this.color = Colors.green,
    this.textStyle,
    this.annotationAlignment = AnnotationAlignment.Bottom,
  });

  final String? text;
  final double radius;
  final Color color;
  final TextStyle? textStyle;
  final AnnotationAlignment annotationAlignment;

  @override
  void paint(PaintingContext context, Offset candleTop, Offset candleBottom) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Offset center = annotationAlignment == AnnotationAlignment.Bottom
        ? candleBottom.translate(0, 20)
        : candleTop.translate(0, -20);

    var path = Path();
    switch (annotationAlignment) {
      case AnnotationAlignment.Bottom:
        path.moveTo(center.dx, center.dy - radius / 2);
        path.lineTo(center.dx - radius / 2, center.dy + radius / 2);
        path.lineTo(center.dx + radius / 2, center.dy + radius / 2);
        break;
      case AnnotationAlignment.Top:
        path.moveTo(center.dx, center.dy + radius / 2);
        path.lineTo(center.dx - radius / 2, center.dy - radius / 2);
        path.lineTo(center.dx + radius / 2, center.dy - radius / 2);
        break;
    }
    path.close();

    context.canvas.drawPath(path, paint);

    if (text != null) {
      final textSpan = TextSpan(
        text: text,
        style: textStyle ?? TextStyle(color: color, fontSize: 12),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout(
        minWidth: 0,
        maxWidth: 80,
      );

      final offset = Offset(
        candleBottom.dx - textPainter.width / 2,
        annotationAlignment == AnnotationAlignment.Bottom
            ? candleBottom.dy + 2 * radius + textPainter.height + 5
            : candleTop.dy - 2 * radius - 2 * textPainter.height - 5,
      );
      textPainter.paint(context.canvas, offset);
    }
  }
}
