class ApiConfig {
  static const String baseUrl = 'http://localhost:3010';
  static const String apiVersion = 'v1';
  static const String apiBasePath = '/api/v1';

  // Auth endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String profileEndpoint = '/auth/profile';

  // Menu endpoints
  static const String menuEndpoint = '/menu';

  // Headers
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> authHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };

  // Full URLs
  static String get loginUrl => '$baseUrl$apiBasePath$loginEndpoint';
  static String get registerUrl => '$baseUrl$apiBasePath$registerEndpoint';
  static String get profileUrl => '$baseUrl$apiBasePath$profileEndpoint';
  static String get menuUrl => '$baseUrl$apiBasePath$menuEndpoint';
}
