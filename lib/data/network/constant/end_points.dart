class EndPoints {
  static const String baseUrl = "https://api.themoviedb.org/3/";
  // receiveTimeout
  static const Duration receiveTimeout = Duration(milliseconds: 15000);

  // connectTimeout
  static const Duration connectionTimeout = Duration(microseconds: 15000);

  static const String users = '/users';
  static const String refreshToken = '/users';
}
