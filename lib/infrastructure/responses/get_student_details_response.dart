class GetStudentDetailsResponse {
  GetStudentDetailsResponse._({
    required this.studentId,
    required this.firstName,
    required this.lastName,
    required this.courseName,
    required this.classScheduleName,
    required this.classSessionName,
    required this.semester,
  });

  final int studentId;
  final String firstName;
  final String lastName;
  final String courseName;
  final String classScheduleName;
  final String classSessionName;
  final int semester;

  factory GetStudentDetailsResponse.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) throw Exception('Empty JSON');

    return GetStudentDetailsResponse._(
      studentId: json['studentId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      courseName: json['courseName'],
      classScheduleName: json['classScheduleName'],
      classSessionName: json['classSessionName'],
      semester: json['semester'],
    );
  }
}
