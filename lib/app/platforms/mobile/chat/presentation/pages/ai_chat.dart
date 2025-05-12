import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:http/http.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/meeting_model.dart';
import 'package:hushh_app/app/platforms/mobile/chat/presentation/bloc/ai_chat_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/chat/presentation/components/chat_bottomsheet.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/ai_handler/ai_handler.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

const Color primaryColor = Color(0xFF2020ED);

class AiChatPage extends StatefulWidget {
  final String? query;

  const AiChatPage({super.key, this.query});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final controller = sl<AiChatPageBloc>();

  @override
  void initState() {
    // controller.messages.clear();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.add(FetchMessagesEvent());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            radius: 20.0,
            child: ClipOval(
              child: SizedBox.fromSize(
                size: const Size.fromRadius(20),
                child: Image.asset(
                  "assets/hbot.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
          ),
          title: const Text("Hushh AI Bot"),
        ),
      ),
      body: BlocBuilder(
          bloc: controller,
          builder: (context, state) {
            return Chat(
                messages: controller.messages,
                onSendPressed: _handleSendPressed,
                user: controller.myUser,
                emptyState: state is FetchingMessageState
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : const Center(child: Text('No messages here yet...')),
                bubbleBuilder: bubbleBuilder,
                customBottomWidget: customTextField(),
                textMessageBuilder: textMessageBuilder,
                fileMessageBuilder: fileMessageBuilder,
                customMessageBuilder: customMessageBuilder,
                imageMessageBuilder: customImageBuilder);
          }),
    );
  }

  Widget bubbleBuilder(
    Widget child, {
    required types.Message message,
    required bool nextMessageInGroup,
  }) {
    bool isMyMessage = message.author.id == controller.myUser.id;
    return FocusedMenuHolder(
      menuWidth: 50.w,
      menuItems: <FocusedMenuItem>[
        if (message.type != types.MessageType.text)
          FocusedMenuItem(
              title: const Text("view"),
              trailingIcon: const Icon(Icons.open_in_new),
              onPressed: () {
                _handleMessageTap(context, message);
              }),
        if (message.type == types.MessageType.text)
          FocusedMenuItem(
              title: const Text("Copy"),
              trailingIcon: const Icon(Icons.copy),
              onPressed: () {
                final text = (message as types.TextMessage).text;
                Clipboard.setData(new ClipboardData(text: text));
                ToastManager(Toast(
                        title: 'Message copied successfully!',
                        type: ToastificationType.info))
                    .show(context);
              }),
        FocusedMenuItem(
            title: const Text("Share"),
            trailingIcon: const Icon(Icons.share),
            onPressed: () async {
              if (message.type == types.MessageType.text) {
                await Share.share((message as types.TextMessage).text);
              } else if (message.type == types.MessageType.file) {
                ToastManager(Toast(
                        title: 'Please wait!',
                        description: "The file is processing...",
                        type: ToastificationType.info))
                    .show(context);
                String fileUri = (message as types.FileMessage).uri;
                final bytes = (await get(Uri.parse(fileUri))).bodyBytes;
                String fileName = message.name;
                Directory tempDir = await getTemporaryDirectory();
                String tempPath = tempDir.path;

                String filePath = '$tempPath/$fileName';
                File file = File(filePath);
                await file.writeAsBytes(bytes);
                XFile xFile = XFile(filePath);
                await Share.shareXFiles([xFile]);
              }
            }),
        // if(isMyMessage)
        // FocusedMenuItem(
        //     backgroundColor: Colors.red,
        //     title: const Text(
        //       "Delete",
        //       style: TextStyle(color: Colors.white),
        //     ),
        //     trailingIcon: const Icon(Icons.delete, color: Colors.white),
        //     onPressed: () {}),
      ],
      onPressed: () {},
      child: Container(
        decoration: BoxDecoration(
            color: !isMyMessage ? const Color(0xFFEBEBF7) : null,
            borderRadius: BorderRadius.circular(
                    message is types.ImageMessage ? 20 : 50)
                .copyWith(
                    bottomRight: isMyMessage ? const Radius.circular(0) : null,
                    bottomLeft: !isMyMessage ? const Radius.circular(0) : null),
            gradient: !isMyMessage
                ? null
                : const LinearGradient(colors: [
                    Color(0xFF321EE0),
                    Color(0xFF4D1ACC),
                  ])),
        child: child,
      ),
    );
  }

  Widget textMessageBuilder(types.TextMessage message,
      {required int messageWidth, required bool showName}) {
    bool isMyMessage = message.author.id == controller.myUser.id;
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20).copyWith(
              bottomRight: isMyMessage ? const Radius.circular(0) : null,
              bottomLeft: !isMyMessage ? const Radius.circular(0) : null),
        ),
        child: isMyMessage
            ? Text(
                message.text,
                style:
                    TextStyle(color: isMyMessage ? Colors.white : Colors.black),
              )
            : Markdown(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                data: message.text,
                styleSheet: MarkdownStyleSheet(
                    p: TextStyle(
                        color: isMyMessage ? Colors.white : Colors.black)),
              ),
      ),
    );
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message.type == types.MessageType.file) {
      String fileUri = (message as types.FileMessage).uri;
      final bytes = (await get(Uri.parse(fileUri))).bodyBytes;
      String fileName = message.name;
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;

      String filePath = '$tempPath/$fileName';
      File file = File(filePath);
      await file.writeAsBytes(bytes);
      Navigator.pushNamed(context, AppRoutes.shared.pdfViewer,
          arguments: filePath);

      // await OpenFilex.open(filePath);
    }
  }

  Widget fileMessageBuilder(types.FileMessage message,
      {required int messageWidth}) {
    bool isMyMessage = message.author.id == controller.myUser.id;
    return GestureDetector(
      onTap: () {
        _handleMessageTap(context, message);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: message.metadata?['isLoading'] == true
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 20.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(50).copyWith(
                          bottomRight:
                              isMyMessage ? const Radius.circular(0) : null,
                          bottomLeft:
                              !isMyMessage ? const Radius.circular(0) : null,
                        )),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    message.name,
                    style: TextStyle(
                        color: isMyMessage ? Colors.white : Colors.black),
                  ),
                  Text(
                    (message.size / 1048576).toStringAsFixed(2) + "mb",
                    style: TextStyle(
                        color: isMyMessage ? Colors.white : Colors.black),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(50).copyWith(
                        bottomRight:
                            isMyMessage ? const Radius.circular(0) : null,
                        bottomLeft:
                            !isMyMessage ? const Radius.circular(0) : null,
                      ),
                      child: CachedNetworkImage(
                        imageUrl: message.metadata?['thumbnail'],
                        height: 20.h,
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
                      )),
                  const SizedBox(height: 6),
                  Text(
                    message.name,
                    style: TextStyle(
                        color: isMyMessage ? Colors.white : Colors.black),
                  ),
                  Text(
                    (message.size / 1048576).toStringAsFixed(2) + "mb",
                    style: TextStyle(
                        color: isMyMessage ? Colors.white : Colors.black),
                  ),
                ],
              ),
      ),
    );
  }

  Widget customMessageBuilder(types.CustomMessage message,
      {required int messageWidth}) {
    bool isMyMessage = message.author.id == controller.myUser.id;
    final meet = MeetingModel.fromJson(message.metadata!['data']);
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        width: messageWidth.toDouble(),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20).copyWith(
              bottomRight: isMyMessage ? const Radius.circular(0) : null,
              bottomLeft: !isMyMessage ? const Radius.circular(0) : null),
        ),
        child: message.metadata?['type'] == 'meeting'
            ? Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        color: Colors.white,
                        size: 42,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(meet.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(
                              DateFormat('dd MMM, yyyy HH:mm')
                                  .format(meet.dateTime),
                              style: const TextStyle(color: Colors.white)),
                          Text("Meeting type: ${meet.meetingType.name}",
                              style: const TextStyle(color: Colors.white))
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () {
                        if (meet.meetingType == MeetingType.walkIn) {
                          launchUrl(Uri.parse(
                              'https://maps.google.com/?q=47.612277327025815,-122.33635108913933'));
                        } else {
                          launchUrl(Uri.parse('https://meet.google.com'));
                          // if (meet.gMeetLink != null) {
                          //   launchUrl(Uri.parse(meet.gMeetLink!));
                          // } else {
                          //   ToastManager(Toast(
                          //           title:
                          //               'No meeting found! Please contact the organizer.',
                          //           type: ToastificationType.error))
                          //       .show(context);
                          // }
                        }
                      },
                      child: Text(meet.meetingType == MeetingType.walkIn
                          ? 'Navigate to 📍'
                          : 'Join Now'),
                    ),
                  )
                ],
              )
            : const SizedBox(),
      ),
    );
  }

  Widget customImageBuilder(types.ImageMessage message,
      {required int messageWidth}) {
    bool isMyMessage = message.author.id == controller.myUser.id;
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20).copyWith(
                bottomRight: isMyMessage ? const Radius.circular(0) : null,
                bottomLeft: !isMyMessage ? const Radius.circular(0) : null),
            image: message.metadata?['isLoading'] == true
                ? DecorationImage(
                    image: FileImage(File(message.metadata?['file_path'])),
                    fit: BoxFit.fill)
                : DecorationImage(
                    image: CachedNetworkImageProvider(message.uri),
                    fit: BoxFit.fill),
          ),
          child: message.metadata?['isLoading'] == true
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : null,
        ),
      ),
    );
  }

  Stream<String> addDelay(Stream<String> input) async* {
    Duration dur = const Duration(milliseconds: 60);
    await Future.delayed(dur);
    await for (var event in input) {
      yield event;
      await Future.delayed(dur);
    }
  }

  Future<void> _handleSendPressed(types.PartialText text,
      {types.TextMessage? message}) async {
    types.TextMessage userMessage;
    if (message == null) {
      controller.textEditingController.clear();
      userMessage = types.TextMessage(
          createdAt: DateTime.now().millisecondsSinceEpoch,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
          author: controller.myUser,
          id: const Uuid().v4(),
          text: text.text);
      controller.messages.insert(0, userMessage);
    } else {
      userMessage = message;
    }
    setState(() {});
    String data = (ModalRoute.of(context)?.settings.arguments as String?) ??
        widget.query ??
        '';
    final stream = AiHandler(data).getChatResponseStream(context, text.text);
    bool convStarted = false;
    String id = const Uuid().v4();
    addDelay(stream).listen(
      (event) {
        log("<ACK>${event.toString()}<NQ>");
        setState(() {
          try {
            final parsedEvent = event;
            if (convStarted) {
              controller.messages.first = types.TextMessage(
                author: controller.otherUser,
                id: id,
                createdAt: DateTime.now().millisecondsSinceEpoch,
                updatedAt: DateTime.now().millisecondsSinceEpoch,
                text: (controller.messages.first as types.TextMessage).text +
                    (parsedEvent),
              );
            } else {
              controller.messages.insert(
                0,
                types.TextMessage(
                  author: controller.otherUser,
                  id: id,
                  createdAt: DateTime.now().millisecondsSinceEpoch,
                  updatedAt: DateTime.now().millisecondsSinceEpoch,
                  text: parsedEvent,
                ),
              );
              convStarted = true;
            }
          } catch (_) {}
        });
      },
    );
  }

  void _handleImageSelection({File? file}) async {
    XFile? result;
    if (file != null) {
      result = XFile(file.path);
    } else {
      result = await ImagePicker().pickImage(
        imageQuality: 70,
        maxWidth: 1440,
        source: ImageSource.gallery,
      );
    }

    if (result != null) {
      final messageId = const Uuid().v4();
      types.ImageMessage imageMessage = types.ImageMessage(
        id: messageId,
        size: 0,
        name: 'image.png',
        uri: "",
        height: 0,
        width: 0,
        author: controller.myUser,
        metadata: {"isLoading": true, "file_path": result.path},
        createdAt: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );
      controller.messages.insert(0, imageMessage);
      setState(() {});
      controller.add(SendMessageEvent(imageMessage));
      final file = File(result.path);
      final size = file.lengthSync();
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final name = result.name;
      InputImage inputImage = InputImage.fromFile(file);
      final textRecognizer =
          TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      try {
        final reference = FirebaseStorage.instance.ref().child(
            'ai_conversations/$messageId/${DateTime.now().toIso8601String()}.${result.path.split('.').lastOrNull ?? "png"}');
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();
        imageMessage = types.ImageMessage(
          id: messageId,
          size: size,
          name: name,
          uri: uri,
          height: 0,
          width: image.width.toDouble(),
          author: controller.myUser,
          metadata: {
            "isLoading": false,
            "file_path": result.path,
            "ocr_text": recognizedText.text,
          },
          createdAt: DateTime.now().millisecondsSinceEpoch,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
        );
        controller.messages.first = imageMessage;
        setState(() {});
        controller.add(UpdateMessageEvent(imageMessage));
      } finally {}
    }
  }

  void _handleFileSelection(FilePickerResult result) async {
    final name = result.files.single.name;
    final filePath = result.files.single.path!;
    final file = File(filePath);

    try {
      final messageId = const Uuid().v4();
      types.FileMessage message = types.FileMessage(
        id: messageId,
        author: controller.myUser,
        mimeType: lookupMimeType(filePath),
        name: name,
        metadata: {"isLoading": true, "file_path": filePath},
        createdAt: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
        size: result.files.single.size,
        uri: "",
      );
      controller.messages.insert(0, message);
      setState(() {});
      controller.add(SendMessageEvent(message));
      String fileName =
          DateTime.now().toIso8601String() + '.' + filePath.split('.').last;
      final reference = FirebaseStorage.instance
          .ref()
          .child('ai_conversations/$messageId/$fileName');
      await reference.putFile(file);
      final uri = await reference.getDownloadURL();
      final document = PdfDocument(inputBytes: file.readAsBytesSync());
      String ocrText = PdfTextExtractor(document).extractText();
      document.dispose();
      Uint8List thumbnail = (await Utils().getImageFromPdf(filePath))!;
      final thumbReference = FirebaseStorage.instance
          .ref()
          .child('thumbnails/$messageId--$fileName/$fileName');
      await thumbReference.putData(thumbnail);
      final thumbUri = await thumbReference.getDownloadURL();
      message = types.FileMessage(
        id: messageId,
        author: controller.myUser,
        mimeType: lookupMimeType(filePath),
        name: name,
        metadata: {
          "ocr_text": ocrText,
          "isLoading": false,
          "file_path": filePath,
          "thumbnail": thumbUri
        },
        createdAt: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
        size: result.files.single.size,
        uri: uri,
      );
      controller.messages.first = message;
      setState(() {});
      controller.add(UpdateMessageEvent(message));
    } finally {}
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        elevation: 0,
        context: context,
        builder: (builder) => ChatBottomSheet(
              onDocumentsUpdated: (FilePickerResult result) {
                _handleFileSelection(result);
              },
              onImageCaptured: (File file) {
                _handleImageSelection(file: file);
              },
              onImagesUploaded: (List<File> files) {
                for (var file in files) {
                  _handleImageSelection(file: file);
                }
              },
              onMeetingClicked: () {},
              onLookbookClicked: () {},
              onPaymentClicked: () {},
            ));
  }

  Widget customTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4)
          .copyWith(bottom: false ? 20 : 4),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              _handleAttachmentPressed();
            },
            icon: ShaderMask(
              shaderCallback: (shader) {
                return const LinearGradient(
                  colors: [
                    Color(0XFFA342FF),
                    Color(0XFFE54D60),
                  ],
                  tileMode: TileMode.mirror,
                ).createShader(shader);
              },
              child: const Icon(
                Icons.add_circle_outline_sharp,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextField(
                controller: controller.textEditingController,
                onSubmitted: (value) {
                  _handleSendPressed(types.PartialText(text: value));
                },
                onChanged: (_) {
                  setState(() {});
                },
                decoration: InputDecoration(
                    hintText: 'Message HushhAI...',
                    suffix: controller.textEditingController.text
                            .trim()
                            .isNotEmpty
                        ? GestureDetector(
                            onTap: () => _handleSendPressed(types.PartialText(
                                text: controller.textEditingController.text)),
                            child: SvgPicture.asset('assets/send.svg'))
                        : null,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    filled: true,
                    fillColor: const Color(0xFFF5F5FD)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
