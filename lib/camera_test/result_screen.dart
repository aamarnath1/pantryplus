import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_fresh/auth/firebase_auth/auth_util.dart';
import 'package:keep_fresh/backend/backend.dart';
import 'package:keep_fresh/backend/schema/food_items.dart';
import 'package:keep_fresh/backend/schema/pantry_data.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_theme.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_util.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_widgets.dart';
import 'package:keep_fresh/pages/meals/new_pantry/new_pantry_widget.dart';

class ResultScreen extends StatefulWidget {
  final String text;
  final String imagePath;
  final bool isPantry;
  const ResultScreen({
    Key? key,
    this.text = '',
    this.imagePath = '',
    this.isPantry = false,
    this.productData = const {},
  }) : super(key: key);
  final Map<String, Object?> productData;
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late Future<List<dynamic>> pantryItems;
  @override
  void initState() {
    super.initState();
  }

  Future<List> getPantryDetails() async {
    late List pantryData = [];
    try {
      var foodItems = await FoodItemsRecord.getAllRecordsWithUid(currentUserDocument!.uid);

      for(var item in foodItems){
        pantryData.add({
          'displayName': item.displayName,
          'pantryItem': item.pantryItem,
          'pantryItemDetails': item.pantryItemDetails,
          'pantryItemId': item.pantryItemId,
          'geminiExpiryDate': item.geminiExpiryDate,
          'updatedExpiryDate': item.updatedExpiryDate,
          'createdTime': item.createdTime,
        });
      }
      
      // for(var item in foodItems){
      //       pantryData.add(item);
      //       }      // var pantryAllrecords =
      //     await PantryRecord.getAllRecordsWithUid(currentUserDocument!.uid);
      //     pantryAllrecords.sort((a, b) => b.createdTime!.compareTo(a.createdTime!));
      // for (var pantryRecord in pantryAllrecords) {
      //   // print('pantryRecord $pantryRecord');
      //   pantryData.add({
      //     'displayName': pantryRecord.displayName,
      //     'imageUrl': pantryRecord.imageUrl,
      //     'pantryData': pantryRecord.pantryData,
      //     'uid': pantryRecord.uid,
      //     'createdTime': pantryRecord.createdTime,
      //   });
      // }
      // ;
      return pantryData;
    } catch (e) {
      print('Error $e');
    }
    return []; // Add a return statement to ensure a value is always returned.
  }


  moveToPantry(){
    pantryItems = getPantryDetails();
    Navigator.push(context, 
    MaterialPageRoute(
      builder: (context) => NewPantryWidget(pantryItems: pantryItems),
      settings: RouteSettings(
        arguments: pantryItems
      )
    ));
  }

  List<DateTime> calculateDateRange(DateTime createdAt, String input) {
    print('input, $input createdAt, $createdAt');
  RegExp regExp = RegExp(r'(\d+)(?:-(\d+))?\s*(day|week|month|days|weeks|months)', caseSensitive: false);
  // RegExp regExp = RegExp(r'(\d+)-(\d+)\s*(days|weeks|months)');
  Match? match = regExp.firstMatch(input);

  if (match != null) {
    int startValue = int.parse(match.group(1)!);
    int endValue = match.group(2) != null ? int.parse(match.group(2)!) : startValue;
    // int endValue = int.parse(match.group(2)!);
    String unit = match.group(3)!;

    DateTime startDate;
    DateTime endDate;

    switch (unit) {
      case 'day':
      case 'days':
        startDate = createdAt.add(Duration(days: startValue));
        endDate = createdAt.add(Duration(days: endValue));
        break;
      case 'week':
      case 'weeks':
        startDate = createdAt.add(Duration(days: startValue * 7));
        endDate = createdAt.add(Duration(days: endValue * 7));
        break;
      case 'month':
      case 'months':
        startDate = DateTime(createdAt.year, createdAt.month + startValue, createdAt.day);
        endDate = DateTime(createdAt.year, createdAt.month + endValue, createdAt.day);
        break;
      default:
        return [];
    }
    return [endDate];
  }
  return [];
}

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Color(0xFFEDE8DF),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: const Color(0xFF000000), //change your color here
          ),
          title: Text(
            'Result',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Comfortaa',
                  letterSpacing: 0,
                  color: const Color(0xFF000000),
                  useGoogleFonts: GoogleFonts.asMap().containsKey('Comfortaa'),
                ),
          ),
          backgroundColor: Color(0xFFEDE8DF),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          // child:Text(text, style: const TextStyle(fontSize: 24.0))
          child: Column(
            children: [
              if (widget.text.isNotEmpty && widget.productData.isEmpty)
                      Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(File(widget.imagePath)),
                          ),
                        ),
                      ),
              if (widget.text.isNotEmpty && widget.productData.isEmpty)
                    Container(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: 
                      Table(
                        border: TableBorder.all(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0)),
                              color: FlutterFlowTheme.of(context).secondary,
                            ),
                            children: [
                              TableCell(
                                verticalAlignment: TableCellVerticalAlignment.middle,
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  child: Text(
                                    'Name',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                          fontFamily: 'Comfortaa',
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0,
                                          color: Color.fromARGB(255, 255, 255, 255),
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey('Comfortaa'),
                                        ),
                                  ),
                                ),
                              ),
                              TableCell(
                                verticalAlignment: TableCellVerticalAlignment.middle,
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  child: Text(
                                    'Type',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                          fontFamily: 'Comfortaa',
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0,
                                          color: Color.fromARGB(255, 255, 255, 255),
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey('Comfortaa'),
                                        ),
                                  ),
                                ),
                              ),
                              TableCell(
                                verticalAlignment: TableCellVerticalAlignment.middle,
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  child: Text(
                                    'Calories',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                          fontFamily: 'Comfortaa',
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0,
                                          color: Color.fromARGB(255, 255, 255, 255),
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey('Comfortaa'),
                                        ),
                                  ),
                                ),
                              ),
                              TableCell(
                                verticalAlignment: TableCellVerticalAlignment.middle,
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  child: Text(
                                    'Expiry Date',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                          fontFamily: 'Comfortaa',
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0,
                                          color: Color.fromARGB(255, 255, 255, 255),
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey('Comfortaa'),
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          for (var i = 0; i < jsonDecode(widget.text).length; i++)
                            TableRow(
                              children: [
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      jsonDecode(widget.text)[i]['name'].toString(),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                              fontFamily: 'Comfortaa',
                                              letterSpacing: 0.0,
                                              color: const Color(0xFF101518)),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      jsonDecode(widget.text)[i]['type'].toString(),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                              fontFamily: 'Comfortaa',
                                              letterSpacing: 0.0,
                                              color: const Color(0xFF101518)),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      jsonDecode(widget.text)[i]['calories']
                                          .toString(),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                              fontFamily: 'Comfortaa',
                                              letterSpacing: 0.0,
                                              color: const Color(0xFF101518)),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      jsonDecode(widget.text)[i]['expiry_date']
                                          .toString(),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                              fontFamily: 'Comfortaa',
                                              letterSpacing: 0.0,
                                              color: const Color(0xFF101518)),
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                    if (!widget.isPantry && widget.productData.isEmpty)
                      AuthUserStreamWidget(
                        builder: (context) => FFButtonWidget(
                            onPressed: () async {
                              final navigator = Navigator.of(context);
                              if (currentUserDocument != null) {
                                var totalFoodItems = jsonDecode(widget.text);
                              for( var item in totalFoodItems){
                               try{
                                var actual_expiry_date = calculateDateRange(DateTime.now(), item['expiry_date']);
                                print('actual_expiry_date, $actual_expiry_date');
                                var batch = FirebaseFirestore.instance.batch();
                                var foodRef = FoodItemsRecord.collection.doc(); // Create a new document reference
                                batch.set(foodRef, {
                                  ...createFoodItemsRecordData(
                                    uid: currentUserDocument?.uid,
                                    displayName: currentUserDocument?.displayName,
                                    pantryItem: item['name'],
                                    pantryItemId: const Uuid().v4(),
                                    geminiExpiryDate: item['expiry_date'],
                                    pantryItemDetails: jsonEncode([item]),
                                    updatedExpiryDate: actual_expiry_date,
                                    createdTime: DateTime.now(),
                                  )
                                });
                                await batch.commit();   // moveToPantry();
                                }catch(e){
                                  print('error adding food item to pantry, $e');
                                }
                              }
                              moveToPantry();
                              } else {
                                context.pushNamed('Onboarding_CreateAccount');
                              }
                            },
                            text: 'Save to Pantry',
                            options: FFButtonOptions(
                              width: 332,
                              height: 50,
                              padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              color: FlutterFlowTheme.of(context).secondary,
                              textStyle:
                                  FlutterFlowTheme.of(context).displaySmall.override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .displaySmallFamily,
                                        color: Color.fromARGB(255, 235, 229, 217),
                                        letterSpacing: 0,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(FlutterFlowTheme.of(context)
                                                .displaySmallFamily),
                                      ),
                              elevation: 3,
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            )),
                      ), 
              if (widget.productData.isNotEmpty)
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: Image.network('${widget.productData['imageUrl']}')
                          .image,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.productData['productName'] != null)
                      _buildInfoRow('Product Name', '${widget.productData['productName']}'),
                    if (widget.productData['brand'] != null)
                      _buildInfoRow('Brand', '${widget.productData['brand']}'),
                    if (widget.productData['nutriments'] != null)
                      _buildInfoRow('Nutriments', '${widget.productData['nutriments']}'),
                    if (widget.productData['additives'] != null)
                      _buildInfoRow(
                          'Additives', '${widget.productData['additives']}'),
                    if (widget.productData['ingredients'] != null)
                      _buildInfoRow('Ingredients', '${widget.productData['ingredients']}'),
                    if (widget.productData['countries'] != null)
                      _buildInfoRow('Countries', '${widget.productData['countries']}'),
                    if (widget.productData['nutriScore'] != null)
                      _buildInfoRow('NutriScore', '${widget.productData['nutriScore']}')
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildInfoRow(String label, String value) {
    return Card(
      elevation: 2,
      color:Color.fromARGB(255, 255, 255, 255),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$label : ',
              style: FlutterFlowTheme.of(context).bodyLarge.override(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Comfortaa',
                    letterSpacing: 0,
                    color: const Color(0xFF000000),
                    useGoogleFonts:
                        GoogleFonts.asMap().containsKey('Comfortaa'),
                  ),
            ),
            Expanded(
              child: Text(
                value,
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: 'Comfortaa',
                      letterSpacing: 0,
                      color: const Color(0xFF000000),
                      useGoogleFonts:
                          GoogleFonts.asMap().containsKey('Comfortaa'),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}