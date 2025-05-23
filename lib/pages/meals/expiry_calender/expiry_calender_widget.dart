import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_fresh/auth/firebase_auth/auth_util.dart';
import 'package:keep_fresh/backend/schema/food_items.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:intl/intl.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_util.dart';
import 'package:keep_fresh/index.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpiryCalendarWidget extends StatefulWidget {
  const ExpiryCalendarWidget({
    Key? key,
    this.isPreview = false,
  }) : super(key: key);

  final bool isPreview;

  @override
  _ExpiryCalendarWidgetState createState() => _ExpiryCalendarWidgetState();
}

class _ExpiryCalendarWidgetState extends State<ExpiryCalendarWidget> {
  DateTime _currentDate = DateTime.now();
  var pantryItemsExpiring = [];
  var _selectedExpiryDates = [];
  Map<DateTime, List<Event>> _markedDateMap = {};

  // Add this map to track checkbox states
  Map<String, bool> _checkedItems = {};

  // Add this method to get the start of the current week
  DateTime _getStartOfWeek() {
    DateTime now = DateTime.now();
    return now.subtract(Duration(days: now.weekday - 1));
  }

  // Add this method to fetch and check grocery list items
  Future<void> checkGroceryListItems() async {
    try {
      final groceryListQuery = await FirebaseFirestore.instance
          .collection('grocery_list')
          .where('uid', isEqualTo: currentUserDocument!.uid)
          .limit(1)
          .get();

      if (groceryListQuery.docs.isNotEmpty) {
        final existingDoc = groceryListQuery.docs.first;
        List<dynamic> existingList = List.from(existingDoc.data()['grocery_list'] ?? []);
        
        setState(() {
          // Update checkbox states based on grocery list
          for (var item in existingList) {
            _checkedItems[item['pantryItemId']] = true;
          }
        });
      }
    } catch (e) {
      print('Error checking grocery list items: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.isPreview) {
      _currentDate = _getStartOfWeek();
    }
    getPantryItems();
    checkGroceryListItems();
  }

  getPantryItems() async {
    var pantryData = [];
    var pantryItems = await FoodItemsRecord.getAllRecordsWithUid(currentUserDocument!.uid);
    for(var food in pantryItems) {
      pantryData.add({
        'item': '${food.pantryItem}',
        'updatedExpiry': food.updatedExpiryDate,
        'id': '${food.pantryItemId}', 
        'itemDetails': '${food.pantryItemDetails}'
      });
    }
    pantryItemsExpiring = pantryData;
    setState(() {
      for (var item in pantryItemsExpiring) {
        DateTime originalDate = DateTime.parse('${item['updatedExpiry'][0]}');
        DateTime formattedDate = DateTime(originalDate.year, originalDate.month, originalDate.day);
        var updatedDesc = jsonEncode({
          "item": "${item['item']}",
          "itemId": "${item['id']}",
          "updatedExpiryDate": "${item['updatedExpiry'][0]}",
          "description": "${item['itemDetails']}"
        });
        
        final event = Event(
          date: formattedDate,
          title: item['item'],
          description: updatedDesc,
        );

        if (_markedDateMap.containsKey(formattedDate)) {
          _markedDateMap[formattedDate]!.add(event);
        } else {
          _markedDateMap[formattedDate] = [event];
        }
      }
    });
  }

  void pushSelected(data) {
    var actualData = jsonDecode(data);
    var finalDescription = jsonDecode(actualData['description']);
    setState(() {
      // Check if the item is already in the list
      bool itemExists = _selectedExpiryDates.any((item) => item['itemId'] == actualData['itemId']);
      
      if (!itemExists) {
        _selectedExpiryDates.add({
          'item': actualData['item'],
          'itemId': actualData['itemId'],
          'updatedExpiryDate': DateTime.parse(actualData['updatedExpiryDate']), 
          "description": finalDescription
        });
      }
    });
  }

  void groceryList (){
    
  }

  // Add this method to update the grocery list
  Future<void> updateGroceryList(List<Map<String, dynamic>> selectedItems) async {
    try {
      final groceryListQuery = await FirebaseFirestore.instance
          .collection('grocery_list')
          .where('uid', isEqualTo: currentUserDocument!.uid)
          .limit(1)
          .get();

      if (groceryListQuery.docs.isEmpty) {
        // If no grocery list exists, create a new one
        await FirebaseFirestore.instance.collection('grocery_list').add({
          'uid': currentUserDocument!.uid,
          'grocery_list_id': Uuid().v4(), // Create a random UUID here
          'grocery_list': selectedItems,
          'created_at': DateTime.now(),
          'updated_at': DateTime.now(),
        });
        print('inside new condition');
      } else {
        // If grocery list exists, update it
        final existingDoc = groceryListQuery.docs.first;
        List<dynamic> existingList = List.from(existingDoc.data()['grocery_list'] ?? []);

        // Only add items that don't already exist in the list
        for (var newItem in selectedItems) {
          if (!existingList.any((item) => item['pantryItemId'] == newItem['pantryItemId'])) {
            existingList.add(newItem);
          }
        }

        await existingDoc.reference.update({
          'grocery_list': existingList,
          'updated_at': DateTime.now(),
        });
      }
    } catch (e) {
      print('Error updating grocery list: $e');
      throw e;
    }
  }

  // Add this method to remove items from the grocery list
  Future<void> removeFromGroceryList(String pantryItemId) async {
    try {
      final groceryListQuery = await FirebaseFirestore.instance
          .collection('grocery_list')
          .where('uid', isEqualTo: currentUserDocument!.uid)
          .limit(1)
          .get();

      if (groceryListQuery.docs.isNotEmpty) {
        final existingDoc = groceryListQuery.docs.first;
        List<dynamic> existingList = List.from(existingDoc.data()['grocery_list'] ?? []);

        // Remove the item with matching pantryItemId
        existingList.removeWhere((item) => item['pantryItemId'] == pantryItemId);

        await existingDoc.reference.update({
          'grocery_list': existingList,
          'updated_at': DateTime.now(),
        });
      }
    } catch (e) {
      print('Error removing from grocery list: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isPreview) {
      return Container(
        height: 370.0,
        child: CalendarCarousel<Event>(
          onDayPressed: (date, events) {
            setState(() => _currentDate = date);
            events.forEach((event) {
              pushSelected(event.description);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExpiryCalendarWidget(
                    isPreview: false,
                  ),
                ),
              );
            });
          },
          weekendTextStyle: TextStyle(color: Colors.black),
          thisMonthDayBorderColor: Colors.grey,
          weekFormat: false,
          height: 370.0,
          selectedDateTime: _currentDate,
          targetDateTime: _currentDate,
          markedDatesMap: EventList<Event>(events: _markedDateMap),
          showIconBehindDayText: true,
          markedDateShowIcon: true,
          markedDateIconMaxShown: 2,
          selectedDayTextStyle: TextStyle(color: Colors.white),
          todayTextStyle: TextStyle(color: Colors.blue),
          markedDateIconBuilder: (event) {
            if (event.description != null) {
              try {
                var eventDescriptionJson = jsonDecode(event.description!);
                var descriptionData = jsonDecode(eventDescriptionJson['description']);
                if (descriptionData.isNotEmpty && descriptionData[0] != null) {
                  var category = descriptionData[0]['category'] as String?;
                  Color markerColor;
                  switch (category) {
                    case 'pantry':
                      markerColor = Color.fromARGB(255, 38, 174, 97);
                      break;
                    case 'fridge':
                      markerColor = Color.fromARGB(255, 86, 117, 160);
                      break;
                    case 'freezer':
                      markerColor = Color.fromARGB(255, 130, 222, 238);
                      break;
                    default:
                      markerColor = Colors.grey;
                  }
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: EdgeInsets.symmetric(horizontal: 0.3),
                    decoration: BoxDecoration(
                      color: markerColor,
                      shape: BoxShape.circle,
                    ),
                  );
                }
              } catch (e) {
                print('Error parsing event data: $e');
              }
            }
            return SizedBox.shrink();
          },
          todayButtonColor: Colors.transparent,
          todayBorderColor: Colors.green,
          markedDateMoreShowTotal: true,
          firstDayOfWeek: 1,
          headerTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          daysTextStyle: TextStyle(color: Colors.black),
        ),
      );
    }
    
    return Scaffold(
      backgroundColor: Color.fromRGBO(215, 215, 215, 1), // RGB color for a light gray background

      appBar: AppBar(
        elevation: 0, // Remove the shadow below the app bar
        backgroundColor: Color.fromRGBO(215, 215, 215, 1), // Changed to RGB format
        leading: IconButton(
          icon: Icon(
            Icons.arrow_circle_left,
            color: Colors.black,
            size: 40,
          ),
          onPressed: () {
            context.pushReplacement('/dashboard');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.black, size: 30),
            onPressed: () {},
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  'Calendar',
                  style: FlutterFlowTheme.of(context)
                      .headlineMedium
                      .override(
                        fontFamily: 'Comfortaa',
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0,
                        color: Colors.black,
                        useGoogleFonts: GoogleFonts.asMap().containsKey('Comfortaa'),
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: CalendarCarousel<Event>(
                  onDayPressed: (date, events) {
                    setState(() => _currentDate = date);
                    events.forEach((event) {
                      pushSelected(event.description);
                    });
                  },
                  weekendTextStyle: TextStyle(color: Colors.black),
                  thisMonthDayBorderColor: Colors.grey,
                  weekFormat: false,
                  height: 370.0,
                  selectedDateTime: _currentDate,
                  targetDateTime: _currentDate,
                  markedDatesMap: EventList<Event>(events: _markedDateMap),
                  showIconBehindDayText: true,
                  markedDateShowIcon: true,
                  markedDateIconMaxShown: 2,
                  selectedDayTextStyle: TextStyle(color: Colors.white),
                  todayTextStyle: TextStyle(color: Colors.blue),
                  markedDateIconBuilder: (event) {
                    if (event.description != null) {
                      try {
                        var eventDescriptionJson = jsonDecode(event.description!);
                        var descriptionData = jsonDecode(eventDescriptionJson['description']);
                        if (descriptionData.isNotEmpty && descriptionData[0] != null) {
                          var category = descriptionData[0]['category'] as String?;
                          Color markerColor;
                          switch (category) {
                            case 'pantry':
                              markerColor = Color.fromARGB(255, 38, 174, 97);
                              break;
                            case 'fridge':
                              markerColor = Color.fromARGB(255, 86, 117, 160);
                              break;
                            case 'freezer':
                              markerColor = Color.fromARGB(255, 130, 222, 238);
                              break;
                            default:
                              markerColor = Colors.grey;
                          }
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: EdgeInsets.symmetric(horizontal: 0.3),
                            decoration: BoxDecoration(
                              color: markerColor,
                              shape: BoxShape.circle,
                            ),
                          );
                        }
                      } catch (e) {
                        print('Error parsing event data: $e');
                      }
                    }
                    return SizedBox.shrink();
                  },
                  todayButtonColor: Colors.transparent,
                  todayBorderColor: Colors.green,
                  markedDateMoreShowTotal: true,
                  firstDayOfWeek: 1,
                  headerTextStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  daysTextStyle: TextStyle(color: Colors.black),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10), // Added borderRadius here
                ),
                child: _selectedExpiryDates.isEmpty
                    ? Center(
                        child: Text(
                          'Select marked dates to see items expiring.',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Items Expiring',
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: 'Comfortaa',
                                      letterSpacing: 0,
                                      color: const Color(0xFF000000),
                                      useGoogleFonts: GoogleFonts.asMap().containsKey('Comfortaa'),
                                    ),
                              ),
                              Text(
                                'ReSupply',
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: 'Comfortaa',
                                      letterSpacing: 0,
                                      color: const Color(0xFF000000),
                                      useGoogleFonts: GoogleFonts.asMap().containsKey('Comfortaa'),
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Flexible(
                            child: ListView.builder(
                              shrinkWrap: true, // This can be removed if the ListView is inside a Flexible or Expanded widget
                              itemCount: _selectedExpiryDates.length,
                              itemBuilder: (context, index) {
                                final item = _selectedExpiryDates[index];
                                final itemId = item['itemId'];
                                
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['item'],
                                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Expires on: ${DateFormat('d MMMM y').format(item['updatedExpiryDate'])}',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Theme(
                                          data: Theme.of(context).copyWith(
                                            checkboxTheme: CheckboxThemeData(
                                              side: BorderSide(color: Colors.black, width: 1.5),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                            ),
                                          ),
                                          child: Checkbox(
                                            value: _checkedItems[itemId] ?? false,
                                            activeColor: Colors.green,
                                            onChanged: (bool? value) {
                                              // print('checkedItems ${_checkedItems}');
                                              ScaffoldMessenger.of(context).clearSnackBars();
                                              
                                              setState(() {
                                                _checkedItems[itemId] = value ?? false;
                                              });
                                              
                                              if (value ?? false) {
                                                // If checked, add to grocery list
                                                updateGroceryList([{
                                                  'pantryItemId': item['itemId'],
                                                  'item': item['item'],
                                                }]);
                                              } else {
                                                // If unchecked, remove from grocery list
                                                removeFromGroceryList(item['itemId']);
                                              }
                                              
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    value ?? false
                                                        ? '${item['item']} added to grocery list'
                                                        : '${item['item']} removed from grocery list',
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                  backgroundColor: value ?? false ? Colors.green : Colors.red,
                                                  duration: Duration(milliseconds: 1500),
                                                  behavior: SnackBarBehavior.floating,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

