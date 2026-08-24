import 'package:dio/dio.dart';

class ApiResponseModel<T> {
  final int? responseStatusCode;
  final String? responseMessage;
  final T? responseData;
  final String? responseDescription;

  ApiResponseModel({
    this.responseStatusCode,
    this.responseMessage,
    this.responseData,
    this.responseDescription,
  });

  /// Standard fromJson if your API ever perfectly matches the model keys.
  factory ApiResponseModel.fromJson(Map<String, dynamic> json) {
    return ApiResponseModel(
      responseStatusCode: json['responseStatusCode'] as int?,
      responseMessage: json['responseMessage'] as String?,
      responseData: json['responseData'] as T?,
      responseDescription: json['responseDescription'] as String?,
    );
  }

  /// Custom factory to handle Dio Responses and map the mismatched API keys.
  factory ApiResponseModel.fromDioResponse(
    Response response, {
    T Function(dynamic data)? fromJson,
  }) {
    final responseDataMap = response.data as Map<String, dynamic>;
    final rawData = responseDataMap['data'];
    return ApiResponseModel<T>(
      // Pulls status code from the Dio response, not the JSON body
      responseStatusCode: response.statusCode,
      // Maps the actual API keys to your model properties
      responseMessage:
          (responseDataMap['msg'] ?? responseDataMap['message']) as String?,
      responseDescription: responseDataMap['description'] as String?,
      // Handles generic DTO parsing if a fromJson function is passed
      responseData: fromJson != null && rawData != null
          ? fromJson(rawData)
          : rawData as T?,
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Error classification helpers
//
// These are intentionally kept OUTSIDE of ApiResponseModel. That class only
// ever runs on a successful Dio Response — it exists to survive the server's
// inconsistent key naming (msg vs message, etc). A blocked duplicate request
// never produces a Response at all (DedupeInterceptor rejects it before the
// network call happens), so there is nothing for ApiResponseModel to parse.
// This helper classifies the *exception* instead, for use in a controller's
// catch block, e.g.:
//
//   } catch (e) {
//     if (isDuplicateRequestError(e)) {
//       state = state.copyWith(isLoading: false);
//       return; // silent no-op — first tap's request is still in flight
//     }
//     final msg = e.toString().replaceFirst('Exception: ', '');
//     ...
//   }
// ════════════════════════════════════════════════════════════════════════════

/// Returns true if [error] is the DioException thrown by DedupeInterceptor
/// when it blocks a duplicate in-flight request (e.g. from a double-tap).
bool isDuplicateRequestError(Object error) {
  return error is DioException &&
      error.type == DioExceptionType.cancel &&
      error.error == 'duplicate_request_blocked';
}
