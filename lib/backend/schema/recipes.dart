import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';

class RecipesRecord extends FirestoreRecord {
  RecipesRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

// "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "name" field.
  String? _recipeId;
  String get recipeId => _recipeId ?? '';
  bool hasName() => _recipeId != null;

    // "name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

    // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  Map? _recipeObj;
  Map? get recipeObj => _recipeObj;
  bool hasrecipeObj() => _recipeObj != null;



  void _initializeFields() {
    _uid = snapshotData['uid'] as String?;
    _recipeId = snapshotData['recipe_id'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _recipeObj = snapshotData['recipe_obj'] as Map?;
    _createdTime = snapshotData['created_time'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('recipes');

  static Stream<RecipesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => RecipesRecord.fromSnapshot(s));

  static Future<RecipesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => RecipesRecord.fromSnapshot(s));

  static RecipesRecord fromSnapshot(DocumentSnapshot snapshot) => RecipesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static Future<List<RecipesRecord>> getAllRecordsWithId(uid) async {
    var querySnapshot = await collection.where('uid', isEqualTo: uid).get();
    return querySnapshot.docs
        .map((snapshot) => RecipesRecord.fromSnapshot(snapshot))
        .toList();
  }

  static Future<void> updateRecipeDetails(String uid, Map<String, dynamic> updatedData) async {
    try {
      await collection.where('uid', isEqualTo: uid).get().then((snapshot) {
        for (var doc in snapshot.docs) {
          doc.reference.update(updatedData);
        }
      });
    } catch (e) {
      print('Error updating document: $e');
      if (e is FirebaseException && e.code == 'not-found') {
        print('Document with id $uid not found.');
      }
    }
  }

  static Future<void> addRecipe(Map<String, dynamic> recipeData) async {
    try {
      await collection.add(recipeData);
    } catch (e) {
      print('Error adding document: $e');
    }
  }
}

Map<String, dynamic> createRecipesRecordData({
  String? uid,
  String? recipeId,
  String? displayName,
  Map? recipeObj,
  DateTime? createdTime,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'uid': uid,
      'recipe_id': recipeId,
      'display_name': displayName,
      'recipe_obj': recipeObj,
      'created_time': createdTime,
    }.withoutNulls,
  );
  print("firestore data printed here, ${firestoreData}");
  return firestoreData;
}

class RecipesRecordDocumentEquality implements Equality<RecipesRecord> {
  const RecipesRecordDocumentEquality();

  @override
  bool equals(RecipesRecord? e1, RecipesRecord? e2) {
    return e1?.uid == e2?.uid &&
        e1?.recipeId == e2?.recipeId &&
        e1?.recipeObj == e2?.recipeObj &&
        e1?.displayName == e2?.displayName;
  }

  @override
  int hash(RecipesRecord? e) => const ListEquality().hash([
        e?.uid,
        e?.recipeId,
        e?.displayName,
        e?.recipeObj,
        e?.createdTime
      ]);

  @override
  bool isValidKey(Object? o) => o is RecipesRecord;
}


