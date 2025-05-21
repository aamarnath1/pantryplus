import 'dart:async';
import 'dart:ffi';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';


class GrocerylistRecord extends FirestoreRecord {

  GrocerylistRecord._(
    super.reference,
    super.data
  ){
    _initializeFields();
  }

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "groceryId" field.
  String? _groceryId;
  String get groceryId => _groceryId ?? '';
  bool hasName() => _groceryId != null;

  //"groceryObj" field.
  Array? _groceryObj;
  Array? get groceryObj => _groceryObj;
  bool hasgroceryObj() => _groceryObj != null;

  void _initializeFields() {
    _uid = snapshotData['uid'] as String?;
    _groceryId = snapshotData['grocery__list_id'] as String?;
    _groceryObj = snapshotData['grocery_list'] as Array?;
  }

  static CollectionReference get collection =>
        FirebaseFirestore.instance.collection('grocery_list');

  static Stream<GrocerylistRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => GrocerylistRecord.fromSnapshot(s));

   static Future<GrocerylistRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => GrocerylistRecord.fromSnapshot(s));

  static GrocerylistRecord fromSnapshot(DocumentSnapshot snapshot) => GrocerylistRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static Future<List<GrocerylistRecord>> getAllRecordsWithId(uid) async {
    var querySnapshot = await collection.where('uid', isEqualTo: uid).get();
    return querySnapshot.docs
        .map((snapshot) => GrocerylistRecord.fromSnapshot(snapshot))
        .toList();
  }

  static Future<void> addGrocery(Map<String, dynamic> groceryData) async {
    try {
      await collection.add(groceryData);
    } catch (e) {
      print('Error adding document: $e');
    }
  }

  Map<String, dynamic> createGrocerylistRecordData({
  String? uid,
  String? groceryId,
  Array? groceryObj,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'uid': uid,
      'grocery_list_id': groceryId,
      'grocery_list': groceryObj,
    }.withoutNulls,
  );
  return firestoreData;
}
}

class GrocerylistRecordDocumentEquality implements Equality<GrocerylistRecord> {
  const GrocerylistRecordDocumentEquality();

  @override
  bool equals(GrocerylistRecord? e1, GrocerylistRecord? e2) {
    return e1?.uid == e2?.uid &&
        e1?.groceryId == e2?.groceryId &&
        e1?.groceryObj == e2?.groceryObj;
  }

  @override
  int hash(GrocerylistRecord? e) => const ListEquality().hash([
        e?.uid,
        e?.groceryId,
        e?.groceryObj,
      ]);

  @override
  bool isValidKey(Object? o) => o is GrocerylistRecord;
}