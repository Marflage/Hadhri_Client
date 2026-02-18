import 'package:hadhri/domain/dtos/course_plan.dart';

class GetCoursePlansResponse {
  late List<CoursePlan> coursePlans;

  GetCoursePlansResponse(Map json) {
    coursePlans = [...(json['coursePlans'] as List).map((e) => CoursePlan(e))];
    // coursePlans = json['coursePlans'];
  }
}
