import 'package:dio/dio.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

class URLInterceptor extends Interceptor {
  String dynamicBaseUrl;

  URLInterceptor(this.dynamicBaseUrl);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.baseUrl = dynamicBaseUrl;
    options.headers.addAll(
      {
        "Content-Type": "application/x-www-form-urlencoded"
        // "Authorization": "Bearer ${UserLocalStorage.authState?.accessToken}",
      },
    );
    // debugPrint('---');
    // debugPrint(options.path);
    // debugPrint(options.data);
    // debugPrint(options.path);
    // debugPrint(jsonEncode(options.headers));
    // debugPrint('---');
    handler.next(options);
  }
}

class ResponseInterceptor extends Interceptor {
  ResponseInterceptor();

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // String requestEndpoint = response.realUri.toString();
    // debugPrint('---');
    // debugPrint('Request Endpoint: $requestEndpoint');
    // debugPrint('Response Status Code: ${response.statusCode}');
    // debugPrint('Response Data: ${response.data}');
    // debugPrint('---');
    handler.next(response);
  }
}

Dio customDio() {
  final dio = Dio(
      BaseOptions(contentType: 'application/json', baseUrl: Constants.baseUrl));
  final talkerDioLogger = TalkerDioLogger(
    talker: sl<Talker>(),
    settings: const TalkerDioLoggerSettings(
      printRequestHeaders: true,
      printResponseHeaders: false,
      printRequestData: true,
      printResponseData: false,
    ),
  );
  // dio.interceptors.add(ResponseInterceptor());
  dio.interceptors.add(talkerDioLogger);
  return dio;
}
