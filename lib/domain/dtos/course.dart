import 'class_schedule.dart';

class Course {
  // TODO: Make all the fields final.
  late int id;
  late String name;
  late List<ClassSchedule> classSchedules;

  Course(Map json) {
    id = json['id'];
    name = json['name'];
    classSchedules = [...(json['classSchedules'] as List).map((e) => ClassSchedule(e))];
  }
}
