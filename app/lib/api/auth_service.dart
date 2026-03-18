class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

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
