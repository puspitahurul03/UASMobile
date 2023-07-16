import 'dart:convert';
import 'dart:developer';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';



 String convertTimestamp(timestamp){
    final dateTime = timestamp.toDate();
    final formattedDateTime = DateFormat('dd MMM yyyy').format(dateTime);
    return formattedDateTime;
  }

  convertRupiah(nominal)
  {
    var nums = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ').format(nominal);
    return nums.toString();
  }


//Check if Date is Today
bool isToday(String date) {
  DateTime now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  DateTime dateConvert = DateTime.parse(date);
  final checkDate =
      DateTime(dateConvert.year, dateConvert.month, dateConvert.day);

  if (checkDate == today) {
    return true;
  }

  return false;
}

//Check if Date is Tomorrow
bool isTomorrow(String date) {
  DateTime now = DateTime.now();
  final tomorrow = DateTime(now.year, now.month, now.day + 1);

  DateTime dateConvert = DateTime.parse(date);
  final checkDate =
      DateTime(dateConvert.year, dateConvert.month, dateConvert.day);

  if (checkDate == tomorrow) {
    return true;
  }

  return false;
}

///Function to check if date is today or tomorrow
checkDate(DateTime date) {
  if (isToday(getDate(date))) {
    return "Today";
  }

  if (isTomorrow(getDate(date))) {
    return "Tomorrow";
  }

  return getDate(date);
}

//Function to get Local time
getTime(date) {
  String hour = "${date.toLocal()}".split(' ')[1].split(':')[0];

  String min = "${date.toLocal()}".split(' ')[1].split(':')[1];
  return "$hour:$min";
}

//Function to get Local date
getDate(date) {
  String day = "${date.toLocal()}".split(' ')[0];

  return day;
}
