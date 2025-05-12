import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/card_wallet_info/card_wallet_info.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/brand.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/browsed_product_model.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/bloc/settings_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/components/card_assets_import.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';
import 'package:metadata_fetch_plus/metadata_fetch_plus.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class ReceiveSharingIntentHelper {
  late StreamSubscription intentSub;
  final _sharedFiles = <SharedMediaFile>[];

  Future<void> _onTextOrUrlReceived(SharedMediaFile textOrUrl) async {
    String? url = Utils().extractUrl(textOrUrl.path);
    if (url != null) {
      // check if extension is linked
      bool isExtensionLinked = AppLocalStorage.user!.isHushhExtensionUser;
      if (!isExtensionLinked) {
        return;
      }
      // fetch all cards
      await sl<CardWalletPageBloc>().getInstalledCards();
      // fetch browsing card
      final browsingCard = sl<CardWalletPageBloc>()
          .preferenceCards
          .where((element) => element.id == Constants.browseCardId)
          .firstOrNull;

      if (browsingCard != null) {
        final currentState = navigatorKey.currentState;
        if (currentState != null) {
          // open browsing card
          currentState.pushNamed(AppRoutes.cardWallet.info.main,
              arguments: CardWalletInfoPageArgs(cardData: browsingCard));
          showDialog(
            context: currentState.context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.all(16),
                    child: const CupertinoActivityIndicator(),
                    // You can customize the dialog further if needed
                  ),
                ],
              );
            },
          );
          // upload url to products table in supabase
          Future.wait([
            MetadataFetch.extract(url),
            Gemini.instance.text(
                "$url\nExtract brand, productTitle, category of the product from the above url Return as a key value pair in json, do not add the ```json in the response with brand,productTitle,category as keys")
          ]).then((value) {
            final metadata = (value[0] as Metadata?);
            final candidates = (value[1] as Candidates?);
            Map? aiResponse;
            try {
              aiResponse = jsonDecode(candidates?.output ?? "");
            } catch (_) {}
            final product = BrowsedProduct(
                productUrl: url,
                productTitle: metadata?.title ?? aiResponse?['productTitle'],
                timestamp: DateTime.now(),
                description: metadata?.description,
                imageUrl: metadata?.image,
                userId: AppLocalStorage.hushhId,
                productCategory: aiResponse?['category'] ?? 'OTHERS',
                brand: Brand(brandName: aiResponse?['brand'] ?? 'OTHERS'));
            sl<SettingsPageBloc>().add(InsertBrowsedProductEvent(product));
          }).catchError((e) => currentState.pop());
        }
      }
    }
  }

  Future<void> _onAssetReceived(List<SharedMediaFile> assets) async {
    final currentState = navigatorKey.currentState;
    if (currentState == null) return;

    // if (assets.length == 1) {
    //   try {
    //     String? result = await Scan.parse(assets.first.path);
    //     Uri? uri = Uri.tryParse(result ?? '');
    //     if (uri != null) {
    //       final Map<String, String> queryParams = uri.queryParameters;
    //       debugPrint('$queryParams');
    //       if (queryParams.containsKey('uid') &&
    //           queryParams.containsKey('data')) {
    //         int? brandIdAsInt = int.tryParse(queryParams['data'] ?? '');
    //         String? uid = queryParams['uid'];
    //         if (brandIdAsInt != null && uid != null) {
    //           Navigator.push(
    //               currentState.context,
    //               MaterialPageRoute(
    //                   builder: (context) =>
    //                       CardImportPage(uid: uid, cardId: brandIdAsInt)));
    //           return;
    //         }
    //       }
    //     }
    //   } catch (e) {
    //     print("ERROR: $e");
    //   }
    // }

    Navigator.push(
        currentState.context,
        MaterialPageRoute(
            builder: (context) => CardAssetsImportPage(
                files: assets.map((e) => File(e.path)).toList())));
  }

  Future<void> _onReceive(List<SharedMediaFile> files) async {
    if (files.isEmpty) return;
    _sharedFiles.clear();
    _sharedFiles.addAll(files);

    if (files.length == 1) {
      final file = files.first;
      if (file.type == SharedMediaType.text ||
          file.type == SharedMediaType.url) {
        await _onTextOrUrlReceived(file);
        return;
      }
    }

    _onAssetReceived(files);
  }

  void initialize() {
    // Listen to media sharing coming from outside the app while the app is in the memory.
    intentSub =
        ReceiveSharingIntent.instance.getMediaStream().listen((value) async {
      await _onReceive(value);
    }, onError: (err) {
      if (kDebugMode) {}
    });

    // Get the media sharing coming from outside the app while the app is closed.
    ReceiveSharingIntent.instance.getInitialMedia().then((value) async {
      await _onReceive(value);

      // Tell the library that we are done processing the intent.
      ReceiveSharingIntent.instance.reset();
    });
  }
}
