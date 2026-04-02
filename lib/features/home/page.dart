import 'package:flutter/material.dart';
import 'package:hadhri/domain/view_models/base_view_model.dart';
import 'package:hadhri/infrastructure/responses/get_student_details_response.dart';
import 'package:hadhri/infrastructure/responses/get_student_enrollment_details_response.dart';
import 'package:hadhri/infrastructure/services/account_service.dart';
import 'package:hadhri/infrastructure/services/attendance_service.dart';
import 'package:hadhri/infrastructure/services/auth_service.dart';
import 'package:hadhri/infrastructure/services/secure_storage_service.dart';
import 'package:slider_button/slider_button.dart';

import '../../infrastructure/enums/storage_keys.dart';
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
  late final GetStudentEnrollmentDetailsResponse _studentEnrollmentDetails;

  bool _isLoadingStudentDetails = true;
  bool _isLoadingStudentEnrollmentDetails = true;

  @override
  void initState() {
    super.initState();
    _onInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoadingStudentDetails || _isLoadingStudentEnrollmentDetails
            ? Center(child: CircularProgressIndicator.adaptive())
            : Column(
                children: [
                  Text('السلام عليكم'),
                  Text('${_studentDetails.firstName} ${_studentDetails.lastName}'),
                  Text('You are enrolled in ${_studentEnrollmentDetails.courseName}'),
                  Text('Class schedule: ${_studentEnrollmentDetails.classScheduleName}'),
                  Text('Class session: ${_studentEnrollmentDetails.classSessionName}'),
                  Text('Semester: ${_studentEnrollmentDetails.semester}'),
                  // Text('Date'),
                  Placeholder(
                    fallbackHeight: 200,
                    fallbackWidth: 200,
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
                  // ElevatedButton(
                  //   onPressed: _getStudentDetails,
                  //   child: Text('Load student details'),
                  // ),
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

  Future<void> _onInit() async {
    _getCurrentStudentDetails();
    _getCurrentStudentEnrollmentDetails();
  }

  Future<bool> _logAttendance() async {
    final int studentId = await _retrieveStudentIdFromStorage();

    final BaseViewState<dynamic> vs = await widget.attendanceService.logAttendance(studentId);

    if (!mounted) return false;

    if (vs.error?.isNotEmpty == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vs.error!)));
      return false;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vs.message!)));

    return true;
  }

  Future<int> _retrieveStudentIdFromStorage() async {
    String? studentIdString = await widget.storageService.read(StorageKeys.studentId.name);

    if (!mounted) return 0;

    if (studentIdString == null || studentIdString.isEmpty == true) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to retrieve student ID.')));
      return 0;
    }

    int? studentId = int.tryParse(studentIdString);

    if (studentId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to retrieve student ID.')));
      return 0;
    }

    return studentId;
  }

  Future<void> _getCurrentStudentDetails() async {
    final BaseViewState<GetStudentDetailsResponse> vs = await widget.accountService
        .getStudentDetails();

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

  Future<void> _getCurrentStudentEnrollmentDetails() async {
    try {
      final vs = await widget.accountService.getStudentEnrollmentDetails();

      setState(() {
        _studentEnrollmentDetails = vs.data!;
        _isLoadingStudentEnrollmentDetails = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vs.message!)));
    } catch (e) {
      // setState(() => _isLoadingStudentEnrollmentDetails = false);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
