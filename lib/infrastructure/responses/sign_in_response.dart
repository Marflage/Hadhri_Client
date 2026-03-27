class SignInResponse {
  SignInResponse._({
    required this.studentId,
    required this.token,
  });

  final int studentId;
  final String token;

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) throw Exception('Empty JSON');

    return SignInResponse._(
      studentId: json['studentId'],
      token: json['token'],
    );
  }
}
