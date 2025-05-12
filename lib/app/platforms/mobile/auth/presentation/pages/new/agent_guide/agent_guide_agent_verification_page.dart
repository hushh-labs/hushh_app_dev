import 'package:dotted_border/dotted_border.dart';
import 'package:fadingpageview/fadingpageview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/agent_sign_up_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/sign_up_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/components/verifying_bottomsheet.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/bloc/card_market_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/agent_text_field.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AgentGuideAgentVerificationPage extends StatefulWidget {
  const AgentGuideAgentVerificationPage({super.key});

  @override
  State<AgentGuideAgentVerificationPage> createState() =>
      _AgentGuideAgentVerificationPageState();
}

class _AgentGuideAgentVerificationPageState
    extends State<AgentGuideAgentVerificationPage> {
  FadingPageViewController get scrollController =>
      sl<SignUpPageBloc>().userGuideController;

  int get totalPages => sl<SignUpPageBloc>().totalPages;

  final TextEditingController _panController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  TextInputType _currentKeyboardType = TextInputType.text;
  bool isBottomSheetOpened = false;

  @override
  void initState() {
    super.initState();
    if (AppLocalStorage.user == null) {
      sl<SignUpPageBloc>().add(
          SignUpEvent(context, onboardStatus: UserOnboardStatus.signUpForm));
    }
    _panController.addListener(_onPanChanged);
  }

  @override
  void dispose() {
    _panController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onPanChanged() {
    final text = _panController.text;
    // Change keyboard type based on input length
    if (text.length < 5) {
      _updateKeyboard(TextInputType.text); // For letters A to Z
    } else if (text.length < 9) {
      _updateKeyboard(TextInputType.number); // For digits 0 to 9
    } else if (text.length == 9) {
      _updateKeyboard(TextInputType.text); // For the last letter
    }
  }

  void _updateKeyboard(TextInputType newType) {
    if (_currentKeyboardType != newType) {
      setState(() {
        _currentKeyboardType = newType;
      });
      // Unfocus and refocus to update the keyboard
      _focusNode.unfocus();
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child:
                      Text('${scrollController.currentPage} of $totalPages'),
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
              'Agent Identity Verification',
              style: context.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 0.8),
            ),
            const SizedBox(height: 26),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                height: 20.h,
                child: Stack(
                  children: [
                    InkWell(
                      onTap: () => uploadImage(ImageSource.camera),
                      borderRadius: BorderRadius.circular(8),
                      child: DottedBorder(
                          borderType: BorderType.RRect,
                          strokeWidth: 1,
                          dashPattern: const [8],
                          color: const Color(0xFFE54D60),
                          radius: const Radius.circular(8),
                          child: sl<AgentSignUpPageBloc>().agentIdCardBytes ==
                                  null
                              ? Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        'assets/agent_id_card.png',
                                        color: const Color(0xFFE54D60)
                                            .withOpacity(0.5),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('UPLOAD',
                                              style: context.bodyLarge
                                                  ?.copyWith(
                                                      color: const Color(
                                                          0xFFE54D60))),
                                          const SizedBox(width: 2),
                                          const Icon(
                                            Icons.upload_outlined,
                                            size: 20,
                                            color: Color(0xFFE54D60),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              : Center(
                                  child: Image.memory(
                                      sl<AgentSignUpPageBloc>()
                                          .agentIdCardBytes!))),
                    ),
                    if (sl<AgentSignUpPageBloc>().agentIdCardBytes != null)
                      Align(
                        alignment: const Alignment(1.08, -1.18),
                        child: InkWell(
                          onTap: () {
                            sl<AgentSignUpPageBloc>().agentIdCardBytes = null;
                            setState(() {});
                          },
                          child: const CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'AGENT IDENTITY CARD',
                style: context.bodySmall?.copyWith(
                  color: const Color(0xFF737373),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.3,
                ),
              ),
            ),
            const SizedBox(height: 36),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                'PAN NUMBER*',
                style: context.titleSmall?.copyWith(
                  color: const Color(0xFF737373),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.3,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: AgentTextField(
                addBelowPadding: false,
                controller: _panController,
                focusNode: _focusNode,
                textInputType: _currentKeyboardType,
                onChanged: (_) => setState(() {}),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                  PanInputFormatter(),
                  LengthLimitingTextInputFormatter(10)
                ],
                fieldType: CustomFormType.text,
                hintText: 'eg. AAAMP1331D',
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                'FULL NAME ON PAN*',
                style: context.titleSmall?.copyWith(
                  color: const Color(0xFF737373),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.3,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: AgentTextField(
                addBelowPadding: false,
                controller: _nameController,
                inputFormatters: [UpperCaseTextFormatter()],
                fieldType: CustomFormType.text,
                onChanged: (_) => setState(() {}),
                textInputType: TextInputType.name,
                hintText: 'eg. RAHUL SHARMA',
              ),
            ),
            HushhLinearGradientButton(
              text: 'Verify Identity',
              height: 48,
              enabled: _panController.text.trim().isNotEmpty &&
                  _nameController.text.trim().isNotEmpty,
              // sl<AgentSignUpPageBloc>().agentIdCardBytes != null,
              onTap: () async {
                Future.delayed(const Duration(seconds: 4), () {
                  if (isBottomSheetOpened) {
                    Navigator.pop(context);
                  }
                  final email = AppLocalStorage.user?.email;
                  if (email != null &&
                      (sl<CardMarketBloc>().brands?.any((element) =>
                              element.domain == email.split('@')[1]) ??
                          false)) {
                    final brand = sl<CardMarketBloc>().brands!.firstWhere(
                        (element) => element.domain == email.split('@')[1]);
                    sl<AgentSignUpPageBloc>()
                        .onBrandClaim(brand, context, true);
                  } else {
                    scrollController.next();
                  }
                });
                isBottomSheetOpened = true;
                await showModalBottomSheet(
                    context: context,
                    isDismissible: false,
                    enableDrag: false,
                    backgroundColor: Colors.transparent,
                    constraints: BoxConstraints(maxHeight: 30.h),
                    builder: (context) => const VerifyingBottomSheet());
                isBottomSheetOpened = false;
              },
              radius: 6,
            ),
            const SizedBox(height: 32)
          ],
        ),
      ),
    );
  }

  uploadImage(ImageSource source) async {
    final result = await ImagePicker().pickImage(
        imageQuality: 60,
        maxWidth: 1440,
        source: source,
        preferredCameraDevice: CameraDevice.front);
    if (result != null) {
      Uint8List bytes = await result.readAsBytes();
      sl<AgentSignUpPageBloc>().agentIdCardBytes = bytes;
      setState(() {});
    }
  }
}

class PanInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.toUpperCase();
    if (text.length <= 5) {
      return TextEditingValue(text: text.replaceAll(RegExp(r'[^A-Z]'), ''));
    } else if (text.length <= 9) {
      return TextEditingValue(text: text.replaceAll(RegExp(r'[^A-Z0-9]'), ''));
    } else if (text.length == 10) {
      return TextEditingValue(
          text: text.replaceAll(RegExp(r'[^A-Z0-9]'), '').substring(0, 10));
    }
    return newValue;
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
