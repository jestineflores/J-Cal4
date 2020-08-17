import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'event.dart';

// class FirestoreService {
//   static final FirestoreService _firestoreService =
//       FirestoreService._internal();
//   Firestore _db = Firestore.instance;
//   FirestoreService._internal();

//   factory FirestoreService() {
//     return _firestoreService;
//   }
// }

DatabaseService<Post> eventDatabase = DatabaseService<Post>('events',
    fromDS: (id, data) => Post.fromDS(id, data),
    toMap: (event) => event.toMap());

// Stream<List<Post>> getEvents() {
//   return _db.collection('events').snapshots().map(
//         (snapshot) => snapshot.documents
//             .map(
//               (doc) => Post.fromMap(doc.data, doc.documentID),
//             )
//             .toList(),
//       );
// }
