import 'package:flutter/material.dart';
import 'package:hadhri/domain/view_models/base_view_model.dart';
import 'package:hadhri/infrastructure/responses/get_student_details_response.dart';
import 'package:hadhri/infrastructure/services/account_service.dart';
import 'package:hadhri/infrastructure/services/attendance_service.dart';
import 'package:hadhri/infrastructure/services/auth_service.dart';
import 'package:hadhri/infrastructure/services/secure_storage_service.dart';
import 'package:slider_button/slider_button.dart';

import '../account/page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.attendanceService,
    required this.accountService,
    required this.storageService,
    required this.authService,
  });

  final AttendanceService attendanceService;
  final AccountService accountService;
  final SecureStorageService storageService;
  final AuthService authService;

  // TODO: Store this in a base class.
  static final String route = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const double _iconSize = 45.0;
  static const double _buttonSize = 65.0;

  late final GetStudentDetailsResponse _studentDetails;

  bool _isLoadingStudentDetails = true;

  @override
  void initState() {
    super.initState();
    _getStudentDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoadingStudentDetails
            ? Center(child: CircularProgressIndicator.adaptive())
            : Column(
                children: [
                  Text('السلام عليكم'),
                  Text('${_studentDetails.firstName} ${_studentDetails.lastName}'),
                  Text('You are enrolled in ${_studentDetails.courseName}'),
                  Text('Class schedule: ${_studentDetails.classScheduleName}'),
                  Text('Class session: ${_studentDetails.classSessionName}'),
                  Text('Semester: ${_studentDetails.semester}'),
                  // Text('Date'),
                  Placeholder(
                    child: Text('Attendance record'),
                  ),
                  SliderButton(
                    icon: Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: _iconSize,
                    ),
                    buttonColor: Colors.green,
                    baseColor: Colors.purple,
                    highlightedColor: Colors.yellow,
                    buttonSize: _buttonSize,
                    // disable: true,
                    label: Text('Mark Attendance'),
                    shimmer: false,
                    vibrationFlag: true,
                    useGlassEffect: true,
                    action: _logAttendance,
                  ),
                  // TODO: Move this into a different component after testing.
                  ElevatedButton(
                    onPressed: _getStudentDetails,
                    child: Text('Load student details'),
                  ),
                  // TODO: Move this into a different component after testing.
                  ElevatedButton(
                    onPressed: _signOut,
                    child: Text('Sign out'),
                  ),
                ],
              ),
      ),
    );
  }

  Future<bool> _logAttendance() async {
    // TODO: Send request to mark attendance.
    const int studentId = 8;
    final vm = await widget.attendanceService.logAttendance(studentId);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vm.message!)));
    }

    // TODO: Store the token in shared prefs.

    return true;
  }

  Future<void> _getStudentDetails() async {
    setState(() => _isLoadingStudentDetails = true);

    // TODO: Fetch student ID from secure storage and use that to request for student details.
    String? studentIdString = await widget.storageService.read('studentId');

    if (!mounted) return;

    if (studentIdString?.isEmpty == true) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to retrieve student ID.')));
      return;
    }

    int? studentId = int.tryParse(studentIdString!);

    if (studentId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to retrieve student ID.')));
      return;
    }

    final BaseViewState<GetStudentDetailsResponse> vs = await widget.accountService
        .getStudentDetails(studentId);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vs.message!)));

    if (vs.data != null) {
      setState(() {
        _isLoadingStudentDetails = false;
        _studentDetails = vs.data!;
      });
    }
  }

  Future<void> _signOut() async {
    await widget.authService.signOut();

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, AccountPage.route);
  }
}
