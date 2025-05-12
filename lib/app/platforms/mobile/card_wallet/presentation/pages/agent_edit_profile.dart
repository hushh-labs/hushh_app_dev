import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/agent.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/agent_sign_up_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/agent_text_field.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AgentEditProfilePage extends StatefulWidget {
  const AgentEditProfilePage({super.key});

  @override
  State<AgentEditProfilePage> createState() => _AgentEditProfilePageState();
}

class _AgentEditProfilePageState extends State<AgentEditProfilePage> {
  final controller = sl<AgentSignUpPageBloc>();

  loadData() {
    Future.delayed(Duration.zero, () {
      final agent = ModalRoute.of(context)!.settings.arguments as AgentModel;
      controller.nameController.text = agent.agentName!;
      controller.emailController.text = agent.agentWorkEmail!;
      controller.descController.text = agent.agentDesc!;
      controller.agentProfileImageBytes = null;
      setState(() {});
    });
  }

  @override
  void initState() {
    /*controller.add(FetchCategoriesEvent());
    controller.add(FetchBrandsEvent());*/
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final agent = ModalRoute.of(context)!.settings.arguments as AgentModel;
    return BlocBuilder(
        bloc: sl<AgentSignUpPageBloc>(),
        builder: (context, state) {
          return Scaffold(
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
              centerTitle: true,
              title: const Text(
                'Edit Profile',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 56,
                child: HushhLinearGradientButton(
                  text: 'Update',
                  enabled: true,
                  onTap: () {
                    controller.add(UpdateAgentEvent(context));
                  },
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    Stack(
                      children: [
                        BlocBuilder(
                            bloc: controller,
                            builder: (context, state) {
                              return GestureDetector(
                                onTap: () {
                                  controller.add(const CaptureImageEvent(
                                      ImageSource.gallery));
                                },
                                child: CircleAvatar(
                                  radius: 12.w,
                                  backgroundImage:
                                      (controller.agentProfileImageBytes == null
                                          ? CachedNetworkImageProvider(
                                              agent.agentImage!)
                                          : MemoryImage(controller
                                                  .agentProfileImageBytes!)
                                              as ImageProvider),
                                ),
                              );
                            }),
                        Positioned(
                          right: 4,
                          bottom: 4,
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(colors: [
                                Color(0XFFA342FF),
                                Color(0XFFE54D60),
                              ]),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Icon(
                                Icons.camera_alt,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 24),
                    AgentTextField(
                        isAuthTextField: true,
                        controller: controller.nameController,
                        onChanged: (_) => setState(() {}),
                        fieldType: CustomFormType.text,
                        hintText: "Enter name"),
                    AgentTextField(
                        isAuthTextField: true,
                        textInputType: TextInputType.emailAddress,
                        onChanged: (_) => setState(() {}),
                        controller: controller.emailController,
                        fieldType: CustomFormType.text,
                        hintText: "Email"),
                    AgentTextField(
                        isAuthTextField: true,
                        maxLines: 4,
                        controller: controller.descController,
                        onChanged: (_) => setState(() {}),
                        fieldType: CustomFormType.text,
                        hintText: "Add Description"),
                    const SizedBox(height: 120)
                  ],
                ),
              ),
            ),
          );
        });
  }
}
