import 'package:flutter/material.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_theme.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_widgets.dart';

class PreviewRecipePage extends StatefulWidget {
  final Map<String, dynamic>? recipeData;

  PreviewRecipePage({required this.recipeData}) {
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
                  Padding(
                  padding: const EdgeInsets.only(bottom: 30, top:10),
                  child: Center(
                    child: FFButtonWidget(
                      onPressed: () {
                        // Add your save recipe logic here
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
