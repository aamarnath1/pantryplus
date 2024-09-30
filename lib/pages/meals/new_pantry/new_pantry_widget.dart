import 'dart:convert';
import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_fresh/auth/firebase_auth/auth_util.dart';
import 'package:intl/intl.dart';
import 'package:keep_fresh/camera_test/result_screen.dart';
import 'package:keep_fresh/index.dart';
import 'package:keep_fresh/pages/meals/new_pantry/pantry_item_details.dart';
import 'package:keep_fresh/pages/meals/pantry_details/pantry_details_widget.dart';
import 'package:sign_in_with_apple_platform_interface/sign_in_with_apple_platform_interface.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'new_pantry_model.dart';
export 'new_pantry_model.dart';

class NewPantryWidget extends StatefulWidget {
  final Future<List<dynamic>>? pantryItems;
  const NewPantryWidget({super.key, this.pantryItems});

  @override
  State<NewPantryWidget> createState() => _NewPantryWidgetState();
}

class _NewPantryWidgetState extends State<NewPantryWidget> {
  // GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late NewPantryModel _model;
  List<dynamic>? pantryDatas;
  List<dynamic>? pantryItems;
  List<dynamic>? freezerItems;
  List<dynamic>? fridgeItems;
  late bool showPantryData = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  initState() {
    super.initState();
    getPantryItmes();
    _model = createModel(context, () => NewPantryModel());
    logFirebaseEvent('screen_view', parameters: {'screen_name': 'NewPantry'});
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  getPantryItmes() async {
    // _isLoader = true;
    // print('inside function');
    pantryDatas = await widget.pantryItems;
    fridgeItems = pantryDatas
        ?.where((item) =>
            jsonDecode(item['pantryItemDetails'])[0]['category'] == 'fridge')
        .toList();
    freezerItems = pantryDatas
        ?.where((item) =>
            jsonDecode(item['pantryItemDetails'])[0]['category'] == 'freezer')
        .toList();
    pantryItems = pantryDatas
        ?.where((item) =>
            jsonDecode(item['pantryItemDetails'])[0]['category'] == 'pantry')
        .toList();
  }

  getImages(String itemName) async {
    String encodedItemName = Uri.encodeComponent(itemName);
    var httpClient = HttpClient();
    var request = await httpClient.getUrl(Uri.parse(
        'https://pixabay.com/api/?key=30703712-02ffe71de411674f06d11b1c9&q=$encodedItemName+food+groceryitem&image_type=photo&safesearch=true'));

    var response =
        await request.close(); // Close the request to get the response

    // Accessing response content
    if (response.statusCode == 200) {
      var responseBody = await response
          .transform(utf8.decoder)
          .join(); // Decode the response body
      var url = jsonDecode(responseBody)['hits'][0]['webformatURL'].toString();
      return url;
    } else {
      print("response, ${response.reasonPhrase}");
      print('Failed to load images: ${response.statusCode}'); // Handle error
    }
  }

  String formatDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    // Extract the day and add the ordinal suffix
    String day = date.day.toString();
    String daySuffix;
    if (day.endsWith('1') && !day.endsWith('11')) {
      daySuffix = 'st';
    } else if (day.endsWith('2') && !day.endsWith('12')) {
      daySuffix = 'nd';
    } else if (day.endsWith('3') && !day.endsWith('13')) {
      daySuffix = 'rd';
    } else {
      daySuffix = 'th';
    }

    // Format the date
    String formattedDate = DateFormat('d MMMM yyyy').format(date);

    // Insert the day suffix
    return formattedDate.replaceFirst(day, day + daySuffix);
  }

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments;
    // print('args, ${args}');
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Color(0xFFEDE8DF),
          body: FutureBuilder<List<dynamic>>(
              future: widget.pantryItems,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  print('inside waiting');
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print('inside error');
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  pantryDatas = snapshot.data;
                  return SafeArea(
                      child: AuthUserStreamWidget( 
                        builder: (context) => 
          currentUserDocument != null ?
                   PageView.builder(
                    controller: _model.pageViewController ??=
                        PageController(initialPage: 0),
                    scrollDirection: Axis.horizontal,
                    itemCount: 3, // Number of pages
                    itemBuilder: (context, pageIndex) {
                      switch (pageIndex) {
                        case 0:
                        if(pantryDatas?.length != 0){
                          return Padding(
                            padding: const EdgeInsetsDirectional.all(0),
                            child: Scaffold(
                              appBar: AppBar(
                                backgroundColor:
                                    Color.fromARGB(255, 38, 174, 97),
                                automaticallyImplyLeading: false,
                                actions: [
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () {
                                      // Add your action here
                                    },
                                  ),
                                  FlutterFlowIconButton(
                                    borderRadius: 20,
                                    buttonSize: 40,
                                    icon: const Icon(Icons.home_outlined),
                                    onPressed: () {
                                      context.pushReplacement('/dashboard');
                                    },
                                  ),
                                ],
                                title: const Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      5, 5, 5, 5),
                                  child: Text('Pantry'),
                                ),
                                centerTitle: true,
                              ),
                              backgroundColor: Color.fromARGB(255, 38, 174, 97),
                              body: GridView.builder(
                                padding: EdgeInsets.all(10),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 0.75,
                                ),
                                itemCount: pantryItems?.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: 3,
                                    color: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(
                                          10), // Ensures ripple effect follows card shape
                                      onTap: () {
                                        print(
                                            'pantry item: ${pantryItems?[index]}');
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PantryItemDetails(
                                                      itemDetails:
                                                          pantryItems?[index])),
                                        );
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(10)),
                                              child: Image.network(
                                                pantryItems?[index]['imageUrl'],
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              pantryItems?[index]['pantryItem'],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }else{
                          return Scaffold(
                            backgroundColor: Color.fromARGB(255, 38, 174, 97), // Add background color
                            appBar: AppBar(
                                backgroundColor:
                                    Color.fromARGB(255, 38, 174, 97),
                                automaticallyImplyLeading: false,
                                actions: [
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () {
                                      // Add your action here
                                    },
                                  ),
                                  FlutterFlowIconButton(
                                    borderRadius: 20,
                                    buttonSize: 40,
                                    icon: const Icon(Icons.home_outlined),
                                    onPressed: () {
                                      context.pushReplacement('/dashboard');
                                    },
                                  ),
                                ],
                                title: const Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      5, 5, 5, 5),
                                  child: Text('Pantry'),
                                ),
                                centerTitle: true,
                              ),
                            body: Container(
                              padding: EdgeInsets.all(10),
                              child: Center(
                                child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'No items in pantry',
                                   style:FlutterFlowTheme.of(context)
                                    .displaySmall
                                    .override(
                                      fontFamily: 'Comfortaa',
                                      letterSpacing: 0.0,
                                      color: Colors.white
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Please add pantry details to get started.',
                                    textAlign: TextAlign.center,
                                    style:FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: 'Comfortaa',
                                      letterSpacing: 0.0,
                                      color: Colors.white
                                    ),
                                  ),
                                SizedBox(height: 20),
                                FFButtonWidget(
                                  text: 'Add Pantry item',
                                  onPressed: () {
                                    // Add your action here
                                  },
                                  options: FFButtonOptions(
                                    width: 150.0,
                                    height: 60.0,
                                    color: Color.fromARGB(255, 23, 109, 60),
                                    textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                                          fontFamily: 'Inter',
                                          color: Colors.white,
                                          letterSpacing: 0.0,
                                        ),
                                    elevation: 2.0,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                ],
                              ),
                              )
                            ),
                          );   
                        }
                        case 1:
                        if(pantryDatas?.length != 0){
                          return Padding(
                            padding: const EdgeInsetsDirectional.all(0),
                            child: Scaffold(
                              appBar: AppBar(
                                title: Text('Fridge'),
                                automaticallyImplyLeading: false,
                                backgroundColor:
                                    Color.fromARGB(255, 129, 176, 240),
                                actions: [
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () {},
                                  ),
                                  FlutterFlowIconButton(
                                    borderRadius: 20,
                                    buttonSize: 40,
                                    icon: const Icon(Icons.home_outlined),
                                    onPressed: () {
                                      context.pushReplacement('/dashboard');
                                    },
                                  ),
                                ],
                                centerTitle: true,
                              ),
                              backgroundColor:
                                  Color.fromARGB(255, 129, 176, 240),
                              body: GridView.builder(
                                padding: EdgeInsets.all(10),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 0.75,
                                ),
                                itemCount: fridgeItems?.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: 3,
                                    color: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(
                                          10), // Ensures ripple effect follows card shape
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PantryItemDetails(
                                                      itemDetails:
                                                          fridgeItems?[index])),
                                        );
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(10)),
                                              child: Image.network(
                                                fridgeItems?[index]['imageUrl'],
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              fridgeItems?[index]['pantryItem'],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }else{
                          return Scaffold(
                            backgroundColor: Color.fromARGB(255, 38, 174, 97), // Add background color
                            appBar: AppBar(
                                backgroundColor:
                                    Color.fromARGB(255, 129, 176, 240),
                                automaticallyImplyLeading: false,
                                actions: [
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () {
                                      // Add your action here
                                    },
                                  ),
                                  FlutterFlowIconButton(
                                    borderRadius: 20,
                                    buttonSize: 40,
                                    icon: const Icon(Icons.home_outlined),
                                    onPressed: () {
                                      context.pushReplacement('/dashboard');
                                    },
                                  ),
                                ],
                                title: const Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      5, 5, 5, 5),
                                  child: Text('Fridge'),
                                ),
                                centerTitle: true,
                              ),
                            body: Container(
                              color: Color.fromARGB(255, 129, 176, 240),
                              padding: EdgeInsets.all(10),
                              child: Center(
                                child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'No items in Fridge',
                                   style:FlutterFlowTheme.of(context)
                                    .displaySmall
                                    .override(
                                      fontFamily: 'Comfortaa',
                                      letterSpacing: 0.0,
                                      color: Colors.white
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Please add Fridge item details to get started.',
                                    textAlign: TextAlign.center,
                                    style:FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: 'Comfortaa',
                                      letterSpacing: 0.0,
                                      color: Colors.white
                                    ),
                                  ),
                                SizedBox(height: 20),
                                FFButtonWidget(
                                  text: 'Add Fridge item',
                                  onPressed: () {
                                    // Add your action here
                                  },
                                  options: FFButtonOptions(
                                    width: 150.0,
                                    height: 60.0,
                                    color: Color.fromARGB(255, 86, 117, 160),
                                    textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                                          fontFamily: 'Inter',
                                          color: Colors.white,
                                          letterSpacing: 0.0,
                                        ),
                                    elevation: 2.0,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                ],
                              ),
                              )
                            ),
                          ); 
                        }
                        case 2:
                        if(pantryDatas?.length != 0){
                          return Padding(
                            padding: const EdgeInsetsDirectional.all(0),
                            child: Scaffold(
                              appBar: AppBar(
                                title: Text('Freezer'),
                                automaticallyImplyLeading: false,
                                backgroundColor:
                                    Color.fromARGB(255, 130, 222, 238),
                                actions: [
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () {
                                      // Add your action here
                                    },
                                  ),
                                  FlutterFlowIconButton(
                                    borderRadius: 20,
                                    buttonSize: 40,
                                    icon: const Icon(Icons.home_outlined),
                                    onPressed: () {
                                      context.pushReplacement('/dashboard');
                                    },
                                  ),
                                ],
                                centerTitle: true,
                              ),
                              backgroundColor:
                                  Color.fromARGB(255, 130, 222, 238),
                              body: GridView.builder(
                                padding: EdgeInsets.all(10),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 0.75,
                                ),
                                itemCount: freezerItems?.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: 3,
                                    color: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(
                                          10), // Ensures ripple effect follows card shape
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PantryItemDetails(
                                                      itemDetails:
                                                          freezerItems?[
                                                              index])),
                                        );
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(10)),
                                              child: Image.network(
                                                freezerItems?[index]
                                                    ['imageUrl'],
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              freezerItems?[index]
                                                  ['pantryItem'],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }else{
                          return Scaffold(
                            backgroundColor: Color.fromARGB(255, 38, 174, 97), // Add background color
                            appBar: AppBar(
                                backgroundColor:
                                    Color.fromARGB(255, 130, 222, 238),
                                automaticallyImplyLeading: false,
                                actions: [
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () {
                                      // Add your action here
                                    },
                                  ),
                                  FlutterFlowIconButton(
                                    borderRadius: 20,
                                    buttonSize: 40,
                                    icon: const Icon(Icons.home_outlined),
                                    onPressed: () {
                                      context.pushReplacement('/dashboard');
                                    },
                                  ),
                                ],
                                title: const Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      5, 5, 5, 5),
                                  child: Text('Freezer'),
                                ),
                                centerTitle: true,
                              ),
                            body: Container(
                              color: Color.fromARGB(255, 130, 222, 238),
                              padding: EdgeInsets.all(10),
                              child: Center(
                                child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'No items in Freezer',
                                   style:FlutterFlowTheme.of(context)
                                    .displaySmall
                                    .override(
                                      fontFamily: 'Comfortaa',
                                      letterSpacing: 0.0,
                                      color: Colors.white
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Please add Freezer item details to get started.',
                                    textAlign: TextAlign.center,
                                    style:FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: 'Comfortaa',
                                      letterSpacing: 0.0,
                                      color: Colors.white
                                    ),
                                  ),
                                SizedBox(height: 20),
                                FFButtonWidget(
                                  text: 'Add Freezer item',
                                  onPressed: () {
                                    // Add your action here
                                  },
                                  options: FFButtonOptions(
                                    width: 150.0,
                                    height: 60.0,
                                    color: Color.fromARGB(255, 79, 135, 144),
                                    textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                                          fontFamily: 'Inter',
                                          color: Colors.white,
                                          letterSpacing: 0.0,
                                        ),
                                    elevation: 2.0,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                ],
                              ),
                              )
                            ),
                          ); 

                        }
                        default:
                          return Container(); // Fallback for safety
                      }
                    },
                  ) :

                       Scaffold(
                          appBar: AppBar(
                            title: Text('Welcome to PantryPlus',
                            style:FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: 'Comfortaa',
                                      letterSpacing: 0.0,
                                      color: Colors.white
                                    ),
                            ),
                            backgroundColor: Color.fromARGB(255, 38, 174, 97),
                          ),
                          body: Container(
                            color: Color(0xFFEDE8DF), // Set background color
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.account_circle, // Using a built-in account icon
                                      size: 100, // Adjust size as needed
                                      color: Color.fromARGB(255, 38, 174, 97), // Match the theme color
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                      'Create Account',
                                      style:FlutterFlowTheme.of(context)
                                    .displaySmall
                                    .override(
                                      fontFamily: 'Comfortaa',
                                      letterSpacing: 0.0,
                                      color: const Color(0xFF101518)
                                    ),
                                    ))
                                    ,
                                    SizedBox(height: 20),
                                    Text(
                                      'Join us to manage your pantry items effectively. Please create an account to get started.',
                                      textAlign: TextAlign.center,
                                     style:FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: 'Comfortaa',
                                      letterSpacing: 0.0,
                                      color: const Color(0xFF101518)
                                    ),
                                    ),
                                    SizedBox(height: 30),
                                    FFButtonWidget(
                                      text: 'Create Account',
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                               OnboardingCreateAccountWidget()
                                          ),
                                        );
                                     
                                      },
                                      options: FFButtonOptions(
                                        width: 200.0,
                                        height: 60.0,
                                        color: Color.fromARGB(255, 38, 174, 97),
                                        textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                                              fontFamily: 'Inter',
                                              color: Colors.white,
                                              letterSpacing: 0.0,
                                            ),
                                        elevation: 2.0,
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    SizedBox(height: 40),
                                    Text(
                                      'You can still access camera features. Try exploring!',
                                      textAlign: TextAlign.center,
                                      style:FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: 'Comfortaa',
                                      letterSpacing: 0.0,
                                      color: const Color(0xFF101518)
                                    ),
                                    ),
                                    SizedBox(height: 40),
                                    FFButtonWidget(
                                      text: 'Explore Camera Features',
                                      onPressed: () {
                                        context.pushReplacement('/dashboard');
                                      },
                                      options: FFButtonOptions(
                                        width: 200.0,
                                        height: 60.0,
                                        color: Color.fromARGB(255, 38, 174, 97),
                                        textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                                              fontFamily: 'Inter',
                                              color: Colors.white,
                                              letterSpacing: 0.0,
                                            ),
                                        elevation: 2.0,
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                        )
                  );
                } else {
                  return Center(child: Text('No data'));
                }
              })),
    );
  }
}
