import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_fresh/auth/firebase_auth/auth_util.dart';
import 'package:keep_fresh/backend/schema/food_items.dart';
import 'package:keep_fresh/backend/schema/recipes.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_theme.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:keep_fresh/pages/meals/generated_recipes/generated_recipes_widget.dart';
import 'package:keep_fresh/pages/meals/generated_recipes/preview_recipe.dart';
import 'package:keep_fresh/pages/profile/eating_preferences/eating_preferences_widget.dart';
import 'package:http/http.dart' as http;

class RecipesWidget extends StatefulWidget {
  const RecipesWidget({Key? key}) : super(key: key);

  @override
  _RecipesWidgetState createState() => _RecipesWidgetState();
}

class _RecipesWidgetState extends State<RecipesWidget> {
  bool isSelected = false;
  TextEditingController _recipePromptController = TextEditingController();
  late final GenerativeModel _model;
  late final GenerativeModel _imageModel;
   List<dynamic> recipes = [];
   List<dynamic>savedRecipes = [];
   List<dynamic>existingPantryItems = [];
   List<String> selectedIngredients = [];
   List<dynamic>sampleCarouselItems = [
  {
    'recipe_title': 'Garlic Ginger Noodles',
    'recipe_time': '20mins',
    'imageUrl': 'https://images.pexels.com/photos/20791757/pexels-photo-20791757/free-photo-of-pasta-noodles-in-a-bowl.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    'recipe_difficult': 'Easy',
    'recipe_short_desc': 'Quick and flavorful noodles with a spicy kick. Perfect for a weeknight meal. Uses pantry staples for a simple dish.',
    'recipe_ingridents': [
      'Noodles',
      'Tomato (1)',
      'Garlic (2 cloves)',
      'Green Onion (2)',
      'Ginger (1 tbsp, grated)',
      'Egg (1)',
      'Chili Pepper (1, finely chopped)'
    ],
    'recipe_nutritional_info': {
      'fibre': '5g',
      'sodium': '100mg',
      'sugars': '10g',
      'protein': '12g',
      'calories': '300',
      'total_fat': '10g',
      'potassium': '200mg',
      'cholestrol': '150mg',
      'saturated_fat': '4g',
      'total_carbohydrate': '50g',
      'iron': '2.0',
      'folate': '50.0',
      'calcium': '5.0',
      'vitamin_a': '15.0',
      'vitamin_c': '10.0'
    },
    'recipe_details': [
      'Cook noodles according to package directions.',
      'While noodles cook, finely chop garlic, green onion, and chili pepper.',
      'Grate ginger.',
      'In a pan, sauté garlic and ginger in a little oil until fragrant (about 1 minute).',
      'Add chopped chili pepper and cook for another minute.',
      'Slice tomato and add to the pan.',
      'Whisk the egg in a small bowl and add it to the pan. Scramble lightly.',
      'Drain the noodles and add them to the pan with the tomato and egg mixture. Toss to combine.',
      'Garnish with green onions and serve immediately.'
    ]
  },
  {
    'recipe_title': 'Spicy Tomato Noodles',
    'recipe_time': '25mins',
    'recipe_difficult': 'Easy',
    'imageUrl': 'https://images.pexels.com/photos/5409014/pexels-photo-5409014.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    'recipe_short_desc': 'A simple noodle dish with a spicy tomato sauce. Easy to customize with your preferred level of spice. Great with a fried egg on top.',
    'recipe_ingridents': [
      'Noodles',
      'Tomato (2)',
      'Garlic (2 cloves)',
      'Green Onion (1)',
      'Ginger (1/2 tbsp, grated)',
      'Chili Pepper (1/2, finely chopped)',
      'Egg (optional)'
    ],
    'recipe_nutritional_info': {
      'fibre': '4g',
      'sodium': '80mg',
      'sugars': '8g',
      'protein': '10g',
      'calories': '250',
      'total_fat': '8g',
      'potassium': '180mg',
      'cholestrol': '120mg',
      'saturated_fat': '3g',
      'total_carbohydrate': '45g',
      'iron': '1.5',
      'folate': '40.0',
      'calcium': '4.0',
      'vitamin_a': '12.0',
      'vitamin_c': '8.0'
    },
    'recipe_details': [
      'Cook noodles according to package directions.',
      'While noodles are cooking, finely chop garlic, green onion, and chili pepper.',
      'Grate ginger.',
      'In a pan, sauté garlic and ginger in a little oil until fragrant (about 1 minute).',
      'Add chopped tomatoes and chili pepper; cook until slightly softened (about 5 minutes).',
      'Drain the noodles and add them to the pan with the tomato sauce. Toss to combine.',
      'Garnish with green onions. Serve with a fried egg on top, if desired.'
    ]
  },
  {
    'recipe_title': 'Egg Drop Noodles',
    'recipe_time': '15mins',
    'imageUrl': 'https://images.pexels.com/photos/20791757/pexels-photo-20791757/free-photo-of-pasta-noodles-in-a-bowl.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    'recipe_difficult': 'Easy',
    'recipe_short_desc': 'A light and quick noodle soup. A simple and satisfying meal. Easily adaptable to your spice preference.',
    'recipe_ingridents': [
      'Noodles',
      'Tomato (1, diced)',
      'Garlic (1 clove, minced)',
      'Green Onion (1, chopped)',
      'Ginger (1/4 tbsp, grated)',
      'Egg (1)',
      'Water (4 cups)',
      'Chili Pepper (optional, a pinch of flakes)'
    ],
    'recipe_nutritional_info': {
      'fibre': '2g',
      'sodium': '70mg',
      'sugars': '5g',
      'protein': '8g',
      'calories': '180',
      'total_fat': '5g',
      'potassium': '150mg',
      'cholestrol': '100mg',
      'saturated_fat': '2g',
      'total_carbohydrate': '30g',
      'iron': '1.0',
      'folate': '30.0',
      'calcium': '3.0',
      'vitamin_a': '8.0',
      'vitamin_c': '5.0'
    },
    'recipe_details': [
      'Bring water to a boil in a pot. Add a pinch of chili pepper flakes if desired.',
      'Add minced garlic and grated ginger.',
      'Cook for 1 minute.',
      'Add diced tomato and cook for 2 minutes.',
      'Add noodles and cook according to package directions.',
      'Whisk the egg lightly.',
      'Slowly drizzle the egg into the boiling soup, stirring gently to create ribbons.',
      'Cook for 1 minute more.',
      'Garnish with chopped green onions and serve immediately.'
    ]
  },
  {
    'recipe_title': 'Garlic Noodles',
    'imageUrl': 'https://images.pexels.com/photos/3606799/pexels-photo-3606799.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    'recipe_time': '10mins',
    'recipe_difficult': 'Easy',
    'recipe_short_desc': 'Simple and flavorful garlic noodles. A quick and easy weeknight meal. Customize with your favorite spices.',
    'recipe_ingridents': [
      'Noodles',
      'Garlic (3 cloves, minced)',
      'Green Onion (2, chopped)',
      'Soy Sauce (optional)',
      'Chili Pepper (optional, flakes)'
    ],
    'recipe_nutritional_info': {
      'fibre': '3g',
      'sodium': '90mg',
      'sugars': '6g',
      'protein': '9g',
      'calories': '220',
      'total_fat': '7g',
      'potassium': '160mg',
      'cholestrol': '110mg',
      'saturated_fat': '3g',
      'total_carbohydrate': '40g',
      'iron': '1.2',
      'folate': '35.0',
      'calcium': '4.5',
      'vitamin_a': '10.0',
      'vitamin_c': '7.0'
    },
    'recipe_details': [
      'Cook noodles according to package directions.',
      'While noodles cook, mince garlic.',
      'Heat a small amount of oil in a pan. Add minced garlic and cook until fragrant.',
      'Add cooked noodles to the pan and toss to coat in garlic oil.',
      'Add soy sauce and/or chili pepper flakes to taste.',
      'Garnish with green onions and serve immediately.'
    ]
  },
  {
    'recipe_title': 'Ginger Noodles',
    'imageUrl': 'https://images.pexels.com/photos/5409012/pexels-photo-5409012.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    'recipe_time': '15mins',
    'recipe_difficult': 'Easy',
    'recipe_short_desc': 'Simple ginger noodles with a hint of spice. A quick and easy side dish or light meal. Easily customized.',
    'recipe_ingridents': [
      'Noodles',
      'Ginger (1 tbsp, grated)',
      'Green Onion (1, chopped)',
      'Chili Pepper (optional, a pinch of flakes)',
      'Soy Sauce (optional)'
    ],
    'recipe_nutritional_info': {
      'fibre': '3g',
      'sodium': '85mg',
      'sugars': '7g',
      'protein': '11g',
      'calories': '240',
      'total_fat': '6g',
      'potassium': '170mg',
      'cholestrol': '130mg',
      'saturated_fat': '2.5g',
      'total_carbohydrate': '42g',
      'iron': '1.8',
      'folate': '38.0',
      'calcium': '4.8',
      'vitamin_a': '11.0',
      'vitamin_c': '6.5'
    },
    'recipe_details': [
      'Cook noodles according to package directions.',
      'While noodles cook, grate ginger.',
      'Heat a small amount of oil in a pan. Add grated ginger and cook until fragrant.',
      'Add cooked noodles to the pan and toss to coat in ginger oil.',
      'Add soy sauce and/or chili pepper flakes to taste.',
      'Garnish with green onions and serve immediately.'
    ]
  }
];

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: 'AIzaSyAQcK7SrU3qP7znukuW5RapadrnGuscHlc'
      );

    // _imageModel = GenerativeModel(
    //   model: 'imagen-3.0-generate-001',
    //   apiKey:'AIzaSyAQcK7SrU3qP7znukuW5RapadrnGuscHlc'
    // );
    // generateImage('Cauliflower Mash');
      getSuggestedRecipes();
      getSavedRecipes();
  }


  Future<String> getRecipeImages(String itemName) async {
    var httpClient = HttpClient();
    var request = await httpClient.getUrl(Uri.parse('https://api.pexels.com/v1/search?query=RecipeName:$itemName&per_page=1'));
    request.headers.set('Authorization', 'UX8wpVU2YBEYfM4BV2qAJLXhySJ7m5gI6D6BGfhbmBnENT1DtpUVBhBl');

    var response = await request.close();
    if (response.statusCode == 200) {
      var responseBody = await response.transform(utf8.decoder).join();
      var url = jsonDecode(responseBody)['photos'][0]['src']['original'].toString();
      return url;
    } else {
      print("response, ${response.reasonPhrase}");
      print('Failed to load images: ${response.statusCode}');
      throw Exception('Failed to load image');
    }
  }

 Future<void> getSavedRecipes() async {
  var recipes = await RecipesRecord.getAllRecordsWithId(currentUserDocument?.uid);
  for (var item in recipes) {
    if (!savedRecipes.any((savedItem) => savedItem['recipeId'] == item.recipeId)) {
      savedRecipes.add({
        'displayName': item.displayName,
        'recipeId': item.recipeId,
        'recipeObj': item.recipeObj,
        'createdTime': item.createdTime,
        'uid': item.uid
      });
    }
  }
 }
  Future<void> _generateRecipe(userPrompt, allergens, diet, dislikedIngredients,fromSuggested) async {
    final navigator = Navigator.of(context);
 try{
  if (currentUserDocument == null) {
    print('Error: currentUserDocument is null');
    return;
  }

  var allergen = allergens?.join(', ') ?? '';
  var dislikedIngredient = dislikedIngredients?.join(',') ?? '';
    final prompt = TextPart("You are a recipe provider bot who is capable of understanding users prompt, understand what is required from the users, these are the users ${diet}, ${allergen} & ${dislikedIngredient} these are the diet preferences, allergens and dislikedIngredients respectively, keep the user preferences as a reference for creating users preferred recipes. $userPrompt. For every response you must suggest atleast 3 or more recipes for users to select them between the recipes, a good number is 5 recipes for every request if 5 is not possible atleast you must be capable of providing 3 recipes, 3 recipes are the minimum value and maximum it can be upto 20 recipes. The response should always be in a list of json format type which includes following attributes: recipe_title, recipe_time, recipe_difficult,recipe_short_desc, recipe_ingridents, recipe_nutritional_info, recipe_details. Details of attributes: recipe_title - The title of the recipe which should not be more than 3 words make sure the title is always small not a sentence.  recipe_time - The time required for an individual to create the recipe time should be mostly in mins and hours for Example:[45mins, 2hours].Strictly no other units for time is accepted only hours and mins. recipe_difficult - This field should scale the difficulty of the recipe with 3 options namely(Easy, Medium, Hard).recipe_short_desc- This is a short description of the recipes which provides short summarisation of the recipe in just 3 lines, always it can be upto 3 lines, not exceeding more than 3 lines.recipe_ingridents-This is the attribute which contains ingridents of the recipe, it should contain all the ingridents required for the recipes,it should be always in a string list format where each ingrident is an item in the list.Ex:[2 Onions, 3 potatoes, 2 chilles, etc..].recipe_nutritional_info - This is the attribute which contains a json object of all the nutritional items mentioned here: Fibre, Sodium, Sugars, Protein, Calories, Total Fat, Potassium, Cholestrol, Saturated fat, Total Carbohydrate, Iron, Folate, Calcium, Vitamin A, Vitamin C, all information should be mentioned with it's units example json format : {'fibre':'2g','sodium':'137mg','sugars':'22g','protein':'4g','calories':'347','total_fat':'18g','potassium':'116mg','cholestrol':'63mg','saturated_fat':'9g','total_carbohydrate':'44g','iron':'9.0','folate':'24.0','calcium':'2.0','vitamin_a':'10.0','vitamin_c':'3.0'}, it should be in this way for all the recipes every field is important.recipe_details - This is the attribute which contains main directions for the recipe, this should contain all points/ directions that is required for recipes, make sure it is always mentioned in a detailed format, it should be always in a string list format where each step is an item in the list. Ex: [cut the vegetables and boil for 10mins, Now smash the boiled vegetables and add 2 tablespoons of salt, next-step, next-step….Final-step]So the final response should always look like this, always in a list of json format: [{recipe_title:””,recipe_time:””, recipe_difficult:””, recipe_short_desc:””, recipe_details: [“”,””,””]},{recipe_title:””,recipe_time:””, recipe_difficult:””, recipe_short_desc:””, recipe_nutritional_info:{'fibre':'2g','sodium':'137mg','sugars':'22g','protein':'4g','calories':'347','total_fat':'18g','potassium':'116mg','cholestrol':'63mg','saturated_fat':'9g','total_carbohydrate':'44g','iron':'9.0','folate':'24.0','vitamin_a':'10.0','vitamin_c':'3.0'}, recipe_details: [“”,””,””]}, {},{},{}…….].Strictly do not include ```json ``` in every response. Only provide the list of json object do not include the list inside ```json ``` for every response strictly. Follow the instruction properly striclty do not include the ```json ```` while providing response everytime, only list of json objects is required not the ```json ```.");
   final response = await _model.generateContent([
      Content.multi([prompt])
    ]);
    if(!fromSuggested){
    await navigator.push(
        MaterialPageRoute(
            builder: (context) => GeneratedRecipes(recipeData: response.text), // Sending data to GeneratedRecipes screen
        ),
      );
    }else{
      String trimmedData = response.text!.trim();
      if (trimmedData.startsWith('```json') && trimmedData.endsWith('```')) {
        trimmedData = trimmedData.replaceFirst('```json', '').replaceFirst('```', '').trim();
        recipes = jsonDecode(trimmedData);
         Future.wait(recipes.map((recipe) => getRecipeImages(recipe['recipe_title']).then((url) {
        recipe['imageUrl'] = url;
      })));
      }
    }
  }catch(e){
    print('error scanning image: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error scanning image")));
  }
  }


  // Future<Uint8List> _generate(String query) async {
  //   Uint8List image = await imageGenerator(query, ImageSize.medium); 
  //   return image;
  // }

// Future<Uint8List> generateImage(String query) async {
//   try {
//     // Set your API token for authentication
//     // Authenticator.setApiToken('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiNDEzNGZiNDMtN2IzOS00NTY2LWI1NDItNTUwODE0NzNjYzViIiwidHlwZSI6ImFwaV90b2tlbiJ9.T2I4De0osuCwz8A17wmYIuntvs44C89B04N1vVG3Ib8'); // Replace with your actual API key
//     //   print('data authenticated here');
//     // // Generate the image using the query and desired image size
//     // Uint8List image = await imageGenerator(query, ImageSize.medium);
//     // print('image generating here, ${image}');
//     var url = Uri.parse('https://api.edenai.run/v2/image/generation'); // Replace with the actual API endpoint
//     var headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiNDEzNGZiNDMtN2IzOS00NTY2LWI1NDItNTUwODE0NzNjYzViIiwidHlwZSI6ImFwaV90b2tlbiJ9.T2I4De0osuCwz8A17wmYIuntvs44C89B04N1vVG3Ib8', // Use the API token for authentication
//     };

//     var payload = {
//     'providers': 'replicate,openai',
//     'text': query,
//     'resolution':'512x512',
//     'fallback_providers': '',
//   };
//       try {
//     print('Generating Image');
//     var response = await http.post(
//       url,
//       headers: headers,
//       body: jsonEncode(payload),
//     );
//     print('response ${response.body}');
//     var result = json.decode(response.body);
//     final bytes = base64.decode((result['openai']['items'][0])['image']);
//     print('bytes ${bytes}');
//     return bytes;
//   } catch (e) {
//     throw Exception();
//   } // Return the generated image
//     // return image;
//   } catch (e) {
//     print('Error generating image: ${e.toString()}'); // More details on the error: ${e.toString()}
//     throw Exception('Failed to generate image');
//   }
// }

 getSuggestedRecipes() async {
        var pantryItems = await FoodItemsRecord.getAllRecordsWithUid(currentUserDocument!.uid);
        for(var food in pantryItems){
            existingPantryItems.add({'item':food.pantryItem, 'image':food.imageUrl});
        }

          final userPrompt = "These are the ingredients present in user pantry for the recipes please use the following ingredients, aswell as if any ingredients required please make sure you inform users to include those ingredient aswell if at all required..!!! Orelse always try to provide recipes with the items user selected, hardly include any other item other than user selected if its required to provide a good recipes, if you could not find recipes with the items user selected. The ingredients selected by user is as follows: ${existingPantryItems.map((item) => item['item']).join(', ')}";

        _generateRecipe(userPrompt, currentUserDocument?.allergens, currentUserDocument?.diet, currentUserDocument?.ingredientDislikes,true);
    }

  Future<List<dynamic>> fetchCarouselItems() async {
    // Simulate a network call or data fetching
    await Future.delayed(Duration(seconds: 2)); // Simulate delay
    return recipes;
      // Add more items as needed
    
  }

  Future<List<dynamic>> fetchSavedRecipes() async {
    // Wait for the savedRecipes to be populated
    await getSavedRecipes();
    return savedRecipes;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Close the keyboard
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0, // Remove the shadow below the app bar
          backgroundColor: Color.fromRGBO(244, 247, 224, 1), // Changed to RGB format
          leading: IconButton(
            icon: Icon(
              Icons.arrow_circle_left,
              color: Colors.green,
              size: 40,
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Go back to the previous screen
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.account_circle, color: Colors.green, size: 30),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EatingPreferencesWidget(),
                  ),
                );
              },
            ),
          ],
        ),
        backgroundColor: Color.fromRGBO(244, 247, 224, 1),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        'Recipes',
                        style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  fontFamily: 'Comfortaa',
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0,
                                  color: Colors.green,
                                  useGoogleFonts: GoogleFonts.asMap()
                                                  .containsKey('Comfortaa'), 
                                                  ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _recipePromptController,
                        readOnly: true,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Comfortaa',
                                color: const Color(0xFF000000),
                                letterSpacing: 0.0,
                              ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, color: Colors.green),
                          hintText: 'Find recipes..',
                          hintStyle: TextStyle(color: Colors.green), // Set hint text color to green
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.green, width: 2.0), // Increased border thickness
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.green, width: 2.0), // Increased border thickness
                          ),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Provide Ingridents', style: FlutterFlowTheme.of(context).titleMedium.override(
                                fontFamily: 'Comfortaa',
                                color: const Color(0xFF000000),
                                letterSpacing: 0.0,
                              )),
                              backgroundColor: Colors.white,
                                content: TextField(
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Comfortaa',
                                color: const Color(0xFF000000),
                                letterSpacing: 0.0,
                              ),
                                  controller: _recipePromptController,
                                  maxLines: 10, // Increased text area size
                                decoration: InputDecoration(
                                  hintText: "Enter your recipe ingredients here",
                                  hintStyle: FlutterFlowTheme.of(context).bodySmall.override(
                                    fontFamily: 'Comfortaa',
                                    color: const Color(0xFF000000),
                                    letterSpacing: 0.0,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(color: Colors.green, width: 2.0), // Set border color to green
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(color: Colors.green, width: 2.0), // Set border color to green
                                  ),
                                ),
                                ),
                                actions: [
                                Center(
                                  child:

                                  AuthUserStreamWidget(builder: (context) => 

                                   FFButtonWidget(
                                    onPressed: () async {
                                   var finalPrompt = "These are the instructions given by user manually which may contain ingredients to be included, excluded and it might contain directions to follow, understand the prompt sensibly and generate responses similar to below. The Prompt provided from the user is as follows : ${_recipePromptController.text}. Hardly include any other item other than user selected if it is required to provide a good recipes, if you could not find recipes with the items user selected." ;
                                     var result = await _generateRecipe(finalPrompt,currentUserDocument?.allergens, currentUserDocument?.diet, currentUserDocument?.ingredientDislikes,false);
                                    Navigator.of(context).pop(); // Close the dialog after generating the recipe
                                    },
                                    text: 'Create Recipe',
                                    options: FFButtonOptions(
                                      width: 120,
                                      height: 50,
                                      color: Colors.green, // Change color if disabled
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
                                  )
                                ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),

                    FutureBuilder<List<dynamic>>(
                      future: fetchCarouselItems(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                         return CarouselSlider(
                            options: CarouselOptions(
                              height: 200.0,
                              enlargeCenterPage: true,
                              autoPlay: true,
                              aspectRatio: 16 / 9,
                              viewportFraction: 0.8,
                            ),
                            items: sampleCarouselItems.map((item) {
                              return GestureDetector(
                                onTap: () {
                                  // Handle the tap event here
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PreviewRecipePage(recipeData: item, isSavedRecipes: false,),
                                    ),
                                  );
                                  // You can navigate to another page or perform any action
                                },
                                child: Card(
                                  margin: const EdgeInsets.symmetric(horizontal: 0.0),
                                  color: Colors.green,
                                  child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 110,
                                          height: 150,
                                          child: Image.network(
                                            item['imageUrl'],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 15.0),
                                                child: Text(
                                                  'Suggested Recipe of the Day!',
                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                        fontFamily: 'Comfortaa',
                                                        color: Colors.white,
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 1.0),
                                                child: Text(
                                                  item['recipe_title'],
                                                  style: FlutterFlowTheme.of(context).titleMedium.override(
                                                        fontFamily: 'Comfortaa',
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 8.0),
                                                child: Text(
                                                  item['recipe_short_desc'],
                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                        fontFamily: 'Comfortaa',
                                                        fontSize: 13,
                                                        color: Colors.white,
                                                        letterSpacing: 0.0,
                                                      ),
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(height: 10.0),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    item['recipe_difficult'],
                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                          fontFamily: 'Comfortaa',
                                                          fontSize: 13,
                                                          color: Colors.white,
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                  Text(
                                                    item['recipe_time'],
                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                          fontFamily: 'Comfortaa',
                                                          fontSize: 13,
                                                          color: Colors.white,
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.bookmark_border, color: Colors.white),
                                            SizedBox(height: 100.0),
                                            Icon(Icons.more_vert, color: Colors.white),
                                          ],
                                        ),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return CarouselSlider(
                            options: CarouselOptions(
                              height: 200.0,
                              enlargeCenterPage: true,
                              autoPlay: true,
                              aspectRatio: 16 / 9,
                              viewportFraction: 0.8,
                            ),
                            items: sampleCarouselItems.map((item) {
                              return GestureDetector(
                                onTap: () {
                                  // Handle the tap event here
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PreviewRecipePage(recipeData: item, isSavedRecipes: false,),
                                    ),
                                  );
                                  // You can navigate to another page or perform any action
                                },
                                child: Card(
                                  margin: const EdgeInsets.symmetric(horizontal: 0.0),
                                  color: Colors.green,
                                  child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 110,
                                          height: 150,
                                          child: Image.network(
                                            item['imageUrl'],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 15.0),
                                                child: Text(
                                                  'Suggested Recipe of the Day!',
                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                        fontFamily: 'Comfortaa',
                                                        color: Colors.white,
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 1.0),
                                                child: Text(
                                                  item['recipe_title'],
                                                  style: FlutterFlowTheme.of(context).titleMedium.override(
                                                        fontFamily: 'Comfortaa',
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 8.0),
                                                child: Text(
                                                  item['recipe_short_desc'],
                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                        fontFamily: 'Comfortaa',
                                                        fontSize: 13,
                                                        color: Colors.white,
                                                        letterSpacing: 0.0,
                                                      ),
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(height: 10.0),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    item['recipe_difficult'],
                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                          fontFamily: 'Comfortaa',
                                                          fontSize: 13,
                                                          color: Colors.white,
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                  Text(
                                                    item['recipe_time'],
                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                          fontFamily: 'Comfortaa',
                                                          fontSize: 13,
                                                          color: Colors.white,
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.bookmark_border, color: Colors.white),
                                            SizedBox(height: 100.0),
                                            Icon(Icons.more_vert, color: Colors.white),
                                          ],
                                        ),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        } else {
                          return CarouselSlider(
                            options: CarouselOptions(
                              height: 200.0,
                              enlargeCenterPage: true,
                              autoPlay: true,
                              aspectRatio: 16 / 9,
                              viewportFraction: 0.8,
                            ),
                            items: snapshot.data!.map((item) {
                              return GestureDetector(
                                onTap: () {
                                  // Handle the tap event here
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PreviewRecipePage(recipeData: item, isSavedRecipes: false,),
                                    ),
                                  );
                                  // You can navigate to another page or perform any action
                                },
                                child: Card(
                                  margin: const EdgeInsets.symmetric(horizontal: 0.0),
                                  color: Colors.green,
                                  child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 110,
                                          height: 150,
                                          child: Image.network(
                                            item['imageUrl']!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 15.0),
                                                child: Text(
                                                  'Suggested Recipe of the Day!',
                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                        fontFamily: 'Comfortaa',
                                                        color: Colors.white,
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 1.0),
                                                child: Text(
                                                  item['recipe_title']!,
                                                  style: FlutterFlowTheme.of(context).titleMedium.override(
                                                        fontFamily: 'Comfortaa',
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 8.0),
                                                child: Text(
                                                  item['recipe_short_desc']!,
                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                        fontFamily: 'Comfortaa',
                                                        fontSize: 13,
                                                        color: Colors.white,
                                                        letterSpacing: 0.0,
                                                      ),
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(height: 10.0),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    item['recipe_difficult']!,
                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                          fontFamily: 'Comfortaa',
                                                          fontSize: 13,
                                                          color: Colors.white,
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                  Text(
                                                    item['recipe_time']!,
                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                          fontFamily: 'Comfortaa',
                                                          fontSize: 13,
                                                          color: Colors.white,
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.bookmark_border, color: Colors.white),
                                            SizedBox(height: 100.0),
                                            Icon(Icons.more_vert, color: Colors.white),
                                          ],
                                        ),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Padding(
                        padding: EdgeInsets.all(2),
                        child: Container(
                          height: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: Colors.green, // Added border radius
                          ),
                          child: FutureBuilder<List<dynamic>>(
                            future: fetchSavedRecipes(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return Center(child: Text('Saved Recipes',
                                 style: FlutterFlowTheme.of(context).titleMedium.override(
                                   fontFamily: 'Comfortaa',
                                   fontWeight: FontWeight.bold,
                                   color: Colors.white,
                                   fontSize: 18, // Adjust font size to match other screens
                                   letterSpacing: 0.0,
                                 )));
                                 
                              } else {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    var item = snapshot.data![index];
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16.0),
                                        // color: Colors.green, // Added border radius
                                      ),
                                      child: Card(
                                        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16.0),
                                        ),
                                        color: Color.fromRGBO(244, 247, 224, 1), // Card color
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => PreviewRecipePage(recipeData: item['recipeObj'], isSavedRecipes: true,),
                                                ),
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(8.0),
                                                  child: Image.network(
                                                    item['recipeObj']['imageUrl'] ?? 'https://images.pexels.com/photos/1109197/pexels-photo-1109197.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2', // Provide a default image URL if needed
                                                    width: 50,
                                                    height: 50,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                SizedBox(width: 16.0),
                                                Expanded(
                                                  child: Text(
                                                    item['recipeObj']['recipe_title'] ?? 'Title',
                                                    style: FlutterFlowTheme.of(context)
                                                        .titleMedium
                                                        .override(
                                                          fontFamily: 'Comfortaa',
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.green,
                                                          letterSpacing: 0.0,
                                                        ),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        // List<String> selectedIngredients = [];
                        return FractionallySizedBox(
                          heightFactor: 0.75, // Set the height to 3/4th of the screen
                          child: StatefulBuilder(
                            builder: (BuildContext context, StateSetter setState) {

                              return Container(
                                color: Colors.green,
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Select Ingredients',
                                      style: FlutterFlowTheme.of(context)
                                                .titleMedium
                                                .override(
                                                  fontFamily: 'Comfortaa',
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  letterSpacing: 0.0,
                                                ),
                                    ),
                                    SizedBox(height: 20,),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: GridView.builder(
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3, // Number of items per row
                                            crossAxisSpacing: 8.0, // Adjusted spacing between items horizontally
                                            mainAxisSpacing: 8.0, // Adjusted spacing between items vertically
                                          ),
                                          itemCount: existingPantryItems.length,
                                          itemBuilder: (context, index) {
                                            bool isSelected = selectedIngredients.contains(existingPantryItems[index]['item']);
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (selectedIngredients.contains(existingPantryItems[index]['item'])) {
                                                    selectedIngredients.remove(existingPantryItems[index]['item']);
                                                  } else {
                                                    selectedIngredients.add(existingPantryItems[index]['item']);
                                                  }
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: isSelected ? Colors.white : Colors.transparent,
                                                    width: 2,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 10.0, left: 0, right: 0, bottom: 0),
                                                  child: Column(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(12),
                                                        child: Image.network(
                                                          existingPantryItems[index]['image'],
                                                          width: 70,
                                                          height: 70,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      Text(
                                                        existingPantryItems[index]['item'],
                                                        style: FlutterFlowTheme.of(context)
                                                            .bodySmall
                                                            .override(
                                                              fontFamily: 'Comfortaa',
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white,
                                                              letterSpacing: 0.0,
                                                            ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    FFButtonWidget(
                                      onPressed: selectedIngredients.isEmpty ? null : () async {
                                      var finalPrompt = "These are the ingredients selected by users for the recipes please use the following ingredients, aswell as if any ingredients required please make sure you inform users to include those ingredient aswell if at all required..!!! Orelse always try to provide recipes with the items user selected, hardly include any other item other than user selected if its required to provide a good recipes, if you could not find recipes with the items user selected.The ingredients selected by user is as follows:${selectedIngredients.join(",")}" ;
                                     var result = await _generateRecipe(finalPrompt,currentUserDocument?.allergens, currentUserDocument?.diet, currentUserDocument?.ingredientDislikes,false);
                                      },
                                      text: 'Create Recipe',
                                      options: FFButtonOptions(
                                        width: 130,
                                        height: 40,
                                        color: Colors.white,
                                        textStyle: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  fontFamily: 'Comfortaa',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green,
                                                  letterSpacing: 0.0,
                                                ),
                                        borderSide: BorderSide(
                                          color: Colors.green,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                      color: Colors.green,
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'From Pantry',
                        style: FlutterFlowTheme.of(context)
                                                .titleMedium
                                                .override(
                                                  fontFamily: 'Comfortaa',
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  letterSpacing: 0.0,
                                                ),
                      ),
                    ),
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
