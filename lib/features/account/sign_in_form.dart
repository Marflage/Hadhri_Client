import 'package:flutter/material.dart';
import 'package:hadhri/domain/view_models/base_view_model.dart';
import 'package:hadhri/infrastructure/requests/sign_in_request.dart';
import 'package:hadhri/infrastructure/services/account_service.dart';

import '../home/page.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({
    super.key,
    required this.accountService,
  });

  final AccountService accountService;

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // TODO: Move to next input field after pressing the return or the tab key on mobile devices as well.
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            validator: _onEmailValidated,
            onSaved: _onEmailSaved,
          ),
          // TODO: Add button to toggle password visibility.
          TextFormField(
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: _onPasswordValidated,
            onSaved: _onPasswordSaved,
          ),
          ElevatedButton(
            onPressed: _onFormSubmitted,
            child: _isLoading
                ? Center(child: CircularProgressIndicator.adaptive())
                : Text('Sign in'),
          ),
        ],
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  String _email = '';
  String _password = '';

  void _onEmailSaved(String? newEmail) => _email = newEmail!;

  void _onPasswordSaved(String? newPassword) => _password = newPassword!;

  // TODO: Move this into a common file that the SignUpForm can use as well.
  String? _onEmailValidated(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email.';
    }

    if (!value.contains('.')) {
      return 'Please enter a valid email.';
    }

    if (!value.contains('@')) {
      return 'Please enter a valid email.';
    }

    return null;
  }

  String? _onPasswordValidated(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password.';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters long.';
    }

    return null;
  }

  void _onFormSubmitted() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() => _isLoading = true);

      final request = SignInRequest(
        email: _email,
        password: _password,
      );

      final BaseViewState<String> vs = await widget.accountService.signIn(request);

      if (!mounted) return;

      setState(() => _isLoading = false);

      if (vs.error?.isNotEmpty == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vs.error!)));
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vs.message!)));

      Navigator.pushReplacementNamed(context, HomePage.route);
    }
  }
}
