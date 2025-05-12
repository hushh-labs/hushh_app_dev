import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/bloc/card_market_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/plaid_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:plaid_flutter/plaid_flutter.dart';

class CardMarketPlaceButton extends StatefulWidget {
  final CardModel card;

  const CardMarketPlaceButton({super.key, required this.card});

  @override
  State<CardMarketPlaceButton> createState() => _CardMarketPlaceButtonState();
}

class _CardMarketPlaceButtonState extends State<CardMarketPlaceButton> {
  bool get isAdd => widget.card.isPreferenceCard
      ? !sl<CardWalletPageBloc>().preferenceCards.contains(widget.card)
      : !sl<CardWalletPageBloc>().brandCardList.contains(widget.card);

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: sl<CardMarketBloc>(),
      listener: (context, state) {
        if (state is CardQuestionsFetchedState) {
          if(state.cardId == widget.card.id) {
            if (
            (sl<CardMarketBloc>().cardQuestions?.isNotEmpty ??
                false) ||
                state.cardId == Constants.businessCardId) {
              Navigator.pushNamed(
                  context,
                  state.cardId == Constants.businessCardId
                      ? AppRoutes.cardMarketPlace.businessCardQuestions
                      : AppRoutes.cardMarketPlace.cardQuestions,
                  arguments: widget.card);
            } else {
              CardModel tempCard = widget.card.copyWith(
                  installedTime: DateTime.now(),
                  name: AppLocalStorage.user!.name,
                  cardValue: "1",
                  userId: AppLocalStorage.hushhId!,
                  coins: "10"
              );
              sl<CardMarketBloc>().add(
                  InsertCardInUserInstalledCardsEvent(tempCard, context));
            }
          }
        }
      },
      child: InkWell(
        onTap: () {
          if (isAdd) {
            if (widget.card.id == Constants.financeCardId) {
              PlaidLink.onSuccess.listen((LinkSuccess event) {
                final token = event.publicToken;
                AppLocalStorage.putPlaidInstitutionName(event.metadata.institution!.name);
                sl<PlaidBloc>().refreshPlaidAccessToken(token);
                final tempCard = widget.card.copyWith(
                    installedTime: DateTime.now(),
                    name: AppLocalStorage.user!.name,
                    cardValue: "1",
                    userId: AppLocalStorage.hushhId!,
                    coins: "10"
                );
                sl<CardMarketBloc>().add(
                    InsertCardInUserInstalledCardsEvent(tempCard, context));
              });
              sl<PlaidBloc>().createLinkTokenConfiguration(context);
            } else {
              sl<CardMarketBloc>()
                  .add(FetchCardQuestionsEvent(widget.card.id!, context));
            }
          } else {
            removeCardFeature(context,
                cardId: widget.card.id!, cardName: widget.card.brandName);
          }
        },
        child: Container(
          width: 80,
          height: 34,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: isAdd ? null : Border.all(color: Colors.black45),
            color: isAdd ? Colors.black : Colors.white,
          ),
          child: Align(
            // alignment: isAdd?Alignment.center:Alignment.centerRight,
            child: isAdd
                ? const Text(
                    "Add",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    "Remove",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black45,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

removeCardFeature(context1,
    {required int cardId,
    required String cardName,
    Function()? onRemove,
    Function()? onNotRemove}) async {
  await showCupertinoDialog(
      context: context1,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Remove card'),
          content: const Text('Are you sure to remove card'),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: () {
                onNotRemove?.call();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black54),
              ),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                onRemove?.call();
                sl<CardMarketBloc>().add(DeleteCardEvent(cardId));
                // Navigator.pop(context);
                if (onRemove == null) {
                  Navigator.pop(context1);
                  sl<CardWalletPageBloc>()
                      .brandCardList
                      .removeWhere((element) => element.id == cardId);
                  sl<CardWalletPageBloc>()
                      .add(CardWalletInitializeEvent(context));
                  Navigator.pop(context1);
                }
              },
              child: const Text(
                'Remove',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      });
}
