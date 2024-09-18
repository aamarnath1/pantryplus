import 'dart:convert';
import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_fresh/auth/firebase_auth/auth_util.dart';
import 'package:intl/intl.dart';
import 'package:keep_fresh/camera_test/result_screen.dart';
import 'package:keep_fresh/index.dart';
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
      // print('pantryDatas ${pantryDatas}');
      fridgeItems = pantryDatas?.where((item) => jsonDecode(item['pantryItemDetails'])[0]['category'] == 'fridge').toList();
      freezerItems = pantryDatas?.where((item) => jsonDecode(item['pantryItemDetails'])[0]['category'] == 'freezer').toList();
      pantryItems = pantryDatas?.where((item) => jsonDecode(item['pantryItemDetails'])[0]['category'] == 'pantry').toList();
  }

  getImages(String itemName) async {
    String encodedItemName = Uri.encodeComponent(itemName);
    var httpClient = HttpClient();
    var request = await httpClient.getUrl(Uri.parse('https://pixabay.com/api/?key=30703712-02ffe71de411674f06d11b1c9&q=$encodedItemName+food+groceryitem&image_type=photo&safesearch=true'));
  
    var response = await request.close(); // Close the request to get the response

    // Accessing response content
    if (response.statusCode == 200) {
      var responseBody = await response.transform(utf8.decoder).join(); // Decode the response body
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
                  return  SafeArea(  
                    child: PageView.builder(
                      controller: _model.pageViewController ??= PageController(initialPage: 0),
                      scrollDirection: Axis.horizontal,
                      itemCount: 3, // Number of pages
                      itemBuilder: (context, pageIndex) {
                        switch (pageIndex) {
                          case 0:
                            return Padding(
                              padding: const EdgeInsetsDirectional.all(0),
                              child: Scaffold(
                                appBar: AppBar(
                                  backgroundColor: Color.fromARGB(255, 38, 174, 97),
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
                                    padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                                    child: Text('Pantry'),
                                  ),
                                  centerTitle: true,
                                ),
                                backgroundColor: Color.fromARGB(255, 38, 174, 97),
                                body: GridView.builder(
                                  padding: EdgeInsets.all(10),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                                              child: FutureBuilder<dynamic>(
                                                future: getImages(pantryItems?[index]['pantryItem']),
                                                builder: (context, snapshot) {
                                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                                    return Center(child: CircularProgressIndicator());
                                                  } else if (snapshot.hasError) {
                                                    return Icon(Icons.error, color: Colors.red);
                                                  } else if (!snapshot.hasData || snapshot.data == null) {
                                                    return Icon(Icons.broken_image, color: Colors.grey);
                                                  } else {
                                                    return Image.network(
                                                      snapshot.data,
                                                      fit: BoxFit.fill,
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              pantryItems?[index]['pantryItem'],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          case 1:
                            return Padding(
                              padding: const EdgeInsetsDirectional.all(0),
                              child: Scaffold(
                                appBar: AppBar(
                                  title: Text('Fridge'),
                                  automaticallyImplyLeading: false,
                                  backgroundColor: Color.fromARGB(255, 129, 176, 240),
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
                                backgroundColor: Color.fromARGB(255, 129, 176, 240),
                                body: GridView.builder(
                                  padding: EdgeInsets.all(10),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                                              child: FutureBuilder<dynamic>(
                                                future: getImages(fridgeItems?[index]['pantryItem']),
                                                builder: (context, snapshot) {
                                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                                    return Center(child: CircularProgressIndicator());
                                                  } else if (snapshot.hasError) {
                                                    return Icon(Icons.error, color: Colors.red);
                                                  } else if (!snapshot.hasData || snapshot.data == null) {
                                                    return Icon(Icons.broken_image, color: Colors.grey);
                                                  } else {
                                                    return Image.network(
                                                      snapshot.data!,
                                                      fit: BoxFit.fill,
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              fridgeItems?[index]['pantryItem'],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          case 2:
                            return Padding(
                              padding: const EdgeInsetsDirectional.all(0),
                              child: Scaffold(
                                appBar: AppBar(
                                  title: Text('Freezer'),
                                  automaticallyImplyLeading: false,
                                  backgroundColor: Color.fromARGB(255, 130, 222, 238),
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
                                backgroundColor: Color.fromARGB(255, 130, 222, 238),
                                body: GridView.builder(
                                  padding: EdgeInsets.all(10),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                                              child: FutureBuilder<dynamic>(
                                                future: getImages(freezerItems?[index]['pantryItem']),
                                                builder: (context, snapshot) {
                                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                                    return Center(child: CircularProgressIndicator());
                                                  } else if (snapshot.hasError) {
                                                    return Icon(Icons.error, color: Colors.red);
                                                  } else if (!snapshot.hasData || snapshot.data == null) {
                                                    return Icon(Icons.broken_image, color: Colors.grey);
                                                  } else {
                                                    return Image.network(
                                                      snapshot.data!,
                                                      fit: BoxFit.fill,
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              freezerItems?[index]['pantryItem'],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          default:
                            return Container(); // Fallback for safety
                        }
                      },
                    )
                    );
                  // pantryDatas = snapshot.data;
                  // return SafeArea(
                  //     top: true,
                  //     child: Padding(
                  //         padding: const EdgeInsetsDirectional.fromSTEB(
                  //             16.0, 16.0, 16.0, 16.0),
                  //         child: Column(
                  //           mainAxisSize: MainAxisSize.max,
                  //           children: [
                  //             Row(
                  //               mainAxisSize: MainAxisSize.max,
                  //               mainAxisAlignment:
                  //                   MainAxisAlignment.spaceBetween,
                  //               children: [
                  //                 Text(
                  //                   'My Pantry',
                  //                   style: FlutterFlowTheme.of(context)
                  //                       .headlineMedium
                  //                       .override(
                  //                         fontFamily: 'Comfortaa',
                  //                         color: Color(0xFF000000),
                  //                         letterSpacing: 0.0,
                  //                       ),
                  //                 ),
                  //                  Padding(
                  //                   padding: EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                  //                   child: FlutterFlowIconButton(
                  //                     borderRadius: 20,
                  //                     buttonSize: 40,
                  //                     icon: Icon(
                  //                       Icons.home_outlined,
                  //                       color: const Color(0xFF000000),
                  //                       size: 24,
                  //                     ),
                  //     onPressed: () {
                  //       context.pushReplacement('/dashboard');
                  //     },
                  //   ),
                  // ),
                  //               ],
                  //             ),
                  //             if (pantryDatas!.isEmpty)
                  //               Padding(
                  //                 padding: const EdgeInsetsDirectional.fromSTEB(
                  //                     16.0, 0.0, 16.0, 0.0),
                  //                 child: Container(
                  //                   width: double.infinity,
                  //                   height: 200.0,
                  //                   decoration: BoxDecoration(
                  //                     color: Color.fromARGB(255, 255, 255, 255),
                  //                     boxShadow: const [
                  //                       BoxShadow(
                  //                         blurRadius: 4.0,
                  //                         color: Color(0x33000000),
                  //                         offset: Offset(
                  //                           0.0,
                  //                           2.0,
                  //                         ),
                  //                         spreadRadius: 0.0,
                  //                       )
                  //                     ],
                  //                     borderRadius: BorderRadius.circular(12.0),
                  //                   ),
                  //                   child: Padding(
                  //                     padding:
                  //                         const EdgeInsetsDirectional.fromSTEB(
                  //                             16.0, 16.0, 16.0, 16.0),
                  //                     child: Column(
                  //                       mainAxisSize: MainAxisSize.max,
                  //                       children: [
                  //                         Text(
                  //                           'Your Pantry is Empty',
                  //                           style: FlutterFlowTheme.of(context)
                  //                               .bodyLarge
                  //                               .override(
                  //                                 fontFamily: 'Comfortaa',
                  //                                 color: FlutterFlowTheme.of(
                  //                                         context)
                  //                                     .secondaryText,
                  //                                 letterSpacing: 0.0,
                  //                               ),
                  //                         ),
                  //                         const Padding(
                  //                             padding: EdgeInsetsDirectional
                  //                                 .fromSTEB(10, 10, 10, 10)),
                  //                         Text(
                  //                           'Start adding items to your pantry by scanning receipts or barcodes.',
                  //                           style: FlutterFlowTheme.of(context)
                  //                               .bodyMedium
                  //                               .override(
                  //                                 fontFamily: 'Comfortaa',
                  //                                 color: FlutterFlowTheme.of(
                  //                                         context)
                  //                                     .secondaryText,
                  //                                 letterSpacing: 0.0,
                  //                               ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //             if (pantryDatas != [] && pantryDatas!.isNotEmpty)
                  //               Padding(
                  //                 padding: const EdgeInsetsDirectional.fromSTEB(
                  //                     16.0, 0.0, 16.0, 0.0),
                  //                 child: Column(
                  //                   children: [
                  //                     Container(
                  //                         height: 500,
                  //                         child: ListView.builder(
                  //                           scrollDirection: Axis.vertical,
                  //                           itemCount: pantryDatas?.length,
                  //                           itemBuilder: (context, index) {
                  //                             // File imageFile = File(pantryDatas[index]['imageUrl']);
                  //                             return Card(
                  //                               elevation: 5,
                  //                               color: Colors.white,
                  //                               margin: EdgeInsets.all(10),
                  //                               child: ListTile(
                  //                                 title: DefaultTextStyle(
                  //                                     style: TextStyle(
                  //                                         color: Colors.black),
                  //                                     child: ListBody(
                  //                                       children: [
                  //                                         Text(
                  //                                           'My Pantry ${ pantryDatas!.length - index}',
                  //                                             style: FlutterFlowTheme
                  //                                                     .of(context).headlineSmall
                  //                                                 .override(
                  //                                                   fontFamily:
                  //                                                     'Comfortaa',
                  //                                                   color: FlutterFlowTheme.of(
                  //                                                           context)
                  //                                                       .secondaryText,
                  //                                                   letterSpacing:
                  //                                                       0.0,
                  //                                                 )),
                  //                                       ],
                  //                                     )),
                  //                                 subtitle:
                  //                                Text(
                  //                                     '${formatDate(pantryDatas![index]['createdTime'].toString())} • ${jsonDecode(pantryDatas![index]['pantryData']).length} items',
                  //                                     style:
                  //                                         FlutterFlowTheme.of(
                  //                                                 context)
                  //                                             .bodyText1
                  //                                             .override(
                  //                                               fontFamily:
                  //                                                   'Comfortaa',
                  //                                               color: FlutterFlowTheme.of(
                  //                                                       context)
                  //                                                   .secondaryText,
                  //                                               letterSpacing:
                  //                                                   0.0,
                  //                                             )),
                  //                                 onTap: () async {
                  //                                   // print('pantryDatas[index] ${pantryDatas![index]}');
                  //                                   final navigator =
                  //                                       Navigator.of(context);
                  //                                       await navigator.push(MaterialPageRoute(builder: (context) => PantryDetailsWidget(data : pantryDatas![index]['pantryData'], createdTime: pantryDatas![index]['createdTime'])));
                  //                                   // await navigator.push(
                  //                                   //   MaterialPageRoute(
                  //                                   //     builder: (context) =>
                  //                                   //         ResultScreen(
                  //                                   //       text: pantryDatas![
                  //                                   //                   index][
                  //                                   //               'pantryData'] ??
                  //                                   //           '',
                  //                                   //       imagePath:
                  //                                   //           pantryDatas![
                  //                                   //                   index]
                  //                                   //               ['imageUrl'],
                  //                                   //       isPantry: true,
                  //                                   //     ),
                  //                                   //   ),
                  //                                   // );
                  //                                 },
                  //                               ),
                  //                             );
                  //                           },
                  //                         )),
                  //                   ],
                  //                 ),
                  //               ),
                  //                    AuthUserStreamWidget(builder: (context) =>
                  //                     Padding(
                  //                       padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                  //                       child:Container(
                  //                         child: Align(
                  //                           alignment:  Alignment(0.2, 0.6),
                  //                            child: FFButtonWidget(
                  //                         onPressed: () async {
                  //                         },
                  //                         text: 'Add Items',
                  //                         options: FFButtonOptions(
                  //                           width: double.infinity,
                  //                           height: 50.0,
                  //                           padding:
                  //                               const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  //                           iconPadding:
                  //                               const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  //                           color: FlutterFlowTheme.of(context).secondary,
                  //                           textStyle:
                  //                               FlutterFlowTheme.of(context).titleSmall.override(
                  //                                     fontFamily: 'Comfortaa',
                  //                                     color: Colors.white,
                  //                                     letterSpacing: 0.0,
                  //                                   ),
                  //                           elevation: 2.0,
                  //                           borderRadius: BorderRadius.circular(12.0),
                  //                         ),
                  //                       ),
                  //                       ),
                  //                     ),
                  //                     ),
                  //                    ),
                  //           ],
                  //         )));
                } else {
                  print('inside no data');
                  return Center(child: Text('No data'));
                }
               
              })
          // body: SafeArea(
          //   top: true,
          //   child: Padding(
          //     padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
          //     child: Column(
          //       mainAxisSize: MainAxisSize.max,
          //       children: [
          //         Row(
          //           mainAxisSize: MainAxisSize.max,
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Text(
          //               'My Pantry',
          //               style:
          //                   FlutterFlowTheme.of(context).headlineMedium.override(
          //                         fontFamily: 'Comfortaa',
          //                         color: Color(0xFF000000),
          //                         letterSpacing: 0.0,
          //                       ),
          //             ),
          //             Padding(
          //               padding:
          //                   const EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
          //               child: FlutterFlowIconButton(
          //                 buttonSize: 40.0,
          //                 icon: Icon(
          //                   Icons.add_rounded,
          //                   color: Color(0xFF000000),
          //                   size: 24.0,
          //                 ),
          //                 onPressed: () {
          //                   print('IconButton pressed ...');
          //                 },
          //               ),
          //             ),
          //           ],
          //         ),
          //       if(pantryDatas == null)
          //           Padding(
          //             padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
          //             child: Container(
          //               width: double.infinity,
          //               height: 200.0,
          //               decoration: BoxDecoration(
          //                 color:Color.fromARGB(255, 255, 255, 255),
          //                 boxShadow: const [
          //                   BoxShadow(
          //                     blurRadius: 4.0,
          //                     color: Color(0x33000000),
          //                     offset: Offset(
          //                       0.0,
          //                       2.0,
          //                     ),
          //                     spreadRadius: 0.0,
          //                   )
          //                 ],
          //                 borderRadius: BorderRadius.circular(12.0),
          //               ),
          //               child: Padding(
          //                 padding: const EdgeInsetsDirectional.fromSTEB(
          //                     16.0, 16.0, 16.0, 16.0),
          //                 child: Column(
          //                   mainAxisSize: MainAxisSize.max,
          //                   children: [
          //                     Text(
          //                       'Your Pantry is Empty',
          //                       style:
          //                           FlutterFlowTheme.of(context).bodyLarge.override(
          //                                 fontFamily: 'Comfortaa',
          //                                 color: FlutterFlowTheme.of(context)
          //                                     .secondaryText,
          //                                 letterSpacing: 0.0,
          //                               ),
          //                     ),
          //                     const Padding(
          //                       padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10)),
          //                     Text(
          //                       'Start adding items to your pantry by scanning receipts or barcodes.',
          //                       style: FlutterFlowTheme.of(context)
          //                           .bodyMedium
          //                           .override(
          //                             fontFamily: 'Comfortaa',
          //                             color: FlutterFlowTheme.of(context)
          //                                 .secondaryText,
          //                             letterSpacing: 0.0,
          //                           ),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           ),
          //           if(pantryDatas != null)
          //             // SingleChildScrollView(
          //               // child:
          //               Padding(
          //                 padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
          //                 child: Column(
          //                   children: [
          //               // if (widget.isLoader) // Conditional rendering of the loader
          //               // Center(
          //               //   child: CircularProgressIndicator(), // Loader
          //               // ),
          //                       Container(
          //                         height: 500,
          //                         child:

          //                           ListView.builder(
          //                           scrollDirection: Axis.vertical,
          //                           itemCount: pantryDatas?.length,
          //                           itemBuilder: (context, index) {
          //                             // File imageFile = File(pantryDatas[index]['imageUrl']);
          //                             return Card(
          //                               elevation:5,
          //                               color: Colors.white,
          //                               margin: EdgeInsets.all(10),
          //                               child: ListTile(
          //                                 title: DefaultTextStyle(
          //                                   style: TextStyle(color: Colors.black),
          //                                   child: ListBody(children: [
          //                                     // Icon(
          //                                     //   Icons.food_bank,
          //                                     //   color: Colors.black,
          //                                     // ),
          //                                     Text(formatDate(pantryDatas![index]['createdTime'].toString()),
          //                                       // ignore: deprecated_member_use_from_same_package
          //                                       style: FlutterFlowTheme.of(context).bodyText1.override(
          //                                         fontFamily: 'Comfortaa',
          //                                         color: FlutterFlowTheme.of(context).secondaryText,
          //                                         letterSpacing: 0.0,
          //                                       )
          //                                     ),
          //                                     // Text(pantryDatas![index]['createdTime'])
          //                                   ],)
          //                                 ),
          //                                 subtitle: Text(pantryDatas![index]['displayName'],

          //                                 // ignore: deprecated_member_use_from_same_package
          //                                 style: FlutterFlowTheme.of(context).bodyText1.override(
          //                                         fontFamily: 'Comfortaa',
          //                                         color: FlutterFlowTheme.of(context).secondaryText,
          //                                         letterSpacing: 0.0,
          //                                       )),
          //                                 // ext(formatDate(pantryDatas![index]['createdTime'].toString())),

          //                                 onTap: () async {
          //                                   final navigator = Navigator.of(context);
          //                                   await navigator.push(
          // MaterialPageRoute(
          //     builder: (context) => ResultScreen(text: pantryDatas![index]['pantryData'] ?? '', imagePath: pantryDatas![index]['imageUrl'], isPantry: true,),
          // ),);
          //                                 },
          //                                 // subtitle: Text(pantryDatas[index]['quantity'].toString()),
          //                               ),
          //                             );
          //                           },
          //                         )
          //               ),

          //       ],
          //                 ),
          //               ),

          //         AuthUserStreamWidget(builder: (context) =>
          //         Padding(
          //           padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
          //           child:Container(
          //             child: Align(
          //               alignment:  Alignment(0.2, 0.6),
          //                child: FFButtonWidget(
          //             onPressed: () async {
          //             },
          //             text: 'Add Items',
          //             options: FFButtonOptions(
          //               width: double.infinity,
          //               height: 50.0,
          //               padding:
          //                   const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          //               iconPadding:
          //                   const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          //               color: FlutterFlowTheme.of(context).secondary,
          //               textStyle:
          //                   FlutterFlowTheme.of(context).titleSmall.override(
          //                         fontFamily: 'Comfortaa',
          //                         color: Colors.white,
          //                         letterSpacing: 0.0,
          //                       ),
          //               elevation: 2.0,
          //               borderRadius: BorderRadius.circular(12.0),
          //             ),
          //           ),
          //           ),
          //         ),
          //         ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          ),
    );
  }
}
