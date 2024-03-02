import 'package:cloud_firestore/cloud_firestore.dart';

String formatDate(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  // Get year, month, and day
  String year = dateTime.year.toString();
  String month = dateTime.month.toString(); // Corrected from dateTime.year.toString()
  String day = dateTime.day.toString();
  String formattedDate = '$day/$month/$year';

  return formattedDate;
}
