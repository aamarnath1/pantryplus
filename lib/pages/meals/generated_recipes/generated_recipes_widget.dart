import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_util.dart';
import 'package:keep_fresh/pages/meals/generated_recipes/preview_recipe.dart';

class GeneratedRecipes extends StatefulWidget {
  final String? recipeData;

  GeneratedRecipes({required this.recipeData});

  @override
  _GeneratedRecipesState createState() => _GeneratedRecipesState();
}

class _GeneratedRecipesState extends State<GeneratedRecipes> {
  List<dynamic> recipes = [];
  Map<String, dynamic>? selectedRecipe;
  bool isLoading = true;
  bool isCarouselView = true;

  @override
  void initState() {
    super.initState();
    if (widget.recipeData != null) {
      String data = widget.recipeData!;
      String trimmedData = data.trim();
      if (trimmedData.startsWith('```json') && trimmedData.endsWith('```')) {
        trimmedData = trimmedData.replaceFirst('```json', '').replaceFirst('```', '').trim();
        recipes = jsonDecode(trimmedData);
      }

      Future.wait(recipes.map((recipe) => getRecipeImages(recipe['recipe_title']).then((url) {
        recipe['imageUrl'] = url;
      }))).then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

getRecipeImages(String itemName) async {
  var httpClient = HttpClient();
  try {
    var request = await httpClient.getUrl(Uri.parse('https://api.pexels.com/v1/search?query=RecipeName:$itemName&per_page=1'));
    request.headers.set('Authorization', 'UX8wpVU2YBEYfM4BV2qAJLXhySJ7m5gI6D6BGfhbmBnENT1DtpUVBhBl');

    var response = await request.close();
    if (response.statusCode == 200) {
      var responseBody = await response.transform(utf8.decoder).join();
      var jsonResponse = jsonDecode(responseBody);

      if (jsonResponse['photos'] != null && jsonResponse['photos'].isNotEmpty) {
        var url = jsonResponse['photos'][0]['src']['original'].toString();
        return url;
      } else {
        print('No photos found for $itemName');
        return 'https://images.pexels.com/photos/9507469/pexels-photo-9507469.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2';
      }
    } else {
      print("Failed to load images: ${response.statusCode} - ${response.reasonPhrase}");
      return null;
    }
  } catch (e) {
    print('Error fetching images: $e');
    return null;
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.green, // Change back button color to green
        ),
        title: Text(
          'Generated Recipes',
         style: FlutterFlowTheme.of(context).titleLarge.override(
                  fontFamily: 'Comfortaa',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Adjust color as needed
                ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              context.pushNamed('Recipes');
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFFFFF8E1),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ToggleButtons(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.view_carousel, color: Colors.green),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.view_list, color: Colors.green),
                            ],
                          ),
                        ),
                      ],
                      isSelected: [isCarouselView, !isCarouselView],
                      onPressed: (int index) {
                        setState(() {
                          isCarouselView = index == 0;
                        });
                      },
                    ),
                  ),
                  if (isCarouselView)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: MediaQuery.of(context).size.height * 0.7,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          aspectRatio: 16 / 9,
                          viewportFraction: 0.8,
                        ),
                        items: recipes.map((recipe) {
                          return Builder(
                            builder: (BuildContext context) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedRecipe = recipe;
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PreviewRecipePage(recipeData: selectedRecipe),
                                    ),
                                  );
                                },
                                child: Card(
                                  margin: EdgeInsets.zero,
                                  color: Colors.green,
                                  child: Column(
                                    children: [
                                      Flexible(
                                        child: Container(
                                          height: MediaQuery.of(context).size.height * 0.6,
                                          width: double.maxFinite,
                                          child: Image.network(
                                            recipe['imageUrl'] ?? '',
                                            fit: BoxFit.cover,
                                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              } else {
                                                return Center(
                                                  child: CircularProgressIndicator(
                                                    value: loadingProgress.expectedTotalBytes != null
                                                        ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                                        : null,
                                                  ),
                                                );
                                              }
                                            },
                                            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                              return Center(
                                                child: Icon(
                                                  Icons.broken_image,
                                                  color: Colors.grey,
                                                  size: 50,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height:10),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                child: Text(
                                                  'Recipes that you may like..!!!',
                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                        fontFamily: 'Comfortaa',
                                                        color: Colors.white,
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ),
                                              SizedBox(height:5),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 6.0),
                                                child: Text(
                                                recipe['recipe_title'] ?? 'No Title',
                                                style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                      fontFamily: 'Comfortaa',
                                                      fontSize: 30,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                      letterSpacing: 0.0,
                                                    ),
                                              )),
                                              SizedBox(height:10),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical:6.0),
                                                child:Text(
                                                recipe['recipe_short_desc'] ?? 'No Description',
                                                style: FlutterFlowTheme.of(context).titleLarge.override(
                                                      fontFamily: 'Comfortaa',
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                      lineHeight: 1.2,
                                                      letterSpacing: 1,
                                                    ),
                                                  maxLines: 4,
                                                  overflow: TextOverflow.ellipsis,
                                              )),
                                             Spacer(),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom: 20, left: 10),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.star, // You can change the icon as needed
                                                          color: Colors.white,
                                                          size: 20,
                                                        ),
                                                        SizedBox(width: 5),
                                                        Text(
                                                          recipe['recipe_difficult'] ?? 'Unknown',
                                                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                fontFamily: 'Comfortaa',
                                                                fontSize: 20,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.white,
                                                                letterSpacing: 0.0,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom:20, right:10),
                                                    child: Row(
                                                      children:[
                                                         Icon(
                                                          Icons.timer, // You can change the icon as needed
                                                          color: Colors.white,
                                                          size: 20,
                                                        ),
                                                    Text(
                                                    recipe['recipe_time'] ?? 'Unknown',
                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                          fontFamily: 'Comfortaa',
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.white,
                                                          letterSpacing: 0.0,
                                                        ),
                                                  )]
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  if (!isCarouselView)
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            // color: Color.fromARGB(255, 248, 248, 247),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: ListView.builder(
                            itemCount: recipes.length,
                            itemBuilder: (context, index) {
                              final recipe = recipes[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PreviewRecipePage(recipeData: recipe),
                                    ),
                                  );
                                },
                                child: Card(
                                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  color: Colors.green,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(8.0),
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        recipe['imageUrl'] ?? '',
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                          return Icon(
                                            Icons.broken_image,
                                            color: Colors.grey,
                                            size: 50,
                                          );
                                        },
                                      ),
                                    ),
                                    title: Text(
                                      recipe['recipe_title'] ?? 'Unknown',
                                      style: FlutterFlowTheme.of(context).titleMedium.override(
                                            fontFamily: 'Comfortaa',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                    subtitle: Text(
                                      recipe['recipe_short_desc'] ?? 'No description available',
                                      style: FlutterFlowTheme.of(context).bodySmall.override(
                                            fontFamily: 'Comfortaa',
                                            fontSize: 14,
                                            color: Colors.white,
                                            letterSpacing: 0.0,
                                          ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
