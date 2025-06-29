import 'package:admin_hrm/common/widgets/breadcrumb/t_breadcrums_with_heading.dart';
import 'package:admin_hrm/pages/contract/table/data_table_contract.dart';
import 'package:admin_hrm/pages/personnel_management/table/data_table_personnel.dart';
import 'package:admin_hrm/pages/position/table/data_table_positon.dart';
import 'package:admin_hrm/router/routers_name.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class PositionPageTablet extends StatelessWidget {
  const PositionPageTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const TBreadcrumsWithHeading(
                heading: 'Chức vụ',
                breadcrumbItems: [],
                rouderName: RouterName.positionPage,
              ),
              const Row(
                children: [
                  Text(
                    'Chức vụ',
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(10),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () {
                              context.go('/position-page/add-position');
                            },
                            child: Text(
                              'Thêm chức vụ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.white),
                            )),
                      ],
                    ),
                    const DataTablePositon()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
