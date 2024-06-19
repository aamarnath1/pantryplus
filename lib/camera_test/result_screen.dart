import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';
import 'dart:typed_data';




class ResultScreen extends StatefulWidget {
  final String text;
  const ResultScreen({Key? key, required this.text}) : super(key: key);
@override
  _ResultScreenState createState() => _ResultScreenState();
}


class _ResultScreenState extends State<ResultScreen> {
  String displayedText = '';

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Result'),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(30.0),
      // child:Text(text, style: const TextStyle(fontSize: 24.0))
      child: Column(
        children: [
          Text(widget.text, style: const TextStyle(fontSize: 24.0)),
        ]

    ),
  )
  );

   void updateText(String newText) {
    setState(() {
      displayedText = newText;
    });
  }
}