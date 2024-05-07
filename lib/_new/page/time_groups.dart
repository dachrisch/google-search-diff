import 'package:relative_time/relative_time.dart';

class TimeGroups {
  static final Map<TimeUnit, String> map = {
    TimeUnit.second: 'Now',
    TimeUnit.minute: 'Recently',
    TimeUnit.hour: 'Today',
    TimeUnit.day: 'Couple Days',
    TimeUnit.month: 'Older',
    TimeUnit.year: 'Older'
  };
}
