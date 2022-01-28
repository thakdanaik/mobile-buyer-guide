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
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.black,
          displayColor: Colors.black,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const Catalog(),
    );
  }
}
