enum AuthFlowMode { login, register }

enum AuthLoginMethod { password, otp }

class AuthFlowArgs {
  const AuthFlowArgs({
    required this.mode,
    this.fullName,
    this.phoneNumber,
  });

  final AuthFlowMode mode;
  final String? fullName;
  final String? phoneNumber;
}

class OtpRequestResult {
  const OtpRequestResult({
    required this.message,
    this.debugCode,
  });

  final String message;
  final String? debugCode;
}
