import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyColors {

      static const Color CUSTOM_RED = Color(0xFFff988d);
      static const Color CUSTOM_GREEN = Color(0xFFAFCDAE);

      static const List<Color> COLORS_PALLETTE = [
        Color(0xFFFFECE0),
        Color(0xFFE68E84),
        Color(0xFFFDEABF),
        Color(0xFFD4D8FC),

        Color(0xFFECA7F8),
        Color(0xFFF6BCBB),
        Color(0xFFFFD18B),
        Color(0xFF98E8CB),

        Color(0xFFDA6B8C),
        Color(0xFF93BFFE),
        Color(0xFFF7CEB8),
        Color(0xFFF6F2E7),

        Color(0xFFF9DE6A),
        Color(0xFFFFD5BF),
        Color(0xFF6DC9C9),
        Color(0xFFF1F8C5),

        Color(0xFFC6E1CE),
        Color(0xFFD6DFEF),
        Color(0xFFF1B9A3),
        Color(0xFFF8D6ED),
      ];

      static Color randomColor() {
        return MyColors.COLORS_PALLETTE[Random().nextInt(MyColors.COLORS_PALLETTE.length)];
      }

      static const MaterialColor WHITE = const MaterialColor(0xFFFFFFFF,
          const {
            50 : const Color(0xFFFFFFFF),
            100 : const Color(0xFFFFFFFF),
            200 : const Color(0xFFFFFFFF),
            300 : const Color(0xFFFFFFFF),
            400 : const Color(0xFFFFFFFF),
            500 : const Color(0xFFFFFFFF),
            600 : const Color(0xFFFFFFFF),
            700 : const Color(0xFFFFFFFF),
            800 : const Color(0xFFFFFFFF),
            900 : const Color(0xFFFFFFFF)
          }
      );

      static const MaterialColor TOMATO = const MaterialColor(0xf14656FF,
          const {
            50 : const Color(0xf14656FF),
            100 : const Color(0xf14656FF),
            200 : const Color(0xf14656FF),
            300 : const Color(0xf14656FF),
            400 : const Color(0xf14656FF),
            500 : const Color(0xd94568FF),
            600 : const Color(0xd94568FF),
            700 : const Color(0xd94568FF),
            800 : const Color(0xd94568FF),
            900 : const Color(0xd94568FF)
          }
      );
}