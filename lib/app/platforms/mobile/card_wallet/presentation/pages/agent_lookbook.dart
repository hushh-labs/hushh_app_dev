import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/lookbook_product_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/agent_profile_header.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/lookbooks_list_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/agent_products.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/components/custom_text_field.dart';
import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:toastification/toastification.dart';

class AgentLookBookPage extends StatefulWidget {
  const AgentLookBookPage({super.key});

  @override
  State<AgentLookBookPage> createState() => _AgentLookBookPageState();
}

class _AgentLookBookPageState extends State<AgentLookBookPage> {
  final controller = sl<LookBookProductBloc>();

  @override
  void initState() {
    controller.add(FetchLookBooksEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as bool?;
    final sendLookBook = args == true;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: sendLookBook
          ? null
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 56,
                child: HushhLinearGradientButton(
                  text: 'Manage Inventory',
                  radius: 12,
                  icon: Icons.inventory_2_outlined,
                  onTap: () {
                    if (AppLocalStorage.agent == null) {
                      ToastManager(Toast(
                              title: 'Please complete profile',
                              description:
                                  'Inventory can only be created once profile is completed',
                              type: ToastificationType.error))
                          .show(context);
                      return;
                    }
                    Navigator.pushNamed(context, AppRoutes.manageInventory);
                    // Add new lookbook
                    // Navigator.pushNamed(
                    //   context,
                    //   AppRoutes.agentProducts,
                    //   arguments: const Tuple3<AgentProductsPageStatus, String?,
                    //       List<AgentProductModel>?>(
                    //       AgentProductsPageStatus.selectProducts, null, null),
                    // );
                  },
                ),
              ),
            ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: SvgPicture.asset('assets/back.svg')),
        ),
        centerTitle: false,
        title: const Text(
          'Lookbook & Products',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: BlocBuilder<LookBookProductBloc, LookBookProductState>(
            bloc: controller,
            buildWhen: (previous, current) =>
                current is LookBooksFetchedState ||
                current is LookBooksSearchState ||
                current is DoneState ||
                current is LookBooksErrorState,
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: controller.searchController,
                    onChanged: (value) {
                      controller.add(const SearchLookBookEvent());
                    },
                    hintText: 'Search',
                  ),
                  const SizedBox(height: 16),
                  if (!sendLookBook)
                    Row(
                      children: [
                        Expanded(
                          child: customButton(
                            icon: Icons.add,
                            name: "Create Lookbook",
                            onTap: () {
                              if (AppLocalStorage.agent == null) {
                                ToastManager(Toast(
                                        title: 'Please complete profile',
                                        description:
                                            'Complete your profile to view products',
                                        type: ToastificationType.error))
                                    .show(context);
                                return;
                              }
                              Navigator.pushNamed(
                                  context, AppRoutes.createLookbook);
                            },
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: customButton(
                            icon: Icons.dashboard,
                            name: "View All Products",
                            onTap: () {
                              if (AppLocalStorage.agent == null) {
                                ToastManager(Toast(
                                        title: 'Please complete profile',
                                        description:
                                            'Products can only be accessed after completing your profile',
                                        type: ToastificationType.error))
                                    .show(context);
                                return;
                              }
                              Navigator.pushNamed(
                                context,
                                AppRoutes.agentProducts,
                                arguments: AgentProductsArgs(
                                    productTileType:
                                        ProductTileType.viewProducts,
                                    brandId:
                                        AppLocalStorage.agent!.agentBrandId),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  const SizedBox(height: 16),
                  controller.lookbooks != null
                      ? controller.lookbooks!.isNotEmpty
                          ? LookBooksListView(
                              sendLookBook: sendLookBook,
                              lookbooks: state is LookBooksSearchState
                                  ? controller.lookBookSearch
                                  : controller.lookbooks!,
                            )
                          : Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Lottie.asset('assets/empty-lookbook.json',
                                      width: 45.w),
                                  const SizedBox(height: 28),
                                  const Text(
                                    'Hey! lets create a look book for you. Look books are a collection of your products that you create and share it with potential Users',
                                    style: TextStyle(color: Color(0xFFA2A2A2)),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 10.h),
                                ],
                              ),
                            )
                      : AppLocalStorage.hushhId == null
                          ? const Center(child: Text('No Products found!'))
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget customButton({
    required IconData icon,
    required String name,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        height: actionButtonHeight,
        // clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
            color: const Color(0xffE7E7E7),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 8),
            Icon(icon),
            const SizedBox(width: 4),
            Expanded(
              child: AutoSizeText(
                name,
                style:
                    TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
              ),
            ),
            const SizedBox(width: 2)
          ],
        ),
      ),
    );
  }
}
