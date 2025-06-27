// app/platforms/mobile/auth/presentation/pages/new/user_guide/user_guide_question_page.dart
import 'dart:io';

import 'package:animated_checkmark/animated_checkmark.dart';
import 'package:fadingpageview/fadingpageview.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_validator/form_validator.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/agent_sign_up_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/auth_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/sign_up_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/components/country_code_text_field.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/pages/agent_categories.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/pages/new/user_guide/coin_page.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/components/custom_camera_page.dart';
import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
import 'package:hushh_app/app/shared/core/components/hushh_secondary_button.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:vibration/vibration.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class UserGuideQuestionPage extends StatefulWidget {
  final UserGuideQuestionType question;
  final MultiChoiceQuestions? multiChoiceQuestion;

  const UserGuideQuestionPage(
      {super.key, required this.question, this.multiChoiceQuestion});

  @override
  State<UserGuideQuestionPage> createState() => _UserGuideQuestionPageState();
}

class _UserGuideQuestionPageState extends State<UserGuideQuestionPage> {
  final _formKey = GlobalKey<FormState>();
  bool isVideoUploading = false;
  String? videoLocalPath;
  int? selectedIndex;
  List<int> selectedIndices = [];

  FadingPageViewController get scrollController =>
      sl<SignUpPageBloc>().userGuideController;

  int get totalPages => sl<SignUpPageBloc>().totalPages;

  bool get shouldRecord =>
      widget.question == UserGuideQuestionType.record &&
      sl<SignUpPageBloc>().recordedVideoUrl == null;

  bool get isPhoneNumber =>
      widget.question == UserGuideQuestionType.emailOrPhone &&
      !sl<AuthPageBloc>().isPhoneLogin;

  bool get isEmail =>
      widget.question == UserGuideQuestionType.emailOrPhone &&
      sl<AuthPageBloc>().isPhoneLogin;

  bool get isName => widget.question == UserGuideQuestionType.name;

  bool get isMultiChoiceQuestion =>
      widget.question == UserGuideQuestionType.multiChoiceQuestion;

  bool get canSelectMultipleOptions =>
      widget.multiChoiceQuestion! == MultiChoiceQuestions.whyInstallHushh;

  bool get isUserFlow => sl<HomePageBloc>().isUserFlow;

  String get title {
    switch (widget.question) {
      case UserGuideQuestionType.name:
        return "What's your name?";
      case UserGuideQuestionType.emailOrPhone:
        return sl<AuthPageBloc>().isPhoneLogin ? 'Enter Email' : 'Enter Number';
      case UserGuideQuestionType.multiChoiceQuestion:
        return getMultiChoiceQuestionTitle(widget.multiChoiceQuestion!);
      case UserGuideQuestionType.dob:
        return 'Enter your Date of Birth 🎂';
      case UserGuideQuestionType.categories:
        return isUserFlow
            ? 'What product categories are you most interested in?'
            : 'What product categories you deal in?';
      case UserGuideQuestionType.record:
        return 'Record Video';
      default:
        return '';
    }
  }

  String get hintText {
    switch (widget.question) {
      case UserGuideQuestionType.name:
        return 'Your name';
      case UserGuideQuestionType.emailOrPhone:
        return sl<AuthPageBloc>().isPhoneLogin ? 'Your Email' : 'Your Number';
      case UserGuideQuestionType.multiChoiceQuestion:
        return 'Select one';
      case UserGuideQuestionType.dob:
        return 'Your Date Of Birth';
      case UserGuideQuestionType.categories:
        return isUserFlow
            ? 'Select up to three categories'
            : 'Select categories';
      case UserGuideQuestionType.record:
        return 'Add an intro video for people to see';
    }
  }

  String? validator(String? value) {
    String? Function(String?)? validate;
    switch (widget.question) {
      case UserGuideQuestionType.name:
        validate = ValidationBuilder().minLength(3).build();
      case UserGuideQuestionType.emailOrPhone:
        validate = sl<AuthPageBloc>().isPhoneLogin
            ? ValidationBuilder().email().build()
            : ValidationBuilder().phone().build();
      default:
        validate = null;
    }
    return validate?.call(value);
  }

  TextEditingController? get controller {
    switch (widget.question) {
      case UserGuideQuestionType.name:
        return sl<SignUpPageBloc>().firstNameController;
      case UserGuideQuestionType.emailOrPhone:
        return sl<SignUpPageBloc>().emailOrPhoneController;
      case UserGuideQuestionType.dob:
        return sl<SignUpPageBloc>().dobController;
      case UserGuideQuestionType.record:
        return TextEditingController();
      default:
        return null;
    }
  }

  @override
  void initState() {
    if (controller?.text.trim().isEmpty ?? false) {
      controller?.clear();
    }
    if (sl<AgentSignUpPageBloc>().allCategorySections.isEmpty) {
      sl<AgentSignUpPageBloc>().add(FetchCategoriesEvent());
    }
    
    // Auto-skip logic for Apple Sign-In users
    final tempUser = AppLocalStorage.tempUser;
    final isAppleSignIn = tempUser?.isAppleSignIn == true;
    
    if (isAppleSignIn) {
      // Auto-skip name step if Apple provided name
      if (isName && tempUser?.name != null && tempUser!.name!.isNotEmpty) {
        print('🍎 [USER_GUIDE] Auto-skipping name step - Apple provided: ${tempUser.name}');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          sl<SignUpPageBloc>().add(OnNextUserGuideClickedEvent(
            isValidated: true,
            question: widget.question,
            context: context,
          ));
        });
        super.initState();
        return;
      }
      
      // Auto-skip email step if Apple provided email
      if (isEmail && tempUser?.email != null && tempUser!.email!.isNotEmpty) {
        print('🍎 [USER_GUIDE] Auto-skipping email step - Apple provided: ${tempUser.email}');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          sl<SignUpPageBloc>().add(OnNextUserGuideClickedEvent(
            isValidated: true,
            question: widget.question,
            context: context,
          ));
        });
        super.initState();
        return;
      }
    }
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(height: 26),
            Text(
              title,
              style: context.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 0.8),
            ),
            if (widget.question == UserGuideQuestionType.record)
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 100),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Introduce yourself! Tell us about your interests, likes, and dislikes—this helps us get to know your style and preferences better.',
                    style: context.bodyLarge
                        ?.copyWith(color: const Color(0xFF4C4C4C)),
                  ),
                ),
              )
            else if (!isMultiChoiceQuestion)
              Row(
                children: [
                  if (isPhoneNumber)
                    const Flexible(child: CountryCodeTextField(onlyCode: true)),
                  Flexible(
                    flex: 3,
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        style:
                            context.headlineSmall?.copyWith(letterSpacing: 0.4),
                        validator: (value) => validator(value),
                        readOnly: (widget.question ==
                                UserGuideQuestionType.record ||
                            widget.question == UserGuideQuestionType.dob ||
                            (isName && controller?.text.isNotEmpty == true) ||
                            (isEmail && controller?.text.isNotEmpty == true)),
                        controller: controller,
                        keyboardType: isPhoneNumber
                            ? TextInputType.number
                            : isEmail
                                ? TextInputType.emailAddress
                                : isName
                                    ? TextInputType.name
                                    : null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintMaxLines: 2,
                          hintStyle: context.headlineSmall?.copyWith(
                              color: Colors.grey, letterSpacing: 0.4),
                          hintText: hintText,
                          filled: (isName &&
                                  controller?.text.isNotEmpty == true) ||
                              (isEmail && controller?.text.isNotEmpty == true),
                          fillColor: ((isName &&
                                      controller?.text.isNotEmpty == true) ||
                                  (isEmail &&
                                      controller?.text.isNotEmpty == true))
                              ? Colors.grey.shade200
                              : null,
                          suffixIcon: ((isName &&
                                      controller?.text.isNotEmpty == true) ||
                                  (isEmail &&
                                      controller?.text.isNotEmpty == true))
                              ? Icon(Icons.lock, color: Colors.grey)
                              : null,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  hintText,
                  style: context.bodyLarge
                      ?.copyWith(color: const Color(0xFF4C4C4C)),
                ),
              ),
            if (isMultiChoiceQuestion)
              Expanded(
                child: canSelectMultipleOptions
                    ? MultiSelectChoiceQuestion(
                        questions: getMultipleChoiceQuestionOptions(
                            widget.multiChoiceQuestion!),
                        selectedIndices: selectedIndices,
                        onSelectionChanged: (indices) {
                          setState(() {
                            selectedIndices = selectedIndices;
                          });
                        })
                    : MultiChoiceQuestion(
                        questions: getMultipleChoiceQuestionOptions(
                            widget.multiChoiceQuestion!),
                        selectedIndex: selectedIndex,
                        onTap: (index) {
                          setState(() {
                            selectedIndex = index;
                          });
                        }),
              )
            else if (widget.question == UserGuideQuestionType.dob)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SfDateRangePicker(
                  onSelectionChanged: (args) {
                    sl<SignUpPageBloc>().birthDatePicker =
                        args.value as DateTime;
                  },
                ),
              )
            else if (widget.question == UserGuideQuestionType.categories)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: isUserFlow ? 16.0 : 0),
                  child: CategoriesView(hideSearch: isUserFlow),
                ),
              )
            else if (widget.question != UserGuideQuestionType.record)
              const Spacer()
            else
              Expanded(
                  child: Center(
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (videoLocalPath != null) {
                          OpenFilex.open(videoLocalPath!);
                        }
                      },
                      child: AspectRatio(
                        aspectRatio: .7,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 32),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: (sl<SignUpPageBloc>()
                                              .recordedVideoImageData ==
                                          null
                                      ? const AssetImage(
                                          'assets/video-banner.png')
                                      : MemoryImage(sl<SignUpPageBloc>()
                                              .recordedVideoImageData!)
                                          as ImageProvider))),
                          child: Center(
                            child: SvgPicture.asset('assets/play-icon.svg'),
                          ),
                        ),
                      ),
                    ),
                    if (videoLocalPath != null)
                      SizedBox(
                        width: 60.w,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: IconButton(
                                onPressed: () {
                                  sl<SignUpPageBloc>().recordedVideoUrl = null;
                                  sl<SignUpPageBloc>().recordedVideoImageData =
                                      null;
                                  videoLocalPath = null;
                                  setState(() {});
                                },
                                style: IconButton.styleFrom(
                                    backgroundColor: Colors.white),
                                icon: const Icon(
                                  Icons.delete_outline_outlined,
                                  color: Colors.red,
                                )),
                          ),
                        ),
                      )
                  ],
                ),
              )),
            if (widget.question == UserGuideQuestionType.dob) const Spacer(),
            BlocBuilder(
                bloc: sl<AgentSignUpPageBloc>(),
                builder: (context, state) {
                  return BlocBuilder(
                    bloc: sl<SignUpPageBloc>(),
                    builder: (context, state) => HushhLinearGradientButton(
                      text: shouldRecord ? 'Record Video' : 'Next',
                      enabled: isMultiChoiceQuestion
                          ? (selectedIndex != null ||
                              selectedIndices.isNotEmpty)
                          : widget.question == UserGuideQuestionType.categories
                              ? (sl<AgentSignUpPageBloc>()
                                  .selectedCategories
                                  .isNotEmpty)
                              : true,
                      loader: state is GoingToNextPageState ||
                          state is SigningUpState ||
                          isVideoUploading,
                      height: 48,
                      onTap: () async {
                        if (shouldRecord) {
                          final path = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CustomCameraPage()));
                          if (path != null) {
                            videoLocalPath = path;
                            isVideoUploading = true;
                            setState(() {});
                            FirebaseStorage storageInc =
                                FirebaseStorage.instanceFor(
                                    bucket: "gs://hushone-app.appspot.com");
                            Reference ref = storageInc.ref().child(
                                "user/videos/${DateTime.now().toIso8601String()}.mp4");
                            UploadTask task = ref.putFile(File(path));
                            String url =
                                await (await task.whenComplete(() => null))
                                    .ref
                                    .getDownloadURL();
                            sl<SignUpPageBloc>().recordedVideoUrl = url;
                            sl<SignUpPageBloc>().recordedVideoImageData =
                                await VideoThumbnail.thumbnailData(
                              video: path,
                              imageFormat: ImageFormat.PNG,
                              quality: 100,
                            );
                            isVideoUploading = false;
                            // ignore: use_build_context_synchronously
                            ToastManager(
                                    Toast(title: 'Video uploaded successfully'))
                                .show(context);
                            setState(() {});
                          }
                        } else {
                          bool isValidated = isMultiChoiceQuestion
                              ? (selectedIndex != null ||
                                  selectedIndices.isNotEmpty)
                              : _formKey.currentState?.validate() ?? false;
                          if (isValidated && isMultiChoiceQuestion) {
                            switch (widget.multiChoiceQuestion!) {
                              case MultiChoiceQuestions.whatGender:
                                sl<SignUpPageBloc>().selectedGender =
                                    getMultipleChoiceQuestionOptions(widget
                                        .multiChoiceQuestion!)[selectedIndex!];
                                break;
                              case MultiChoiceQuestions.whyInstallHushh:
                                sl<SignUpPageBloc>()
                                        .selectedReasonForUsingHushh =
                                    selectedIndices
                                        .map((e) =>
                                            getMultipleChoiceQuestionOptions(
                                                widget.multiChoiceQuestion!)[e])
                                        .toList()
                                        .join(",");
                                break;
                            }
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.bottomToTop,
                                    duration: const Duration(milliseconds: 300),
                                    child: CoinPage(
                                      id: 'coins-[${widget.multiChoiceQuestion?.name}]',
                                      coins: 5,
                                    )));
                            Future.delayed(const Duration(milliseconds: 50),
                                () {
                              AudioPlayer()
                                ..setAsset('assets/cha_ching.mp3')
                                ..play();
                            });
                            Future.delayed(const Duration(milliseconds: 500),
                                () async {
                              if ((await Vibration.hasVibrator()) ?? false) {
                                Vibration.vibrate();
                              }
                              sl<SignUpPageBloc>().add(
                                  OnNextUserGuideClickedEvent(
                                      isValidated: isValidated,
                                      question: widget.question,
                                      context: context));
                            });
                          } else {
                            sl<SignUpPageBloc>().add(
                                OnNextUserGuideClickedEvent(
                                    isValidated: isValidated,
                                    question: widget.question,
                                    context: context));
                          }
                        }
                      },
                      radius: 6,
                    ),
                  );
                }),
            if (widget.question == UserGuideQuestionType.record) ...[
              const SizedBox(height: 16),
              HushhSecondaryButton(
                text: 'Skip',
                height: 42,
                onTap: () {
                  sl<SignUpPageBloc>().add(OnNextUserGuideClickedEvent(
                      isValidated: true,
                      question: widget.question,
                      context: context));
                },
                radius: 6,
              ),
            ],
            const SizedBox(height: 32)
          ],
        ),
      ),
    );
  }

  String getMultiChoiceQuestionTitle(MultiChoiceQuestions multiChoiceQuestion) {
    switch (multiChoiceQuestion) {
      case MultiChoiceQuestions.whyInstallHushh:
        return "How do you plan on using your wallet?";
      case MultiChoiceQuestions.whatGender:
        return "Which gender identity do you most closely identify with?";
    }
  }

  List<String> getMultipleChoiceQuestionOptions(
      MultiChoiceQuestions multiChoiceQuestion) {
    switch (multiChoiceQuestion) {
      case MultiChoiceQuestions.whyInstallHushh:
        return [
          'Tracking my expenses',
          'Sell my data and earn money',
          'Enahance the shopping experience'
        ];
      case MultiChoiceQuestions.whatGender:
        return [
          'Male',
          'Female',
          'Non-Binary',
          'Transgender',
          'Genderqueer',
          'Agender',
          'Other',
        ];
    }
  }
}

class MultiChoiceQuestion extends StatefulWidget {
  final List<String> questions;
  final int? selectedIndex;
  final Function(int) onTap;

  const MultiChoiceQuestion(
      {super.key,
      required this.questions,
      this.selectedIndex,
      required this.onTap});

  @override
  State<MultiChoiceQuestion> createState() => _MultiChoiceQuestionState();
}

class _MultiChoiceQuestionState extends State<MultiChoiceQuestion> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    List<String> alphabets =
        List.generate(26, (index) => String.fromCharCode(index + 65));
    return Padding(
      padding: EdgeInsets.only(top: 4.h),
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(widget.questions.length, (index) {
            Color color = index == widget.selectedIndex
                ? const Color(0xFF1980E5)
                : const Color(0xFFF5F5F5);
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Material(
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    widget.onTap(index);
                    isChecked = false;
                    Future.delayed(const Duration(milliseconds: 100), () {
                      isChecked = true;
                      setState(() {});
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                        color: color, borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      children: [
                        if (index == widget.selectedIndex)
                          Checkmark(
                              checked: isChecked,
                              indeterminate: false,
                              size: 16,
                              weight: 1.4,
                              color: Colors.white)
                        else
                          Text('${alphabets[index].toUpperCase()}.',
                              style: context.titleMedium?.copyWith(
                                  color: Utils().getTextColor(color))),
                        const SizedBox(width: 10),
                        Text(
                          widget.questions[index],
                          style: context.titleMedium
                              ?.copyWith(color: Utils().getTextColor(color)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class MultiSelectChoiceQuestion extends StatefulWidget {
  final List<String> questions;
  final List<int> selectedIndices;
  final Function(List<int>) onSelectionChanged;

  const MultiSelectChoiceQuestion({
    Key? key,
    required this.questions,
    required this.selectedIndices,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  State<MultiSelectChoiceQuestion> createState() =>
      _MultiSelectChoiceQuestionState();
}

class _MultiSelectChoiceQuestionState extends State<MultiSelectChoiceQuestion> {
  late List<bool> _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = List.generate(widget.questions.length, (index) => false);
    _updateCheckedState();
  }

  void _updateCheckedState() {
    for (int index in widget.selectedIndices) {
      _isChecked[index] = true;
    }
  }

  @override
  void didUpdateWidget(MultiSelectChoiceQuestion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndices != widget.selectedIndices) {
      _updateCheckedState();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> alphabets =
        List.generate(26, (index) => String.fromCharCode(index + 65));
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(widget.questions.length, (index) {
            Color color = widget.selectedIndices.contains(index)
                ? const Color(0xFF1980E5)
                : const Color(0xFFF5F5F5);
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Material(
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    setState(() {
                      if (widget.selectedIndices.contains(index)) {
                        widget.selectedIndices.remove(index);
                        _isChecked[index] = false;
                      } else {
                        widget.selectedIndices.add(index);
                        _isChecked[index] = true;
                      }
                      widget.onSelectionChanged(widget.selectedIndices);
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        if (widget.selectedIndices.contains(index))
                          Checkmark(
                            checked: _isChecked[index],
                            indeterminate: false,
                            size: 16,
                            weight: 1.4,
                            color: Colors.white,
                          )
                        else
                          Text(
                            '${alphabets[index].toUpperCase()}.',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Utils().getTextColor(color),
                                ),
                          ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.questions[index],
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Utils().getTextColor(color),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
