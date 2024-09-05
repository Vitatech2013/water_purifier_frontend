import 'package:intl/intl.dart';

class AppDateFormatters {
  static DateFormat time = DateFormat('HH:mm');
  static DateFormat timeMS = DateFormat('mm:ss');
  static DateFormat date = DateFormat('yyyy-MM-dd');
  static DateFormat dateMDY = DateFormat('MM-dd-yyyy');
  static DateFormat dateDMYHMS = DateFormat('dd-MM-yyyy hh:mm:ss');
}
