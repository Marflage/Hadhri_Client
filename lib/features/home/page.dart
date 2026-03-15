import 'package:flutter/material.dart';
import 'package:hadhri/infrastructure/services/attendance_service.dart';
import 'package:slider_button/slider_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.attendanceService,
  });

  final AttendanceService attendanceService;

  // TODO: Store this in a base class.
  static final String route = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final double _iconSize = 45.0;
  final double _buttonSize = 65.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text('Assalamu Alaikum!'),
            Text('Name'),
            Text('Date'),
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vm.message)));
    }

    // TODO: Store the token in shared prefs.

    return true;
  }
}
