import 'package:admin_hrm/common/widgets/breadcrumb/t_breadcrums_with_heading.dart';
import 'package:admin_hrm/common/widgets/method/method.dart';
import 'package:admin_hrm/constants/sizes.dart';
import 'package:admin_hrm/pages/kpi/bloc/kpi_bloc.dart';
import 'package:admin_hrm/pages/kpi/bloc/kpi_state.dart';
import 'package:admin_hrm/pages/kpi/table/data_table_kpi.dart';
import 'package:admin_hrm/router/routers_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class KPIPageTable extends StatelessWidget {
  const KPIPageTable({super.key});

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
                heading: 'KPI',
                breadcrumbItems: [],
              ),
              const Row(
                children: [
                  Text(
                    'KPI',
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                ],
              ),
              Gap(TSizes.spaceBtwItems),
              Container(
                padding: const EdgeInsets.all(10),
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
                              context.pushNamed(RouterName.addKpi);
                            },
                            child: Text(
                              'Thêm KPI',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.white),
                            )),
                        const Gap(10),
                        BlocBuilder<KPIBloc, KPIState>(
                            builder: (context, state) {
                          if (state is KPILoaded) {
                            return TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed: () {
                                  exportDynamicExcel(
                                    headers: [
                                      'Mã nhân viên',
                                      'Tên phòng ban',
                                      'Kỳ đánh giá',
                                      'Tổng điểm KPI',
                                      'Người đánh giá',
                                      'Ghi chú',
                                      'Ngày tạo',
                                    ],
                                    dataRows: state.kpis
                                        .map((kpi) => [
                                              kpi.userId,
                                              kpi.departmentId,
                                              kpi.period,
                                              kpi.totalScore.toStringAsFixed(2),
                                              kpi.evaluatorId ?? '-',
                                              kpi.notes ?? '-',
                                              kpi.createdAt.toString(),
                                            ])
                                        .toList(),
                                  );
                                },
                                child: Text(
                                  'Xuất danh sách chấm công',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.white),
                                ));
                          } else {
                            return const SizedBox();
                          }
                        }),
                      ],
                    ),
                    Gap(TSizes.spaceBtwItems),
                    const DataTableKPI()
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
