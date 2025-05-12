import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/agent_card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/agent_task_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/customer_list_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/meeting_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/task_list_view.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:toastification/toastification.dart';

class AgentDashboardPage extends StatefulWidget {
  const AgentDashboardPage({super.key});

  @override
  State<AgentDashboardPage> createState() => _AgentDashboardPageState();
}

class _AgentDashboardPageState extends State<AgentDashboardPage>
    with SingleTickerProviderStateMixin {
  final controller = sl<AgentCardWalletPageBloc>();

  @override
  void initState() {
    controller.dashboardTabController = TabController(length: 3, vsync: this);
    controller.dashboardTabController.addListener(() {
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      int? index = ModalRoute.of(context)!.settings.arguments as int?;
      if (index != null) {
        controller.dashboardTabController.index = index;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            controller: controller.dashboardTabController,
            indicatorColor: const Color(0xFFe5e8eb),
            labelStyle: context.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600, color: Colors.black),
            unselectedLabelStyle: context.titleMedium?.copyWith(
                fontWeight: FontWeight.w600, color: const Color(0xFF964F66)),
            tabs: const [
              Tab(
                child: Text('Services'),
              ),
              Tab(
                child: Text('Calendar'),
              ),
              Tab(
                child: Text('Customers'),
              ),
            ],
            dividerColor: const Color(0xFFe8d1d6),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: controller.dashboardTabController.index == 0
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if(AppLocalStorage.hushhId == null) {
                       ToastManager(Toast(
                         title: 'Please complete profile',
                         description: 'Task can only be created once profile is completed',
                         type: ToastificationType.error
                       )).show(context);
                    } else {
                      Navigator.pushNamed(context, AppRoutes.agentNewTask);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(100.w, 48),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: const Color(0xFFE51A5E)),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 4),
                      Text('Add New Task')
                    ],
                  ),
                ),
              )
            : controller.dashboardTabController.index == 1
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, AppRoutes.agentCreateMeeting);
                      },
                      child: Container(
                        width: 327.30,
                        height: 48.63,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14.96, vertical: 13.09),
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment(-1.00, 0.05),
                            end: Alignment(1, -0.05),
                            colors: [
                              Color(0xFFA342FF),
                              Color(0xFFE54D60),
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(67),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Schedule',
                              style: TextStyle(
                                color: Color(0xFFF6F6F6),
                                fontSize: 14,
                                fontFamily: 'Figtree',
                                fontWeight: FontWeight.w700,
                                height: 1,
                                letterSpacing: 0.20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
        body: BlocBuilder(
            bloc: controller,
            builder: (context, state) {
              return TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: controller.dashboardTabController,
                children: [
                  TaskListView(tasks: sl<AgentTaskBloc>().tasks),
                  const MeetingView(),
                  CustomerListView(customers: controller.customers),
                ],
              );
            }));
  }
}
