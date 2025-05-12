import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toastification/toastification.dart';

class ChatBottomSheet extends StatelessWidget {
  final Function(FilePickerResult) onDocumentsUpdated;
  final Function(File) onImageCaptured;
  final Function(List<File>) onImagesUploaded;
  final Function() onMeetingClicked;
  final Function() onPaymentClicked;
  final Function() onLookbookClicked;

  const ChatBottomSheet({
    super.key,
    required this.onDocumentsUpdated,
    required this.onImageCaptured,
    required this.onImagesUploaded,
    required this.onMeetingClicked,
    required this.onPaymentClicked,
    required this.onLookbookClicked,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: sl<CardWalletPageBloc>().isAgent ? 278 : 170,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularChatIcon(
                    Icons.insert_drive_file,
                    Colors.indigo,
                    "Document",
                    onTap: () async {
                      final result = await FilePicker.platform.pickFiles(
                          type: FileType.custom, allowedExtensions: ['pdf']);
                      if (result != null && result.files.isNotEmpty) {
                        Navigator.pop(context);
                        onDocumentsUpdated(result);
                      }
                    },
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  CircularChatIcon(
                    Icons.camera_alt,
                    Colors.pink,
                    "Camera",
                    onTap: () async {
                      final result = await ImagePicker().pickImage(
                        imageQuality: 70,
                        maxWidth: 1440,
                        source: ImageSource.camera,
                      );
                      if (result != null) {
                        Navigator.pop(context);
                        onImageCaptured(File(result.path));
                      }
                    },
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  CircularChatIcon(
                    Icons.insert_photo,
                    Colors.purple,
                    "Gallery",
                    onTap: () async {
                      final result = await ImagePicker().pickMultiImage(
                        imageQuality: 70,
                        maxWidth: 1440,
                      );
                      if (result.isNotEmpty) {
                        Navigator.pop(context);
                        onImagesUploaded(
                            result.map((e) => File(e.path)).toList());
                      }
                    },
                  ),
                ],
              ),
              if (sl<CardWalletPageBloc>().isAgent) ...[
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularChatIcon(
                      Icons.collections,
                      Colors.orange,
                      "Lookbook",
                      onTap: onLookbookClicked,
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    CircularChatIcon(
                      Icons.payment,
                      Colors.teal,
                      "Payment",
                      onTap: onPaymentClicked,
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    CircularChatIcon(
                      Icons.meeting_room,
                      Colors.deepOrangeAccent,
                      "Meeting",
                      onTap: onMeetingClicked,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class CircularChatIcon extends StatelessWidget {
  final IconData icons;
  final Color color;
  final String text;
  final Function()? onTap;

  const CircularChatIcon(
    this.icons,
    this.color,
    this.text, {
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icons,
              // semanticLabel: "Help",
              size: 29,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              // fontWeight: FontWeight.w100,
            ),
          )
        ],
      ),
    );
  }
}
