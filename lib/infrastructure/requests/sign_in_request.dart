class SignInRequest {
  SignInRequest({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  Map<String, String> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
