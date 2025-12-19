import 'package:flutter/material.dart';

ThemeData getApplicationTheme(){

  return ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 145, 94, 222)),
        useMaterial3: true,
        fontFamily: 'OpenSans Bold',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(
              fontSize: 18,
              color: Color.fromARGB(255, 233, 240, 233),
              fontWeight: FontWeight.w500,
              fontFamily: 'OpenSans Regular'),
              backgroundColor: const Color.fromARGB(255, 236, 233, 229),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
          ),
        ),
        appBarTheme: AppBarTheme(
          
        )
  );
}