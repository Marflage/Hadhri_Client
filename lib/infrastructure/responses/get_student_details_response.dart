class GetStudentDetailsResponse {
  GetStudentDetailsResponse._({
    required this.firstName,
    required this.lastName,
  });

  final String firstName;
  final String lastName;

  factory GetStudentDetailsResponse.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) throw Exception('Empty JSON');

    return GetStudentDetailsResponse._(
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }
}
