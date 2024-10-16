import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:keep_fresh/auth/firebase_auth/auth_util.dart';
import 'package:intl/intl.dart';
// import 'package:keep_fresh/camera_test/result_screen.dart';
import 'package:keep_fresh/index.dart';
import 'package:keep_fresh/pages/meals/new_pantry/pantry_item_details.dart';
import 'package:keep_fresh/backend/schema/food_items.dart';
import 'package:uuid/uuid.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:http/http.dart' as http;
import 'new_pantry_model.dart';
export 'new_pantry_model.dart';

class NewPantryWidget extends StatefulWidget {
  final Future<List<dynamic>>? pantryItems;
  const NewPantryWidget({Key? key, this.pantryItems}) : super(key: key);

  @override
  State<NewPantryWidget> createState() => _NewPantryWidgetState();
}

class _NewPantryWidgetState extends State<NewPantryWidget> with SingleTickerProviderStateMixin {
  late NewPantryModel _model;
  List<dynamic> pantryDatas = [];
  List<dynamic> pantryItems = [];
  List<dynamic> freezerItems = [];
  List<dynamic> fridgeItems = [];
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  DateTime? selectedExpiryDate;
  String? _categoryValue;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NewPantryModel());
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
    getPantryItems(true);
    logFirebaseEvent('screen_view', parameters: {'screen_name': 'NewPantry'});
  }

  @override
  void dispose() {
    _model.dispose();
    _dateController.dispose();
    _itemNameController.dispose();
    _typeController.dispose();
    _categoryController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> getPantryItems(bool isFirst) async {
     late List pantryData = [];
    if (isFirst) {
      pantryDatas = await widget.pantryItems ?? [];
    } else {
      var foodItems = await FoodItemsRecord.getAllRecordsWithUid(currentUserDocument!.uid);
      for(var item in foodItems){
        pantryData.add({
          'displayName': item.displayName,
          'pantryItem': item.pantryItem,
          'pantryItemDetails': item.pantryItemDetails,
          'pantryItemId': item.pantryItemId,
          'imageUrl': item.imageUrl,
          'geminiExpiryDate': item.geminiExpiryDate,
          'updatedExpiryDate': item.updatedExpiryDate?[0],
          'createdTime': item.createdTime,
        });
    }
    pantryDatas = pantryData;
      // pantryDatas = foodItems.map((item) => item.toMap()).toList(); // Changed to toMap() to fix the error
    }

    fridgeItems.clear();
    freezerItems.clear();
    pantryItems.clear();

    for (var item in pantryDatas) {
      try {
        var details = jsonDecode(item['pantryItemDetails']);
        if (details is List && details.isNotEmpty) {
          String category = details[0]['category']?.toLowerCase() ?? '';
          switch (category) {
            case 'fridge':
              fridgeItems.add(item);
              break;
            case 'freezer':
              freezerItems.add(item);
              break;
            case 'pantry':
              pantryItems.add(item);
              break;
            default:
              print("Unknown category for item: ${item['pantryItem']}");
          }
        }
      } catch (e) {
        print("Error processing item ${item['pantryItem']}: $e");
      }
    }
    setState(() {});
  }

  Future<String?> getImages(String itemName) async {
    var url = Uri.parse('https://api.pexels.com/v1/search?query=$itemName&per_page=1');
    var response = await http.get(url, headers: {
      'Authorization': 'UX8wpVU2YBEYfM4BV2qAJLXhySJ7m5gI6D6BGfhbmBnENT1DtpUVBhBl'
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print('url ${data['photos'][0]['src']['original'].toString()}');
      return data['photos'][0]['src']['original'].toString();
    } else {
      print('Failed to load images: ${response.statusCode}');
      return 'noImage';
    }
  }

  String formatDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    String day = DateFormat('d').format(date);
    String daySuffix = _getDaySuffix(int.parse(day));
    return DateFormat("d'$daySuffix' MMMM yyyy").format(date);
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1: return 'st';
      case 2: return 'nd';
      case 3: return 'rd';
      default: return 'th';
    }
  }

  void _showAddItemDialog() {
    _itemNameController.clear();
    _dateController.clear();
    _typeController.clear();
    _categoryController.clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Item',
            style: FlutterFlowTheme.of(context).titleMedium.override(
              fontFamily: 'Comfortaa',
              color: const Color(0xFF000000),
              letterSpacing: 0.0,
            ),
          ),
          backgroundColor: Colors.white,
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(_itemNameController, 'Item Name'),
                _buildTextField(_dateController, 'Expiry Date', readOnly: true, onTap: _selectDate),
                _buildTextField(_categoryController, 'Category', 
                  dropdownItems: ['fridge', 'freezer', 'pantry'],
                  onChanged: (newValue) {
                    setState(() {
                      _categoryValue = newValue;
                    });
                  },
                ),
                _buildTextField(_typeController, 'Type'),
                 FFButtonWidget(

                           text: 'Add Item',
                            
                              options: FFButtonOptions(
                              width: 100,
                              height: 50,
                              padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              color: Color.fromARGB(255, 38, 174, 97),
                              textStyle:
                                  FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: Colors.white,
                                        letterSpacing: 0,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(FlutterFlowTheme.of(context)
                                                .bodyMediumFamily),
                                      ),
                              elevation: 3,
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              ),
                              onPressed: () => _addItem(_categoryController.text)
                         ),
              ],
            ),
          ),
          
          // actions: [
          //   // TextButton(
          //   //   child: Text('Cancel'),
          //   //   onPressed: () => Navigator.of(context).pop(),
          //   // ),
          //   // TextButton(
          //   //   child: Text('Add'),
          //   //   onPressed: () => _addItem(_categoryController.text),
          //   // ),

          // ],
        );
      },
    );
  }

InputDecoration _getInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Color(0xFF26AE61), width: 2.0),
      ),
      labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
        fontFamily: 'Comfortaa',
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {
    bool readOnly = false,
    VoidCallback? onTap,
    List<String>? dropdownItems,
    Function(String?)? onChanged,
  }) {
    if (dropdownItems != null) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
                                                      filled: true,
                                                          // fillColor: Color(0xFFEDE8DF), // Light gray background for better visibility
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(8.0),
                                                            borderSide: BorderSide(
                                                              color: Colors.grey, // Border color
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                          enabledBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(8.0),
                                                            borderSide: BorderSide(
                                                              color: Colors.grey, // Border color when enabled
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(8.0),
                                                            borderSide: BorderSide(
                                                              color: Color.fromARGB(255, 38, 174, 97), // Border color when focused
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                      labelText: label,
                                                      labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                        fontFamily: 'Comfortaa',
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                      ),

                                                    ),
          value: controller.text.isEmpty ? null : controller.text,
          onChanged: (String? newValue) {
            controller.text = newValue ?? '';
            if (onChanged != null) {
              onChanged(newValue);
            }
          },
          items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value,
              style: FlutterFlowTheme.of(context).labelMedium.override(
                                                            fontFamily: 'Comfortaa',
                                                            color: Colors.black, // Set text color to black
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w500,
                                                          ),
              ),
            );
          }).toList(),
          dropdownColor: Color.fromARGB(255, 244, 243, 243),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: TextFormField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
                                                      filled: true,
                                                          // fillColor: Color(0xFFEDE8DF), // Light gray background for better visibility
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(8.0),
                                                            borderSide: BorderSide(
                                                              color: Colors.grey, // Border color
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                          enabledBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(8.0),
                                                            borderSide: BorderSide(
                                                              color: Colors.grey, // Border color when enabled
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(8.0),
                                                            borderSide: BorderSide(
                                                              color: Color.fromARGB(255, 38, 174, 97), // Border color when focused
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                      labelText: label,
                                                      labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                        fontFamily: 'Comfortaa',
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                      ),

                                                    ),
        ),
      );
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedExpiryDate = picked;
        _dateController.text = formatDate(picked.toString());
      });
    }
  }

  Future<void> _addItem(String category) async {
    if (_itemNameController.text.isNotEmpty && _dateController.text.isNotEmpty && _typeController.text.isNotEmpty) {
      var imageUrl = await getImages(_itemNameController.text);
      if (imageUrl != null) {
        final newItem = {
          "uid": currentUserDocument?.uid,
          "displayName": currentUserDocument?.displayName,
          "pantryItem": _itemNameController.text,
          "pantryItemId": const Uuid().v4(),
          "geminiExpiryDate": '',
          "imageUrl": imageUrl,
          "pantryItemDetails": jsonEncode([{
            "category": category.toLowerCase(),
            "type": _typeController.text,
          }]),
          "createdTime": DateTime.now(),
          "updatedExpiryDate": [selectedExpiryDate],
        };

        await FoodItemsRecord.collection.doc().set({
          "uid": currentUserDocument?.uid,
          "display_name": currentUserDocument?.displayName,
          "pantry_item": _itemNameController.text,
          "pantry_item_id": const Uuid().v4(),
          "gemini_expiry_date": '',
          "image_url": imageUrl,
          "pantry_item_details": jsonEncode([{
            "category": category.toLowerCase(),
            "type": _typeController.text,
          }]),
          "created_time": DateTime.now(),
          "updated_expiry_date": [selectedExpiryDate],
        }).then((value) => 
        print("data added to database succcesfully..!!!"));
                // Update the local state
        setState(() {
          switch (category.toLowerCase()) {
            case 'pantry':
              pantryItems.add(newItem);
              break;
            case 'fridge':
              fridgeItems.add(newItem);
              break;
            case 'freezer':
              freezerItems.add(newItem);
              break;
          }
        });

        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to retrieve image. Please try again.'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildItemGrid(List<dynamic> items) {
    return items.isEmpty
      ? Center(child: Text('No items', style: TextStyle(color: Colors.white)))
      : FutureBuilder<List<dynamic>>(
          future: Future.value(items), // Convert the list to a Future
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No items', style: TextStyle(color: Colors.white)));
            } else {
              return GridView.builder(
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) => _buildItemCard(snapshot.data![index]),
              );
            }
          },
        );
  }

  Widget _buildItemCard(dynamic item) {
    return Card(
      elevation: 3,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => {
        print('item, $item'),
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PantryItemDetails(itemDetails: item)),
        )
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: item['imageUrl'] != null
                    ? Image.network(item['imageUrl'], fit: BoxFit.cover)
                    : Image.asset('assets/images/pantryItem.png', fit: BoxFit.cover)
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                item['pantryItem'],
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Color(0xFFEDE8DF),
        body: SafeArea(
          child: AuthUserStreamWidget(
            builder: (context) => currentUserDocument != null
              ? _buildMainContent()
              : _buildUnregisteredUserScreen(),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        AppBar(
          title: Text('Pantry Shelf',
           style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  fontFamily: 'Comfortaa',
                                  letterSpacing: 0,
                                  color: const Color(0xFF000000),
                                  useGoogleFonts: GoogleFonts.asMap()
                                                  .containsKey('Comfortaa'), 
                                                  )
           ),
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xFFEDE8DF), // Set a common background color for all sections
          actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            color: Colors.black,
            onPressed: () => _showAddItemDialog(),
          ),
          FlutterFlowIconButton(
            borderRadius: 20,
            buttonSize: 40,
            icon: Icon(Icons.home_outlined,
            color: Colors.black,
            ),
            onPressed: () => context.pushReplacement('/dashboard'),
          ),
        ],
        ),
        TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondary, // Changed background color for the indicator to a clean light color
            borderRadius: BorderRadius.circular(8),
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey, // Changed unselected label color
          labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
            fontFamily: 'Comfortaa',
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
            fontFamily: 'Comfortaa',
            color: Colors.grey, // Ensured unselected label has a consistent color
          ),
          tabs: [
            Tab(text: 'Pantry'),
            Tab(text: 'Fridge'),
            Tab(text: 'Freezer'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildCategoryView('Pantry', Color.fromARGB(255, 38, 174, 97), pantryItems),
              _buildCategoryView('Fridge', Color.fromARGB(255, 86, 117, 160), fridgeItems),
              _buildCategoryView('Freezer', Color.fromARGB(255, 130, 222, 238), freezerItems),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryView(String title, Color color, List<dynamic> items) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: color,
      //   title: Text(title),
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.add_circle_outline),
      //       onPressed: () => _showAddItemDialog(title),
      //     ),
      //     FlutterFlowIconButton(
      //       borderRadius: 20,
      //       buttonSize: 40,
      //       icon: Icon(Icons.home_outlined),
      //       onPressed: () => context.pushReplacement('/dashboard'),
      //     ),
      //   ],
      // ),
      backgroundColor: color,
      body: _buildItemGrid(items),
    );
  }

  Widget _buildUnregisteredUserScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to PantryPlus'),
        backgroundColor: Color.fromARGB(255, 38, 174, 97),
      ),
      body: Container(
        color: Color(0xFFEDE8DF),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_circle, size: 100, color: Color.fromARGB(255, 38, 174, 97)),
                Text('Create Account', style: FlutterFlowTheme.of(context).displaySmall),
                SizedBox(height: 20),
                Text('Join us to manage your pantry items effectively.', textAlign: TextAlign.center),
                SizedBox(height: 30),
                FFButtonWidget(
                  text: 'Create Account',
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => OnboardingCreateAccountWidget())),
                  options: FFButtonOptions(
                    width: 200.0,
                    height: 60.0,
                    color: Color.fromARGB(255, 38, 174, 97),
                    textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                      fontFamily: 'Inter',
                      color: Colors.white,
                    ),
                    elevation: 2.0,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                SizedBox(height: 40),
                Text('You can still access camera features. Try exploring!', textAlign: TextAlign.center),
                SizedBox(height: 40),
                FFButtonWidget(
                  text: 'Explore Camera Features',
                  onPressed: () => context.pushReplacement('/dashboard'),
                  options: FFButtonOptions(
                    width: 200.0,
                    height: 60.0,
                    color: Color.fromARGB(255, 38, 174, 97),
                    textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                      fontFamily: 'Inter',
                      color: Colors.white,
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
    );
  }
  TextStyle _getDropdownTextStyle() {
    return FlutterFlowTheme.of(context).labelMedium.override(
      fontFamily: 'Comfortaa',
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );
  }

  // Color _getSelectedColor() {
  //   print('inside select color ');
  //   switch (_tabController.index) {
  //     case 0:
  //       return Color.fromARGB(255, 38, 174, 97); // Pantry color
  //     case 1:
  //       return Color.fromARGB(255, 86, 117, 160); // Fridge color
  //     case 2:
  //       return Color.fromARGB(255, 130, 222, 238); // Freezer color
  //     default:
  //       return Color.fromARGB(255, 38, 174, 97); // Default to Pantry color
  //   }
  // }
}