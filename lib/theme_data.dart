import 'package:flutter/material.dart';

import 'constants.dart';

final themeData = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.white,
  primarySwatch: Colors.teal,
  fontFamily: 'Roboto',
  textTheme: TextTheme(
    headline1: TextStyle(
      color: colors[1],
      fontFamily: 'Audiowave',
      fontWeight: FontWeight.w600,
      letterSpacing: 4,
      height: 1,
      fontSize: 50,
    ),
  ),
  iconTheme: IconThemeData(
    color: colors[0],
  ),
);