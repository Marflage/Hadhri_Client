class SignUpRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final int courseId;
  final int classScheduleId;
  final int classSessionId;
  final int semester;
  final String password;

  const SignUpRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.courseId,
    required this.classScheduleId,
    required this.classSessionId,
    required this.semester,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'phoneNumber': phoneNumber,
    'courseId': courseId,
    'classScheduleId': classScheduleId,
    'classSessionId': classSessionId,
    'semester': semester,
    'password': password,
  };
}
