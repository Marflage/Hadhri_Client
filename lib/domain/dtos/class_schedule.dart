import 'class_session.dart';

class ClassSchedule {
  // TODO: Make all the fields final.
  late int id;
  late String name;
  late List<ClassSession> classSessions;

  ClassSchedule.create({this.id = 0, this.name = '', this.classSessions = const []});

  factory ClassSchedule(Map json) {
    return ClassSchedule.create(
      id: json['id'],
      name: json['name'],
      classSessions: [...(json['classSessions'] as List).map((e) => ClassSession(e))],
    );
  }
}
