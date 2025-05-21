import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_fresh/auth/firebase_auth/auth_util.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_theme.dart';

class GroceryListWidget extends StatefulWidget {
  const GroceryListWidget({Key? key}) : super(key: key);

  @override
  State<GroceryListWidget> createState() => _GroceryListWidgetState();
}


class _GroceryListWidgetState extends State<GroceryListWidget> {
  // List to store grocery items
  List<GroceryItem> groceryItems = [
  ];

   @override
  void initState() {
    super.initState();
    checkGroceryListItems();
  }

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
            print('item ${item['pantryItemId']}');
            groceryItems.add(GroceryItem(name: item['item'], pantryItemId: item['pantryItemId']));
          }
        });
        print('groceryItems in check function ${groceryItems}');
      }
    } catch (e) {
      print('Error checking grocery list items: $e');
    }
  }


  void addItem(GroceryItem item) {
    setState(() {
      groceryItems.add(item);
    });
  }

  void removeItem(int index) {
    setState(() {
      groceryItems.removeAt(index);
    });
  }

  void editItem(int index, GroceryItem newItem) {
    setState(() {
      groceryItems[index] = newItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         iconTheme: IconThemeData(
            color: const Color(0xFF000000), //change your color here
          ),
        title: Text('Grocery List',
        style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  fontFamily: 'Comfortaa',
                                  letterSpacing: 0,
                                  color: const Color(0xFF000000),
                                  useGoogleFonts: GoogleFonts.asMap()
                                                  .containsKey('Comfortaa'),   
                                )),
        backgroundColor: Color(0xFFEDE8DF)
      ),
      backgroundColor: Color(0xFFEDE8DF),
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (context, index) {
          final item = groceryItems[index];
          return GroceryItemTile(
            item: item,
            onDelete: () => removeItem(index),
            onEdit: (newItem) => editItem(index, newItem),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add new item dialog/screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class GroceryItem {
  final String name;
  final String pantryItemId;

  GroceryItem({
    required this.name,
    required this.pantryItemId
  });
}

class GroceryItemTile extends StatelessWidget {
  final GroceryItem item;
  final VoidCallback onDelete;
  final Function(GroceryItem) onEdit;

  const GroceryItemTile({
    Key? key,
    required this.item,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('groceryItem ${item.name}');
    return ListTile(
      leading: const Icon(Icons.shopping_basket, color: Colors.black),
      title: Text(item.name,
      style: FlutterFlowTheme.of(context).bodyLarge.override(
          fontFamily: 'Comfortaa',
          letterSpacing: 0.0,
          color: const Color(0xFF101518),
          decoration: TextDecoration.none,
        ),
      ),
      // subtitle: Text('${item.quantity} ${item.unit}',
      // style: FlutterFlowTheme.of(context).bodyMedium.override(
      //     fontFamily: 'Comfortaa',
      //     letterSpacing: 0.0,
      //     color: const Color(0xFF101518),
      //     decoration: TextDecoration.none,
      //   ),
      
      // ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            onPressed: () {
              // TODO: Show edit dialog and call onEdit with new item
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
