import 'package:flutter/material.dart';

// The only place with a raw colour: the seed. Screens use Theme.of(context).colorScheme.*.
const Color _seed = Color(0xFF5B5BD6);

ThemeData buildAppTheme(Brightness brightness) => ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: _seed, brightness: brightness),
    );
