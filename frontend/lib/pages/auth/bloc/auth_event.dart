import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthAppStarted extends AuthEvent {
  const AuthAppStarted();
}

class AuthRegisterNameSubmitted extends AuthEvent {
  const AuthRegisterNameSubmitted({
    required this.firstName,
    required this.lastName,
  });

  final String firstName;
  final String lastName;

  @override
  List<Object?> get props => [firstName, lastName];
}

class AuthPasswordLoginSubmitted extends AuthEvent {
  const AuthPasswordLoginSubmitted({
    required this.phoneNumber,
    required this.password,
  });

  final String phoneNumber;
  final String password;

  @override
  List<Object?> get props => [phoneNumber, password];
}

class AuthLoginOtpRequested extends AuthEvent {
  const AuthLoginOtpRequested(this.phoneNumber);

  final String phoneNumber;

  @override
  List<Object?> get props => [phoneNumber];
}

class AuthRegisterPasswordSubmitted extends AuthEvent {
  const AuthRegisterPasswordSubmitted(this.password);

  final String password;

  @override
  List<Object?> get props => [password];
}

class AuthPhoneSubmitted extends AuthEvent {
  const AuthPhoneSubmitted(this.phoneNumber);

  final String phoneNumber;

  @override
  List<Object?> get props => [phoneNumber];
}

class AuthOtpSubmitted extends AuthEvent {
  const AuthOtpSubmitted(this.code, {this.phoneNumber});

  final String code;
  final String? phoneNumber;

  @override
  List<Object?> get props => [code, phoneNumber];
}

class AuthResendOtpRequested extends AuthEvent {
  const AuthResendOtpRequested();
}

class AuthGoogleSignInRequested extends AuthEvent {
  const AuthGoogleSignInRequested();
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthFlowModeSelected extends AuthEvent {
  const AuthFlowModeSelected({required this.isRegister});

  final bool isRegister;

  @override
  List<Object?> get props => [isRegister];
}
