import 'package:flutter/material.dart';
import 'package:keep_fresh/auth/firebase_auth/auth_util.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_theme.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';

class RecipesWidget extends StatefulWidget {
  const RecipesWidget({Key? key}) : super(key: key);

  @override
  _RecipesWidgetState createState() => _RecipesWidgetState();
}

class _RecipesWidgetState extends State<RecipesWidget> {
  bool isSelected = false;
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
              // Handle back button press
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.account_circle, color: Colors.green, size: 30),
              onPressed: () {
                // Handle more options
              },
            ),
          ],
        ),
        backgroundColor: Color.fromRGBO(244, 247, 224, 1),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  'Recipes',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 200.0,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.9,
                  ),
                  items: [
                    Card(
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
                                'https://images.pexels.com/photos/18330395/pexels-photo-18330395/free-photo-of-photo-of-lunch-in-a-bowl.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
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
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 1.0),
                                    child: Text(
                                      'Changed Title',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'This recipe combines fresh ingredients and bold flavors. '
                                    'Perfect for a quick weeknight dinner or a weekend gathering.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 8.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Recipe Difficulty',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'Recipe Time',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
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
                    Card(
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
                                'https://images.pexels.com/photos/19264273/pexels-photo-19264273/free-photo-of-close-up-of-meal-in-bowl.jpeg?auto=compress&cs=tinysrgb&w=800', // Replace with your image URL
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
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 1.0),
                                    child: Text(
                                      'Title',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'This recipe combines fresh ingredients and bold flavors. '
                                    'Perfect for a quick weeknight dinner or a weekend gathering.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 8.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Recipe Difficulty',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'Recipe Time',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
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
                    Card(
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
                                'https://images.pexels.com/photos/14883760/pexels-photo-14883760.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
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
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 1.0),
                                    child: Text(
                                      'Title',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'This recipe combines fresh ingredients and bold flavors. '
                                    'Perfect for a quick weeknight dinner or a weekend gathering.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 8.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Recipe Difficulty',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'Recipe Time',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
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
                    Card(
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
                                'https://images.pexels.com/photos/2714722/pexels-photo-2714722.jpeg',
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
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 1.0),
                                    child: Text(
                                      'Title',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'This recipe combines fresh ingredients and bold flavors. '
                                    'Perfect for a quick weeknight dinner or a weekend gathering.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 8.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Recipe Difficulty',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'Recipe Time',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
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
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Padding(
                  padding: EdgeInsets.all(2),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Colors.green, // Added border radius
                    ),
                    height: 300,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 7, // Replace with your data length
                      itemBuilder: (context, index) {
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
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  SizedBox(width: 16.0),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Title',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                      Text(
                                        'Description',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
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
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder: (BuildContext context, StateSetter setState) {
                              List<String> ingredients = [
                                'Tomatoes', 'Onions', 'Garlic', 'Chicken', 'Basil', 'Olive Oil', 'Salt', 'Pepper'
                              ];
                              List<String> selectedIngredients = [];

                              return Container(
                                color: Colors.green,
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Text(
                                      'Select Ingredients',
                                      style: TextStyle(color: Colors.white, fontSize: 18),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: ingredients.length,
                                        itemBuilder: (context, index) {
                                          return StatefulBuilder(
                                            builder: (context, setState) {
                                              bool isSelected = selectedIngredients.contains(ingredients[index]);
                                              return ListTile(
                                                title: Row(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(12), // Add border radius to make it look like an icon
                                                      child: Image.network(
                                                        'https://images.pexels.com/photos/533280/pexels-photo-533280.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2', // Replace with the actual image URL
                                                        width: 24, // Set the width to match the text size
                                                        height: 24, // Set the height to match the text size
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    SizedBox(width: 8), // Add some space between the image and text
                                                    Text(
                                                      ingredients[index],
                                                      style: TextStyle(color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                                trailing: IconButton(
                                                  icon: Icon(
                                                    isSelected ? Icons.remove : Icons.add,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      if (isSelected) {
                                                        selectedIngredients.remove(ingredients[index]);
                                                      } else {
                                                        selectedIngredients.add(ingredients[index]);
                                                      }
                                                    });
                                                  },
                                                ),
                                              );
                                            },
                                            
                                          );
                                        },
                                      ),
                                    ),
                                    FFButtonWidget(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Ingredients: ${selectedIngredients.join(', ')}'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                        Navigator.pop(context); // Close the current screen
                                      },
                                      text: 'Create Recipe',
                                      options:const FFButtonOptions(
                                        width: 130,
                                        height: 40,
                                        color: Colors.white,
                                        textStyle: TextStyle(
                                          color: Colors.green,
                                          fontSize: 16,
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
                        color: Colors.green, // Added border radius
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          'From Pantry',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
