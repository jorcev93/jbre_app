/// Respuesta genérica del adaptador HTTP
class HttpResponse<T> {
  final T data;
  final int statusCode;
  final Map<String, dynamic> headers;

  HttpResponse({
    required this.data,
    required this.statusCode,
    this.headers = const {},
  });
}

/// Excepción personalizada para errores HTTP
class HttpAdapterException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;
  final HttpResponse? response;

  HttpAdapterException({
    required this.message,
    this.statusCode,
    this.data,
    this.response,
  });

  @override
  String toString() =>
      'HttpAdapterException: $message (statusCode: $statusCode)';
}

/// Interfaz abstracta para el adaptador HTTP.
/// Permite desacoplar la implementación concreta (Dio, http, etc.)
/// del resto de la aplicación.
abstract class HttpAdapter {
  /// Realiza una petición GET
  Future<HttpResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });

  /// Realiza una petición POST
  Future<HttpResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });

  /// Realiza una petición PUT
  Future<HttpResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });

  /// Realiza una petición PATCH
  Future<HttpResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });

  /// Realiza una petición DELETE
  Future<HttpResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });

  /// Configura el token de autorización para las peticiones
  void setAuthToken(String token);

  /// Elimina el token de autorización
  void clearAuthToken();
}
