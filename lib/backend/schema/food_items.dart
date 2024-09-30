import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';

class FoodItemsRecord extends FirestoreRecord {
  FoodItemsRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

// "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  //"pantry_item_id" field.
  String? _pantry_item_id;
  String get pantryItemId => _pantry_item_id ?? '';
  bool hasPantryItemId() => _pantry_item_id != null;

  // "name" field.
  String? _display_name;
  String get displayName => _display_name ?? '';
  bool hasName() => _display_name != null;


  //"pantry_item" field.
  String? _pantry_item;
  String get pantryItem => _pantry_item ?? '';
  bool hasPantryItem() => _pantry_item != null;

  //"pantry_item_details" field.
  String? _pantry_item_details;
  String? get pantryItemDetails => _pantry_item_details;
  bool hasPantryItemDetails() => _pantry_item_details != null;


  //"gemini_expiry_date" field.
  String? _gemini_expiry_date;
  String? get geminiExpiryDate => _gemini_expiry_date;
  bool hasGeminiExpiryDate() => _gemini_expiry_date != null;

  String? _image_url;
  String? get imageUrl => _image_url;
  bool hasImageUrl() => _image_url != null;

  //"updated_expiry_date" field.
  List<dynamic>? _updated_expiry_date;
  List<dynamic>? get updatedExpiryDate => _updated_expiry_date;
  bool hasUpdatedExpiryDate() => _updated_expiry_date != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  void _initializeFields() {
    _uid = snapshotData['uid'] as String?;
    _pantry_item_id = snapshotData['pantry_item_id'] as String?;
    _display_name = snapshotData['display_name'] as String?;
    _pantry_item = snapshotData['pantry_item'] as String?;
    _pantry_item_details = snapshotData['pantry_item_details'] as String?;
    _gemini_expiry_date = snapshotData['gemini_expiry_date'] as String?;
    _image_url = snapshotData['image_url'] as String?;
    _updated_expiry_date = snapshotData['updated_expiry_date'] as List<dynamic>?;
    _createdTime = snapshotData['created_time'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('food_items');

  static Stream<FoodItemsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => FoodItemsRecord.fromSnapshot(s));

  static Future<FoodItemsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => FoodItemsRecord.fromSnapshot(s));

   static FoodItemsRecord fromSnapshot(DocumentSnapshot snapshot) => FoodItemsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );
      
  static Future<List<FoodItemsRecord>> getAllRecordsWithUid(String uid) async {
    var querySnapshot = await collection.where('uid', isEqualTo: uid).get();
    return querySnapshot.docs
        .map((snapshot) => FoodItemsRecord.fromSnapshot(snapshot))
        .toList();
  }
  

        
      
}


Map<String, dynamic> createFoodItemsRecordData({
  String? uid,
  String? displayName,
  DateTime? createdTime,
  String? pantryItem,
  String? pantryItemDetails,
  String? imageUrl,
  String? pantryItemId,
  String? geminiExpiryDate,
  List<dynamic>? updatedExpiryDate,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'uid': uid,
      'display_name': displayName,
      'created_time': createdTime,
      'pantry_item': pantryItem,
      'pantry_item_id': pantryItemId,
      'pantry_item_details': pantryItemDetails,
      'image_url': imageUrl,
      'gemini_expiry_date': geminiExpiryDate,
      'updated_expiry_date': updatedExpiryDate,
    }.withoutNulls,
  );
  return firestoreData;
}

class FoodItemsRecorDocumentEquality implements Equality<FoodItemsRecord> {
  const FoodItemsRecorDocumentEquality();

  @override
  bool equals(FoodItemsRecord? e1, FoodItemsRecord? e2) {
    // return true;
    return e1?.uid == e2?.uid && 
        e1?.pantryItem == e2?.pantryItem &&
        e1?.pantryItemDetails == e2?.pantryItemDetails &&
        e1?.pantryItemId == e2?.pantryItemId &&
        e1?.geminiExpiryDate == e2?.geminiExpiryDate &&
        e1?.updatedExpiryDate == e2?.updatedExpiryDate;
  }

  @override
  int hash(FoodItemsRecord? e) => const ListEquality().hash([
        e?.uid,
        e?.displayName,
        e?.pantryItem,
        e?.pantryItemDetails,
        e?.pantryItemId,
        e?.imageUrl,
        e?.geminiExpiryDate,
        e?.updatedExpiryDate,
        e?.createdTime
      ]);

  @override
  bool isValidKey(Object? o) => o is FoodItemsRecord;
}