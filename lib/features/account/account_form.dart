import 'package:flutter/material.dart';
import 'package:hadhri/domain/dtos/course.dart';
import 'package:hadhri/infrastructure/responses/get_course_plans.dart';
import 'package:hadhri/infrastructure/services/account_form_service.dart';

import '../../domain/dtos/class_schedule.dart';
import '../../domain/dtos/class_session.dart';
import '../../infrastructure/requests/sign_up_request.dart';

class AccountForm extends StatefulWidget {
  AccountForm({
    super.key,
    required this.getCoursePlans,
    required this.service,
  });

  final GetCoursePlans getCoursePlans;
  final AccountFormService service;

  @override
  State<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // TODO: Validate all the fields.
          TextFormField(
            decoration: InputDecoration(labelText: 'First Name'),
            validator: _validateFirstName,
            onSaved: _onFirstNameSaved,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Last Name'),
            validator: _validateLastName,
            onSaved: _onLastNameSaved,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            validator: _validateEmail,
            onSaved: _onEmailSaved,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Phone Number'),
            validator: _validatePhoneNumber,
            onSaved: _onPhoneNumberSaved,
          ),
          DropdownMenuFormField(
            initialSelection: _selectedCourse,
            label: Text('Course'),
            dropdownMenuEntries: _courseDropdownEntries,
            onSelected: _onCourseSelected,
          ),
          DropdownMenuFormField(
            controller: _classScheduleController,
            enabled: _classScheduleDropdownEntries.isNotEmpty,
            initialSelection: _selectedClassSchedule,
            label: Text('Class Schedule'),
            dropdownMenuEntries: _classScheduleDropdownEntries,
            onSelected: _onClassScheduleSelected,
          ),
          DropdownMenuFormField(
            controller: _classSessionController,
            enabled: _classSessionDropdownEntries.isNotEmpty,
            initialSelection: _selectedClassSession,
            label: Text('Class Session'),
            dropdownMenuEntries: _classSessionDropdownEntries,
            onSelected: _onClassSessionSelected,
          ),
          DropdownMenuFormField(
            controller: _semesterController,
            enabled: _semesterDropdownEntries.isNotEmpty,
            initialSelection: _selectedSemester,
            label: Text('Semester'),
            dropdownMenuEntries: _semesterDropdownEntries,
            onSelected: _onSemesterSelected,
          ),
          // TODO: Obscure the text.
          // TODO: Show icon to toggle password visibility.
          // TODO: Create a unified component for password combining with confirm password.
          TextFormField(
            obscureText: _isPasswordVisible ? false : true,
            decoration: InputDecoration(
              labelText: 'Password',
              suffixIcon: IconButton(
                onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
              ),
            ),
            validator: _validatePassword,
            onSaved: _onPasswordSaved,
          ),
          // TODO: Match the passwords.
          TextFormField(
            obscureText: _isPasswordVisible ? false : true,
            decoration: InputDecoration(labelText: 'Confirm Password'),
            validator: _validateConfirmPassword,
          ),
          ElevatedButton(
            onPressed: _onSubmit,
            child: Text('Register'),
          ),
        ],
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _classScheduleController = TextEditingController();
  final TextEditingController _classSessionController = TextEditingController();
  final TextEditingController _semesterController = TextEditingController();

  // UI states
  List<DropdownMenuEntry<ClassSchedule>> _classScheduleDropdownEntries = [];

  List<DropdownMenuEntry<ClassSession>> _classSessionDropdownEntries = [];
  List<DropdownMenuEntry<int>> _semesterDropdownEntries = [];

  // Non-UI
  late String _firstName;
  late String _lastName;
  late String _email;
  late String _phoneNumber;
  late String _password;

  // TODO: Why are these fields nullable? Cannot they be marked late?
  Course? _selectedCourse;
  ClassSchedule? _selectedClassSchedule;
  ClassSession? _selectedClassSession;
  int? _selectedSemester;

  late String _validationPassword;
  bool _isPasswordVisible = false;

  List<DropdownMenuEntry<Course>> get _courseDropdownEntries {
    return widget.getCoursePlans.coursePlans
        .map(
          (x) => DropdownMenuEntry<Course>(
            label: x.course.name,
            value: x.course,
          ),
        )
        .toList();
  }

  // TODO: Find a way to convert this into a generic method.
  List<DropdownMenuEntry<ClassSchedule>> _createClassScheduleDropdownMenuEntries(
    List<ClassSchedule> list,
  ) => list.map((x) => DropdownMenuEntry(label: x.name, value: x)).toList();

  List<DropdownMenuEntry<ClassSession>> _createClassSessionDropdownMenuEntries(
    List<ClassSession> list,
  ) => list.map((x) => DropdownMenuEntry(label: x.name, value: x)).toList();

  List<DropdownMenuEntry<int>> _createSemesterDropdownMenuEntries(List<int> list) =>
      list.map((x) => DropdownMenuEntry(value: x, label: x.toString())).toList();

  void _onCourseSelected(Course? newCourse) {
    if (newCourse == null || _selectedCourse == newCourse) {
      return;
    }

    _selectedCourse = newCourse;

    setState(() {
      _selectedClassSchedule = null;
      _selectedClassSession = null;
      _selectedSemester = null;

      _classScheduleController.clear();
      _classSessionController.clear();
      _semesterController.clear();

      _classScheduleDropdownEntries = _createClassScheduleDropdownMenuEntries(
        newCourse.classSchedules,
      );

      _classSessionDropdownEntries = [];
      _semesterDropdownEntries = [];
    });
  }

  void _onClassScheduleSelected(ClassSchedule? newClassSchedule) {
    if (newClassSchedule == null || _selectedClassSchedule == newClassSchedule) {
      return;
    }

    _selectedClassSchedule = newClassSchedule;

    setState(() {
      _selectedClassSession = null;
      _selectedSemester = null;

      _classSessionController.clear();
      _semesterController.clear();

      _classSessionDropdownEntries = _createClassSessionDropdownMenuEntries(
        newClassSchedule.classSessions,
      );

      _semesterDropdownEntries = [];
    });
  }

  void _onClassSessionSelected(ClassSession? newClassSession) {
    if (newClassSession == null || _selectedClassSession == newClassSession) {
      return;
    }

    _selectedClassSession = newClassSession;

    setState(() {
      _selectedSemester = null;

      _semesterController.clear();

      _semesterDropdownEntries = _createSemesterDropdownMenuEntries(
        newClassSession.availableSemesters,
      );
    });
  }

  void _onSemesterSelected(int? newSemester) {
    if (newSemester == null || _selectedSemester == newSemester) {
      return;
    }

    _selectedSemester = newSemester;
  }

  void _onFirstNameSaved(String? newFirstName) => _firstName = newFirstName!;

  void _onLastNameSaved(String? newLastName) => _lastName = newLastName!;

  void _onEmailSaved(String? newEmail) => _email = newEmail!;

  void _onPhoneNumberSaved(String? newPhoneNumber) => _phoneNumber = newPhoneNumber!;

  void _onPasswordSaved(String? newPassword) => _password = newPassword!;

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // TODO: How to inject AccountFormService here?
      // TODO: Create an object to send in the API request.
      final request = SignUpRequest(
        firstName: _firstName,
        lastName: _lastName,
        email: _email,
        phoneNumber: _phoneNumber,
        courseId: _selectedCourse!.id,
        classScheduleId: _selectedClassSchedule!.id,
        classSessionId: _selectedClassSession!.id,
        semester: _selectedSemester!,
        password: _password,
      );
      // TODO: Send a request to the backend.

      await widget.service.register(request);

      var t = 3;
    }
  }

  // TODO: Find better packages with robust validations.
  String? _validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your first name.';
    }

    return null;
  }

  String? _validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your last name.';
    }

    return null;
  }

  String? _validateEmail(String? value) {
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

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number.';
    }

    if (value.length != 11) {
      return 'Please enter a valid phone number.';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password.';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters long.';
    }

    _validationPassword = value;

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password.';
    }

    if (value != _validationPassword) {
      return 'Passwords do not match.';
    }

    return null;
  }
}
