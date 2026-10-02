class ApiConfig {
  static const String baseUrl = 'https://ecommerce-backend-irl8.onrender.com';

  // Auth endpoints
  static const String register = '$baseUrl/api/auth/register';
  static const String login = '$baseUrl/api/auth/login';
  static const String logout = '$baseUrl/api/auth/logout';
  static const String me = '$baseUrl/api/auth/me';
  static const String sendOtp = '$baseUrl/api/auth/send-otp';
  static const String verifyOtp = '$baseUrl/api/auth/login-otp';

  // Products & Categories
  static const String products = '$baseUrl/api/products';
  static const String categories = '$baseUrl/api/categories';
  static const String banners = '$baseUrl/api/banners';

  // Cart, Orders, Coupons, Notifications, Addresses
  static const String cart = '$baseUrl/api/cart';
  static const String orders = '$baseUrl/api/orders';
  static const String coupons = '$baseUrl/api/coupons';
  static const String notifications = '$baseUrl/api/notifications';
  static const String addresses = '$baseUrl/api/addresses';

  // Standard Headers
  static Map<String, String> headers({String? token}) {
    final Map<String, String> h = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      h['Authorization'] = 'Bearer $token';
    }
    return h;
  }
}
