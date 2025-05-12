import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'card_market_api_data_source.g.dart';

@RestApi(baseUrl: "https://sandbox.plaid.com")
abstract class CardMarketApiDataSource {
  factory CardMarketApiDataSource(Dio dio) = _CardMarketApiDataSource;

  @POST('/item/public_token/exchange')
  Future<HttpResponse> generatePlaidToken(
    @Field("client_id") String client_id,
    @Field("secret") String secret,
    @Field("public_token") String public_token,
  );
}
