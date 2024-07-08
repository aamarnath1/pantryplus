import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_html/flutter_html.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_theme.dart';



class ResultScreen extends StatefulWidget {
  final String text;
  final String imagePath; 
  const ResultScreen({
    Key? key,
    this.text = '',
    this.imagePath = '',
    this.productData = const {},
  }) : super(key: key);
  final Map<String, Object?> productData;
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
        if(widget.text.isNotEmpty)
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: FileImage(File(widget.imagePath)),
              ),
            ),
          ),
          Html(data: widget.text),
        if(widget.productData.isNotEmpty)
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: Image.network('${widget.productData['imageUrl']}').image,
              ),
            ),
          ),
         Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
           children: [
              if(widget.productData['productName'] != null)
                _buildInfoRow('Product Name', '${widget.productData['productName']}'),
              if(widget.productData['brand'] != null)
              _buildInfoRow('Brand', '${widget.productData['brand']}'),
              if(widget.productData['nutriments'] != null)
              _buildInfoRow('Nutriments', '${widget.productData['nutriments']}'),
              if(widget.productData['additives'] != null)
              _buildInfoRow('Additives', '${widget.productData['additives']}'),
              if(widget.productData['ingredients'] != null)
              _buildInfoRow('Ingredients', '${widget.productData['ingredients']}'),
              if(widget.productData['countries'] != null)
              _buildInfoRow('Countries', '${widget.productData['countries']}'),
              if(widget.productData['nutriScore'] != null)
              _buildInfoRow('NutriScore', '${widget.productData['nutriScore']}')
            ],
        ),
      ),
        ],
    ),
          

    ),
  );

  Widget _buildInfoRow(String label, String value) {
    return Card(
      elevation: 2,
      color:Color.fromARGB(255, 255, 255, 255),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$label : ',
              style: FlutterFlowTheme.of(context)
                                .bodyLarge
                                .override(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Comfortaa',
                                  letterSpacing: 0,
                                  color: const Color(0xFF000000),
                                  useGoogleFonts: GoogleFonts.asMap()
                                                  .containsKey('Comfortaa'),   
                                ), 
            ),
            Expanded(
              child: Text(value,
                style: FlutterFlowTheme.of(context)
                                .bodyLarge
                                .override(
                                  fontFamily: 'Comfortaa',
                                  letterSpacing: 0,
                                  color: const Color(0xFF000000),
                                  useGoogleFonts: GoogleFonts.asMap()
                                                  .containsKey('Comfortaa'),   
                                ),  
                ),
              ),
          ],
        ),
      ),
    );
  }
}