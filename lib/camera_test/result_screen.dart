import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_theme.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_widgets.dart';



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
  @override
  void initState() {
    super.initState();
var displayJsonList = jsonDecode(widget.text);
  print('displayJson $displayJsonList, ${displayJsonList.runtimeType}');
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
          Container(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child : Table(
            border: TableBorder.all(
              borderRadius: BorderRadius.circular(10.0),
            ),
            children: [
              TableRow(
                 decoration: BoxDecoration(
                 borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
            color: FlutterFlowTheme.of(context).secondary,
          ),
                children: [
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Container( 
                    padding: const EdgeInsets.all(15),
                    child: Text('Name',
                  style: FlutterFlowTheme.of(context)
                                .bodyLarge
                                .override(
                                  fontFamily: 'Comfortaa',
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  useGoogleFonts: GoogleFonts.asMap()
                                                  .containsKey('Comfortaa'),   
                                ),
                    ),
                  ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Container( 
                    padding: const EdgeInsets.all(15),
                    child: Text('Type',
                  style: FlutterFlowTheme.of(context)
                                .bodyLarge
                                .override(
                                  fontFamily: 'Comfortaa',
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  useGoogleFonts: GoogleFonts.asMap()
                                                  .containsKey('Comfortaa'),   
                                ),
                    ),
                  ),
                  ),
                 TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Container( 
                    padding: const EdgeInsets.all(15),
                    child: Text('Expiry Date',
                  style: FlutterFlowTheme.of(context)
                                .bodyLarge
                                .override(
                                  fontFamily: 'Comfortaa',
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  useGoogleFonts: GoogleFonts.asMap()
                                                  .containsKey('Comfortaa'),   
                                ),
                    ),
                  ),
                  ),
                ],
              ),
              for (var i = 0; i < jsonDecode(widget.text).length; i++)
                TableRow(
                  children: [
                    TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Container( 
                    padding: const EdgeInsets.all(10),
                    child: Text(jsonDecode(widget.text)[i]['name'].toString(),
                    style: FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Comfortaa',
                                                        letterSpacing: 0.0,
                                                        color: const Color(0xFF101518)
                                                      ),
                    ),
                  ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Container( 
                    padding: const EdgeInsets.all(10),
                    child: Text(jsonDecode(widget.text)[i]['type'].toString(),
                    style: FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Comfortaa',
                                                        letterSpacing: 0.0,
                                                        color: const Color(0xFF101518)
                                                      ),
                    ),
                  ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Container( 
                    padding: const EdgeInsets.all(10),
                    child: Text(jsonDecode(widget.text)[i]['expiry_date'].toString(),
                    style: FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Comfortaa',
                                                        letterSpacing: 0.0,
                                                        color: const Color(0xFF101518)
                                                      ),
                    ),
                  ),
                  ),
            ],
          )
          // for (var i = 0; i < jsonDecode(widget.text).length; i++)
          //   Text(widget.productData[i].toString()),
            ],
          ),
          ),
           FFButtonWidget(
                      onPressed: () {
                      },
                      text: 'Save to Pantry',
                      options: FFButtonOptions(
                        width: 332,
                        height: 50,
                        padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        color: FlutterFlowTheme.of(context).secondary,
                        textStyle:
                            FlutterFlowTheme.of(context).displaySmall.override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .displaySmallFamily,
                                  color: Color.fromARGB(255, 235, 229, 217),
                                  letterSpacing: 0,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .displaySmallFamily),
                                ),
                        elevation: 3,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      )    
                      ),
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