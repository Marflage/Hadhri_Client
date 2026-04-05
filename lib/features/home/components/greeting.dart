import 'package:flutter/widgets.dart';

class Greeting extends StatelessWidget {
  const Greeting({
    super.key,
    required this.firstName,
    required this.lastName,
  });

  final String firstName;
  final String lastName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Greeting
        const Text(
          'السلام عليكم',
          textScaler: .linear(3),
          textDirection: .rtl,
        ),
        // Full name
        Text(
          '$firstName $lastName',
          textScaler: const .linear(1.5),
        ),
      ],
    );
  }
}
