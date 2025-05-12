part of 'card_wallet_page_api_source.dart';

class CardWalletPageApiDataSourceImpl extends CardWalletPageApiDataSource {
  @override
  Future<void> acceptDataConsentRequest(String requestId) async {
    final r = await sl<Dio>().post(
        'https://app-apis-53407187172.us-central1.run.app/api/v1/process-dev-consent-request',
        options: Options(headers: {'jwt-token': Supabase.instance.client.auth.currentSession?.accessToken}),
        data: {"request_id": requestId, "status": true});
    print(r.data);
  }
}
