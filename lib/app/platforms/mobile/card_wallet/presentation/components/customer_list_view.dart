import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/user.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/customer_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/agent_card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/card_wallet_info/card_wallet_info.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class CustomerListView extends StatefulWidget {
  final List<CustomerModel>? customers;
  final List<UserModel>? selectedUsers;
  final int? length;
  final bool isEdit;
  final bool search;

  const CustomerListView({
    super.key,
    this.customers,
    this.selectedUsers,
    this.length,
    this.isEdit = false,
    this.search = true,
  });

  @override
  State<CustomerListView> createState() => _CustomerListViewState();
}

class _CustomerListViewState extends State<CustomerListView> {
  List<CustomerModel> selectedCustomers = [];
  List<CustomerModel> searchList = [];
  final TextEditingController searchController = TextEditingController();
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  List<CustomerModel>? get customers {
    widget.customers?.removeWhere(
        (element) => element.brand.userId == AppLocalStorage.hushhId);
    List<CustomerModel>? sortedCustomers = widget.customers;
    sortedCustomers?.sort(
        (b, a) => a.brand.installedTime!.compareTo(b.brand.installedTime!));
    return sortedCustomers;
  }

  @override
  void initState() {
    sl<AgentCardWalletPageBloc>().add(FetchCustomersEvent());
    if (widget.selectedUsers != null) {
      final userIds = widget.selectedUsers!.map((e) => e.hushhId).toList();
      selectedCustomers = customers
              ?.where((element) => userIds.contains(element.user.hushhId!))
              .toList() ??
          [];
      setState(() {});
    }
    super.initState();
  }

  searchCustomers(searchText) {
    searchList = customers!
        .where((element) =>
            element.user.name!.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (customers?.isEmpty ?? true) {
      return const Center(
        child: Text('No Customers Found!'),
      );
    } else {
      if (false) {
        return SmartRefresher(
          controller: refreshController,
          onLoading: () {
            if (mounted) {
              setState(() {});
            }
            refreshController.loadComplete();
          },
          enablePullDown: true,
          onRefresh: () {
            refreshController.refreshCompleted();
          },
          child: list(),
        );
      } else {
        return list();
      }
    }
  }

  Widget list() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.search)
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                height: 40,
                child: TextFormField(
                  autofocus: false,
                  controller: searchController,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      searchCustomers(value);
                    } else {
                      searchList.clear();
                      setState(() {});
                    }
                  },
                  style:
                      const TextStyle(fontSize: 14.0, color: Color(0xff181941)),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    filled: true,
                    fillColor: const Color(0xFFf5f5fd),
                    hintText: 'Search customers',
                    hintStyle: const TextStyle(
                      fontSize: 14.0,
                      color: Color(0xFF7f7f97),
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(6),
                      child: SvgPicture.asset(
                        'assets/search_new.svg',
                        color: const Color(0xFF616180),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xFFf5f5fd),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xFFf5f5fd),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xFFf5f5fd),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          searchController.text.isNotEmpty
              ? searchList.isEmpty
                  ? const Center(
                      child: Text('No Customers Found!'),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: searchList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final customer = searchList[index];
                        return ListTile(
                            leading: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(customer
                                              .user.avatar?.isNotEmpty ??
                                          false
                                      ? customer.user.avatar!
                                      : "https://static-00.iconduck.com/assets.00/profile-user-icon-512x512-nm62qfu0.png"),
                                ),
                                Positioned(
                                  right: -5,
                                  bottom: -5,
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Colors.black,
                                    backgroundImage:
                                        NetworkImage(customer.brand.logo),
                                  ),
                                )
                              ],
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.cardWallet.info.main,
                                  arguments: CardWalletInfoPageArgs(
                                      customer: customer,
                                      cardData: customer.brand));
                            },
                            title: Text(customer.user.name!),
                            subtitle: Text(customer.brand.brandName),
                            trailing: customer.brand.installedTime != null
                                ? Text(
                                    DateFormat("dd MMM, yy")
                                        .format(customer.brand.installedTime!),
                                  )
                                : null);
                      },
                    )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: (customers?.length ?? 0) > (widget.length ?? 0)?widget.length ?? customers?.length:customers?.length ?? 0,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final customer = customers![index];
                    final isEdit = widget.isEdit;
                    return ListTile(
                        leading: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(customer
                                          .user.avatar?.isNotEmpty ??
                                      false
                                  ? customer.user.avatar!
                                  : "https://static-00.iconduck.com/assets.00/profile-user-icon-512x512-nm62qfu0.png"),
                            ),
                            Positioned(
                              right: -5,
                              bottom: -5,
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.black,
                                backgroundImage:
                                    NetworkImage(customer.brand.logo),
                              ),
                            )
                          ],
                        ),
                        onTap: isEdit
                            ? () {
                                if (!selectedCustomers.contains(customer)) {
                                  selectedCustomers.add(customer);
                                } else {
                                  selectedCustomers.remove(customer);
                                }
                                setState(() {});
                              }
                            : () {
                                Navigator.pushNamed(
                                    context, AppRoutes.cardWallet.info.main,
                                    arguments: CardWalletInfoPageArgs(
                                        customer: customer,
                                        cardData: customer.brand));
                              },
                        title: Text(customer.user.name ?? 'NA'),
                        subtitle: Text(customer.brand.brandName),
                        trailing: customer.brand.installedTime != null &&
                                !isEdit
                            ? Text(
                                DateFormat("dd MMM, yy")
                                    .format(customer.brand.installedTime!),
                              )
                            : isEdit
                                ? Checkbox(
                                    shape: const CircleBorder(),
                                    value: selectedCustomers.contains(customer),
                                    onChanged: (value) {
                                      if (value == true) {
                                        selectedCustomers.add(customer);
                                      } else {
                                        selectedCustomers.remove(customer);
                                      }
                                      setState(() {});
                                    },
                                  )
                                : null);
                  },
                ),
          if (widget.isEdit)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context, selectedCustomers);
                },
                child: Container(
                  width: double.infinity,
                  height: 48.63,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14.96, vertical: 13.09),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    // color: selectedCustomers.isEmpty ? Colors.grey : null,
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
                        'Update Participant(s)',
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
        ],
      ),
    );
  }
}
