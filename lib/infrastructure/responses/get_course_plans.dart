import 'package:hadhri/domain/dtos/course_plan.dart';

class GetCoursePlans {
  late List<CoursePlan> coursePlans;

  GetCoursePlans(Map json) {
    coursePlans = [...(json['coursePlans'] as List).map((e) => CoursePlan(e))];
    // coursePlans = json['coursePlans'];
  }
}
