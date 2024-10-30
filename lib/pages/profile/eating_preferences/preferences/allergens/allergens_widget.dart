import 'package:flutter/material.dart';
import 'package:keep_fresh/auth/firebase_auth/auth_util.dart';
import 'package:keep_fresh/backend/schema/users_record.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_theme.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_widgets.dart';

class AllergensWidget extends StatefulWidget {
  const AllergensWidget({Key? key}) : super(key: key);

  @override
  _AllergensWidgetState createState() => _AllergensWidgetState();
}

class _AllergensWidgetState extends State<AllergensWidget> {
  List<String> selectedAllergens = [];
  TextEditingController _controller = TextEditingController();

  final List<String> commonAllergens = [
    'Peanuts', 'Tree Nuts', 'Milk', 'Eggs', 'Fish',
    'Shellfish', 'Soy', 'Wheat', 'Sesame', 'Mustard'
  ];

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
        backgroundColor: Color(0xFFEDE8DF),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Color(0xFFEDE8DF),
      body:
      AuthUserStreamWidget(builder: (context) {
        if (selectedAllergens.isEmpty && currentUserDocument?.allergens != null) {
          selectedAllergens = List.from(currentUserDocument!.allergens);
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0, bottom: 10.0),
              child: Text(
                'Select common allergens:',
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                  fontFamily: 'Comfortaa',
                  letterSpacing: 0.0,
                  color: const Color(0xFF101518)
                ),
              ),
            ),
            Wrap(
              spacing: 8,
              children: commonAllergens.map((allergen) {
                return FilterChip(
                  label: Text(allergen,
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: 'Comfortaa',
                      letterSpacing: 0.0,
                      color: (currentUserDocument!.allergens.contains(allergen) && selectedAllergens.length == 0) ||  selectedAllergens.contains(allergen) ? Colors.white : const Color(0xFF101518)
                    ),
                  ),
                  backgroundColor: Colors.green[400],
                  selected:(currentUserDocument!.allergens.contains(allergen) && selectedAllergens.length == 0) || selectedAllergens.contains(allergen),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedAllergens.add(allergen);
                      } else {
                        selectedAllergens.remove(allergen);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter a custom allergen',
                        hintStyle: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Comfortaa',
                          letterSpacing: 0.0,
                          color: const Color(0xFF101518),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      controller: _controller,
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                        fontFamily: 'Comfortaa',
                        letterSpacing: 0.0,
                        color: const Color(0xFF101518),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addCustomAllergen,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ),
                    child: Text('Add',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'Comfortaa',
                        letterSpacing: 0.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: selectedAllergens.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      selectedAllergens[index],
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                        fontFamily: 'Comfortaa',
                        letterSpacing: 0.0,
                        color: const Color(0xFF101518)
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      color: Colors.red[300],
                      onPressed: () => _removeAllergen(index),
                    ),
                  );
                },
              ),
            ),


            Padding(
              padding: const EdgeInsets.only(bottom: 20.0), 
              child: FFButtonWidget(
              onPressed: () async {
                await UsersRecord.collection.doc(currentUserDocument?.uid).update({
                    ...createUsersRecordData(
                      allergens: selectedAllergens
                    )
                  });
                // TODO: Implement save functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Allergens saved: ${selectedAllergens.join(', ')}')),
                );
              },
              text: 'Save Allergens',
              options: FFButtonOptions(
                width: 300, // Set a specific width instead of maxFinite
                height: 40,
                color: Colors.green, // Change button color to blue
                textStyle: FlutterFlowTheme.of(context)
                        .bodySmall
                        .override(
                      fontFamily: 'Comfortaa',
                      letterSpacing: 0.0,
                      color: Colors.white,
                    ),
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            )
            ),
          ],
        );
      }),
    );
  }

  void _addCustomAllergen() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        selectedAllergens.add(_controller.text);
        _controller.clear();
      });
    }
  }

  void _removeAllergen(int index) {
    setState(() {
      selectedAllergens.removeAt(index); 
    });
  }
}
