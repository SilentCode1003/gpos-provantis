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

  factory ApiResponseModel.fromJson(Map<String, dynamic> json) {
    return ApiResponseModel(
      responseStatusCode: json['responseStatusCode'] as int?,
      responseMessage: json['responseMessage'] as String?,
      responseData: json['responseData'] as T?,
      responseDescription: json['responseDescription'] as String?,
    );
  }

  factory ApiResponseModel.fromDioResponse(
    Response response, {
    T Function(dynamic data)? fromJson,
  }) {
    final responseDataMap = response.data as Map<String, dynamic>;
    final rawData = responseDataMap['data'];
    return ApiResponseModel<T>(
      responseStatusCode: response.statusCode,

      responseMessage:
          (responseDataMap['msg'] ?? responseDataMap['message']) as String?,
      responseDescription: responseDataMap['description'] as String?,

      responseData: fromJson != null && rawData != null
          ? fromJson(rawData)
          : rawData as T?,
    );
  }
}

bool isDuplicateRequestError(Object error) {
  return error is DioException &&
      error.type == DioExceptionType.cancel &&
      error.error == 'duplicate_request_blocked';
}
