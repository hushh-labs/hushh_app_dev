import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:io';

import 'package:azlistview/azlistview.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/user.dart';
import 'package:hushh_app/app/shared/config/constants/colors.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/core/backend_controller/db_controller/db_controller_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/firebasecrashlytics.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/models/alphabet_search_model.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:url_launcher/url_launcher.dart';

class InviteUsersToHushhPage extends StatefulWidget {
  const InviteUsersToHushhPage({Key? key}) : super(key: key);

  @override
  State<InviteUsersToHushhPage> createState() => _InviteUsersToHushhPageState();
}

class _InviteUsersToHushhPageState extends State<InviteUsersToHushhPage> {
  late Iterable<Contact> contactsStore;
  late Widget container;
  final GlobalKey<ScaffoldState> chatListViewScaffoldKey =
      GlobalKey<ScaffoldState>();
  late double textSizeBasedOnDevice;
  late double width;
  late double height;
  bool exitApp = false;
  bool contactsControl = false;

  get primaryColor => CustomColors.projectBaseBlue;
  List<String> phoneNumberListHushUsersFromDataBase = [];
  List<String> phoneContactPhoneNumberListFull = [];
  List<String> phoneContactPhoneNumberListHushUser = [];
  List<String> phoneContactPhoneNumberListNonHushUser = [];
  List<String> phoneContactNameListFull = [];
  List<String> phoneContactNameListHushUser = [];
  List<String> phoneContactNameListNonHushUser = [];
  late List getUnrgisteredcontacts = [];
  List searchList = [];
  List<Languages1> originList = [];
  List<AlphabetSearch>? dataList;
  List<AlphabetSearch>? initialList;
  ItemScrollController itemScrollController = ItemScrollController();
  static List githubLanguageColors = [];
  String link = '';

  List<String> filteredNameList = [];

  onWillPop(bool) {
    Navigator.of(context).pop();
    return false;
  }

  unFocus() {
    FocusScope.of(context).unfocus();
  }

  bool isNumeric(String str) {
    RegExp _numeric = RegExp(r'^-?[0-9]+$');
    return _numeric.hasMatch(str);
  }

  // contactDataFetchFresh() async{
  //   final SharedPreferences prefs = await _prefs;
  //   final Iterable<Contact> contacts = await ContactsService.getContacts(withThumbnails: false, photoHighResolution: false,);
  //   QuerySnapshot querySnapshot = await fireStore.collection("HushUsers").get();
  //   List data = querySnapshot.docs.map((doc) => doc.data()).toList();
  //   for(int i = 0; i < data.length; i++){
  //     setState(() {
  //       phoneNumberListHushUsersFromDataBase.add(data[i]['phoneNumber']);
  //       contactsStore = contacts;
  //     });
  //   }
  //   for(int i = 0; i < contactsStore.length; i ++){
  //     Contact? contact = contactsStore.elementAt(i);
  //     var mobileNumber = contact.phones?.toList();
  //     if(mobileNumber!.isNotEmpty){
  //       if(mobileNumber[0].value!.length > 3){
  //         bool intRemoval = isNumeric(contact.displayName.toString().substring(0,2));
  //         if(intRemoval == false){
  //           setState(() {
  //             phoneContactNameListFull.add(contact.displayName.toString());
  //             phoneContactPhoneNumberListFull.add(mobileNumber[0].value.toString());
  //             phoneContactNameListNonHushUser = phoneContactNameListFull;
  //             phoneContactPhoneNumberListNonHushUser = phoneContactPhoneNumberListFull;
  //           });
  //         }
  //       }
  //     }
  //   }
  //   setState((){
  //     phoneContactPhoneNumberListHushUser = phoneContactPhoneNumberListFull.where((item) => phoneNumberListHushUsersFromDataBase.contains(item)).toList();
  //   });
  //   for(int i = 0; i < phoneContactPhoneNumberListFull.length; i++){
  //     if(phoneContactPhoneNumberListHushUser.any((e) => e.contains(phoneContactPhoneNumberListFull[i])) == true){
  //       setState(() {
  //         phoneContactNameListHushUser.add(phoneContactNameListFull[i]);
  //         phoneContactNameListNonHushUser.remove(phoneContactNameListFull[i]);
  //         phoneContactPhoneNumberListNonHushUser.remove(phoneContactPhoneNumberListNonHushUser[i]);
  //       });
  //     }
  //   }
  //   setState(() {
  //     contactsControl = true;
  //   });
  // }

  // permissionHandler() async{
  //   await Permission.contacts.request();
  //   final PermissionStatus permissionStatus = await getPermission();
  //   if (permissionStatus == PermissionStatus.granted) {
  //     contactDataFetchFresh();
  //   } else{
  //     return showDialog(
  //         context: context,
  //         builder: (BuildContext context) => CupertinoAlertDialog(
  //           title: const Text('Permissions error'),
  //           content: const Text('Please enable contacts access '
  //               'permission in system settings'),
  //           actions: <Widget>[
  //             CupertinoDialogAction(
  //               child: const Text('OK'),
  //               onPressed: () => Navigator.of(context).pop(),
  //             )
  //           ],
  //         ));
  //   }
  // }

  // Future<PermissionStatus> getPermission() async {
  //   final PermissionStatus permission = await Permission.contacts.status;
  //   if (permission != PermissionStatus.granted &&
  //       permission != PermissionStatus.denied){
  //     final Map<Permission, PermissionStatus> permissionStatus =
  //     await [Permission.contacts].request();
  //     return permissionStatus[Permission.contacts] ??
  //         PermissionStatus.denied;
  //   }else{
  //     return permission;
  //   }
  // }

  Future<List<Contact>> fetchHushhUsersInContacts() async {
    final contacts = await ContactsService.getContacts();
    final result = <Contact>[];

    // Fetch existing phone numbers of Hushh users
    List<String> existingNumbers = await sl<DbController>().fetchAllUsers();

    await Future.forEach(contacts, (Contact contact) async {
      final phoneNumbers = contact.phones ?? [];
      for (var phone in phoneNumbers) {
        String? phoneNumber = phone.value;

        if (phoneNumber != null && phoneNumber.trim().isNotEmpty) {
          // Clean the phone number by removing non-numeric characters
          phoneNumber = phoneNumber.phoneNumber();

          // Check if the number exists in the list of Hushh users
          final isHushUser = existingNumbers.contains(phoneNumber);
          if (!isHushUser) {
            result.add(contact);
            break; // Stop processing further numbers for this contact
          }
        }
      }
    });

    return result;
  }

  sharei(String numb) {
    try {
      String subject =
          "Let's chat on Hushh! It's a fast, simple, and secure app we can use to message and earn points each other for free. get it ios: https://testflight.apple.com/join/PCkFSIyu";
      if (Platform.isAndroid) {
        setState(() {
          link = "https://bit.ly/3vohH1I";
        });
      } else if (Platform.isIOS) {
        setState(() {
          link = "https://testflight.apple.com/join/PCkFSIyu";
        });
      }
      shareinn(numb, subject, link);
    } catch (e, s) {
      // FirebaseCrashLogs.logFatelError(
      //     error: e,
      //     stackTrace: s,
      //     reason: "Exception in sharei Method in NewChatInvite.dart");
    }
  }

  shareinn(String number1, String sub, String link) async {
    try {
      if (Platform.isAndroid) {
        String uri = 'sms:$number1?body=$sub';
        await launchUrl(Uri.parse(uri));
      } else if (Platform.isIOS) {
        final Uri smsLaunchUri = Uri(
          path: number1,
        );
        var encodeString = Uri.encodeFull(sub);
        String uri = 'sms:$smsLaunchUri&body=$encodeString';
        await launchUrl(Uri.parse(uri));
      }
    } catch (e, s) {
      // FirebaseCrashLogs.logFatelError(
      //     error: e,
      //     stackTrace: s,
      //     reason: "Exception in shareinn Method in NewChatInvite.dart");
    }
  }

  void filterSearchResults(String query) {
    try {
      List dummySearchList = [];
      dummySearchList.addAll(getUnrgisteredcontacts);
      if (query.isNotEmpty) {
        List dummyListData = [];
        dummySearchList.forEach((item) {
          if (item['name'].toLowerCase().contains(query)) {
            dummyListData.add(item);
          } else if (item['name'].toUpperCase().contains(query)) {
            dummyListData.add(item);
          }
        });
        setState(() {
          searchList.clear();
          searchList.addAll(dummyListData);
        });
        return;
      } else {
        setState(() {
          searchList.clear();
          searchList.addAll(getUnrgisteredcontacts);
        });
      }
    } catch (e, s) {
      // FirebaseCrashLogs.logFatelError(
      //     error: e,
      //     stackTrace: s,
      //     reason:
      //         "Exception in filterSearchResults Method in NewChatInvite.dart");
    }
  }

  Widget getSusItem(BuildContext context, String tag, {double susHeight = 40}) {
    return Container(
      height: susHeight,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 16.0),
      color: const Color(0xffEBEBF7),
      alignment: Alignment.centerLeft,
      child: Text(
        tag,
        softWrap: false,
        style: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: Color(0xFF666666),
        ),
      ),
    );
  }

  void _search(String text) {
    try {
      if (text.trim().isEmpty) {
        dataList = List.from(initialList!);
        setState(() {});
        return;
      }
      List<AlphabetSearch> list = dataList!.where((v) {
        return v.contactName.toLowerCase().contains(text.toLowerCase());
      }).toList();
      _handleList(list);
    } catch (e, s) {
      // FirebaseCrashLogs.logFatelError(
      //     error: e,
      //     stackTrace: s,
      //     reason: "Exception in _search Method in NewChatInvite.dart");
    }
  }

  void _handleList(List<AlphabetSearch> list) {
    try {
      dataList!.clear();
      setState(() {});
      dataList!.addAll(list);
      // A-Z sort.
      SuspensionUtil.sortListBySuspensionTag(dataList);

      // show sus tag.
      SuspensionUtil.setShowSuspensionStatus(dataList);

      setState(() {});

      if (itemScrollController.isAttached) {
        itemScrollController.jumpTo(index: 0);
      }
    } catch (e, s) {
      // FirebaseCrashLogs.logFatelError(
      //     error: e,
      //     stackTrace: s,
      //     reason: "Exception in _handleList Method in NewChatInvite.dart");
    }
  }

  List<GithubLanguage1> newService() {
    githubLanguageColors = searchList;

    List<GithubLanguage1> list =
        githubLanguageColors.map((v) => GithubLanguage1.fromJson(v)).toList();

    return list;
  }

  Widget getListItem(BuildContext context, AlphabetSearch model,
      {double susHeight = 40}) {
    return GestureDetector(
      onTap: () async {
        var number = model.contactPhoneNumber;
        sharei(number);
      },
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
        leading: CircleAvatar(
          child: Text(model.contactName.isNotEmpty
              ? model.contactName.substring(0, 1)
              : ""),
          backgroundColor: CustomColors.projectBaseBlue,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(model.contactName),
                Text(
                  model.contactPhoneNumber,
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),

            /*IconButton(
                        icon: const Icon(Icons.share),
                        iconSize: 25.0,
                        color: CustomColors.projectBaseBlue,
                        onPressed: () async {
                          sharing(context);
                        },
                      ),*/
          ],
        ),
      ),
    );
  }

  loadContactData() {
    fetchHushhUsersInContacts().then((value) {
      dataList = value.map((contact) {
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
      initialList = List.from(dataList!);
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    loadContactData();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    container = homeViewContainer();
    return Scaffold(
        body: container,
        resizeToAvoidBottomInset: false,
        key: chatListViewScaffoldKey);
  }

  homeViewContainer() {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white)),
        title: const Text(
          'Invite',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: CustomColors.projectBaseBlue,
      ),
      body: dataList != null
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    height: 40,
                    child: TextField(
                      autofocus: false,
                      onChanged: (r) {
                        _search(r);
                      },
                      style: TextStyle(
                          fontSize: 17.0, color: Colors.grey.shade600),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Search...',
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                    height: 20,
                    child: Center(
                      child: Text(
                        "Tap the contact to invite people on your contacts",
                        style: TextStyle(
                            color: CustomColors.greyColor, fontSize: 13),
                      ),
                    )),
                Expanded(
                  child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (overflow) {
                      overflow.disallowIndicator();
                      return true;
                    },
                    child: AzListView(
                      itemScrollController: itemScrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      data: dataList!,
                      itemCount: dataList!.length,
                      itemBuilder: (BuildContext context, int index) {
                        AlphabetSearch model = dataList![index];
                        return getListItem(
                          context,
                          model,
                        );
                      },
                      susItemBuilder: (BuildContext context, int index) {
                        AlphabetSearch model = dataList![index];
                        return getSusItem(context, model.getSuspensionTag());
                      },
                      indexBarOptions: const IndexBarOptions(
                        needRebuild: true,
                        hapticFeedback: true,
                        selectTextStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                        selectItemDecoration: BoxDecoration(
                            shape: BoxShape.circle, color: Color(0xFF333333)),
                        indexHintWidth: 96,
                        indexHintHeight: 97,
                        indexHintAlignment: Alignment.centerRight,
                        indexHintTextStyle:
                            TextStyle(fontSize: 24.0, color: Colors.white),
                        indexHintOffset: Offset(-30, 0),
                      ),
                    ),
                  ),
                ),
                // Expanded(
                //   child: ListView.builder(
                //     shrinkWrap: true,
                //     itemCount: searchList.isEmpty ? 0 : searchList.length,
                //     itemBuilder: (BuildContext context, int index) {
                //       return ListTile(
                //         contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                //         leading: const CircleAvatar(
                //           child: Text('H'),
                //           backgroundColor: CustomColors.projectBaseBlue,
                //         ),
                //         title: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Column(
                //               mainAxisAlignment: MainAxisAlignment.start,
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                 Text(searchList[index]['name']),
                //                 Text(searchList[index]['phoneNumber'],
                //                   style: const TextStyle(fontSize: 10),),
                //               ],
                //             ),
                //             IconButton(
                //               icon: const Icon(Icons.share),
                //               iconSize: 25.0,
                //               color: CustomColors.projectBaseBlue,
                //               onPressed: () async {
                //                 sharing(context);
                //               },
                //             ),
                //           ],
                //         ),
                //       );
                //     },
                //   ),
                // ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(
              color: CustomColors.projectBaseBlue,
            )),
    );
  }
}

class Languages1 extends GithubLanguage1 with ISuspensionBean {
  String? tagIndex;

  Languages1.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = super.toJson();
    return map;
  }

  @override
  String getSuspensionTag() {
    return tagIndex!;
  }

  @override
  String toString() {
    return json.encode(this);
  }
}

class GithubLanguage1 {
  String contactName;
  String contactPhoneNumber;

  GithubLanguage1.fromJson(json)
      : contactName = json['name'],
        contactPhoneNumber = json['phoneNumber'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    void addIfNonNull(String fieldName, dynamic value) {
      if (value != null) {
        map[fieldName] = value;
      }
    }

    addIfNonNull('name', contactName);
    addIfNonNull('phoneNumber', contactPhoneNumber);
    return map;
  }

  @override
  String toString() {
    return json.encode(this);
  }
}
