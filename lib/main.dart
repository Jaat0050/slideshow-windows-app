import 'dart:io';

import 'package:ffmpeg_helper/ffmpeg_helper.dart';
import 'package:flutter/material.dart';
import 'package:slideshow_app/app/screens/home_screen.dart';
import 'package:slideshow_app/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FFMpegHelper.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interactive Slideshow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.black,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey).copyWith(secondary: Colors.black),
          fontFamily: 'Roboto',
          textTheme: const TextTheme(
            titleLarge: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black38,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          scaffoldBackgroundColor: backgroundColor),
      home: HomeScreen(),
    );
  }
}
