import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jiffy/jiffy.dart';

// The date at time formats to use for Jiffy DateTime formatting
const DISPLAY_DATE_FORMAT = 'yyyy-MM-dd';
const DISPLAY_TIME_FORMAT = 'HH:mm:ss'; // 24-hour time format
const DISPLAY_DATE_TIME_FORMAT = 'yyyy-MM-dd HH:mm:ss'; // 24-hour time format

List<Jiffy> generateWeeks(Jiffy start, Jiffy end) {
  List<Jiffy> list = [];
  Jiffy current = start;
  for (var i = 0; i < 1000; i++) {
    if (current.isAfter(end)) {
      break;
    }
    list.add(current);
    current = Jiffy(Jiffy(current).add(days: 8)).startOf(Units.WEEK);
  }
  return list;
}

List<Jiffy> generateMonths(Jiffy start, Jiffy end) {
  List<Jiffy> list = [];
  Jiffy current = Jiffy(start).startOf(Units.MONTH);
  for (var i = 0; i < 1000; i++) {
    if (current.isAfter(end)) {
      break;
    }
    list.add(current);
    current = Jiffy(current).add(days: 32).startOf(Units.MONTH);
  }
  return list;
}

List<Jiffy> generateDays(Jiffy start, Jiffy end) {
  List<Jiffy> list = [];
  Jiffy current = start;
  for (var i = 0; i < 1000; i++) {
    if (current.isAfter(end)) {
      break;
    }
    list.add(current);
    current = Jiffy(current).add(days: 1).startOf(Units.DAY);
  }
  return list;
}

const WIDE_SCREEN_WIDTH = 600;
