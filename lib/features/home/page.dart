import 'package:flutter/material.dart';
import 'package:hadhri/domain/view_models/base_view_model.dart';
import 'package:hadhri/features/home/components/enrolled_course_plan.dart';
import 'package:hadhri/features/home/components/greeting.dart';
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

  bool _isLoadingData = true;
  bool _isAttendanceMarked = false;

  @override
  void initState() {
    super.initState();
    _onInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoadingData
            ? Center(child: CircularProgressIndicator.adaptive())
            : Center(
                child: Column(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Greeting(
                          firstName: _studentDetails.firstName,
                          lastName: _studentDetails.lastName,
                        ),
                        EnrolledCoursePlan(
                          courseName: _studentEnrollmentDetails.courseName,
                          classScheduleName: _studentEnrollmentDetails.classScheduleName,
                          classSessionName: _studentEnrollmentDetails.classSessionName,
                          semester: _studentEnrollmentDetails.semester,
                        ),
                      ],
                    ),
                    // Text('Date'),
                    Placeholder(
                      fallbackHeight: 200,
                      fallbackWidth: 200,
                      child: Text('Attendance record'),
                    ),
                    // Spacer(),
                    _isAttendanceMarked
                        ? Text('Your attendance has been logged.')
                        : SliderButton(
                            icon: Icon(
                              Icons.check_rounded,
                              color: Colors.green,
                              size: _iconSize,
                            ),
                            buttonSize: _buttonSize,
                            disable: !_isClassSessionNow(),
                            // disable: true,
                            label: Text('Log your attendance'),
                            shimmer: true,
                            vibrationFlag: true,
                            useGlassEffect: true,
                            action: _logAttendance,
                            // action: () async => false,
                          ),
                    // TODO: Move this into a different component after testing.
                    // ElevatedButton(
                    //   onPressed: _getStudentDetails,
                    //   child: Text('Load student details'),
                    // ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> _onInit() async {
    try {
      GetStudentDetailsResponse studentDetails = await _getCurrentStudentDetails();
      GetStudentEnrollmentDetailsResponse enrollmentDetails =
          await _getCurrentStudentEnrollmentDetails();
      bool isAttendanceMarked = await _isAttendanceLogged();

      if (!mounted) return;

      setState(() {
        _studentDetails = studentDetails;
        _studentEnrollmentDetails = enrollmentDetails;
        _isAttendanceMarked = isAttendanceMarked;
        _isLoadingData = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Successfully loaded initial data.')));
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoadingData = false);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<GetStudentDetailsResponse> _getCurrentStudentDetails() async {
    final vs = await widget.accountService.getStudentDetails();
    if (vs.error?.isNotEmpty == true) throw Exception(vs.error);
    return vs.data!;
  }

  Future<GetStudentEnrollmentDetailsResponse> _getCurrentStudentEnrollmentDetails() async {
    final vs = await widget.accountService.getStudentEnrollmentDetails();
    if (vs.error?.isNotEmpty == true) throw Exception(vs.error);
    return vs.data!;
  }

  Future<bool> _isAttendanceLogged() async {
    final BaseViewState<bool> vs = await widget.attendanceService.isAttendanceLogged();
    if (vs.error?.isNotEmpty == true) throw Exception(vs.error);
    return vs.data!;
  }

  bool _isClassSessionNow() {
    final DateTime now = DateTime.now();

    final DateTime classSessionStartTime = DateTime(
      now.year,
      now.month,
      now.day,
      _studentEnrollmentDetails.classSessionStartTime.hour,
      _studentEnrollmentDetails.classSessionStartTime.minute,
      _studentEnrollmentDetails.classSessionStartTime.second,
    );

    final DateTime classSessionEndTime = DateTime(
      now.year,
      now.month,
      now.day,
      _studentEnrollmentDetails.classSessionEndTime.hour,
      _studentEnrollmentDetails.classSessionEndTime.minute,
      _studentEnrollmentDetails.classSessionEndTime.second,
    );

    if (now.isAfter(classSessionStartTime) && now.isBefore(classSessionEndTime)) {
      return true;
    }

    return false;
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

    setState(() => _isAttendanceMarked = true);

    return false;
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

  Future<void> _signOut() async {
    await widget.authService.signOut();

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, AccountPage.route);
  }
}
