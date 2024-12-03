import 'package:flutter/material.dart';
import 'package:keep_fresh/auth/firebase_auth/auth_util.dart';
import 'package:keep_fresh/backend/schema/recipes.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_theme.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_util.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_widgets.dart';
import 'package:uuid/uuid.dart';
import 'package:keep_fresh/pages/meals/generated_recipes/Nutritional_info/nutritional_info_widget.dart';

// ignore: must_be_immutable
class PreviewRecipePage extends StatefulWidget {
  final Map<String, dynamic>? recipeData;
  bool isSavedRecipes;

  PreviewRecipePage({required this.recipeData, required this.isSavedRecipes}) {
  }

  @override
  _PreviewRecipePageState createState() => _PreviewRecipePageState();
}

class _PreviewRecipePageState extends State<PreviewRecipePage> {

  @override
  Widget build(BuildContext context) {
    final recipeData = widget.recipeData ?? {};
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark_border),
            onPressed: () {
              // Bookmark action
            },
          ),
        ],
      ),
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(recipeData['imageUrl'] ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              color: Colors.blue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.timer, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              recipeData['recipe_time'] ?? 'N/A',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Comfortaa',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                    ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.white), // Using a star icon to represent difficulty
                            SizedBox(width: 8),
                            Text(
                              recipeData['recipe_difficult'] ?? 'N/A',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Comfortaa',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                      recipeData['recipe_title'] ?? 'Recipe Title',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Comfortaa',
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                    ),
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      recipeData['recipe_short_desc'] ?? '',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Comfortaa',
                                      fontSize: 16,
                                      color: Colors.white70,
                                    ),
                    ),
                  ),
                Center(
                    child: InkWell(
                      onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NutritionalInfoScreen(
                                      nutritionalData: recipeData['recipe_nutritional_info'],
                                    ),
                                  ),
                                );
                              },
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            child: Card(
                              color: Color(0xFFD3D3D3), // Light cement color
                              margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Nutritional Facts',
                                      style: FlutterFlowTheme.of(context).headlineMedium.override(
                                        fontFamily: 'Comfortaa',
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black, // Text color set to black
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Calories: ${recipeData['recipe_nutritional_info']['calories'] ?? 'N/A'}',
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Comfortaa',
                                        fontSize: 16,
                                        color: Colors.black, // Text color set to black
                                      ),
                                    ),
                                    Text(
                                      'Protein: ${recipeData['recipe_nutritional_info']['protein'] ?? 'N/A'}',
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Comfortaa',
                                        fontSize: 16,
                                        color: Colors.black, // Text color set to black
                                      ),
                                    ),
                                    Text(
                                      'Total Carbohydrates: ${recipeData['recipe_nutritional_info']['total_carbohydrate'] ?? 'N/A'}',
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Comfortaa',
                                        fontSize: 16,
                                        color: Colors.black, // Text color set to black
                                      ),
                                    ),
                                    Text(
                                      'Total Fat: ${recipeData['recipe_nutritional_info']['total_fat'] ?? 'N/A'}',
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Comfortaa',
                                        fontSize: 16,
                                        color: Colors.black, // Text color set to black
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NutritionalInfoScreen(
                                          nutritionalData: recipeData['recipe_nutritional_info'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0), // Added padding
                                    child: Text(
                                      'More Info',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height:10),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'Ingredients',
                        style: FlutterFlowTheme.of(context).headlineMedium.override(
                                        fontFamily: 'Comfortaa',
                                        fontSize: 27,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: recipeData['recipe_ingridents']?.length ?? 0,
                    itemBuilder: (context, index) {
                      return ListTile(
                        tileColor: Colors.blueAccent.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        title: Text(
                          recipeData['recipe_ingridents'][index],
                         style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Comfortaa',
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                        ),
                        trailing: Icon(Icons.local_dining, color: Colors.white),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                      'Instructions',
                      style: FlutterFlowTheme.of(context).headlineMedium.override(
                                        fontFamily: 'Comfortaa',
                                        fontSize: 27,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                    )
                    ),
                  ),
                  Column(
                    children: [
                      for (int index = 0; index < (recipeData['recipe_details']?.length ?? 0); index++)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.check_circle_outline, color: Colors.white),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  recipeData['recipe_details'][index],
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Comfortaa',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  if(!widget.isSavedRecipes)
                  Padding(
                  padding: const EdgeInsets.only(bottom: 30, top:10),
                  child: Center(
                    child: FFButtonWidget(
                      onPressed: () async {
                        final recipe = createRecipesRecordData(
                          uid: currentUserDocument?.uid,
                          recipeId: 'recipe_${Uuid().v4()}',
                          displayName: currentUserDocument?.displayName,
                          recipeObj: recipeData,
                          createdTime: DateTime.now(),
                        );
                      await RecipesRecord.addRecipe(recipe).then((val) =>{
                      context.pushNamed('Recipes')
                      });
                      },
                      text: 'Save Recipe',
                      options: FFButtonOptions(
                        width: 130,
                        height: 40,
                        color: const Color.fromARGB(255, 7, 120, 172),
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                      ),
                    ),
                ))
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
