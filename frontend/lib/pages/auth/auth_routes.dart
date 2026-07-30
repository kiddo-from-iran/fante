class AuthRoutes {
  AuthRoutes._();

  static const landing = '/auth';
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const registerPhone = '/auth/register/phone';
  static const otp = '/auth/otp';
  static const setPassword = '/auth/set-password';

  /// @deprecated Use [login] instead.
  static const loginPhone = login;
}
