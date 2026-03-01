import 'package:flutter/material.dart';
import 'package:hadhri/features/account/sign_up_form.dart';
import 'package:hadhri/infrastructure/responses/get_course_plans.dart';
import 'package:hadhri/infrastructure/services/account_form_service.dart';
import 'package:pullex/pullex.dart';

import '../../infrastructure/services/course_plan_service.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({
    super.key,
    required this.service,
  });

  final CoursePlanService service;

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late GetCoursePlansResponse _getCoursePlans;
  var _isLoading = true;
  var _isDataAvailable = false;

  final _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Analyze if this Scaffold can be removed safely.
    return Scaffold(
      body: PullexRefresh(
        controller: _refreshController,
        header: BaseHeader(),
        onRefresh: _onRefresh,
        child: _isLoading
            ? Center(child: const CircularProgressIndicator.adaptive())
            : _isDataAvailable
            ? SignUpForm(
                getCoursePlans: _getCoursePlans,
                service: AccountFormService(),
              )
            : Center(
                // child: Text('Pull down to refresh.'),
                // TODO: Remove this after testing.
                child: ElevatedButton(onPressed: _onRefresh, child: Text('Refresh')),
              ),
      ),
    );
  }

  // TODO: Move this into a separate file.
  Future _onRefresh() async {
    final vm = await widget.service.fetchCoursePlansAsync();

    setState(() => _isLoading = false);

    if (vm.data == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vm.message)));
      }

      _refreshController.refreshCompleted();

      return;
    }

    setState(() {
      _isDataAvailable = true;
      _getCoursePlans = vm.data!;
    });

    _refreshController.refreshCompleted();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
