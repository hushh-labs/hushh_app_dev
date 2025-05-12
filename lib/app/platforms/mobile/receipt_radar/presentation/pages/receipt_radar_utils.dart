import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/receipt_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/domain/usecases/fetch_receipt_radar_insights_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/bloc/receipt_radar_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/components/receipt_radar_google_auth.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/core/backend_controller/db_controller/db_tables.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tuple/tuple.dart';

class ReceiptRadarUtils {
  final FetchReceiptRadarInsightsUseCase fetchReceiptRadarInsightsUseCase;

  ReceiptRadarUtils(this.fetchReceiptRadarInsightsUseCase);

  Future<List<ReceiptModel>> fetchReceipts(
      {String? uid, bool forceFetch = false}) async {
    if (AppLocalStorage.hushhId == null) {
      return [];
    }
    if ((sl<ReceiptRadarBloc>().receipts?.isNotEmpty ?? false) && !forceFetch) {
      return sl<ReceiptRadarBloc>().receipts!;
    }
    Completer<List<ReceiptModel>> completer = Completer();
    final result = await fetchReceiptRadarInsightsUseCase(
        uid: uid ?? AppLocalStorage.hushhId!);
    result.fold((l) => null, (r) {
      final Map<String, ReceiptModel> receiptMap = {};
      for (var receipt in r) {
        if (receipt.company != '' && !receiptMap.containsKey(receipt.finalTitle)) {
          receiptMap[receipt.finalTitle] = receipt;
        }
      }
      log(receiptMap.toString());
      final uniqueReceipts = receiptMap.values.toList();
      sl<ReceiptRadarBloc>().receipts = uniqueReceipts;
      completer.complete(uniqueReceipts);
    });
    return completer.future;
  }

  Stream<List<ReceiptModel>> fetchReceiptsAsStream({String? uid}) {
    final supabase = Supabase.instance.client;
    final data = supabase
        .from(DbTables.receiptRadarTable)
        .select()
        .eq('user_id', uid ?? AppLocalStorage.hushhId!)
        .asStream();
    return data
        .map((event) => event.map((e) => ReceiptModel.fromJson(e)).toList());
  }

  /// item1: email?
  /// item2: accessToken?
  Future<Tuple2<String?, String?>?> googleAuth({bool refresh = false}) async {
    if (refresh) {
      return Future.value();
    }
    Completer<Tuple2<String?, String?>?> completer =
        Completer<Tuple2<String?, String?>?>();

    final currentState = navigatorKey.currentState;

    if (currentState == null) {
      return Future.value();
    }

    await Navigator.of(currentState.context).push(
      MaterialPageRoute(
        builder: (context) => GoogleAuthWebView(
          onAuthComplete: (String? email, String? accessToken) {
            if (email != null) {
              AppLocalStorage.userConnectReceiptRadar(email);
              sl<CardWalletPageBloc>().addCoins(20);
            }
            completer.complete(Tuple2(email, accessToken));
          },
        ),
      ),
    );

    final data = await completer.future;
    if (data?.item1 != null) {
      AppLocalStorage.userConnectReceiptRadar(data!.item1);
    }
    return data;
  }

// Future<String?> googleAuth({bool refresh = false}) async {
//   final scopes = [
//     'https://www.googleapis.com/auth/gmail.readonly',
//   ];
//   GoogleSignIn googleSignIn = GoogleSignIn(
//     scopes: scopes,
//   );
//
//   if (kIsWeb || Platform.isAndroid) {
//     googleSignIn = GoogleSignIn(
//       scopes: scopes,
//     );
//   }
//
//   if (Platform.isIOS || Platform.isMacOS) {
//     googleSignIn = GoogleSignIn(
//       clientId: Secrets.getIosId(),
//       scopes: scopes,
//     );
//   }
//
//   String? accessToken;
//   if (refresh) {
//     final isUserSignedIn = await googleSignIn.isSignedIn();
//     if (isUserSignedIn) {
//       final googleSignInAccount = await googleSignIn.signInSilently();
//       if (googleSignInAccount != null &&
//           googleSignInAccount.email == AppLocalStorage.lastSyncedEmail) {
//         final credentials = await googleSignInAccount.authentication;
//         // getRefreshToken(credentials.idToken!);
//         accessToken = credentials.accessToken;
//       }
//     } else {
//       print("Cannot sync the receipts since user isn't signed in");
//     }
//   } else {
//     final value = await googleSignIn.isSignedIn();
//     if (value) {
//       await googleSignIn.signOut();
//     }
//     final googleSignInAccount = await googleSignIn.signIn();
//     if (googleSignInAccount != null) {
//       AppLocalStorage.updateLastSyncedEmail(googleSignInAccount.email);
//       final credentials = await googleSignInAccount.authentication;
//       // getRefreshToken(credentials.idToken!);
//       accessToken = credentials.accessToken;
//     }
//   }
//   if (accessToken != null) {
//     AppLocalStorage.userConnectReceiptRadar(accessToken);
//   }
//   return accessToken;
// }
}
