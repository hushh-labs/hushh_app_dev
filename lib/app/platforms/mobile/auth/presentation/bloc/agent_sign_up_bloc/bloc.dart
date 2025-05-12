import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hushh_app/app/platforms/mobile/auth/data/models/agent_category.dart';
import 'package:hushh_app/app/platforms/mobile/auth/data/models/brand_category.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/agent.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/location.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/user.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/fetch_agents_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/fetch_brand_categories_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/fetch_categories_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/insert_agent_role_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/insert_agent_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/insert_brand_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/insert_user_agent_location_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/update_agent_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/update_user_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/sign_up_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/components/claim_brand_bottomsheet.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/bloc/card_market_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/brand.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/brand_location.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/card_exists_use_case.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';

part 'events.dart';

part 'states.dart';

class AgentSignUpPageBloc
    extends Bloc<AgentSignUpPageEvent, AgentSignUpPageState> {
  final FetchBrandCategoriesUseCase fetchBrandCategoriesUseCase;
  final FetchCategoriesUseCase fetchCategoriesUseCase;
  final UpdateAgentUseCase updateAgentUseCase;
  final InsertBrandUseCase insertBrandUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final InsertAgentUseCase insertAgentUseCase;
  final FetchAgentsUseCase fetchAgentsUseCase;
  final InsertUserAgentLocationUseCase insertUserAgentLocationUseCase;
  final InsertAgentRoleUseCase insertAgentRoleUseCase;
  final CardExistsUseCase cardExistsUseCase;

  AgentSignUpPageBloc(
    this.fetchCategoriesUseCase,
    this.updateAgentUseCase,
    this.insertBrandUseCase,
    this.fetchBrandCategoriesUseCase,
    this.updateUserUseCase,
    this.insertAgentUseCase,
    this.insertUserAgentLocationUseCase,
    this.insertAgentRoleUseCase,
    this.fetchAgentsUseCase,
    this.cardExistsUseCase,
  ) : super(AgentSignUpPageInitialState()) {
    on<FetchCategoriesEvent>(fetchCategoriesEvent);
    on<FetchBrandCategoriesEvent>(fetchBrandCategoriesEvent);
    on<CaptureImageEvent>(captureImageEvent);
    on<UpdateAgentEvent>(updateAgentEvent);
    on<UpdateBrandCategoryEvent>(updateBrandCategoryEvent);
    on<CreateBrandEvent>(createBrandEvent);
    on<AgentSignUpEvent>(agentSignUpEvent);
    on<CreateNewBrandCardEvent>(createNewBrandCardEvent);
    on<CheckIfCardIsCreatedElseCreateNewBrandCardEvent>(
        checkIfCardIsCreatedElseCreateNewBrandCardEvent);
    on<GenerateNewTxtRecordEvent>(generateNewTxtRecordEvent);
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  String? agentImageExt;
  List<AgentCategory> selectedCategories = [];
  Map<String, List<AgentCategory>> allCategorySections = {};
  List<AgentCategory>? suggestedCategorySections;
  List<BrandCategory> brandCategories = [];
  Brand? newlyCreatedSelectedBrand;
  Brand? selectedBrand;
  Uint8List? agentProfileImageBytes;
  Uint8List? agentIdCardBytes;
  Position? lastKnownLocation;
  CardModel? newlyCreatedCard;

  FutureOr<void> fetchCategoriesEvent(
      FetchCategoriesEvent event, Emitter<AgentSignUpPageState> emit) async {
    emit(FetchingAllCategoriesState());
    final result = await fetchCategoriesUseCase();
    result.fold((l) {}, (r) {
      Map<String, List<AgentCategory>> groupedCategories = {};

      for (var category in r) {
        if (groupedCategories.containsKey(category.type)) {
          groupedCategories[category.type]!.add(category);
        } else {
          groupedCategories[category.type] = [category];
        }
      }

      allCategorySections = groupedCategories;
      emit(AllCategoriesFetchedState());
    });
  }

  FutureOr<void> captureImageEvent(
      CaptureImageEvent event, Emitter<AgentSignUpPageState> emit) async {
    emit(CapturingImageState());
    XFile? result = await ImagePicker().pickImage(
      imageQuality: 60,
      maxWidth: 1440,
      source: event.source,
    );
    if (result != null) {
      agentProfileImageBytes = await result.readAsBytes();
      agentImageExt = result.path.split('.').lastOrNull ?? "png";
      emit(ImageCapturedState());
    }
  }

  FutureOr<void> updateAgentEvent(
      UpdateAgentEvent event, Emitter<AgentSignUpPageState> emit) async {
    emit(UpdatingAgentState());
    String? uri;
    showDialog(
      context: event.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.all(16),
              child: const CupertinoActivityIndicator(),
              // You can customize the dialog further if needed
            ),
          ],
        );
      },
    );
    if (agentProfileImageBytes != null) {
      final reference = FirebaseStorage.instance
          .ref()
          .child('agent_profiles/${const Uuid().v4()}.$agentImageExt');
      await reference.putData(agentProfileImageBytes!);
      uri = await reference.getDownloadURL();
    }
    AgentModel agent = AppLocalStorage.agent!.copyWith(
      agentWorkEmail: emailController.text,
      agentImage: uri,
      agentName: nameController.text,
      agentDesc: descController.text,
    );

    final result = await updateAgentUseCase(agent: agent);
    await result.fold((l) {
      Navigator.pop(event.context);
      ToastManager(Toast(
              title: "some error occurred", type: ToastificationType.error))
          .show(event.context);
    }, (r) async {
      AppLocalStorage.updateAgent(agent);
      ToastManager(Toast(
              title: "Your profile updated successfully!",
              type: ToastificationType.success))
          .show(event.context);
      Navigator.pop(event.context);
      Navigator.pop(event.context);
      emit(UpdatedAgentState());
    });
  }

  FutureOr<void> updateBrandCategoryEvent(UpdateBrandCategoryEvent event,
      Emitter<AgentSignUpPageState> emit) async {
    emit(UpdatingBrandCategoryState());
    List<BrandCategory> taskList = brandCategories;
    BrandCategory? brandCategory = await showModalBottomSheet(
        context: event.context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 40.h,
                child: Card(
                  color: const Color(0xffFBFBFB),
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: ListView.builder(
                      itemCount: taskList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ListTile(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20))),
                              onTap: () {
                                Navigator.pop(context, taskList[index]);
                              },
                              title: Center(
                                  child: Text(
                                taskList[index].brandCategory,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff454567)),
                              )),
                            ),
                            if (taskList.length - 1 != index)
                              const Divider(height: 0),
                          ],
                        );
                      }),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 23.88,
              ),
            ],
          );
        });
    if (brandCategory != null) {
      emit(UpdatedBrandCategoryState(brandCategory));
    }
  }

  Future<String?> generateCardBodyImageUrl(String logoUrl) async {
    Future<String> uploadImage(Uint8List data) async {
      final supabase = Supabase.instance.client;
      String path = "public/brands/${DateTime.now().toIso8601String()}.png";
      try {
        await supabase.storage.from('dump').uploadBinary(path, data);
      } on StorageException {}

      String url = supabase.storage.from('dump').getPublicUrl(path);
      return url;
    }

    final palette =
        await PaletteGenerator.fromImageProvider(NetworkImage(logoUrl));
    Color dominantColor = palette.dominantColor!.color;
    String hex = '#${dominantColor.value.toRadixString(16)}';
    Uint8List? data = await generateImage(hex);
    if (data != null) {
      String url = await uploadImage(data);
      return url;
    }
    return null;
  }

  Future<Uint8List?> generateImage(String dominantColor) async {
    try {
      final response = await sl<Dio>().get(
          'https://receipt-radar-27-jul-1-yxfa6ba3aq-uc.a.run.app/card-data/generate-image?color=$dominantColor');
      return (response.data as Uint8List);
    } catch (_) {
      return null;
    }
  }

  FutureOr<void> createBrandEvent(
      CreateBrandEvent event, Emitter<AgentSignUpPageState> emit) async {
    emit(CreatingBrandState());
    final result = await insertBrandUseCase(brand: event.brand);
    await result.fold((l) {
      Navigator.pop(event.context);
      ToastManager(Toast(
              title: "some error occurred", type: ToastificationType.error))
          .show(event.context);
      emit(BandCreationErrorState());
    }, (r) async {
      Navigator.pop(event.context);
      ToastManager(Toast(
              title: "Brand created successfully!",
              type: ToastificationType.success))
          .show(event.context);
      final brandLocations = event.locations
          .map((e) => BrandLocation(
              brandId: r,
              registeredBy: AppLocalStorage.user!.hushhId!,
              location: 'POINT(${e.longitude} ${e.latitude})'))
          .toList();
      Navigator.pop(event.context);
      Brand brand = event.brand;
      brand.id = r;
      newlyCreatedSelectedBrand = brand;
      sl<CardMarketBloc>().add(InsertBrandLocationsEvent(brandLocations));
      // add(CreateNewBrandCardEvent(brand, r, event.context));
      sl<CardMarketBloc>().add(FetchBrandsEvent());
      emit(BrandCreatedState());
    });
  }

  FutureOr<void> fetchBrandCategoriesEvent(FetchBrandCategoriesEvent event,
      Emitter<AgentSignUpPageState> emit) async {
    emit(FetchingAllBrandCategoriesState());
    final result = await fetchBrandCategoriesUseCase();
    result.fold((l) {}, (r) {
      brandCategories = r;
      emit(AllBrandCategoriesFetchedState());
    });
  }

  FutureOr<void> agentSignUpEvent(
      AgentSignUpEvent event, Emitter<AgentSignUpPageState> emit) async {
    final user = event.user;

    if (selectedBrand == null) return;
    // final reference = FirebaseStorage.instance
    //     .ref()
    //     .child('agent_profiles/${AppLocalStorage.hushhId}.$agentImageExt');
    // await reference.putData(agentProfileImageBytes!);
    // final uri = await reference.getDownloadURL();
    const agentRole = AgentRole.Admin;
        // selectedBrand!.isClaimed ? AgentRole.SalesAgent : AgentRole.Admin;
    bool isAgentDocumentApproved =
        false; // todo: add api logic result to determine if the document is approved

    AgentModel agent = AgentModel(
        agentWorkEmail: user.email,
        agentImage: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQABqQIdskCD9BK0I81EbVfV9tTz320XvJ35A&s',//, uri,
        hushhId: user.hushhId,
        agentName: user.name,
        agentBrandId: selectedBrand!.id!,
        agentDesc: descController.text,
        agentCategories: selectedCategories,
        agentCoins: 0,
        agentCard: newlyCreatedCard,
        agentApprovalStatus: null);

    if(lastKnownLocation != null) {
      insertUserAgentLocationUseCase(
        location: LocationModel(
            location:
                'POINT(${lastKnownLocation!.latitude} ${lastKnownLocation!.longitude})',
            createdAt: DateTime.now(),
            hushhId: user.hushhId!));
    }

    await insertAgentUseCase(agent: agent).then((value) {
      value.fold((l) => null, (r) async {
        AppLocalStorage.updateAgent(agent);
        insertAgentRoleUseCase(
            brandId: selectedBrand!.id!,
            hushhId: user.hushhId!,
            status: selectedBrand!.domain == null
                ? AgentApprovalStatus.approved
                : AgentApprovalStatus.pending,
            agentRole: agentRole);
        final result = await fetchAgentsUseCase(uid: user.hushhId);
        result.fold((l) => null, (r) {
          if (r.isNotEmpty) {
            AppLocalStorage.updateAgent(r.first);
          }
        });
        Navigator.pop(event.context);
        AppLocalStorage.updateUserOnboardingStatus(UserOnboardStatus.loggedIn);
        clearAndReinitializeDependencies().then((value) {
          Navigator.pushNamedAndRemoveUntil(
              event.context, AppRoutes.splash, (route) => false);
        });
      });
    });
  }

  FutureOr<void> createNewBrandCardEvent(
      CreateNewBrandCardEvent event, Emitter<AgentSignUpPageState> emit) async {
    String? bodyImageUrl =
        await generateCardBodyImageUrl(event.brand.brandLogo);

    CardModel brandCard = CardModel(
        brandName: event.brand.brandName,
        image: event.brand.brandLogo,
        category: brandCategories
                .firstWhereOrNull(
                    (element) => element.id == event.brand.brandCategoryId)
                ?.brandCategory ??
            'N/A',
        type: 1,
        featured: 1,
        logo: event.brand.brandLogo,
        brandId: event.brandId,
        domain: event.brand.domain,
        bodyImage: bodyImageUrl);
    sl<CardMarketBloc>().add(InsertCardEvent(brandCard, event.context, afterInsertingCardSignUpAgent: event.signUp, brand: event.brand));
  }

  FutureOr<void> checkIfCardIsCreatedElseCreateNewBrandCardEvent(
      CheckIfCardIsCreatedElseCreateNewBrandCardEvent event,
      Emitter<AgentSignUpPageState> emit) async {
    emit(CheckingIfCardExistsInCardMarketState());
    Utils().showLoader(event.context);
    final result = await cardExistsUseCase(id: event.brand.id!);
    result.fold((l) => null, (card) {
      if (card == null) {
        emit(CardDoesNotExistsInCardMarketState());
        add(CreateNewBrandCardEvent(
            event.brand, event.brand.id!, event.context, signUp: true));
      } else {
        newlyCreatedCard = card;
        selectedBrand = event.brand;
        add(AgentSignUpEvent(AppLocalStorage.user!, event.context));
        emit(CardExistsInCardMarketState());
      }
    });
  }

  FutureOr<void> generateNewTxtRecordEvent(GenerateNewTxtRecordEvent event,
      Emitter<AgentSignUpPageState> emit) async {
    String generateHushhTxtRecord({
      required String domain,
      required String companyName,
      DateTime? issuedDate,
      String? verificationId,
    }) {
      // Helper function to format DateTime to 'YYYY-MM-DD'
      String formatDate(DateTime date) {
        return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      }

      // Helper function to generate random alphanumeric string
      String generateRandomString(int length) {
        const chars =
            'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        Random random = Random();
        return List.generate(
            length, (index) => chars[random.nextInt(chars.length)]).join();
      }

      // Set defaults for issuedDate and verificationId if not provided
      DateTime issued = issuedDate ?? DateTime.now();
      String id = verificationId ?? generateRandomString(10);
      DateTime validUntil = issued.add(Duration(days: 2));

      return 'hushh-verification=$domain; '
          'company-name=$companyName; '
          'verification-id=$id; '
          'issued-date=${formatDate(issued)}; '
          'valid-until=${formatDate(validUntil)}';
    }

    if (selectedBrand != null) {
      if (selectedBrand?.domain == null) {
        add(AgentSignUpEvent(AppLocalStorage.user!, event.context));
      } else {
        generateHushhTxtRecord(
            companyName: selectedBrand!.brandName,
            domain: selectedBrand!.domain!);
      }
    }
  }

  Future<void> onBrandClaim(Brand brand, context,
      [bool? bottomSheetOpened = false]) async {
    if(bottomSheetOpened == false) {
      bottomSheetOpened = await showModalBottomSheet(
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(maxHeight: 30.h),
      context: context,
      builder: (_) {
        return ClaimBrandBottomSheet(
            brandName: brand.brandName,
            onDeny: () {
              Navigator.pop(context, false);
            },
            onClaim: () {
              add(CheckIfCardIsCreatedElseCreateNewBrandCardEvent(
                  brand, context));
              Navigator.pop(context, true);
            });
      },
    );
    }
    // if (bottomSheetOpened == true) {
    // selectedBrand = brand;
    // add(AgentSignUpEvent(AppLocalStorage.user!, context));
      // if (brand.domain == null) {
      //   add(AgentSignUpEvent(AppLocalStorage.user!, context));
      // } else {
      //   sl<SignUpPageBloc>().userGuideController.next();
      // }
    // }
  }

  void handleDomainExists(BuildContext context) {
    // todo: add email verification logic
    add(AgentSignUpEvent(AppLocalStorage.user!, context));
  }
}
