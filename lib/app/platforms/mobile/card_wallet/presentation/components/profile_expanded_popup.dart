import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfileExpandedPopup extends StatelessWidget {
  const ProfileExpandedPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 100.w,
                height: 100.h,
                color: Colors.transparent,
              )),
          Center(
            child: BlocBuilder(
              bloc: sl<HomePageBloc>(),
              builder: (context, state) {
                return CircleAvatar(
                  radius: (100.w - 200) / 2,
                  child: Stack(
                    children: [
                      Transform.scale(
                          scale: 1.1,
                          child: CachedNetworkImage(
                              width: (100.w - 200) / 2,
                              height: (100.w - 200) / 2,
                              fit: BoxFit.cover,
                              imageUrl: AppLocalStorage.user!.avatar!)),
                      if(state is UpdatingProfileImageState)
                      const Positioned.fill(child: CupertinoActivityIndicator(color: Colors.white,))
                    ],
                  ),
                );
              }
            ),
          ),
          Positioned.fill(
            left: (100.w - 200) - 80,
            top: (100.w - 200) - 50,
            child: Center(
              child: Transform.scale(
                scale: 1.1,
                child: InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () async {
                    showImagePickerBottomSheet(context);
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.edit_outlined),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void showImagePickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SizedBox(
          height: 180,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 16),
              const Text(
                'Choose an option',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildOption(
                    context,
                    Icons.camera_alt,
                    'Camera',
                        () => _pickImage(context, ImageSource.camera),
                  ),
                  _buildOption(
                    context,
                    Icons.photo_library,
                    'Gallery',
                        () => _pickImage(context, ImageSource.gallery),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOption(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 30, color: Theme.of(context).primaryColor),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    Navigator.pop(context);
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: source,
    );
    if (result != null) {
      Uint8List bytes = await result.readAsBytes();
      sl<HomePageBloc>().add(UpdateUserProfileEvent(bytes: bytes));
    }
  }
}
