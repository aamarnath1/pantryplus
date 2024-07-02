import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';
import 'dart:typed_data';

import 'package:keep_fresh/flutter_flow/flutter_flow_theme.dart';



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
    backgroundColor: Color(0xFFEDE8DF),
    appBar: AppBar(
      iconTheme: IconThemeData(
        color: const Color(0xFF000000), //change your color here
      ),
      title: Text(
        'Result',
        style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  fontFamily: 'Comfortaa',
                                  letterSpacing: 0,
                                  color: const Color(0xFF000000),
                                  useGoogleFonts: GoogleFonts.asMap()
                                                  .containsKey('Comfortaa'),   
                                ),
      
      ),
       backgroundColor: Color(0xFFEDE8DF),
      ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(30.0),
      // child:Text(text, style: const TextStyle(fontSize: 24.0))
      child: Column(
        children: [
          Text(widget.text, style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyLarge
                                                      .override(
                                                        fontFamily: 'Comfortaa',
                                                        letterSpacing: 0.0,
                                                        color: const Color(0xFF101518)
                                                      ),)
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