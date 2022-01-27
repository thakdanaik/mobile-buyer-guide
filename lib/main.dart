import 'package:flutter/material.dart';
import 'package:mobile_buyer_guide/screens/catalog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Buyer\'s Guide',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const Catalog(),
    );
  }
}
