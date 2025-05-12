import 'dart:io';

import 'package:azlistview/azlistview.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/chat/presentation/bloc/chat_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/colors.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/models/alphabet_search_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class HushhContactsBottomSheet extends StatefulWidget {
  final File? file;

  const HushhContactsBottomSheet({super.key, this.file});

  @override
  State<HushhContactsBottomSheet> createState() =>
      _HushhContactsBottomSheetState();
}

class _HushhContactsBottomSheetState extends State<HushhContactsBottomSheet> {
  ItemScrollController itemScrollController = ItemScrollController();
  List<Contact>? initialContacts;
  List<Contact>? searchContacts;

  @override
  void initState() {
    if (sl<CardWalletPageBloc>().foundHushhContacts == null) {
      sl<CardWalletPageBloc>().fetchHushhUsersInContacts(context).then((value) {
        sl<CardWalletPageBloc>().foundHushhContacts = value;
        initialContacts = value;
        searchContacts = value;
        setState(() {});
      });
    } else {
      initialContacts = sl<CardWalletPageBloc>().foundHushhContacts;
      searchContacts = sl<CardWalletPageBloc>().foundHushhContacts;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<AlphabetSearch>? dataList = searchContacts?.map((contact) {
      return AlphabetSearch.fromJson({
        "name": contact.displayName ?? "",
        "contactName": contact.displayName ?? "",
        "avatar": "", //contact.avatar,
        "contactPhoneNumber": contact.phones?.firstOrNull?.value ?? "",
        "phoneNumber": contact.phones?.firstOrNull?.value ?? "",
        "uid": contact.identifier,
      })
        ..tagIndex = contact.displayName ?? "";
    }).toList();
    return SizedBox(
      height: 85.h,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 70,
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    initialContacts = null;
                    searchContacts = null;
                    setState(() {});
                    sl<CardWalletPageBloc>()
                        .fetchHushhUsersInContacts(context)
                        .then((value) {
                      initialContacts = value;
                      searchContacts = value;
                      setState(() {});
                    });
                  },
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/refresh.svg',
                    ),
                  ),
                ),
                SizedBox(
                  width: 85.w,
                  height: 70,
                  child: TextField(
                    autofocus: false,
                    onChanged: (value) {
                      if (value.trim().isEmpty) {
                        searchContacts = initialContacts;
                        setState(() {});
                        return;
                      }
                      searchContacts = initialContacts
                          ?.where((element) =>
                              element.displayName
                                  ?.toLowerCase()
                                  .contains(value) ??
                              false)
                          .toList();
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                      filled: true,
                      fillColor: const Color(0xFFf5f5fd),
                      hintText: 'Search...',
                      hintStyle: const TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFF7f7f97),
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(6),
                        child: SvgPicture.asset(
                          'assets/search_new.svg',
                          color: const Color(0xFF616180),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFFf5f5fd),
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFFf5f5fd),
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFFf5f5fd),
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            minLeadingWidth: 40,
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100.h / 20.3,
                  width: 100.w / 9.37,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xffEBEBF7)),
                  child: Center(child: SvgPicture.asset('assets/single_c.svg')),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Invite friend to Hushh',
                  style: TextStyle(
                      color: Color(0xff2020ED),
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 100.h / 101.5,
                ),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.inviteUsersToHushh);
            },
          ),
          Expanded(
            child: dataList == null
                ? const Center(
                    child: CircularProgressIndicator(
                        color: CustomColors.projectBaseBlue),
                  )
                : AzListView(
                    itemScrollController: itemScrollController,
                    hapticFeedback: false,
                    physics: const AlwaysScrollableScrollPhysics(),
                    data: dataList,
                    itemCount: dataList.length,
                    itemBuilder: (BuildContext context, int index) {
                      AlphabetSearch model = dataList[index];
                      return Container(
                        padding: const EdgeInsets.only(right: 15, left: 15),
                        child: getListItem(context, model, index),
                      );
                    },
                    indexBarItemHeight: 16.5,
                    indexBarOptions: const IndexBarOptions(
                      needRebuild: true,
                      hapticFeedback: false,
                      textStyle:
                          TextStyle(fontSize: 10, color: Color(0xff7f7f97)),
                      selectTextStyle: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                      selectItemDecoration: BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xFF333333)),
                      indexHintAlignment: Alignment.centerRight,
                      indexHintTextStyle:
                          TextStyle(fontSize: 24.0, color: Colors.white),
                      indexHintOffset: Offset(-30, 0),
                    ),
                  ),
          )
        ],
      ),
    );
  }

  Widget getListItem(BuildContext context, AlphabetSearch model, int index,
      {double susHeight = 40}) {
    return InkWell(
      onTap: () async {
        sl<ChatPageBloc>().add(InitiateChatEvent(
          context,
          widget.file,
          model.uid,
        ));
      },
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.transparent,
            border:
                Border(bottom: BorderSide(color: Color(0xffebebf7), width: 1))),
        height: 100.h / 11.1,
        width: MediaQuery.of(context).size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(20),
                  child: Image.network(
                    model.avatar,
                    fit: BoxFit.fill,
                    errorBuilder: (context, url, error) {
                      return Image.asset('assets/user.png');
                    },
                  ),
                ),
              ),
            ),
            SizedBox(width: 100.w / 46.8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    model.contactName,
                    style: const TextStyle(
                      color: Color(0xff181941),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    model.contactPhoneNumber,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getSusItem(BuildContext context, String tag, {double susHeight = 30}) {
    return Container(
      height: susHeight,
      width: 100.w,
      padding: const EdgeInsets.only(left: 16.0),
      color: const Color(0xffEBEBF7),
      alignment: Alignment.centerLeft,
      child: Text(
        tag,
        softWrap: false,
        style: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: Color(0xFF181941),
        ),
      ),
    );
  }
}
