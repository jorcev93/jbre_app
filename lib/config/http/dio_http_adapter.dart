import 'package:dio/dio.dart';

import 'http_adapter.dart';

/// Implementación del adaptador HTTP usando Dio.
class DioHttpAdapter implements HttpAdapter {
  late final Dio _dio;

  DioHttpAdapter({
    required String baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Map<String, String>? defaultHeaders,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout ?? const Duration(seconds: 10),
        receiveTimeout: receiveTimeout ?? const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          ...?defaultHeaders,
        },
      ),
    );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Log de peticiones (útil para debug)
          // print('REQUEST[${options.method}] => PATH: ${options.path}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          // Log de respuestas (útil para debug)
          // print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          handler.next(response);
        },
        onError: (error, handler) {
          // Log de errores (útil para debug)
          // print('ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}');
          handler.next(error);
        },
      ),
    );
  }

  @override
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  @override
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  @override
  Future<HttpResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    return _executeRequest<T>(
      () => _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      ),
    );
  }

  @override
  Future<HttpResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    return _executeRequest<T>(
      () => _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      ),
    );
  }

  @override
  Future<HttpResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    return _executeRequest<T>(
      () => _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      ),
    );
  }

  @override
  Future<HttpResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    return _executeRequest<T>(
      () => _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      ),
    );
  }

  @override
  Future<HttpResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    return _executeRequest<T>(
      () => _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      ),
    );
  }

  Future<HttpResponse<T>> _executeRequest<T>(
    Future<Response<dynamic>> Function() request,
  ) async {
    try {
      final response = await request();
      return HttpResponse<T>(
        data: response.data as T,
        statusCode: response.statusCode ?? 0,
        headers: response.headers.map.map(
          (key, value) => MapEntry(key, value.join(', ')),
        ),
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  HttpAdapterException _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return HttpAdapterException(
          message: 'Tiempo de conexión agotado',
          statusCode: null,
        );
      case DioExceptionType.sendTimeout:
        return HttpAdapterException(
          message: 'Tiempo de envío agotado',
          statusCode: null,
        );
      case DioExceptionType.receiveTimeout:
        return HttpAdapterException(
          message: 'Tiempo de respuesta agotado',
          statusCode: null,
        );
      case DioExceptionType.badResponse:
        return HttpAdapterException(
          message: e.response?.statusMessage ?? 'Error en la respuesta',
          statusCode: e.response?.statusCode,
          data: e.response?.data,
        );
      case DioExceptionType.cancel:
        return HttpAdapterException(
          message: 'Petición cancelada',
          statusCode: null,
        );
      case DioExceptionType.connectionError:
        return HttpAdapterException(
          message: 'Error de conexión. Verifica tu conexión a internet.',
          statusCode: null,
        );
      case DioExceptionType.badCertificate:
        return HttpAdapterException(
          message: 'Certificado SSL inválido',
          statusCode: null,
        );
      case DioExceptionType.unknown:
        return HttpAdapterException(
          message: e.message ?? 'Error desconocido',
          statusCode: null,
        );
    }
  }
}
