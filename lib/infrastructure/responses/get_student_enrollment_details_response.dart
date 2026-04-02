class GetStudentEnrollmentDetailsResponse {
  GetStudentEnrollmentDetailsResponse._({
    required this.courseName,
    required this.classScheduleName,
    required this.classSessionName,
    required this.classSessionStartTime,
    required this.classSessionEndTime,
    required this.semester,
  });

  final String courseName;
  final String classScheduleName;
  final String classSessionName;
  final DateTime classSessionStartTime;
  final DateTime classSessionEndTime;
  final int semester;

  factory GetStudentEnrollmentDetailsResponse.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) throw Exception('Empty JSON.');

    return GetStudentEnrollmentDetailsResponse._(
      courseName: json['courseName'],
      classScheduleName: json['classScheduleName'],
      classSessionName: json['classSessionName'],
      classSessionStartTime: DateTime.parse(json['classSessionStartTime']),
      classSessionEndTime: DateTime.parse(json['classSessionEndTime']),
      semester: json['semester'],
    );
  }
}
