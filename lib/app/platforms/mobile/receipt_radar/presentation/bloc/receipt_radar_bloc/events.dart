part of 'bloc.dart';

abstract class ReceiptRadarEvent extends Equatable {
  const ReceiptRadarEvent();

  @override
  List<Object> get props => [];
}

class FetchInsightsEvent extends ReceiptRadarEvent {
  final String uid;
  final String? brandName;
  final String? brandCategory;
  final List<ReceiptModel>? receipts;

  const FetchInsightsEvent(this.uid, this.receipts, {this.brandName, this.brandCategory});
}

class FetchCategoriesFromReceiptsEvent extends ReceiptRadarEvent {
  final List<ReceiptModel> receipts;

  const FetchCategoriesFromReceiptsEvent(this.receipts);
}

class ResetFiltersEvent extends ReceiptRadarEvent {}

class UpdateReceiptRadarHistoryEvent extends ReceiptRadarEvent {
  final ReceiptRadarHistory receiptRadarHistory;

  const UpdateReceiptRadarHistoryEvent(this.receiptRadarHistory);
}

class ApplyFiltersEvent extends ReceiptRadarEvent {
  final List<FilterModel> brands;
  final List<FilterModel> categories;
  final List<FilterModel> domains;
  final List<FilterModel> times;
  final ReceiptRadarSortType updatedSortValue;

  const ApplyFiltersEvent(
    this.brands,
    this.categories,
    this.domains,
    this.times,
    this.updatedSortValue,
  );
}
