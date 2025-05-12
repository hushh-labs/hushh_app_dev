part of 'bloc.dart';

abstract class LookBookProductEvent extends Equatable {
  const LookBookProductEvent();

  @override
  List<Object> get props => [];
}

class FetchLookBooksEvent extends LookBookProductEvent {}

class FetchAllProductsEvent extends LookBookProductEvent {
  final int brandId;

  const FetchAllProductsEvent(this.brandId);
}

class AddProductsToLookBook extends LookBookProductEvent {
  final BuildContext context;

  const AddProductsToLookBook(this.context);
}

class DeleteProductEvent extends LookBookProductEvent {
  final AgentProductModel product;
  final BuildContext context;
  final List<AgentProductModel>? selectedProducts;

  const DeleteProductEvent(this.product, this.context, this.selectedProducts);
}

class UploadCatalogueEvent extends LookBookProductEvent {
  final BuildContext context;

  const UploadCatalogueEvent(this.context);
}

class CreateLookbookEvent extends LookBookProductEvent {
  final String name;
  final BuildContext context;

  const CreateLookbookEvent(this.name, this.context);
}

class FetchLookBookProductsEvent extends LookBookProductEvent {
  final String lookbookId;

  const FetchLookBookProductsEvent(this.lookbookId);
}

class SendProductInquiryToAgent extends LookBookProductEvent {
  final BuildContext context;
  final AgentProductModel product;
  final AgentModel agent;

  const SendProductInquiryToAgent(this.context, this.product, this.agent);
}

class SendLookBookInquiryToAgent extends LookBookProductEvent {
  final BuildContext context;
  final AgentLookBook lookbook;
  final AgentModel agent;

  const SendLookBookInquiryToAgent(this.context, this.lookbook, this.agent);
}

class DeleteLookBookEvent extends LookBookProductEvent {
  final AgentLookBook lookBook;
  final BuildContext context;

  const DeleteLookBookEvent(this.lookBook, this.context);
}

class SearchLookBookEvent extends LookBookProductEvent {
  const SearchLookBookEvent();
}

class SearchProductEvent extends LookBookProductEvent {
  const SearchProductEvent();
}

class SendPaymentRequestToUserEvent extends LookBookProductEvent {
  final BuildContext context;
  // final AgentModel agent;
  final PaymentModel paymentModel;
  final types.User myUser;
  final String customerId;
  final String? otherUserAvatar;
  final String? otherUserName;

  const SendPaymentRequestToUserEvent({
    required this.context,
    this.otherUserAvatar,
    this.otherUserName,
    // required this.agent,
    required this.paymentModel,
    required this.myUser,
    required this.customerId,
  });
}
