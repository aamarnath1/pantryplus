import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';


class PantryRecord extends FirestoreRecord{
    PantryRecord._(
        super.reference,
        super.data,
      ) {
        _initializeFields();
      }
    
   // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "image_url" field.
  String? _imageUrl;
  String get imageUrl => _imageUrl ?? '';
  bool hasImageUrl() => _imageUrl != null;

  // "pantry_data" field. 
  String? _pantryData;
  String get pantryData => _pantryData ?? '';
  bool hasPantryData() => _pantryData != null;

   // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;


  void _initializeFields() {
    _displayName = snapshotData['display_name'] as String?;
    _uid = snapshotData['uid'] as String?;
    _imageUrl = snapshotData['image_url'] as String?;
    _pantryData = snapshotData['pantry_data'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('pantry_data');

  static Stream<PantryRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PantryRecord.fromSnapshot(s));

static Future<PantryRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PantryRecord.fromSnapshot(s));

  static PantryRecord fromSnapshot(DocumentSnapshot snapshot) => PantryRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );
   static Future<List<PantryRecord>> getAllRecordsWithUid(String uid) async {
    var querySnapshot = await collection.where('uid', isEqualTo: uid).get();
    return querySnapshot.docs
        .map((snapshot) => PantryRecord.fromSnapshot(snapshot))
        .toList();
  }
}

Map<String, dynamic> createPantryRecord({
  String? displayName,
  String? imageUrl,
  String? uid,
  String? pantryData,
  DateTime? createdTime,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'display_name': displayName,
      'image_url': imageUrl,
      'uid': uid,
      'pantry_data': pantryData,
      'created_time': createdTime,
    }.withoutNulls,
  );
    print('firestoreData $firestoreData');
  return firestoreData;
}

class PantryRecordDocumentEquality implements Equality<PantryRecord> {
  const PantryRecordDocumentEquality();

  @override
  bool equals(PantryRecord? e1, PantryRecord? e2) {
    // return true;
    return e1?.uid == e2?.uid &&
        e1?.displayName == e2?.displayName &&
        e1?.imageUrl == e2?.imageUrl &&
        e1?.pantryData == e2?.pantryData;
        // e1?.createdTime == e2?.createdTime;
  }

  @override
  int hash(PantryRecord? e) => const ListEquality().hash([
        e?.uid,
        e?.displayName,
        e?.pantryData,
        e?.imageUrl,
        e?.createdTime
      ]);

  @override
  bool isValidKey(Object? o) => o is PantryRecord;
}