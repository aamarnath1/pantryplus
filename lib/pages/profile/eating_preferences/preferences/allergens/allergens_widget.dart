import 'package:flutter/material.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_theme.dart';

class AllergensWidget extends StatefulWidget {
  const AllergensWidget({Key? key}) : super(key: key);

  @override
  _AllergensWidgetState createState() => _AllergensWidgetState();
}

class _AllergensWidgetState extends State<AllergensWidget> {
  final List<String> _predefinedAllergens = [
    'Peanuts',
    'Tree Nuts',
    'Milk',
    'Eggs',
    'Fish',
    'Shellfish',
    'Soy',
    'Wheat',
  ];

  final Set<String> _selectedAllergens = {};
  final TextEditingController _customAllergenController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Allergens Preferences',
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
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Select your allergens:',
                    style:FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                      fontFamily: 'Comfortaa',
                      letterSpacing: 0.0,
                                      color: const Color(0xFF101518)
                    ),
                  ),
                ),
                _buildSelectedAllergenChips(),
                ..._predefinedAllergens.map(_buildAllergenCheckbox).toList(),
                _buildCustomAllergenInput(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedAllergenChips() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: _selectedAllergens.map((allergen) {
              return Chip(
                label: Text(allergen,
                style:FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                          fontFamily: 'Comfortaa',
                          letterSpacing: 0.0,
                          color: const Color(0xFF101518)
                        ),
                ),
                deleteIcon: const Icon(Icons.cancel, size: 18),
                backgroundColor: Colors.green[400], // Change background color for this chip
                onDeleted: () {
                  setState(() {
                    _selectedAllergens.remove(allergen);
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16), // Add some space between chips and button
          ElevatedButton(
            onPressed: () {
              // TODO: Implement save functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Allergens saved: ${_selectedAllergens.join(', ')}')),
              );
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green), // Green background
            ),
            child: Text('Save Allergens',
              style: FlutterFlowTheme.of(context)
                  .bodySmall
                  .override(
                    fontFamily: 'Comfortaa',
                    letterSpacing: 0.0,
                    color: Colors.white,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllergenCheckbox(String allergen) {
    return CheckboxListTile(
      title: Text(allergen,
        style:FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                      fontFamily: 'Comfortaa',
                      letterSpacing: 0.0,
                                      color: const Color(0xFF101518)
                    ),
      ),
      value: _selectedAllergens.contains(allergen),   
      activeColor: FlutterFlowTheme.of(context).secondary,
      checkboxShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      side: const BorderSide(color: Colors.black, width: 1.5),
      onChanged: (bool? value) {
        setState(() {
          if (value == true) {
            _selectedAllergens.add(allergen);
          } else {
            _selectedAllergens.remove(allergen);
          }
        });
      },
    );
  }

  Widget _buildCustomAllergenInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _customAllergenController,
              decoration: InputDecoration(
                labelText: 'Add custom allergen',
                labelStyle: FlutterFlowTheme.of(context)
                    .bodyLarge
                    .override(
                      fontFamily: 'Comfortaa',
                      letterSpacing: 0.0,
                      color: const Color(0xFF101518),
                    ),
                // contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                hintText: 'Enter allergen name',
                hintStyle: FlutterFlowTheme.of(context)
                    .bodySmall
                    .override(
                      fontFamily: 'Comfortaa',
                      letterSpacing: 0.0,
                      color: const Color(0xFF101518),
                    ), // Added padding
              ),
              style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                      fontFamily: 'Comfortaa',
                      letterSpacing: 0.0,
                                      color: const Color(0xFF101518)
                    ) ,
            ),
          ),
          IconButton(
            icon: Icon(Icons.add, color: const Color(0xFF101518)),
            onPressed: () {
              final String newAllergen = _customAllergenController.text.trim();
              if (newAllergen.isNotEmpty) {
                setState(() {
                  _selectedAllergens.add(newAllergen);
                  _customAllergenController.clear();
                });
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _customAllergenController.dispose();
    super.dispose();
  }
}
