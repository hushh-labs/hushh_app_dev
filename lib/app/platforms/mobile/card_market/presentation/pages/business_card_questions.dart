import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/bloc/card_market_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/user_preference.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/lookbook_name_bottomsheet.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/components/custom_text_field.dart';
import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
import 'package:hushh_app/app/shared/core/components/linkedin_login_button.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signin_with_linkedin/signin_with_linkedin.dart';
import 'package:tuple/tuple.dart';

class BusinessCardQuestionsPage extends StatefulWidget {
  const BusinessCardQuestionsPage({Key? key}) : super(key: key);

  @override
  State<BusinessCardQuestionsPage> createState() =>
      _BusinessCardQuestionsPageState();
}

class _BusinessCardQuestionsPageState extends State<BusinessCardQuestionsPage> {
  final PageController pageController = PageController();
  final controller = sl<CardMarketBloc>();
  double currentPage = 0;
  List<Tuple2<String, TextEditingController>> fields = [];
  bool linkedinVerified = false;
  bool useLinkedin = false;
  LinkedInUser? linkedInUser;

  Timer? _debounce;
  List<String?> websiteIcons = [];

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.currentQuestionIndex = 0;
      controller.userSelections = [];
      final cardData = ModalRoute.of(context)!.settings.arguments! as CardModel;
      if (cardData.id == Constants.businessCardId) {
        controller.userSelections.add(UserPreference(
            question: 'Business Information',
            questionId: -1,
            mandatory: true,
            questionType: CardQuestionType.multiSelectQuestion));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cardData = ModalRoute.of(context)!.settings.arguments! as CardModel;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
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
            'Business Card',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: 100.h - kToolbarHeight - 52,
            child: BlocBuilder(
                bloc: controller,
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: state is FetchingCardQuestionsState
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Column(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Add Your Business Links',
                                        style: context.titleLarge?.copyWith(
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 0.8),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            'Showcase your brand by adding important links like your website, social profiles, and more to your brand card.')),
                                    const SizedBox(height: 16),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: List.generate(
                                                fields.length,
                                                (index) => Padding(
                                                      padding: EdgeInsets.only(
                                                          top: index == 0
                                                              ? 0
                                                              : 16),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                CustomTextField(
                                                              edgeInsets:
                                                                  EdgeInsets
                                                                      .zero,
                                                              showPrefix: false,
                                                              height: 46,
                                                              controller:
                                                                  fields[index]
                                                                      .item2,
                                                              onChanged:
                                                                  (value) {
                                                                if (_debounce
                                                                        ?.isActive ??
                                                                    false) {
                                                                  _debounce
                                                                      ?.cancel();
                                                                }
                                                                _debounce = Timer(
                                                                    const Duration(
                                                                        milliseconds:
                                                                            1200),
                                                                    () {
                                                                  websiteIcons[
                                                                          index] =
                                                                      'http://www.google.com/s2/favicons?domain=$value';
                                                                  setState(
                                                                      () {});
                                                                });
                                                              },
                                                              trailing: websiteIcons[
                                                                          index] ==
                                                                      null
                                                                  ? null
                                                                  : Image
                                                                      .network(
                                                                      websiteIcons[
                                                                          index]!,
                                                                      errorBuilder: (context,
                                                                              _,
                                                                              s) =>
                                                                          const SizedBox(),
                                                                    ),
                                                              hintText:
                                                                  'Add your link',
                                                            ),
                                                          ),
                                                          IconButton(
                                                              onPressed: () {
                                                                fields.removeAt(
                                                                    index);
                                                                websiteIcons
                                                                    .removeAt(
                                                                        index);
                                                                setState(() {});
                                                              },
                                                              icon: const Icon(
                                                                Icons
                                                                    .delete_outline_outlined,
                                                                color: Colors
                                                                    .redAccent,
                                                              ))
                                                        ],
                                                      ),
                                                    )),
                                          ),
                                          if (fields.length < 4) ...[
                                            if (fields.isEmpty)
                                              Expanded(
                                                  child: Center(
                                                child: addMoreLinks(),
                                              ))
                                            else
                                              addMoreLinks()
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Get Verified with LinkedIn',
                                            style: context.titleLarge?.copyWith(
                                                fontWeight: FontWeight.w900,
                                                letterSpacing: 0.8),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(
                                          Icons.verified,
                                          color: Colors.blue,
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            'Earn a verified badge on your business card by signing in with LinkedIn and boost your credibility.')),
                                    const SizedBox(height: 16),
                                    Expanded(
                                      child: Center(
                                        child: linkedinVerified
                                            ? Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 32),
                                                    child: ElevatedButton.icon(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            const Color(
                                                                0xFF0077B5),
                                                        // LinkedIn blue color
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 12,
                                                                horizontal: 16),
                                                      ),
                                                      onPressed: () {},
                                                      icon: Image.network(
                                                        linkedInUser?.picture ??
                                                            "",
                                                        height: 32,
                                                        width: 32,
                                                      ),
                                                      label: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 8.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  linkedInUser
                                                                          ?.name ??
                                                                      'N/A',
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 4),
                                                                const Icon(
                                                                  Icons
                                                                      .verified,
                                                                  size: 14,
                                                                  color: Colors
                                                                      .white,
                                                                )
                                                              ],
                                                            ),
                                                            const Text(
                                                              'Profile Verified',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    "We'll be using the verified '${linkedInUser!.email}' in your business card.'",
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontSize: 12),
                                                  )
                                                ],
                                              )
                                            : LinkedInLoginButton(
                                                onPressed: () async {
                                                  final _linkedInConfig =
                                                      LinkedInConfig(
                                                    clientId: '77ivxky0bdo15w',
                                                    clientSecret:
                                                        'nG4TJe187JTCJ3eY',
                                                    redirectUrl:
                                                        'https://www.linkedin.com/developers/tools/oauth/redirect',
                                                    scope: [
                                                      'openid',
                                                      'profile',
                                                      'email'
                                                    ],
                                                  );

                                                  SignInWithLinkedIn.signIn(
                                                    context,
                                                    config: _linkedInConfig,
                                                    onGetAuthToken: (data) {
                                                      log('Auth token data: ${data.toJson()}');
                                                    },
                                                    onGetUserProfile:
                                                        (_, user) {
                                                      log('LinkedIn User: ${user.toJson()}');
                                                      linkedinVerified =
                                                          user.emailVerified ??
                                                              false;
                                                      linkedInUser = user;
                                                      if (!(user
                                                              .emailVerified ??
                                                          false)) {
                                                        ToastManager(Toast(
                                                                title:
                                                                    'Unverified email detected!'))
                                                            .show(context);
                                                      } else {
                                                        ToastManager(Toast(
                                                                title:
                                                                    'Business card verified successfully'))
                                                            .show(context);
                                                      }
                                                      setState(() {});
                                                    },
                                                    onSignInError: (error) {
                                                      log('Error on sign in: $error');
                                                    },
                                                  );
                                                },
                                              ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              HushhLinearGradientButton(
                                  text: 'Create your Business Card',
                                  onTap: () async {
                                    String? businessName =
                                        await showModalBottomSheet(
                                      isDismissible: true,
                                      enableDrag: true,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      builder: (context) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom),
                                          child:
                                              const LookbookNameBottomSheet(),
                                        );
                                      },
                                    );
                                    if (businessName != null) {
                                      controller.userSelections = [
                                        UserPreference(
                                            question: 'Business Information',
                                            questionId: -1,
                                            mandatory: true,
                                            metadata: {
                                              "question": "business_links",
                                              "answers": {
                                                "links": fields
                                                    .map((e) => e.item2.text)
                                                    .toList(),
                                                "linkedin_verified":
                                                    linkedinVerified,
                                                "linkedin_data":
                                                    linkedInUser?.toJson(),
                                                "use_linkedin": useLinkedin,
                                                "email": AppLocalStorage
                                                    .user?.email!,
                                                "name":
                                                    AppLocalStorage.user?.name,
                                                "business_name": businessName,
                                                "phone_number": AppLocalStorage
                                                    .user
                                                    ?.phoneNumberWithCountryCode
                                              },
                                            },
                                            questionType: CardQuestionType
                                                .multiSelectQuestion)
                                      ];
                                      final data = cardData.copyWith(
                                          audioUrl: null,
                                          cardValue: "1",
                                          userId: AppLocalStorage.hushhId!,
                                          coins: "50",
                                          cardCurrency: sl<HomePageBloc>().currency.name,
                                          preferences:
                                              controller.userSelections,
                                          name: AppLocalStorage.user!.name,
                                          installedTime: DateTime.now());
                                      sl<CardMarketBloc>().add(
                                          InsertCardInUserInstalledCardsEvent(
                                              data, context));
                                    }
                                  }),
                              const SizedBox(height: 16),
                            ],
                          ),
                  );
                }),
          ),
        ),
      ),
    );
  }

  Widget addMoreLinks() {
    onAdd() {
      fields.add(Tuple2("", TextEditingController()));
      websiteIcons.add("");
      setState(() {});
    }

    if (fields.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () => onAdd(),
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                elevation: 0,
                foregroundColor: const Color(0xFFE51A5E)),
            child: const Text('Add Link +'),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'Make it easy for others to find and connect with your business online',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          )
        ],
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              onAdd();
            },
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
