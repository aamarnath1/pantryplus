import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_theme.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_widgets.dart';

class DietWidget extends StatefulWidget {
  const DietWidget({Key? key}) : super(key: key);

  @override
  _DietWidgetState createState() => _DietWidgetState();
}

class _DietWidgetState extends State<DietWidget> {
  String? _selectedDiet;
  final List<String> _dietOptions = [
    'No specific diet',
    'Vegetarian',
    'Vegan',
    'Pescatarian',
    'Flexitarian',
    'Keto',
    'Paleo',
    'Low-carb',
    'Gluten-free',
    'Dairy-free',
    'Mediterranean',
    'Whole30',
    'DASH',
    'Plant-based',
    'Raw food',
    'Intermittent fasting',
    'Low-FODMAP',
    'Atkins',
    'Zone diet',
    'Macrobiotic',
    'Alkaline diet',
    'Specific Carbohydrate Diet (SCD)',
    'Anti-inflammatory diet',
    'Carnivore diet',
    'Kosher',
    'Halal',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diet Preferences',
        style: FlutterFlowTheme.of(context).titleMedium.override(
              fontFamily: 'Comfortaa',
              color: const Color(0xFF000000),
              letterSpacing: 0.0,
            ),
        ),
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Color(0xFFEDE8DF),
      ),
      backgroundColor: Color(0xFFEDE8DF),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Select your diet preference:',
            style:FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                      fontFamily: 'Comfortaa',
                      letterSpacing: 0.0,
                                      color: const Color(0xFF101518)
                    ),
          ),
          const SizedBox(height: 16),
          ...(_dietOptions.map((diet) => RadioListTile<String>(
                title: Text(diet,
                style:FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                      fontFamily: 'Comfortaa',
                      letterSpacing: 0.0,
                                      color: const Color(0xFF101518)
                    ),
                ),
                value: diet,
                groupValue: _selectedDiet,
                activeColor: FlutterFlowTheme.of(context).secondary,
                visualDensity: VisualDensity.adaptivePlatformDensity, // Adjusts the density of the radio button
                fillColor: WidgetStateProperty.all(const Color.fromARGB(255, 35, 36, 37)),
                     onChanged: (value) {
                  setState(() {
                    _selectedDiet = value;
                  });
                },
              ))),
          const SizedBox(height: 24),
          // ElevatedButton(
          //   style: FlutterFlowTheme.of(context).secondary,
          //   onPressed: _selectedDiet != null
          //       ? () {
          //           // TODO: Save the selected diet preference
          //           ScaffoldMessenger.of(context).showSnackBar(
          //             SnackBar(content: Text('Diet preference saved: $_selectedDiet')),
          //           );
          //         }
          //       : null,
          //   child: const Text('Save Preference'),
          // ),

           FFButtonWidget(
                      onPressed: _selectedDiet != null
                ? () {
                    // TODO: Save the selected diet preference
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Diet preference saved: $_selectedDiet')),
                    );
                  }
                : null,
                      text: 'Save Preference',
                      options: FFButtonOptions(
                        width: 322,
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
        ],
      ),
    );
  }
}
