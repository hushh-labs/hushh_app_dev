import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/inventory_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/create_inventory_bottom_sheet.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/inventory/inventory_products_page.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ManageInventory extends StatefulWidget {
  const ManageInventory({super.key});

  @override
  State<ManageInventory> createState() => _ManageInventoryState();
}

class _ManageInventoryState extends State<ManageInventory> {
  final controller = sl<InventoryBloc>();

  @override
  void initState() {
    controller.add(FetchInventoriesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as bool?;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isDismissible: true,
            enableDrag: true,
            backgroundColor: Colors.transparent,
            constraints: BoxConstraints(maxHeight: 32.h),
            context: context,
            builder: (BuildContext context) =>
                const CreateInventoryBottomSheet(),
          );
        },
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        backgroundColor: const Color(0xFFE51A5E),
        child: const Icon(Icons.add),
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
          'Manage Inventory',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocConsumer(
            bloc: controller,
            listener: (context, state) {
              if (state is FetchedInventoriesState) {
                bool inventoriesNotAvailable =
                    ((controller.inventories?.length ?? -1) <= 0);
                if (inventoriesNotAvailable) {
                  showModalBottomSheet(
                    isDismissible: true,
                    enableDrag: true,
                    backgroundColor: Colors.transparent,
                    constraints: BoxConstraints(maxHeight: 32.h),
                    context: context,
                    builder: (BuildContext context) =>
                        const CreateInventoryBottomSheet(),
                  );
                }
              }
            },
            builder: (context, state) {
              if (state is FetchingInventoriesState) {
                return const Center(child: CupertinoActivityIndicator());
              }
              return GridView.builder(
                  itemCount: controller.inventories?.length ?? 0,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    final inventory = controller.inventories!.elementAt(index);
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, AppRoutes.inventoryProductsPage,
                            arguments: InventoryProductsPageArgs(
                                productTileType: ProductTileType.editProducts,
                                configurationId: inventory.configurationId,
                                brandId: inventory.brandId));
                      },
                      child: Card(
                        child: Center(
                            child: Text(
                          inventory.inventoryName,
                          textAlign: TextAlign.center,
                        )),
                      ),
                    );
                  });
            }),
      ),
    );
  }
}
