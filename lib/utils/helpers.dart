import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


String formatDate(DateTime d) {
return DateFormat('yyyy-MM-dd').format(d);
}


String formatTimeOfDay(TimeOfDay t) {
final h = t.hour.toString().padLeft(2, '0');
final m = t.minute.toString().padLeft(2, '0');
return '$h:$m';
}