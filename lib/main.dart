import 'package:flutter/material.dart';
import 'package:testnewtron/pages/home.dart';
import 'package:testnewtron/pages/home_base.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.lightBlue,
      ),
      home: const HomeBasePage(),
    );
  }
}
