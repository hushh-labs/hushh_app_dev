import 'package:fadingpageview/fadingpageview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:fuzzywuzzy/model/extracted_result.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/agent_sign_up_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/sign_up_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/components/create_new_brand_list_tile.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/bloc/card_market_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/brand.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/components/custom_text_field.dart';
import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';

class AgentGuideBrandSelectPage extends StatefulWidget {
  const AgentGuideBrandSelectPage({super.key});

  @override
  State<AgentGuideBrandSelectPage> createState() =>
      _AgentGuideBrandSelectPageState();
}

class _AgentGuideBrandSelectPageState extends State<AgentGuideBrandSelectPage> {
  TextEditingController textController = TextEditingController();

  FadingPageViewController get scrollController =>
      sl<SignUpPageBloc>().userGuideController;

  int get totalPages => sl<SignUpPageBloc>().totalPages;

  List<Brand>? get allBrands => sl<CardMarketBloc>().brands;

  @override
  void initState() {
    if(AppLocalStorage.user == null) {
      sl<SignUpPageBloc>().add(
          SignUpEvent(context, onboardStatus: UserOnboardStatus.signUpForm));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                    '${((scrollController.currentPage / totalPages) * 100).toStringAsFixed(0)}%'),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: scrollController.currentPage / totalPages,
                color: const Color(0xFF6725F2),
                borderRadius: BorderRadius.circular(50),
                minHeight: 10,
              ),
            ],
          ),
          const SizedBox(height: 26),
          Text(
            'Select Your Brand',
            style: context.headlineMedium
                ?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 0.8),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose the brand',
            style: context.headlineSmall
                ?.copyWith(color: Colors.grey, letterSpacing: 0.4),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: textController,
            edgeInsets: EdgeInsets.zero,
            onChanged: (value) {
              setState(() {});
            },
          ),
          const SizedBox(height: 16),
          const CreateNewBrandListTile(),
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder(
                bloc: sl<CardMarketBloc>(),
                builder: (context, state) {
                  List<Brand>? brands = allBrands;
                  if (textController.text.isNotEmpty && brands != null) {
                    List<ExtractedResult<Brand>> results =
                        extractAllSorted<Brand>(
                      query: textController.text,
                      choices: brands,
                      getter: (x) {
                        String combinedFields = '${x.domain} ${x.brandName}';
                        return combinedFields;
                      },
                    );
                    results.sort((a, b) => b.score.compareTo(a.score));
                    brands = results.map((e) => e.choice).toList();
                  }
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: brands?.length ?? 0,
                    itemBuilder: (context, index) {
                      final brand = brands![index];
                      bool isBrandUnclaimed = !brand.isClaimed;
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        onTap: () {
                          final bloc = sl<AgentSignUpPageBloc>();
                          final newlyCreatedBrand =
                              bloc.newlyCreatedSelectedBrand;

                          if (isBrandUnclaimed && newlyCreatedBrand != brand) {
                            bloc.onBrandClaim(brand, context);
                          } else if (isBrandUnclaimed) {
                            bloc.selectedBrand = brand;
                            if (newlyCreatedBrand?.domain != null) {
                              bloc.handleDomainExists(context);
                            } else {
                              scrollController.next();
                            }
                          } else {
                            bloc.selectedBrand = brand;
                            bloc.newlyCreatedSelectedBrand = brand;
                            setState(() {});
                          }
                        },
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(brand.brandLogo),
                        ),
                        subtitle: Row(
                          children: [
                            Text(brand.domain ?? "Domain Not Found"),
                            if (brand.domain != null &&
                                !isBrandUnclaimed &&
                                brand.brandApprovalStatus ==
                                    BrandApprovalStatus.approved) ...[
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.verified,
                                color: Colors.blue,
                                size: 16,
                              )
                            ]
                          ],
                        ),
                        trailing: isBrandUnclaimed &&
                                sl<AgentSignUpPageBloc>()
                                        .newlyCreatedSelectedBrand !=
                                    brand
                            ? ElevatedButton(
                                onPressed: () => sl<AgentSignUpPageBloc>()
                                    .onBrandClaim(brand, context),
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6)),
                                    elevation: 0,
                                    foregroundColor: const Color(0xFFE51A5E)),
                                child: const Text('Claim'),
                              )
                            : (sl<AgentSignUpPageBloc>()
                                        .newlyCreatedSelectedBrand ==
                                    brand
                                ? const Padding(
                                    padding: EdgeInsets.only(right: 2.0),
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Color(0xFFE51A5E),
                                    ),
                                  )
                                : const SizedBox()),
                        title: Text(brand.brandName.toLowerCase().capitalize()),
                      );
                    },
                  );
                }),
          ),
          BlocBuilder(
            bloc: sl<CardMarketBloc>(),
            builder: (context, state) {
              final brand = sl<AgentSignUpPageBloc>().newlyCreatedSelectedBrand;
              if (brand != null) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: HushhLinearGradientButton(
                      text: 'Continue with ${brand.brandName}',
                      onTap: () {
                        sl<AgentSignUpPageBloc>().selectedBrand = brand;
                        sl<AgentSignUpPageBloc>().add(CheckIfCardIsCreatedElseCreateNewBrandCardEvent(
                            brand, context));
                        // if (sl<AgentSignUpPageBloc>()
                        //             .newlyCreatedSelectedBrand ==
                        //         null ||
                        //     sl<AgentSignUpPageBloc>()
                        //             .newlyCreatedSelectedBrand
                        //             ?.domain !=
                        //         null) {
                        //   scrollController.next();
                        // } else {
                        //   sl<AgentSignUpPageBloc>().add(
                        //       AgentSignUpEvent(AppLocalStorage.user!, context));
                        // }
                      }),
                );
              }
              return const SizedBox();
            },
          )
        ],
      ),
    );
  }
}
