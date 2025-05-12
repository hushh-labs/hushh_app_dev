import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/error_handler/dev_tool.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:retrofit/retrofit.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'error_state.dart';

class ErrorHandler {
  static Future<bool> _isConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  static Future<Either<ErrorState, T>> callApi<T>(
    Future<HttpResponse> Function() repositoryConnect,
    T Function(dynamic) repositoryParse,
  ) async {
    try {
      final response = await repositoryConnect();
      switch (response.response.statusCode) {
        case 200:
          try {
            return right(repositoryParse(response.data));
          } catch (e) {
            return left(DataParseError(Exception(e.toString())));
          }
        case 401:
          return left(DataHttpError(HttpException.unAuthorized));
        case 500:
          return left(DataHttpError(HttpException.internalServerError));
        default:
          return left(DataHttpError(HttpException.unknown));
      }
    } on DioException catch (e) {
      // print(e.error);
      // print(e.response);
      // print(e.stackTrace);
      if (!await _isConnected()) {
        return left(DataNetworkError(
            NetworkException.noInternetConnection, e.response));
      }

      switch (e.type) {
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
          return left(
              DataNetworkError(NetworkException.timeOutError, e.response));
        default:
          return left(DataNetworkError(NetworkException.unknown, e.response));
      }
    }
  }

  static Future<Either<ErrorState, T>> callSupabase<T>(
      Future<dynamic> Function() repositoryConnect,
      T Function(dynamic) repositoryParse,
      ) async {
    try {
      dynamic response = await repositoryConnect();
      return right(repositoryParse(response));
    } catch (e, s) {
      // print(e.error);
      // print(e.response);
      // print(e.stackTrace);
      sl<Talker>().logTyped(SupabaseLogger(e.toString(), s, e));
      if (!await _isConnected()) {
        return left(DataNetworkError(
            NetworkException.noInternetConnection, Response(
          requestOptions: RequestOptions(),
          data: "No internet connection!"
        )));
      } else {
        return left(DataNetworkError(
            NetworkException.unknown, Response(
            requestOptions: RequestOptions(),
            data: "$e\n${s.toString()}"
        )));
      }
    }
  }
}
