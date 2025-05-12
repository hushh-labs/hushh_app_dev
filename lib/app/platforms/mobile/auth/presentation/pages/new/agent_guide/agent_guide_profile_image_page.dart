import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:fadingpageview/fadingpageview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/agent_sign_up_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/sign_up_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
import 'package:hushh_app/app/shared/core/components/hushh_secondary_button.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AgentGuideProfileImagePage extends StatefulWidget {
  const AgentGuideProfileImagePage({super.key});

  @override
  State<AgentGuideProfileImagePage> createState() =>
      _AgentGuideProfileImagePageState();
}

class _AgentGuideProfileImagePageState extends State<AgentGuideProfileImagePage> {
  FadingPageViewController get scrollController =>
      sl<SignUpPageBloc>().userGuideController;

  int get totalPages => sl<SignUpPageBloc>().totalPages;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('${scrollController.currentPage} of $totalPages'),
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
              'Upload your Profile Image',
              style: context.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 0.8),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                'FILE PREVIEW',
                style: context.titleSmall?.copyWith(
                  color: const Color(0xFF737373),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.3,
                ),
              ),
            ),
            const SizedBox(height: 46),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                height: 20.h,
                child: GestureDetector(
                  onTap: () async {},
                  child: BlocBuilder(
                      bloc: sl<AgentSignUpPageBloc>(),
                      builder: (context, state) {
                        return DottedBorder(
                          borderType: BorderType.Circle,
                          strokeWidth: 1,
                          dashPattern: const [8],
                          color: const Color(0xFFE54D60),
                          // radius: const Radius.circular(8),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (sl<AgentSignUpPageBloc>()
                                        .agentProfileImageBytes ==
                                    null)
                                  Center(
                                    child: Icon(
                                      Icons.person,
                                      size: 24.w,
                                      color: const Color(0xFFE54D60)
                                          .withOpacity(0.5),
                                    ),
                                  )
                                else
                                  CircleAvatar(
                                      radius: (20.h / 2) * 0.8,
                                      backgroundImage: MemoryImage(
                                          sl<AgentSignUpPageBloc>()
                                              .agentProfileImageBytes!))
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ),
            const Spacer(),
            BlocBuilder(
                bloc: sl<AgentSignUpPageBloc>(),
                builder: (context, state) {
                  if (sl<AgentSignUpPageBloc>().agentProfileImageBytes != null) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HushhLinearGradientButton(
                          text: 'Continue',
                          height: 48,
                          onTap: () => scrollController.next(),
                          radius: 6,
                        ),
                        const SizedBox(height: 16),
                        HushhSecondaryButton(
                          text: 'Remove',
                          height: 48,
                          onTap: () => setState(() => sl<AgentSignUpPageBloc>()
                              .agentProfileImageBytes = null),
                          radius: 6,
                        ),
                      ],
                    );
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HushhLinearGradientButton(
                        text: 'Capture Image',
                        height: 48,
                        onTap: () => sl<AgentSignUpPageBloc>().add(const CaptureImageEvent(ImageSource.camera)),
                        radius: 6,
                      ),
                      const SizedBox(height: 16),
                      HushhSecondaryButton(
                        text: 'Upload Image',
                        height: 48,
                        onTap: () => sl<AgentSignUpPageBloc>().add(const CaptureImageEvent(ImageSource.gallery)),
                        radius: 6,
                      ),
                    ],
                  );
                }),
            const SizedBox(height: 32)
          ],
        ),
      ),
    );
  }
}
