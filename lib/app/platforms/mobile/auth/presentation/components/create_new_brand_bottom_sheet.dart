import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/agent_sign_up_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/brand.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/agent_text_field.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/components/custom_map_picker.dart';
import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateBrandBottomSheet extends StatefulWidget {
  const CreateBrandBottomSheet({super.key});

  @override
  State<CreateBrandBottomSheet> createState() => _CreateBrandBottomSheetState();
}

class _CreateBrandBottomSheetState extends State<CreateBrandBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController brandNameController = TextEditingController();
  TextEditingController brandDomainController = TextEditingController();
  TextEditingController brandCategoryController = TextEditingController();
  int? selectedBrandCategoryId;
  XFile? _brandLogo;
  FocusNode focusNode = FocusNode();
  List<LatLng> locations = [];
  Timer? _debounce;
  String? websiteIcon;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickLogo() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _brandLogo = pickedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery
              .of(context)
              .viewInsets
              .bottom,
        ),
        child: Container(
          height: 80.h,
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 52,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text("Create New Brand",
                            style: context.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.8)),
                        const SizedBox(height: 26),
                        GestureDetector(
                          onTap: _pickLogo,
                          child: DottedBorder(
                            borderType: BorderType.Circle,
                            strokeWidth: 1,
                            dashPattern: const [8],
                            color: const Color(0xFFE54D60),
                            // radius: const Radius.circular(8),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_brandLogo == null)
                                    Center(
                                      child: Icon(
                                        Icons.add,
                                        size: 24.w,
                                        color: const Color(0xFFE54D60)
                                            .withOpacity(0.5),
                                      ),
                                    )
                                  else
                                    CircleAvatar(
                                        radius: (20.h / 2) * 0.8,
                                        backgroundImage:
                                        FileImage(File(_brandLogo!.path)))
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'BRAND NAME',
                            style: context.titleSmall?.copyWith(
                              color: const Color(0xFF737373),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        AgentTextField(
                          addBelowPadding: false,
                          controller: brandNameController,
                          fieldType: CustomFormType.text,
                          textInputType: TextInputType.name,
                          hintText: 'Brand name',
                          focusNode: focusNode,
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'BRAND CATEGORY',
                            style: context.titleSmall?.copyWith(
                              color: const Color(0xFF737373),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        BlocListener(
                          listener: (context, state) {
                            if (state is UpdatedBrandCategoryState) {
                              brandCategoryController.text =
                                  state.value.brandCategory;
                              selectedBrandCategoryId = state.value.id;
                              setState(() {});
                            }
                          },
                          bloc: sl<AgentSignUpPageBloc>(),
                          child: AgentTextField(
                            addBelowPadding: false,
                            controller: brandCategoryController,
                            fieldType: CustomFormType.list,
                            textInputType: TextInputType.name,
                            hintText: 'Brand category',
                            onTap: () {
                              sl<AgentSignUpPageBloc>()
                                  .add(UpdateBrandCategoryEvent(context));
                            },
                          ),
                        ),
                        const SizedBox(height: 26),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'BRAND LOCATION(s)',
                            style: context.titleSmall?.copyWith(
                              color: const Color(0xFF737373),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (locations.isEmpty)
                          InkWell(
                            onTap: addLocation,
                            borderRadius: BorderRadius.circular(8),
                            child: DottedBorder(
                                borderType: BorderType.RRect,
                                strokeWidth: 1,
                                dashPattern: const [8],
                                color: const Color(0xFFE54D60),
                                radius: const Radius.circular(8),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 32),
                                      const Icon(Icons.location_on_outlined,
                                          size: 36, color: Color(0xFFE54D60)),
                                      const SizedBox(height: 12),
                                      Text('Add Brand Location +',
                                          style: context.bodyLarge?.copyWith(
                                              color: const Color(0xFFE54D60))),
                                      const SizedBox(height: 32),
                                    ],
                                  ),
                                )),
                          )
                        else
                          GridView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: locations.length + 1,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 14,
                                  mainAxisSpacing: 14,
                                  crossAxisCount: 3),
                              itemBuilder: (context, index) {
                                if (index == locations.length) {
                                  return Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                            onPressed: addLocation,
                                            icon: const Icon(
                                              Icons.add,
                                              size: 46,
                                            )),
                                      ],
                                    ),
                                  );
                                }
                                return Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: FlutterMap(
                                        options: MapOptions(
                                            initialCenter:
                                            locations.elementAt(index),
                                            initialZoom: 16,
                                            interactionOptions:
                                            const InteractionOptions(
                                                flags: 0)),
                                        children: [
                                          TileLayer(
                                              urlTemplate:
                                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                              userAgentPackageName:
                                              'com.hushhone.hushh',
                                              maxNativeZoom: 19),
                                          MarkerLayer(markers: [
                                            Marker(
                                                point:
                                                locations.elementAt(index),
                                                child: SvgPicture.asset(
                                                    'assets/location.svg',
                                                    color: Colors.black,
                                                    height: 42))
                                          ])
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: const Alignment(1.5, -1.5),
                                      child: Transform.scale(
                                        scale: .6,
                                        child: IconButton(
                                          onPressed: () {
                                            locations.removeAt(index);
                                            setState(() {});
                                          },
                                          style: IconButton.styleFrom(
                                              backgroundColor: Colors.redAccent,
                                              foregroundColor: Colors.white),
                                          icon: const Icon(Icons.close),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              }),
                        const SizedBox(height: 32),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'DOMAIN',
                            style: context.titleSmall?.copyWith(
                              color: const Color(0xFF737373),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        AgentTextField(
                          addBelowPadding: false,
                          controller: brandDomainController,
                          fieldType: CustomFormType.web,
                          trailing: websiteIcon == null
                              ? null
                              : Image.network(
                            websiteIcon!,
                            errorBuilder: (context, _, s) =>
                            const SizedBox(),
                          ),
                          textInputType: TextInputType.url,
                          onChanged: (value) {
                            if (_debounce?.isActive ?? false) {
                              _debounce?.cancel();
                            }
                            _debounce =
                                Timer(const Duration(milliseconds: 1200), () {
                                  websiteIcon =
                                  'http://www.google.com/s2/favicons?domain=$value';
                                  setState(() {});
                                });
                          },
                          hintText: 'example.com',
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                BlocBuilder(
                    bloc: sl<AgentSignUpPageBloc>(),
                    builder: (context, state) {
                      return HushhLinearGradientButton(
                        text: 'Submit',
                        height: 48,
                        loader: state is CreatingBrandState,
                        onTap: () async {
                          //todo: check if brand domain is unique and not in the db
                          Future<String> uploadImage(Uint8List data) async {
                            final supabase = Supabase.instance.client;
                            String path =
                                "public/brands/${DateTime.now().toIso8601String()}.png";
                            try {
                              await supabase.storage
                                  .from('dump')
                                  .uploadBinary(path, data);
                            } on StorageException {}

                            String url = supabase.storage
                                .from('dump')
                                .getPublicUrl(path);
                            return url;
                          }

                          if (selectedBrandCategoryId == null) {
                            return;
                          }
                          if (_brandLogo == null) {
                            return;
                          }
                          Utils().showLoader(context);
                          String brandLogo = await uploadImage(
                              await _brandLogo!.readAsBytes());
                          bool isDomainNotEntered = //true;
                          brandDomainController.text
                              .trim()
                              .isEmpty;
                          final brand = Brand(
                              domain: isDomainNotEntered
                                  ? null
                                  : brandDomainController.text,
                              brandName: brandNameController.text,
                              brandCategoryId: selectedBrandCategoryId!,
                              brandLogo: brandLogo,
                              brandApprovalStatus: isDomainNotEntered
                                  ? null
                                  : BrandApprovalStatus.pending,
                              customBrand: false);
                          sl<AgentSignUpPageBloc>()
                              .add(CreateBrandEvent(brand, context, locations));
                        },
                        radius: 6,
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addLocation() async {
    final position = sl<AgentSignUpPageBloc>().lastKnownLocation;
    if (position != null) {
      final latLng = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CustomMapPicker(
                    latLng: LatLng(position.latitude, position.longitude),
                  )));
      if (latLng != null) {
        locations.add(latLng);
        setState(() {});
      }
    }
  }
}
