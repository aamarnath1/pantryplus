import 'package:flutter/material.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_theme.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_util.dart';

class PantryItemDetails extends StatelessWidget {
  final Map<String, Object?> itemDetails;

  const PantryItemDetails({
    Key? key,
    required this.itemDetails,
  }) : super(key: key);

 String formatDate(dateStr) {
    DateTime date;
    if(dateStr.runtimeType == DateTime){
       date = dateStr;
    }else{
      if(dateStr.length == 0){
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
  Widget build(BuildContext context) {
    return Column(
      
      children: [
        // Display half screen image
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(itemDetails['imageUrl'].toString()),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Food item details below the image
       SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width * 1,
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                itemDetails['pantryItem'].toString(),
                style:FlutterFlowTheme.of(context)
                                    .displayMedium
                                    .override(
                                      fontFamily: 'Comfortaa',
                                      letterSpacing: 0.0,
                                      color: const Color(0xFF101518),
                                      decoration: TextDecoration.none,
                                    ),
                textAlign: TextAlign.left, // Align text to the center
              ),
              ),
              SizedBox(height: 30), // Creates space between header and content


            Padding(padding: EdgeInsets.all(10), 
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Type : ${jsonDecode(itemDetails['pantryItemDetails'].toString())[0]['type']}",
              style:FlutterFlowTheme.of(context)
                                    .displaySmall
                                    .override(
                                      fontFamily: 'Comfortaa',
                                      letterSpacing: 0.0,
                                      color: const Color(0xFF101518),
                                      decoration: TextDecoration.none,
                                      ),
                                      ),
            )
            ),
              Padding(padding: EdgeInsets.all(5), 
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Calories: ${jsonDecode(itemDetails['pantryItemDetails'].toString())[0]['calories']} kcal",
                  style: FlutterFlowTheme.of(context)
                    .displaySmall
                    .override(
                      fontFamily: 'Comfortaa',
                      letterSpacing: 0.0,
                      color: const Color(0xFF101518),
                      decoration: TextDecoration.none,
                    ),
                ),
              ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child:Align(
                alignment: Alignment.centerLeft,
                child: Text("Use by : ${ formatDate(itemDetails['updatedExpiryDate']) == '' ? itemDetails['geminiExpiryDate'].toString() : formatDate(itemDetails['updatedExpiryDate']) }",
                          style:FlutterFlowTheme.of(context)
                                                .displaySmall
                                                .override(
                                                  fontFamily: 'Comfortaa',
                                                  letterSpacing: 0.0,
                                                  color: const Color(0xFF101518),
                                                  decoration: TextDecoration.none,
                                                ),
                )
                )
              ),
            ],
          ),
        ),
         )
      ],
    );
  }
}
