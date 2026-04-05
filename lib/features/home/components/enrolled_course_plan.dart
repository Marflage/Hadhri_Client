import 'package:flutter/material.dart' show Card, Chip;
import 'package:flutter/widgets.dart';

class EnrolledCoursePlan extends StatelessWidget {
  const EnrolledCoursePlan({
    super.key,
    required this.courseName,
    required this.classScheduleName,
    required this.classSessionName,
    required this.semester,
  });

  final String courseName;
  final String classScheduleName;
  final String classSessionName;
  final int semester;

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: Column(
        mainAxisAlignment: .spaceBetween,
        children: [
          Chip(label: Text('Enrolled course plan')),
          Column(
            crossAxisAlignment: .start,
            children: [
              Text('Course: $courseName'),
              Text(
                'Class schedule: $classScheduleName',
              ),
              Text('Class session: $classSessionName'),
              Text('Semester: $semester'),
            ],
          ),
        ],
      ),
    );
  }
}
