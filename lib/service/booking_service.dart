// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class BookingService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   Future<void> saveBooking({
//     required String type, // "bus", "train", or "flight"
//     required Map<String, dynamic> data,
//   }) async {
//     final user = _auth.currentUser;
//     if (user != null) {
//       await _firestore.collection('bookings').add({
//         ...data,
//         'type': type,
//         'userId': user.uid,
//         'timestamp': Timestamp.now(),
//       });
//     }
//   }
//
//   Stream<QuerySnapshot> getUserBookings() {
//     final user = _auth.currentUser;
//     return _firestore
//         .collection('bookings')
//         .where('userId', isEqualTo: user?.uid)
//         .orderBy('timestamp', descending: true)
//         .snapshots();
//   }
// }
