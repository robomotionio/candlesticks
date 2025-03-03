import 'package:candlestix/src/models/candle.dart';
import 'package:candlestix/src/theme/theme_data.dart';
import 'package:candlestix/src/utils/helper_functions.dart';
import 'package:flutter/material.dart';

class CandleInfoText extends StatelessWidget {
  const CandleInfoText({
    Key? key,
    required this.candle,
  }) : super(key: key);

  final Candle candle;

  String numberFormat(int value) {
    return "${value < 10 ? 0 : ""}$value";
  }

  String dateFormatter(DateTime date) {
    return "${date.year}-${numberFormat(date.month)}-${numberFormat(date.day)} ${numberFormat(date.hour)}:${numberFormat(date.minute)}";
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: dateFormatter(candle.date),
        style: TextStyle(color: Theme.of(context).grayColor, fontSize: 10),
        children: <TextSpan>[
          TextSpan(text: " O:"),
          TextSpan(
              text: HelperFunctions.priceToString(candle.open),
              style: TextStyle(
                  color: candle.isBull
                      ? Theme.of(context).primaryGreen
                      : Theme.of(context).primaryRed)),
          TextSpan(text: " H:"),
          TextSpan(
              text: HelperFunctions.priceToString(candle.high),
              style: TextStyle(
                  color: candle.isBull
                      ? Theme.of(context).primaryGreen
                      : Theme.of(context).primaryRed)),
          TextSpan(text: " L:"),
          TextSpan(
              text: HelperFunctions.priceToString(candle.low),
              style: TextStyle(
                  color: candle.isBull
                      ? Theme.of(context).primaryGreen
                      : Theme.of(context).primaryRed)),
          TextSpan(text: " C:"),
          TextSpan(
              text: HelperFunctions.priceToString(candle.close),
              style: TextStyle(
                  color: candle.isBull
                      ? Theme.of(context).primaryGreen
                      : Theme.of(context).primaryRed)),
        ],
      ),
    );
  }
}
