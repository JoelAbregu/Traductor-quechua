import 'package:flutter/material.dart';
 
import 'package:translator_quechua/config/theme/apptheme.dart';
import 'package:translator_quechua/presentation/screens/translator_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   
    return MaterialApp(
      title: 'Translator Quechua',
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
      home: const TranslatorScreen(),
    );
  }
}
