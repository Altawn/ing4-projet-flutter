class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const pbBaseUrl = String.fromEnvironment('PB_URL', defaultValue: 'http://127.0.0.1:8090');

  String? token;
  String? userId;

  void setTokenAndUserId(String newToken, String newUserId) {
    token = newToken;
    userId = newUserId;
  }

  void logout() {
    token = null;
    userId = null;
  }
}
