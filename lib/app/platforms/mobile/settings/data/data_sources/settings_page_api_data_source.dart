import 'package:dio/dio.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/app_usage_data.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:retrofit/retrofit.dart';

part 'settings_page_api_data_source.g.dart';

@RestApi(baseUrl: Constants.baseUrl)
abstract class SettingsPageApiDataSource {
  factory SettingsPageApiDataSource(Dio dio) = _SettingsPageApiDataSource;

  @POST('/app-usage/after-usage-inserted')
  Future<HttpResponse> afterUsageInserted(
    @Body() List<AppUsageData> appUsageRequests,
  );
}
