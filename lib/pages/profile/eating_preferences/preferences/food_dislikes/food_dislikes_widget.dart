import 'package:flutter/material.dart';
import 'package:keep_fresh/auth/firebase_auth/auth_util.dart';
import 'package:keep_fresh/backend/schema/users_record.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_theme.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_widgets.dart';

class FoodDislikesScreen extends StatefulWidget {
  @override
  _FoodDislikesScreenState createState() => _FoodDislikesScreenState();
}

class _FoodDislikesScreenState extends State<FoodDislikesScreen> {
  List<String> dislikedIngredients = [];
  TextEditingController _controller = TextEditingController();

  // List of common ingredients
  final List<String> commonIngredients = [
    'Onions', 'Garlic', 'Tomatoes', 'Mushrooms', 'Bell Peppers',
    'Cilantro', 'Olives', 'Eggplant', 'Avocado', 'Nuts'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disliked Ingredients',
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
      body: AuthUserStreamWidget(
      builder: (context) { 
      if (dislikedIngredients.isEmpty && currentUserDocument?.ingredientDislikes != null) {
          dislikedIngredients = List.from(currentUserDocument!.ingredientDislikes);
        }   
       return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0, bottom: 10.0),
            child: Text(
              'Select common ingredients you dislike:',
              style:FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                      fontFamily: 'Comfortaa',
                      letterSpacing: 0.0,
                                      color: const Color(0xFF101518)
                    ),
            ),
          ),
          Wrap(
            spacing: 8,
            children: commonIngredients.map((ingredient) {
              return FilterChip(
                label: Text(ingredient,
               style:FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                      fontFamily: 'Comfortaa',
                      letterSpacing: 0.0,
                                      color: (currentUserDocument!.ingredientDislikes.contains(ingredient)) || dislikedIngredients.contains(ingredient) ? Colors.white : const Color(0xFF101518)
                    ),
                ),
                backgroundColor: Colors.green[400],
                selected: (currentUserDocument!.ingredientDislikes.contains(ingredient)) || dislikedIngredients.contains(ingredient),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      dislikedIngredients.add(ingredient);
                    } else {
                      dislikedIngredients.remove(ingredient);
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
                  child: GestureDetector(
                    // child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Enter a custom ingredient',
                          hintStyle: FlutterFlowTheme.of(context)
                              .bodySmall
                              .override(
                            fontFamily: 'Comfortaa',
                            letterSpacing: 0.0,
                            color: const Color(0xFF101518),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black), // Set border color to black
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green), // Set enabled border color to black
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black), // Set focused border color to black
                          ),
                        ),
                        controller: _controller,
                        style: FlutterFlowTheme.of(context)
                            .bodyLarge
                            .override(
                          fontFamily: 'Comfortaa',
                          letterSpacing: 0.0,
                          color: const Color(0xFF101518),
                        ),
                      ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addCustomIngredient,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green), // Change button color to green
                  ),
                  child: Text('Add',
                  style: FlutterFlowTheme.of(context)
                          .bodySmall
                          .override(
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
            child: ListView.builder(
              itemCount: dislikedIngredients.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(dislikedIngredients[index],
                  style:FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                      fontFamily: 'Comfortaa',
                      letterSpacing: 0.0,
                                      color: const Color(0xFF101518)
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete,
                    ),
                    color: Colors.red[300],
                    onPressed: () => _removeIngredient(index),
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
                      dislikedIngredients: dislikedIngredients
                    )
                  });
              // TODO: Implement save functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Disliked ingredients saved: ${dislikedIngredients.join(', ')}')),
              );
              },
              text: 'Save Ingredients',
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
      );}
    )
    );
  }

  void _addCustomIngredient() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        dislikedIngredients.add(_controller.text);
        _controller.clear();
      });
    }
  }

  void _removeIngredient(int index) {
    setState(() {
      dislikedIngredients.removeAt(index);
    });
  }
}
