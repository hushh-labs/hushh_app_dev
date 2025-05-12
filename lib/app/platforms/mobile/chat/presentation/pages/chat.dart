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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart' as hw;
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:http/http.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_lookbook.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/meeting_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/agent_card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/lookbooks_list_view.dart';
import 'package:hushh_app/app/platforms/mobile/chat/data/models/conversation.dart';
import 'package:hushh_app/app/platforms/mobile/chat/presentation/bloc/chat_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/chat/presentation/components/chat_bottomsheet.dart';
import 'package:hushh_app/app/platforms/mobile/chat/presentation/components/payment_message.dart';
import 'package:hushh_app/app/platforms/mobile/chat/presentation/components/profile_image_bottom_sheet.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/backend_controller/db_controller/db_controller_impl.dart';
import 'package:hushh_app/app/shared/core/components/request_payment_page.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/mention_tag_text_field/mention_tag_text_field.dart';
import 'package:hushh_app/app/shared/core/models/payment_model.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toastification/toastification.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

const Color primaryColor = Color(0xFF2020ED);

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _isAttachmentUploading = false;
  final controller = sl<ChatPageBloc>();
  final myUser = types.User(
      id: AppLocalStorage.hushhId!,
      firstName: sl<CardWalletPageBloc>().user!.name);

  void _handleAttachmentPressed() {
    Tuple3<Conversation, File?, bool> data = ModalRoute.of(context)
        ?.settings
        .arguments as Tuple3<Conversation, File?, bool>;
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
              onMeetingClicked: () {
                Navigator.pop(context);
                Tuple2<Map, String>? otherUser = data.item1.getOtherUser();
                Navigator.pushNamed(context, AppRoutes.agentCreateMeeting,
                    arguments: otherUser);
              },
              onLookbookClicked: () async {
                Navigator.pop(context);
                final selectedLookBooks = await Navigator.pushNamed(
                    context, AppRoutes.agentLookbook,
                    arguments: true);
                if (selectedLookBooks != null) {
                  for (var lookbook in (selectedLookBooks as List)) {
                    final message = types.CustomMessage(
                        author: myUser,
                        id: const Uuid().v4(),
                        createdAt: DateTime.now().millisecondsSinceEpoch,
                        updatedAt: DateTime.now().millisecondsSinceEpoch,
                        metadata: {
                          "type": "lookbook",
                          "data": lookbook.toJson(),
                          "message": "",
                        });
                    controller.add(SendMessageEvent(message, data.item1));
                  }
                }
              },
              onPaymentClicked: () async {
                Map? payment = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RequestPaymentPage()));
                if (payment != null) {
                  Navigator.pop(context);
                  final paymentModel = PaymentModel(
                    id: const Uuid().v4(),
                    initiatedUuid: myUser.id,
                    toUuid: getOtherParticipantId(data.item1.participants),
                    image: "",
                    currency: sl<HomePageBloc>().currency.name,
                    status: PaymentStatus.pending,
                    amountRaised:
                        double.tryParse(payment['amount_raised']) ?? 0.0,
                    title: payment['title'],
                  );
                  controller.add(InsertPaymentRequest(paymentModel));
                  final message = types.CustomMessage(
                      author: myUser,
                      id: const Uuid().v4(),
                      createdAt: DateTime.now().millisecondsSinceEpoch,
                      updatedAt: DateTime.now().millisecondsSinceEpoch,
                      metadata: {
                        "type": "payment",
                        "data": paymentModel.toJson()
                      });
                  controller.add(SendMessageEvent(message, data.item1));
                } else {
                  Navigator.pop(context);
                }
              },
            ));
  }

  void _handleFileSelection(FilePickerResult result) async {
    Tuple3<Conversation, File?, bool> data = ModalRoute.of(context)
        ?.settings
        .arguments as Tuple3<Conversation, File?, bool>;
    final conversation = data.item1;
    _setAttachmentUploading(true);
    final name = result.files.single.name;
    final filePath = result.files.single.path!;
    final file = File(filePath);

    try {
      final messageId = const Uuid().v4();
      types.FileMessage message = types.FileMessage(
        id: messageId,
        author: myUser,
        mimeType: lookupMimeType(filePath),
        name: name,
        metadata: {"isLoading": true, "file_path": filePath},
        createdAt: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
        size: result.files.single.size,
        uri: "",
      );
      controller.add(SendMessageEvent(message, conversation));
      String fileName =
          DateTime.now().toIso8601String() + '.' + filePath.split('.').last;
      final reference = FirebaseStorage.instance
          .ref()
          .child('conversations/${conversation.id}/$fileName');
      await reference.putFile(file);
      final uri = await reference.getDownloadURL();
      Uint8List thumbnail = (await Utils().getImageFromPdf(filePath))!;
      final thumbReference = FirebaseStorage.instance
          .ref()
          .child('thumbnails/${conversation.id}--$fileName/$fileName');
      await thumbReference.putData(thumbnail);
      final thumbUri = await thumbReference.getDownloadURL();
      message = types.FileMessage(
        id: messageId,
        author: myUser,
        mimeType: lookupMimeType(filePath),
        name: name,
        metadata: {
          "isLoading": false,
          "file_path": filePath,
          "thumbnail": thumbUri
        },
        createdAt: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
        size: result.files.single.size,
        uri: uri,
      );
      controller.add(UpdateMessageEvent(message, conversation));

      _setAttachmentUploading(false);
    } finally {
      _setAttachmentUploading(false);
    }
  }

  void _handleImageSelection({File? file, CardModel? card}) async {
    Tuple3<Conversation, File?, bool> data = ModalRoute.of(context)
        ?.settings
        .arguments as Tuple3<Conversation, File?, bool>;
    final conversation = data.item1;
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
      _setAttachmentUploading(true);
      final messageId = const Uuid().v4();
      types.ImageMessage imageMessage = types.ImageMessage(
          id: messageId,
          size: 0,
          name: 'image.png',
          uri: "",
          height: 0,
          width: 0,
          author: myUser,
          metadata: {
            "isLoading": true,
            "file_path": result.path,
            "user_id": card?.userId,
            "brand_id": card?.id
          },
          createdAt: DateTime.now().millisecondsSinceEpoch,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
          roomId: conversation.id);
      controller.add(SendMessageEvent(imageMessage, conversation));

      final file = File(result.path);
      final size = file.lengthSync();
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final name = result.name;

      try {
        final reference = FirebaseStorage.instance.ref().child(
            'conversations/${conversation.id}/${DateTime.now().toIso8601String()}.${result.path.split('.').lastOrNull ?? "png"}');
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();
        imageMessage = types.ImageMessage(
            id: messageId,
            size: size,
            name: name,
            uri: uri,
            height: 0,
            width: image.width.toDouble(),
            author: myUser,
            metadata: {
              "isLoading": false,
              "file_path": result.path,
              "user_id": AppLocalStorage.hushhId,
              "brand_id": card?.id
            },
            createdAt: DateTime.now().millisecondsSinceEpoch,
            updatedAt: DateTime.now().millisecondsSinceEpoch,
            roomId: conversation.id);
        controller.add(UpdateMessageEvent(imageMessage, conversation));

        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
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

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final updatedMessage = message.copyWith(previewData: previewData);

    // FirebaseChatCore.instance.updateMessage(updatedMessage, widget.conversation.id);
  }

  void _handleSendPressed(types.PartialText message) {
    Tuple3<Conversation, File?, bool> data = ModalRoute.of(context)
        ?.settings
        .arguments as Tuple3<Conversation, File?, bool>;
    final conversation = data.item1;
    final textMessage = types.TextMessage(
        id: const Uuid().v4(),
        author: myUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        metadata: message.metadata,
        repliedMessage: message.repliedMessage,
        previewData: (message).previewData,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
        roomId: conversation.id,
        text: (message).text);
    controller.add(SendMessageEvent(textMessage, conversation));
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }

  String getOtherParticipantId(Map<String, dynamic> participants) {
    for (var uid in participants.keys) {
      if (uid != AppLocalStorage.hushhId) {
        return uid;
      }
    }
    return ''; // Return empty string if no other participant found
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Tuple3<Conversation, File?, bool> data = ModalRoute.of(context)
          ?.settings
          .arguments as Tuple3<Conversation, File?, bool>;
      final file = data.item2;
      bool notYourMessage = data.item1.lastMessage != null &&
          data.item1.lastMessage!.author.id != AppLocalStorage.hushhId;
      if (notYourMessage) {
        controller.add(ResetUnReadCountEvent(data.item1));
      }
      if (file != null) {
        _handleImageSelection(
            file: file, card: sl<CardWalletPageBloc>().cardData!);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Tuple3<Conversation, File?, bool> data = ModalRoute.of(context)
        ?.settings
        .arguments as Tuple3<Conversation, File?, bool>;
    final conversation = data.item1;
    final otherUser = types.User(
        id: getOtherParticipantId(conversation.participants),
        firstName: conversation.getOtherUserInfo('name'));
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              ToastManager(Toast(
                      title: 'Coming Soon', type: ToastificationType.info))
                  .show(context);
            },
            icon: const Icon(
              Icons.call_outlined,
              color: primaryColor,
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: InkWell(
            onTap: () async {
              await showDialog(
                  context: context,
                  builder: (_) =>
                      ProfileImageBottomSheet(conversation: conversation));
            },
            child: CircleAvatar(
              radius: 20.0,
              child: ClipOval(
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(20),
                  child: conversation.getOtherUserInfo('avatar') != null
                      ? CachedNetworkImage(
                          imageUrl: conversation.getOtherUserInfo('avatar'))
                      : Image.asset('assets/user.png'),
                ),
              ),
              backgroundColor: Colors.transparent,
            ),
          ),
          title: Text(((conversation.getOtherUserInfo('name') ?? '') as String)
              .capitalize()),
        ),
      ),
      body: BlocBuilder(
          bloc: controller,
          builder: (context, state) {
            return StreamBuilder<List<types.Message>>(
              initialData: const [],
              stream: sl<DbController>().fetchMessagesStream(conversation.id),
              builder: (context, snapshot) {
                return Chat(
                  isAttachmentUploading: _isAttachmentUploading,
                  messages: snapshot.data ?? [],
                  onMessageTap: _handleMessageTap,
                  onPreviewDataFetched: _handlePreviewDataFetched,
                  onSendPressed: _handleSendPressed,
                  user: myUser,
                  bubbleBuilder: bubbleBuilder,
                  customBottomWidget: customTextField(),
                  textMessageBuilder: textMessageBuilder,
                  fileMessageBuilder: fileMessageBuilder,
                  customMessageBuilder: customMessageBuilder,
                  imageMessageBuilder: customImageBuilder,
                );
              },
            );
          }),
    );
  }

  Widget bubbleBuilder(
    Widget child, {
    required types.Message message,
    required bool nextMessageInGroup,
  }) {
    bool isMyMessage = message.author.id == myUser.id;
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
        if (isMyMessage)
          FocusedMenuItem(
              backgroundColor: Colors.red,
              title: const Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
              trailingIcon: const Icon(Icons.delete, color: Colors.white),
              onPressed: () {
                ToastManager(Toast(
                        title: 'Coming soon!',
                        description:
                            "This feature will be available in the next release :)",
                        type: ToastificationType.info))
                    .show(context);
              }),
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
    bool isMyMessage = message.author.id == myUser.id;
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20).copyWith(
              bottomRight: isMyMessage ? const Radius.circular(0) : null,
              bottomLeft: !isMyMessage ? const Radius.circular(0) : null),
        ),
        child: Text(
          message.text,
          style: TextStyle(color: isMyMessage ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget fileMessageBuilder(types.FileMessage message,
      {required int messageWidth}) {
    bool isMyMessage = message.author.id == myUser.id;
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        (message.size / 1048576).toStringAsFixed(2) + "mb",
                        style: TextStyle(
                            color: isMyMessage ? Colors.white : Colors.black),
                      ),
                      if (!isMyMessage) const SizedBox(width: 20)
                    ],
                  )
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        (message.size / 1048576).toStringAsFixed(2) + "mb",
                        style: TextStyle(
                            color: isMyMessage ? Colors.white : Colors.black),
                      ),
                      if (!isMyMessage) const SizedBox(width: 20)
                    ],
                  )
                ],
              ),
      ),
    );
  }

  Widget customMessageBuilder(types.CustomMessage message,
      {required int messageWidth}) {
    Tuple3<Conversation, File?, bool> data = ModalRoute.of(context)
        ?.settings
        .arguments as Tuple3<Conversation, File?, bool>;
    final conversation = data.item1;

    bool isMyMessage = message.author.id == myUser.id;
    MeetingModel? meet;
    if (message.metadata!['type'] == 'meeting') {
      meet = MeetingModel.fromJson(message.metadata!['data']);
    }
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: GestureDetector(
        onTap: () {
          if (meet != null) {
            Navigator.pushNamed(context, AppRoutes.agentMeetingInfo,
                arguments: meet);
          }
        },
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
                        Icon(
                          Icons.calendar_month_outlined,
                          color: !isMyMessage ? primaryColor : Colors.white,
                          size: 42,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(meet!.title,
                                style: TextStyle(
                                  color: !isMyMessage
                                      ? primaryColor
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text(
                                DateFormat('dd MMM, yyyy HH:mm')
                                    .format(meet.dateTime),
                                style: TextStyle(
                                  color: !isMyMessage
                                      ? primaryColor
                                      : Colors.white,
                                )),
                            Text("Meeting type: ${meet.meetingType.name}",
                                style: TextStyle(
                                  color: !isMyMessage
                                      ? primaryColor
                                      : Colors.white,
                                ))
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
                          if (meet!.meetingType == MeetingType.walkIn) {
                            launchUrl(Uri.parse(
                                'https://maps.google.com/?q=47.612277327025815,-122.33635108913933'));
                          } else {
                            if (meet.gMeetLink != null) {
                              launchUrl(Uri.parse(meet.gMeetLink!));
                            } else {
                              ToastManager(Toast(
                                      title:
                                          'No meeting found! Please contact the organizer.',
                                      type: ToastificationType.error))
                                  .show(context);
                            }
                          }
                        },
                        child: Text(meet.meetingType == MeetingType.walkIn
                            ? 'Navigate to 📍'
                            : 'Join Now'),
                      ),
                    )
                  ],
                )
              : message.metadata?['type'] == 'payment'
                  ? PaymentMessage(
                      agentBrandId:
                          conversation.getOtherUserInfo('brand')?['id'],
                      isMyMessage: isMyMessage,
                      onPaymentMade: (amount) {
                        Tuple3<Conversation, File?, bool> data =
                            ModalRoute.of(context)?.settings.arguments
                                as Tuple3<Conversation, File?, bool>;
                        final conversation = data.item1;
                        final paymentModel =
                            PaymentModel.fromJson(message.metadata!['data']);
                        paymentModel.status = PaymentStatus.accepted;
                        paymentModel.amountPayed =
                            double.tryParse(amount ?? '') ?? 0.0;
                        final updatedMessage = types.CustomMessage(
                            author: message.author,
                            id: message.id,
                            createdAt: DateTime.now().millisecondsSinceEpoch,
                            updatedAt: DateTime.now().millisecondsSinceEpoch,
                            metadata: {
                              "type": "payment",
                              "data": paymentModel.toJson()
                            });
                        controller.add(
                            UpdateMessageEvent(updatedMessage, conversation));
                        controller.add(PaymentStatusUpdateEvent(
                            paymentModel:
                                PaymentModel.fromJson(message.metadata!['data'])
                                    .copyWith(
                                        amountPayed:
                                            double.tryParse(amount ?? '') ??
                                                0.0,
                                        status: PaymentStatus.accepted)));
                        if (paymentModel.sharedCardId != null &&
                            paymentModel
                                .shareInfoAfterPaymentWithInitiatedUuid) {
                          sl<AgentCardWalletPageBloc>().add(
                              OnSuccessCardUnlockEvent(
                                  context: context,
                                  cardInfoUnlockMethod:
                                      CardInfoUnlockMethod.byUser,
                                  payment: paymentModel));
                        }
                      },
                      onPaymentDeclined: () {
                        Tuple3<Conversation, File?, bool> data =
                            ModalRoute.of(context)?.settings.arguments
                                as Tuple3<Conversation, File?, bool>;
                        final conversation = data.item1;
                        final paymentModel =
                            PaymentModel.fromJson(message.metadata!['data']);
                        paymentModel.status = PaymentStatus.declined;
                        final updatedMessage = types.CustomMessage(
                            author: message.author,
                            id: message.id,
                            createdAt: DateTime.now().millisecondsSinceEpoch,
                            updatedAt: DateTime.now().millisecondsSinceEpoch,
                            metadata: {
                              "type": "payment",
                              "data": paymentModel.toJson()
                            });
                        controller.add(
                            UpdateMessageEvent(updatedMessage, conversation));
                        controller.add(PaymentStatusUpdateEvent(
                            paymentModel:
                                PaymentModel.fromJson(message.metadata!['data'])
                                    .copyWith(status: PaymentStatus.declined)));
                      },
                      dateTime: DateTime.fromMillisecondsSinceEpoch(
                          message.createdAt!),
                      payment: PaymentModel.fromJson(message.metadata!['data']),
                      hushhId: myUser.id)
                  : message.metadata?['type'] == 'product'
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(
                                AgentProductModel.fromJson(
                                        message.metadata!['data'])
                                    .productImage,
                              ),
                            ),
                            const SizedBox(height: 8),
                            hw.HtmlWidget(
                              message.metadata?['message'] ?? "",
                              textStyle: TextStyle(
                                color:
                                    !isMyMessage ? primaryColor : Colors.white,
                              ),
                            )
                          ],
                        )
                      : message.metadata?['type'] == 'lookbook'
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                LookBooksListView(lookbooks: [
                                  AgentLookBook.fromJson(
                                      message.metadata!['data'])
                                ], fromChat: true),
                                const SizedBox(height: 8),
                                hw.HtmlWidget(
                                  message.metadata?['message'] ?? "",
                                  textStyle: TextStyle(
                                    color: !isMyMessage
                                        ? primaryColor
                                        : Colors.white,
                                  ),
                                )
                              ],
                            )
                          : const SizedBox(),
        ),
      ),
    );
  }

  Widget customImageBuilder(types.ImageMessage message,
      {required int messageWidth}) {
    bool isMyMessage = message.author.id == myUser.id;
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: GestureDetector(
        onTap: () {
          if (message.metadata?['user_id'] != null &&
              message.metadata?['brand_id'] != null &&
              sl<CardWalletPageBloc>().isAgent) {
            sl<AgentCardWalletPageBloc>().add(FetchCardInfoEvent(
                message.metadata?['user_id'],
                message.metadata?['brand_id'],
                context));
          }
        },
        child: Container(
          height: message.metadata?['isLoading'] ?? false ? 175 : null,
          width: messageWidth.toDouble(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20).copyWith(
                bottomRight: isMyMessage ? const Radius.circular(0) : null,
                bottomLeft: !isMyMessage ? const Radius.circular(0) : null),
            image: message.metadata?['isLoading'] == true
                ? DecorationImage(
                    image: FileImage(File(message.metadata?['file_path'])),
                    fit: BoxFit.fill)
                : null,
          ),
          child: message.metadata?['isLoading'] == true
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(20).copyWith(
                      bottomRight:
                          isMyMessage ? const Radius.circular(0) : null,
                      bottomLeft:
                          !isMyMessage ? const Radius.circular(0) : null),
                  child: ImageMessage(
                    // imageHeaders: imageHeaders,
                    // imageProviderBuilder: imageProviderBuilder,
                    message: message,
                    messageWidth: messageWidth,
                  ),
                ),
        ),
      ),
    );
  }

  Widget customTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
              child: MentionTagTextField(
                controller: controller.textEditingController,
                initialMentions: const [('@HushhAI', null, null)],
                onMention: (value) {},
                onSubmitted: (value) {
                  _handleSendPressed(types.PartialText(text: value));
                },
                onChanged: (_) {
                  setState(() {});
                },
                decoration: InputDecoration(
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
