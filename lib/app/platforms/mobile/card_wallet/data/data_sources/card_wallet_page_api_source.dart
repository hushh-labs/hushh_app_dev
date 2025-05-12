import 'package:dio/dio.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'card_wallet_page_api_source_impl.dart';

abstract class CardWalletPageApiDataSource {
  Future<void> acceptDataConsentRequest(String requestId);
}
