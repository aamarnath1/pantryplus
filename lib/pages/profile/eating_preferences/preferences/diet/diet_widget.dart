import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_fresh/auth/firebase_auth/auth_util.dart';
import 'package:keep_fresh/backend/schema/users_record.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_theme.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_widgets.dart';

class DietWidget extends StatefulWidget {
  const DietWidget({Key? key}) : super(key: key);

  @override
  _DietWidgetState createState() => _DietWidgetState();
}

class _DietWidgetState extends State<DietWidget> {
  String? _selectedDiet;
  // String? _dietSelected;
  TextEditingController _controller = TextEditingController();

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
  ];

@override
void initState() {
  super.initState();
  
}


@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Diet Preferences',
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
    body: AuthUserStreamWidget(
      builder: (context) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, left: 10.0, right: 10.0, bottom: 10.0),
              child: Text(
                'Select your diet  :',
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                    fontFamily: 'Comfortaa',
                    letterSpacing: 0.0,
                    color: const Color(0xFF101518)),
              ),
            ),
            Wrap(
              spacing: 8,
              children: _dietOptions.map((diet) {
                return FilterChip(
                  label: Text(
                    diet,
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                        fontFamily: 'Comfortaa',
                        letterSpacing: 0.0,
                        color:(currentUserDocument?.diet == diet && _selectedDiet == null) || _selectedDiet == diet
                            ? Colors.white
                            : const Color(0xFF101518)),
                  ),
                  backgroundColor: Colors.green[400],
                  selected: (currentUserDocument?.diet == diet && _selectedDiet == null) || _selectedDiet == diet,
                  onSelected: (selected) {
                    // _dietSelected = diet;
                    setState(() {
                      _selectedDiet = selected ? diet : null;
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
                        hintText: 'Enter a custom diet',
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
                    onPressed: _addCustomDiet,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ),
                    child: Text('Add',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'Comfortaa',
                        letterSpacing: 0.0,
                        color: const Color(0xFF101518),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListTile(
                      title: Text( 
                        '${_selectedDiet == null ? currentUserDocument?.diet : _selectedDiet!}',
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                          fontFamily: 'Comfortaa',
                          letterSpacing: 0.0,
                          color: const Color(0xFF101518)
                        ),
                      ),
                      trailing:
                      _selectedDiet !=null ?
                       IconButton(
                        icon: Icon(Icons.delete),
                        color: Colors.red[300],
                        onPressed: () => setState(() {
                         _selectedDiet = null;
                         }),
                      ) : null,
                    )
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0), 
              child: FFButtonWidget(
              onPressed: () async {
                await UsersRecord.collection.doc(currentUserDocument?.uid).update({
                  ...createUsersRecordData(
                    diet: _selectedDiet
                  )
                });
                // TODO: Implement save functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Diet preference saved: $_selectedDiet')),
                );
              },
              text: 'Save Diet',
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
      },
    ),
  );
}

void _addCustomDiet() {
  if (_controller.text.isNotEmpty) {
    setState(() {
      _selectedDiet = _controller.text;
      _controller.clear();
    });
  }
}
}