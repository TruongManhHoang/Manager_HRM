import 'package:admin_hrm/common/widgets/breadcrumb/t_breadcrums_with_heading.dart';
import 'package:admin_hrm/common/widgets/method/method.dart';
import 'package:admin_hrm/constants/sizes.dart';
import 'package:admin_hrm/pages/reward/bloc/reward_bloc.dart';
import 'package:admin_hrm/pages/reward/bloc/reward_event.dart';
import 'package:admin_hrm/pages/reward/bloc/reward_state.dart';
import 'package:admin_hrm/pages/reward/table/data_table_reward.dart';
import 'package:admin_hrm/router/routers_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class RewardPageTable extends StatelessWidget {
  const RewardPageTable({super.key});
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
                heading: 'Khen Thưởng',
                breadcrumbItems: [],
              ),
              const Row(
                children: [
                  Text(
                    'Khen thưởng',
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                ],
              ),
              Gap(TSizes.spaceBtwItems),
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
                            onPressed: () async {
                              final result =
                                  await context.push(RouterName.addReward);
                              if (result == true) {
                                context.read<RewardBloc>().add(LoadRewards());
                              }
                            },
                            child: Text(
                              'Thêm Khen Thưởng',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.white),
                            )),
                        const Gap(10),
                        BlocBuilder<RewardBloc, RewardState>(
                            builder: (context, state) {
                          if (state is RewardLoaded) {
                            return TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed: () {
                                  exportDynamicExcel(
                                    headers: [
                                      'Mã khen thưởng',
                                      'Mã nhân viên',
                                      'Lý do',
                                      'Loại khen thưởng',
                                      'Trạng thái',
                                      'Ngày khen thưởng',
                                      'Giá trị khen thưởng',
                                      'Người phê duyệt',
                                    ],
                                    dataRows: state.rewards
                                        .map((reward) => [
                                              reward.id,
                                              reward.employeeId,
                                              reward.reason,
                                              reward.status,
                                              reward.rewardType,
                                              reward.rewardDate,
                                              reward.rewardValue,
                                              reward.approvedBy,
                                              reward.rewardDate
                                            ])
                                        .toList(),
                                  );
                                },
                                child: Text(
                                  'Xuất danh sách khen thưởng',
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
                    const DataTableReward()
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
