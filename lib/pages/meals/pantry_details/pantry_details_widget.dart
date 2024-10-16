import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_icon_button.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_theme.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_util.dart';
import 'package:keep_fresh/pages/meals/new_pantry/new_pantry_widget.dart';

class PantryDetailsWidget extends StatefulWidget {
   final String? data;
   final DateTime? createdTime;
 const PantryDetailsWidget({super.key, this.data, this.createdTime});

 String formatDate(dateStr) {
    DateTime date;
    if(dateStr.runtimeType == DateTime){
       date = dateStr;
    }else{
      if(dateStr == []){
        return '';
      }else{
        date = dateStr[0];
      };
    }
    // }
    
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
  // ignore: library_private_types_in_public_api
  _PantryDetailsWidgetState createState() => _PantryDetailsWidgetState();
}


class _PantryDetailsWidgetState extends State<PantryDetailsWidget> {
var pantryItems;
  @override
  void initState() {
    pantryItems = jsonDecode(widget.data!);
    super.initState();
  }

   @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        backgroundColor: Color(0xFFEDE8DF),
        appBar: AppBar(
          title: Text('Pantry Shelf',
          style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  fontFamily: 'Comfortaa',
                                  letterSpacing: 0,
                                  color: const Color(0xFF000000),
                                  useGoogleFonts: GoogleFonts.asMap()
                                                  .containsKey('Comfortaa'),   
                                )),
          backgroundColor: Color(0xFFEDE8DF),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
            color: Color(0xFF000000),),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
         body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ShelfDesign(items: pantryItems, date: widget.createdTime),
      ),
      ),
    );
  }
}


class ShelfDesign extends StatelessWidget {
  final List<dynamic> items;
  final DateTime ? date;

  const ShelfDesign({required this.items, this.date});

  @override
  Widget build(BuildContext context) {
    // Group items by type
    final groupedItems = {};
    for (var item in items) {
      final type = item['type']!;
      if (!groupedItems.containsKey(type)) {
        groupedItems[type!] = [];
      }
      groupedItems[type]!.add(item);
    }

  // String formatDate(dateStr) {
  //   DateTime date;
  //   if(dateStr.runtimeType != DateTime){
  //    date = DateTime.parse(dateStr);
  //   }else{
  //      date = dateStr;
  //   }
    
  //   // Extract the day and add the ordinal suffix
  //   String day = date.day.toString();
  //   String daySuffix;
  //   if (day.endsWith('1') && !day.endsWith('11')) {
  //     daySuffix = 'st';
  //   } else if (day.endsWith('2') && !day.endsWith('12')) {
  //     daySuffix = 'nd';
  //   } else if (day.endsWith('3') && !day.endsWith('13')) {
  //     daySuffix = 'rd';
  //   } else {
  //     daySuffix = 'th';
  //   }

  //   // Format the date
  //   String formattedDate = DateFormat('d MMMM yyyy').format(date);

  //   // Insert the day suffix
  //   return formattedDate.replaceFirst(day, day + daySuffix);
  // }

    return Scaffold(
      appBar: AppBar(
        title: Text('${PantryDetailsWidget().formatDate(this.date)}',
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
        backgroundColor: Color(0xFFEDE8DF),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: FlutterFlowTheme.of(context).secondary,
      body: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: groupedItems.entries.map((entry) {
            return Shelf(
              type: entry.key,
              items: entry.value,
              date: this.date,
            );
          }).toList(),
        ),
        ),
      ),
    );
  }
}

class Shelf extends StatelessWidget {
  final String type;
  final List<dynamic> items;
  final date;

  Shelf({required this.type, required this.items, this.date});
  

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
        padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
        child: Text(
          type[0].toUpperCase() + type.substring(1),
          style: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .override(
                                          fontFamily: 'Comfortaa',
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold
                                        ),
        ),
        ),
        ..._buildRacks(),
      ],
    );
  }

  List<dynamic> _buildRacks() {
    List<dynamic> racks = [];
    const int itemsPerRack = 3; // Number of items per rack

    for (int i = 0; i < items.length; i += itemsPerRack) {
      List<dynamic> rackItems = items.skip(i).take(itemsPerRack).toList();
      racks.add(
        Rack(items: rackItems, date: this.date),
      );
    }

    return racks;
  }
}

  void showFoodItemDetails(BuildContext context,item, date) {
  List<DateTime> calculateDateRange(DateTime createdAt, String input) {
    print("expiryDate: $input");
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

   var  itemVal = calculateDateRange( date ,'${item['expiry_date']}');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title:
    Text('Pantry Item',
          style: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .override(
                                          fontFamily: 'Comfortaa',
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF000000),
                                        ),),
          backgroundColor: Colors.white,
          children: <Widget>[
             Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child:
                  Text("${item['name']}",
                  style: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .override(
                                          fontFamily: 'Comfortaa',
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF000000),
                                        ),
                  ),
                  ),
                  Text("[${item['type']}]",
                  style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Comfortaa',
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF000000),
                                        ),
                  ),
                  SizedBox(height: 20),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text("Use by: ${ itemVal.length == 0 ? item['expiry_date'] : PantryDetailsWidget().formatDate(itemVal[0]) }",
                  style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Comfortaa',
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF000000),
                                        ),),
                  Text("${item['calories']}\nkcal",
                  style: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .override(
                                          fontFamily: 'Comfortaa',
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF000000),
                                        ),),
                  ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );  
  }


class Rack extends StatelessWidget {
  final List<dynamic> items;
  final date;

  Rack({required this.items, this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 207, 250, 219),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items.map((item) => Expanded(child: ItemCard(item: item, date: this.date))).toList()
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final item;
  final date;

  ItemCard({required this.item, this.date});

  @override
  Widget build(BuildContext context) {
    return 
    GestureDetector(
      onTap: () {
        showFoodItemDetails(context, item , this.date);
      },
    child: Card(
      // margin: const EdgeInsets.all(4.0),
      elevation: 4.0,
      color: Color.fromARGB(255, 207, 250, 219),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(color: Colors.green, width: 4.0),
          ),
          borderRadius:  BorderRadius.only(
            topLeft: Radius.circular(8.0),
            bottomRight: Radius.circular(8.0),
          )
        //    borderRadius: BorderRadius(
        //   topLeft: Radius.circular(8.0),
        //   bottomRight: Radius.circular(8.0),

        // )
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item['name']!,
              style:FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: 'Comfortaa',
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF101518)
                                    ),
            ),
            SizedBox(height: 4),
            // Text(
            //   'Expiry: ${item['expiry_date']}',
            //   style: FlutterFlowTheme.of(context)
            //                     .bodyLarge
            //                     .override(
            //                       fontFamily: 'Comfortaa',
            //                       letterSpacing: 0,
            //                       color: const Color(0xFF000000),
            //                       useGoogleFonts: GoogleFonts.asMap()
            //                                       .containsKey('Comfortaa'),   
            //                     ),
            // ),
          ],
        ),
      ),
    )
    );
  }
}