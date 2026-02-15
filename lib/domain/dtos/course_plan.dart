import 'course.dart';

class CoursePlan {
  // TODO: Make all the fields final.
  late Course course;

  CoursePlan(Map json) {
    course = Course(json['course']);
  }
}
