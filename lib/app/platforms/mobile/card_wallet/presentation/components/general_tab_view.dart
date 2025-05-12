import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/preference_card_list_view.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class GeneralTabView extends StatelessWidget {
  const GeneralTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = sl<CardWalletPageBloc>();

    return BlocBuilder(
      bloc: sl<CardWalletPageBloc>(),
      builder: (context, state) {
        return controller.preferenceCards.isNotEmpty
            ? PreferenceCardListView(
          isDetailsScreen: false,
          onIndexChanged: () {
            sl<CardWalletPageBloc>().emit(InitializingState());
            sl<CardWalletPageBloc>().emit(InitializedState());
          },
        )
            : const SizedBox();
      },
    );
  }
}
