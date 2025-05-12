import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/receipt_model.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/data/models/filter_model.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/bloc/receipt_radar_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/components/receipt_filters/filter_section.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';

enum FiltersPageType { group, individual }

class FiltersBottomSheet extends StatefulWidget {
  final FiltersPageType filtersPageType;

  const FiltersBottomSheet({super.key, required this.filtersPageType});

  @override
  State<FiltersBottomSheet> createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends State<FiltersBottomSheet> {
  List<FilterModel> brands = [];

  List<FilterModel> domains = [];

  List<FilterModel> categories = [];

  List<FilterModel> times = [];

  late List<FilterModel> sorts;

  late ReceiptRadarSortType updatedSortValue;

  List<ReceiptRadarSortType> sortTypes = [
    ReceiptRadarSortType.newestFirst,
    ReceiptRadarSortType.oldestFirst,
    ReceiptRadarSortType.lowToHighTotalPrice,
    ReceiptRadarSortType.highToLowTotalPrice
  ];

  final controller = sl<ReceiptRadarBloc>();

  Map<String, dynamic> timeframes = {
    'Last 7 days': (DateTime dt) =>
        dt.isAfter(DateTime.now().subtract(const Duration(days: 7))),
    'Last 15 days': (DateTime dt) =>
        dt.isAfter(DateTime.now().subtract(const Duration(days: 15))),
    'Last 1 month': (DateTime dt) =>
        dt.isAfter(DateTime.now().subtract(const Duration(days: 30))),
    'Last 3 months': (DateTime dt) =>
        dt.isAfter(DateTime.now().subtract(const Duration(days: 90))),
    'Last 6 months': (DateTime dt) =>
        dt.isAfter(DateTime.now().subtract(const Duration(days: 180))),
    'Last year': (DateTime dt) =>
        dt.isAfter(DateTime.now().subtract(const Duration(days: 365))),
    'Lifetime': (DateTime dt) => true,
  };

  addBrandsFilter(ReceiptModel receipt) {
    String receiptBrandName(ReceiptModel receipt) =>
        ((receipt.brand?.trim().isNotEmpty ?? false)
                ? receipt.brand!
                : receipt.company)
            ?.capitalize() ?? 'N/A';

    String brandName = receiptBrandName(receipt);
    try {
      brands
          .firstWhere((element) => element.name == brandName)
          .ids
          ?.add(receipt.messageId!);
      if (brands.firstWhere((element) => element.name == brandName).ids?.any(
              (element) =>
                  sl<ReceiptRadarBloc>()
                      .filterBasedReceipts
                      ?.map((e) => e.messageId)
                      .contains(element) ??
                  false) ??
          false) {
        brands.firstWhere((element) => element.name == brandName).isSelected =
            true;
      }
    } catch (_) {
      brands.add(FilterModel(
          name: brandName,
          ids: [receipt.messageId!],
          isSelected: sl<ReceiptRadarBloc>()
                  .filterBasedReceipts
                  ?.map((e) => e.messageId)
                  .contains(receipt.messageId) ??
              false));
    }
  }

  addCategoriesFilter(ReceiptModel receipt) {
    if(receipt.brandCategory?.isEmpty ?? true) {
      return;
    }
    String category = receipt.brandCategory!;
    try {
      categories
          .firstWhere((element) => element.name == category)
          .ids
          ?.add(receipt.messageId!);
      if (categories.firstWhere((element) => element.name == category).ids?.any(
              (element) =>
          sl<ReceiptRadarBloc>()
              .filterBasedReceipts
              ?.map((e) => e.messageId)
              .contains(element) ??
              false) ??
          false) {
        categories.firstWhere((element) => element.name == category).isSelected =
        true;
      }
    } catch (_) {
      categories.add(FilterModel(
          name: category,
          ids: [receipt.messageId!],
          isSelected: sl<ReceiptRadarBloc>()
              .filterBasedReceipts
              ?.map((e) => e.messageId)
              .contains(receipt.messageId) ??
              false));
    }
  }

  addDomainsFilter(ReceiptModel receipt) {
    String domain = '@${receipt.company}';
    try {
      domains
          .firstWhere((element) => element.name == domain)
          .ids
          ?.add(receipt.messageId!);
      if (domains.firstWhere((element) => element.name == domain).ids?.any(
              (element) =>
                  sl<ReceiptRadarBloc>()
                      .filterBasedReceipts
                      ?.map((e) => e.messageId)
                      .contains(element) ??
                  false) ??
          false) {
        domains.firstWhere((element) => element.name == domain).isSelected =
            true;
      }
    } catch (_) {
      domains.add(FilterModel(
          name: domain,
          ids: [receipt.messageId!],
          isSelected: sl<ReceiptRadarBloc>()
                  .filterBasedReceipts
                  ?.map((e) => e.messageId)
                  .contains(receipt.messageId) ??
              false));
    }
  }

  addTimesFilter(ReceiptModel receipt) {
    String receiptTimeFrame(ReceiptModel receipt) {
      for (var entry in timeframes.entries) {
        if (entry.value(receipt.finalDate)) {
          return entry.key;
        }
      }
      return 'Lifetime';
    }

    String timeframe = receiptTimeFrame(receipt);
    try {
      times
          .firstWhere((element) => element.name == timeframe)
          .ids
          ?.add(receipt.messageId!);

      if (times.firstWhere((element) => element.name == timeframe).ids?.any(
              (element) =>
                  sl<ReceiptRadarBloc>()
                      .filterBasedReceipts
                      ?.map((e) => e.messageId)
                      .contains(element) ??
                  false) ??
          false) {
        times.firstWhere((element) => element.name == timeframe).isSelected =
            true;
      }
    } catch (_) {
      times.add(FilterModel(
          name: timeframe,
          ids: [receipt.messageId!],
          isSelected: sl<ReceiptRadarBloc>()
                  .filterBasedReceipts
                  ?.map((e) => e.messageId)
                  .contains(receipt.messageId) ??
              false));
    }
  }

  @override
  void initState() {
    sorts = sortTypes
        .map((e) => FilterModel(
            name: e.text, isSelected: e == controller.selectedSortType))
        .toList();
    updatedSortValue = controller.selectedSortType;
    final receipts = sl<ReceiptRadarBloc>().receipts ?? [];
    for (int index = 0; index < receipts.length; index++) {
      final receipt = receipts[index];
      addBrandsFilter(receipt);
      addCategoriesFilter(receipt);
      addDomainsFilter(receipt);
      addTimesFilter(receipt);
    }

    // fix time filter
    final timeframesOrder = timeframes.keys.toList();

    final currentAvailableOrder = times.map((e) => e.name).toList();
    timeframesOrder
        .removeWhere((element) => !currentAvailableOrder.contains(element));

    Map<String, Set<String>> mergedIds = {};
    for (String timeframe in timeframesOrder) {
      mergedIds[timeframe] = {};
    }

    for (String timeframe in timeframesOrder) {
      var filterModel = times.firstWhere((element) => element.name == timeframe,
          orElse: () => FilterModel(name: timeframe, ids: []));
      mergedIds[timeframe]!.addAll(filterModel.ids ?? []);
      // Add ids to all greater timeframes
      for (String greaterTimeframe in timeframesOrder) {
        if (timeframesOrder.indexOf(greaterTimeframe) >
            timeframesOrder.indexOf(timeframe)) {
          mergedIds[greaterTimeframe]!.addAll(filterModel.ids ?? []);
        }
      }
    }

    // Update the times list with merged IDs
    times = mergedIds.entries
        .map((entry) => FilterModel(name: entry.key, ids: entry.value.toList()))
        .toList();

    // Sort times filter from lowest to highest timeframe
    times.sort((a, b) => timeframesOrder
        .indexOf(a.name)
        .compareTo(timeframesOrder.indexOf(b.name)));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0)
                  .copyWith(top: 16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if(widget.filtersPageType == FiltersPageType.individual) ...[
                      FilterSection(
                        title: 'Brands',
                        filters: List.generate(
                            brands.length, (index) => brands[index]),
                        multipleSelection: true,
                        onSelectionChanged: (filters) {
                          brands = filters;
                          // Handle selection change
                          print(filters
                              .where((f) => f.isSelected)
                              .map((f) => f.name)
                              .toList());
                        },
                      ),
                    ],
                    FilterSection(
                      title: 'Category',
                      filters: categories,
                      multipleSelection: true,
                      onSelectionChanged: (filters) {
                        categories = filters;
                        // Handle selection change
                        print(filters
                            .where((f) => f.isSelected)
                            .map((f) => f.name)
                            .toList());
                      },
                    ),
                    FilterSection(
                      title: 'Domains',
                      filters: domains,
                      multipleSelection: true,
                      onSelectionChanged: (filters) {
                        domains = filters;
                        // Handle selection change
                        print(filters
                            .where((f) => f.isSelected)
                            .map((f) => f.name)
                            .toList());
                      },
                    ),
                    FilterSection(
                      title: 'Time',
                      filters: times,
                      multipleSelection: false,
                      onSelectionChanged: (filters) {
                        times = filters;
                        // Handle selection change
                        print(filters
                            .where((f) => f.isSelected)
                            .map((f) => f.name)
                            .toList());
                      },
                    ),

                    FilterSection(
                      title: 'Sort By',
                      filters: sorts,
                      selectOneMandatory: true,
                      multipleSelection: false,
                      onSelectionChanged: (filters) {
                        // Handle selection change
                        int i = sorts
                            .indexOf(filters.where((f) => f.isSelected).first);
                        updatedSortValue = sortTypes[i];
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    sl<ReceiptRadarBloc>().add(ResetFiltersEvent());
                    Navigator.pop(context);
                  },
                  child: const ColoredBox(
                    color: Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: Text('RESET')),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    sl<ReceiptRadarBloc>().add(ApplyFiltersEvent(
                      brands,
                      categories,
                      domains,
                      times,
                      updatedSortValue,
                    ));
                    Navigator.pop(context);
                  },
                  child: const ColoredBox(
                    color: Colors.black,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          'APPLY',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
