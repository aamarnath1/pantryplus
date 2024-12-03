import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_theme.dart';

class NutritionalInfoScreen extends StatefulWidget {
  final Map<String, dynamic> nutritionalData;

  NutritionalInfoScreen({required this.nutritionalData});

  @override
  _NutritionalInfoScreenState createState() => _NutritionalInfoScreenState();
}

class _NutritionalInfoScreenState extends State<NutritionalInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark_border_outlined),
            onPressed: () {
              // Bookmark action
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            height: constraints.maxHeight,
            color: Colors.white70,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Nutritional Facts',
                        style: FlutterFlowTheme.of(context)
                                      .headlineMedium
                                      .override(
                                        fontFamily: 'Comfortaa',
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0,
                                        color: Colors.black,
                                        useGoogleFonts: GoogleFonts.asMap()
                                                        .containsKey('Comfortaa'), 
                                                        ),
                      ),
                    ),
                    Divider(),
                    SizedBox(height:10),
                    Divider(color: Colors.black, thickness: 1.0),
                    // Padding(
                      // padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                      // child: 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top:0.0, bottom:0.0, left:6.0, right:6.0),
                            child: Text('Calories',style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Comfortaa',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.black, // Text color set to black
                                            ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.nutritionalData['calories']?.toString() ?? 'N/A', style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Comfortaa',
                                              fontSize: 12,
                                              color: Colors.black, // Text color set to black
                                            ),),
                          ),

                        ],
                      ),
                    // ),
                    Divider(color: Colors.black, thickness: 1.0),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top:0.0, bottom:0.0, left:6.0, right:6.0),
                            child: Text('Sodium',style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Comfortaa',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.black, // Text color set to black
                                            ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.nutritionalData['sodium']?.toString() ?? 'N/A', style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Comfortaa',
                                              fontSize: 12,
                                              color: Colors.black, // Text color set to black
                                            ),),
                          ),

                        ],
                      ),
                      Divider(color: Colors.black, thickness: 1.0),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top:0.0, bottom:0.0, left:6.0, right:6.0),
                            child: Text('Sugars',style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Comfortaa',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.black, // Text color set to black
                                            ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.nutritionalData['sugars']?.toString() ?? 'N/A', style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Comfortaa',
                                              fontSize: 12,
                                              color: Colors.black, // Text color set to black
                                            ),),
                          ),
                        ],
                      ),
                      Divider(color: Colors.black, thickness: 1.0),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top:0.0, bottom:0.0, left:6.0, right:6.0),
                            child: Text('Protein',style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Comfortaa',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.black, // Text color set to black
                                            ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.nutritionalData['protein']?.toString() ?? 'N/A', style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Comfortaa',
                                              fontSize: 12,
                                              color: Colors.black, // Text color set to black
                                            ),),
                          ),
                        ],
                      ),
                      Divider(color: Colors.black, thickness: 1.0),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top:0.0, bottom:0.0, left:6.0, right:6.0),
                            child: Text('Calories',style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Comfortaa',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.black, // Text color set to black
                                            ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.nutritionalData['calories']?.toString() ?? 'N/A', style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Comfortaa',
                                              fontSize: 12,
                                              color: Colors.black, // Text color set to black
                                            ),),
                          ),
                        ],
                      ),
                    Divider(color: Colors.black, thickness: 1.0),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top:0.0, bottom:0.0, left:6.0, right:6.0),
                            child: Text('Total Fat',style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Comfortaa',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.black, // Text color set to black
                                            ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.nutritionalData['total_fat']?.toString() ?? 'N/A', style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Comfortaa',
                                              fontSize: 12,
                                              color: Colors.black, // Text color set to black
                                            ),),
                          ),
                        ],
                      ),
                      Divider(color: Colors.black, thickness: 1.0),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top:0.0, bottom:0.0, left:6.0, right:6.0),
                            child: Text('Potassium',style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Comfortaa',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.black, // Text color set to black
                                            ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.nutritionalData['potassium']?.toString() ?? 'N/A', style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Comfortaa',
                                              fontSize: 12,
                                              color: Colors.black, // Text color set to black
                                            ),),
                          ),
                        ],
                      ),
                       Divider(color: Colors.black, thickness: 1.0),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top:0.0, bottom:0.0, left:6.0, right:6.0),
                            child: Text('Cholesterol',style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Comfortaa',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.black, // Text color set to black
                                            ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.nutritionalData['cholesterol']?.toString() ?? 'N/A', style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Comfortaa',
                                              fontSize: 12,
                                              color: Colors.black, // Text color set to black
                                            ),),
                          ),
                        ],
                      ),
                       Divider(color: Colors.black, thickness: 1.0),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top:0.0, bottom:0.0, left:6.0, right:6.0),
                            child: Text('Saturated Fat',style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Comfortaa',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.black, // Text color set to black
                                            ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.nutritionalData['saturated_fat']?.toString() ?? 'N/A', style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Comfortaa',
                                              fontSize: 12,
                                              color: Colors.black, // Text color set to black
                                            ),),
                          ),
                        ],
                      ),
                      Divider(color: Colors.black, thickness: 1.0),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top:0.0, bottom:0.0, left:6.0, right:6.0),
                            child: Text('Total Carbohydrate',style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Comfortaa',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.black, // Text color set to black
                                            ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.nutritionalData['total_carbohydrate']?.toString() ?? 'N/A', style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Comfortaa',
                                              fontSize: 12,
                                              color: Colors.black, // Text color set to black
                                            ),),
                          ),
                        ],
                      ),

                      SizedBox(height: 20,),

                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right:20.0),
                        child: Text(
                          '%RDI',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Comfortaa',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black, // Text color set to black
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top:0.0, bottom:0.0, left:6.0, right:6.0),
                            child: Text('Iron',style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Comfortaa',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.black, // Text color set to black
                                            ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.nutritionalData['iron']?.toString() ?? 'N/A', style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Comfortaa',
                                              fontSize: 12,
                                              color: Colors.black, // Text color set to black
                                            ),),
                          ),
                        ],
                      ),
                      Divider(color: Colors.black, thickness: 1.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top:0.0, bottom:0.0, left:6.0, right:6.0),
                            child: Text('Folate',style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Comfortaa',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.black, // Text color set to black
                                            ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.nutritionalData['folate']?.toString() ?? 'N/A', style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Comfortaa',
                                              fontSize: 12,
                                              color: Colors.black, // Text color set to black
                                            ),),
                          ),
                        ],
                      ),
                      Divider(color: Colors.black, thickness: 1.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top:0.0, bottom:0.0, left:6.0, right:6.0),
                            child: Text('Calcium',style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Comfortaa',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.black, // Text color set to black
                                            ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.nutritionalData['calcium']?.toString() ?? 'N/A', style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Comfortaa',
                                              fontSize: 12,
                                              color: Colors.black, // Text color set to black
                                            ),),
                          ),
                        ],
                      ),
                      Divider(color: Colors.black, thickness: 1.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top:0.0, bottom:0.0, left:6.0, right:6.0),
                            child: Text('Vitamin A',style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Comfortaa',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.black, // Text color set to black
                                            ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.nutritionalData['vitamin_a']?.toString() ?? 'N/A', style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Comfortaa',
                                              fontSize: 12,
                                              color: Colors.black, // Text color set to black
                                            ),),
                          ),
                        ],
                      ),
                      Divider(color: Colors.black, thickness: 1.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top:0.0, bottom:0.0, left:6.0, right:6.0),
                            child: Text('Vitamin C',style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Comfortaa',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.black, // Text color set to black
                                            ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.nutritionalData['vitamin_c']?.toString() ?? 'N/A', style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Comfortaa',
                                              fontSize: 12,
                                              color: Colors.black, // Text color set to black
                                            ),),
                          ),
                        ],
                      ),
                      SizedBox(height:20)
                      ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
