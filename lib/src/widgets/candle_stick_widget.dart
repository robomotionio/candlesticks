import 'package:candlestix/src/models/candle.dart';
import 'package:candlestix/src/models/candle_annotation.dart';
import 'package:flutter/material.dart';
import '../models/candle.dart';

class CandleStickWidget extends LeafRenderObjectWidget {
  final List<Candle> candles;
  final int index;
  final double candleWidth;
  final double high;
  final double low;
  final Color bullColor;
  final Color bearColor;
  final List<Annotation?> annotations;

  CandleStickWidget({
    required this.candles,
    required this.index,
    required this.candleWidth,
    required this.low,
    required this.high,
    required this.bearColor,
    required this.bullColor,
    required this.annotations,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return CandleStickRenderObject(
      candles,
      index,
      candleWidth,
      low,
      high,
      bullColor,
      bearColor,
      annotations,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderObject renderObject) {
    CandleStickRenderObject candlestickRenderObject =
        renderObject as CandleStickRenderObject;

    if (index <= 0 && candlestickRenderObject._close != candles[0].close) {
      candlestickRenderObject._candles = candles;
      candlestickRenderObject._index = index;
      candlestickRenderObject._candleWidth = candleWidth;
      candlestickRenderObject._high = high;
      candlestickRenderObject._low = low;
      candlestickRenderObject._bullColor = bullColor;
      candlestickRenderObject._bearColor = bearColor;
      candlestickRenderObject.markNeedsPaint();
    } else if (candlestickRenderObject._index != index ||
        candlestickRenderObject._candleWidth != candleWidth ||
        candlestickRenderObject._high != high ||
        candlestickRenderObject._low != low) {
      candlestickRenderObject._candles = candles;
      candlestickRenderObject._index = index;
      candlestickRenderObject._candleWidth = candleWidth;
      candlestickRenderObject._high = high;
      candlestickRenderObject._low = low;
      candlestickRenderObject._bullColor = bullColor;
      candlestickRenderObject._bearColor = bearColor;
      candlestickRenderObject.markNeedsPaint();
    }
    super.updateRenderObject(context, renderObject);
  }
}

class CandleStickRenderObject extends RenderBox {
  late List<Candle> _candles;
  late int _index;
  late double _candleWidth;
  late double _low;
  late double _high;
  late double _close;
  late Color _bullColor;
  late Color _bearColor;
  late List<Annotation?> _annotations;

  CandleStickRenderObject(
    List<Candle> candles,
    int index,
    double candleWidth,
    double low,
    double high,
    Color bullColor,
    Color bearColor,
    List<Annotation?> annotations,
  ) {
    _candles = candles;
    _index = index;
    _candleWidth = candleWidth;
    _low = low;
    _high = high;
    _bearColor = bearColor;
    _bullColor = bullColor;
    _annotations = annotations;
  }

  /// set size as large as possible
  @override
  void performLayout() {
    size = Size(constraints.maxWidth, constraints.maxHeight);
  }

  /// draws a single candle
  void paintCandle(PaintingContext context, Offset offset, int index,
      Candle candle, Annotation? annotation, double range) {
    Color color = candle.isBull ? _bullColor : _bearColor;

    final candleTop = Offset(
      size.width + offset.dx - (index + 0.5) * _candleWidth,
      offset.dy + (_high - candle.high) / range,
    );

    final len = (candle.high - candle.low) / range;

    final candleBottom = Offset(candleTop.dx, candleTop.dy + len);

    annotation?.paint(context, candleTop, candleBottom);

    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    double x = size.width + offset.dx - (index + 0.5) * _candleWidth;

    context.canvas.drawLine(
      Offset(x, offset.dy + (_high - candle.high) / range),
      Offset(x, offset.dy + (_high - candle.low) / range),
      paint,
    );

    final double openCandleY = offset.dy + (_high - candle.open) / range;
    final double closeCandleY = offset.dy + (_high - candle.close) / range;

    if ((openCandleY - closeCandleY).abs() > 1) {
      context.canvas.drawLine(
        Offset(x, openCandleY),
        Offset(x, closeCandleY),
        paint..strokeWidth = _candleWidth - 1,
      );
    } else {
      // if the candle body is too small
      final double mid = (closeCandleY + openCandleY) / 2;
      context.canvas.drawLine(
        Offset(x, mid - 0.5),
        Offset(x, mid + 0.5),
        paint..strokeWidth = _candleWidth - 1,
      );
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    double range = (_high - _low) / size.height;
    for (int i = 0; (i + 1) * _candleWidth < size.width; i++) {
      if (i + _index >= _candles.length || i + _index < 0) continue;
      var candle = _candles[i + _index];
      final annotation =
          i + _index >= _annotations.length ? null : _annotations[i + _index];
      paintCandle(context, offset, i, candle, annotation, range);
    }
    _close = _candles[0].close;
    context.canvas.save();
    context.canvas.restore();
  }
}
