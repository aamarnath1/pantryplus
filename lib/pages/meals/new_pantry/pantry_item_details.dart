import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_theme.dart';
import 'package:keep_fresh/backend/schema/food_items.dart';

class PantryItemDetails extends StatefulWidget {
  final Map<String, Object?> itemDetails;
  
  const PantryItemDetails({Key? key, required this.itemDetails}) : super(key: key);

  @override
  State<PantryItemDetails> createState() => _PantryItemDetailsState();
}

class _PantryItemDetailsState extends State<PantryItemDetails> {
  late Future<Map<String, dynamic>> _pantryDetailsFuture;
  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedExpiryDate;
  String? _categoryValue;

  @override
  void initState() {
    super.initState();
    print('item ${widget.itemDetails.runtimeType}');
    _pantryDetailsFuture = _getPantryDetails(widget.itemDetails['pantryItemId']);
  }

  Future<Map<String, dynamic>> _getPantryDetails(dynamic pantryItemId) async {
    final pantryItemRecord = await FoodItemsRecord.getPantryDetails(pantryItemId);
    return {
      'uid': pantryItemRecord[0].uid,
      'displayName': pantryItemRecord[0].displayName,
      'pantryItem': pantryItemRecord[0].pantryItem,
      'pantryItemDetails': pantryItemRecord[0].pantryItemDetails,
      'pantryItemId': pantryItemRecord[0].pantryItemId,
      'imageUrl': pantryItemRecord[0].imageUrl,
      'geminiExpiryDate': pantryItemRecord[0].geminiExpiryDate,
      'updatedExpiryDate': pantryItemRecord[0].updatedExpiryDate,
      'createdTime': pantryItemRecord[0].createdTime,
    };
  }

  String _formatDate(dynamic dateStr) {
    if (dateStr == null || (dateStr is List && dateStr.isEmpty)) return '';
    
    final date = dateStr is DateTime ? dateStr : (dateStr is List ? dateStr[0] : null);
    if (date == null) return '';

    final day = date.day.toString();
    final suffix = _getDaySuffix(int.parse(day));
    final formattedDate = DateFormat('d MMMM yyyy').format(date);
    return formattedDate.replaceFirst(day, '$day$suffix');
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

  @override
  Widget build(BuildContext context) {

    // return GridView.builder(
    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //     crossAxisCount: 1, // Adjust as needed
    //     childAspectRatio: 2, // Adjust as needed
    //   ),
    //   itemCount: 1, // Since we are displaying a single item
    //   itemBuilder: (context, index) {
    //     return _buildContent(context, {
    //       'uid': widget.itemDetails['uid'],
    //       'displayName': widget.itemDetails['displayName'],
    //       'pantryItem': widget.itemDetails['pantryItem'],
    //       'pantryItemDetails': widget.itemDetails['pantryItemDetails'],
    //       'pantryItemId': widget.itemDetails['pantryItemId'],
    //       'imageUrl': widget.itemDetails['imageUrl'],
    //       'geminiExpiryDate': widget.itemDetails['geminiExpiryDate'],
    //       'updatedExpiryDate': widget.itemDetails['updatedExpiryDate'],
    //       'createdTime': widget.itemDetails['createdTime'],
    //     });
    //   },
    // );
    return FutureBuilder<Map<String, dynamic>>(
      future: _pantryDetailsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print('Error obtained here');
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No data available'));
        }

        final pantryRecord = snapshot.data!;
        return _buildContent(context, pantryRecord);
      },
    );
  }

  Widget _buildContent(BuildContext context, Map<String, dynamic> pantryRecord) {
    return Column(
      children: [
        _buildImageContainer(),
        SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              color: Colors.white,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildItemName(pantryRecord),
                  const SizedBox(height: 30),
                  _buildItemType(pantryRecord),
                  _buildCalories(pantryRecord),
                  _buildExpiryDate(pantryRecord),
                  _buildEditButton(pantryRecord),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImageContainer() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: widget.itemDetails['imageUrl'] != null ? NetworkImage(widget.itemDetails['imageUrl'].toString()) : const AssetImage('assets/images/pantryItem.png') as ImageProvider<Object>,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildItemName(Map<String, dynamic> pantryRecord) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        pantryRecord['pantryItem'].toString(),
        style: FlutterFlowTheme.of(context).displayMedium.override(
          fontFamily: 'Comfortaa',
          letterSpacing: 0.0,
          color: const Color(0xFF101518),
          decoration: TextDecoration.none,
        ),
      ),
    );
  }

  Widget _buildItemType(Map<String, dynamic> pantryRecord) {
    final itemDetails = jsonDecode(pantryRecord['pantryItemDetails'].toString())[0];
    return _buildInfoText("Type: ${itemDetails['type']}");
  }

  Widget _buildCalories(Map<String, dynamic> pantryRecord) {
    final itemDetails = jsonDecode(pantryRecord['pantryItemDetails'].toString())[0];
    if (itemDetails['calories'] != null) {
      return _buildInfoText("Calories: ${itemDetails['calories']} kcal");
    }
    return const SizedBox.shrink();
  }

  Widget _buildExpiryDate(Map<String, dynamic> pantryRecord) {
    final expiryDate = _formatDate(pantryRecord['updatedExpiryDate']) == '' 
        ? pantryRecord['geminiExpiryDate'].toString() 
        : _formatDate(pantryRecord['updatedExpiryDate']);
    return _buildInfoText("Use by: $expiryDate");
  }

  Widget _buildInfoText(String text) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        style: FlutterFlowTheme.of(context).displaySmall.override(
          fontFamily: 'Comfortaa',
          letterSpacing: 0.0,
          color: const Color(0xFF101518),
          decoration: TextDecoration.none,
        ),
      ),
    );
  }

  Widget _buildEditButton(Map<String, dynamic> pantryRecord) {
    return Material(
      color: Colors.transparent,
      child: IconButton(
        icon: const Icon(Icons.edit, color: Colors.blue),
        tooltip: 'Edit Item Details',
        onPressed: () => _showEditDialog(pantryRecord),
      ),
    );
  }

  void _showEditDialog(Map<String, dynamic> pantryRecord) {
    final itemDetails = jsonDecode(pantryRecord['pantryItemDetails'].toString())[0];
    _categoryValue = itemDetails['category'];
    _dateController.text = _formatDate(pantryRecord['updatedExpiryDate']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Item Details', style: FlutterFlowTheme.of(context).titleMedium.override(
            fontFamily: 'Comfortaa',
            color: const Color(0xFF000000),
            letterSpacing: 0.0,
          )),
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCategoryDropdown(itemDetails),
              const SizedBox(height: 10),
              _buildExpiryDateField(pantryRecord),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => _saveChanges(pantryRecord),
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryDropdown(Map<String, dynamic> itemDetails) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DropdownButtonFormField<String>(
        decoration: _getInputDecoration('Category'),
        value: itemDetails['category'],
        onChanged: (String? newValue) => _categoryValue = newValue,
        items: ['fridge', 'freezer', 'pantry'].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: _getDropdownTextStyle()),
          );
        }).toList(),
        dropdownColor: Color.fromARGB(255, 244, 243, 243),
      ),
    );
  }

  Widget _buildExpiryDateField(Map<String, dynamic> pantryRecord) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        decoration: _getInputDecoration('Expiry Date'),
        readOnly: true,
        onTap: () => _selectDate(pantryRecord),
        controller: _dateController,
        style: _getDropdownTextStyle(),
      ),
    );
  }

  void _selectDate(Map<String, dynamic> pantryRecord) {
    final dateTime = pantryRecord['updatedExpiryDate'] as List;
    showDatePicker(
      context: context,
      initialDate: dateTime[0],
      firstDate: dateTime[0],
      lastDate: DateTime(2301),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF26AE61),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    ).then((selectedDate) {
      if (selectedDate != null) {
        setState(() {
          _selectedExpiryDate = selectedDate;
          _dateController.text = _formatDate(selectedDate);
        });
      }
    });
  }

  void _saveChanges(Map<String, dynamic> pantryRecord) async {
    final itemDetails = jsonDecode(pantryRecord['pantryItemDetails'].toString())[0];
    itemDetails['category'] = _categoryValue;
    
    final updatedData = {
      'uid': pantryRecord['uid'],
      'display_name': pantryRecord['displayName'],
      'pantry_item': pantryRecord['pantryItem'],
      'pantry_item_id': pantryRecord['pantryItemId'],
      'gemini_expiry_date': pantryRecord['geminiExpiryDate'],
      'image_url': pantryRecord['imageUrl'],
      'pantry_item_details': jsonEncode([itemDetails]),
      'created_time': pantryRecord['createdTime'],
      'updated_expiry_date': _selectedExpiryDate != null ? [_selectedExpiryDate] : pantryRecord['updatedExpiryDate'],
    };

    try {
      await FoodItemsRecord.updatePantryDetails(pantryRecord['pantryItemId'], updatedData);
      setState(() {
        _pantryDetailsFuture = _getPantryDetails(pantryRecord['pantryItemId']);
      });
      Navigator.of(context).pop();
    } catch (e) {
      print("Error after updating: $e");
    }
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

  TextStyle _getDropdownTextStyle() {
    return FlutterFlowTheme.of(context).labelMedium.override(
      fontFamily: 'Comfortaa',
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );
  }
}