import 'package:equatable/equatable.dart';
import 'package:frontend/models/auth_info.dart';
import 'package:frontend/pages/auth/models/auth_flow_args.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading({this.message});

  final String? message;

  @override
  List<Object?> get props => [message];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated({
    this.flowMode = AuthFlowMode.login,
    this.fullName,
    this.phoneNumber,
    this.message,
  });

  final AuthFlowMode flowMode;
  final String? fullName;
  final String? phoneNumber;
  final String? message;

  @override
  List<Object?> get props => [flowMode, fullName, phoneNumber, message];
}

class AuthOtpSent extends AuthState {
  const AuthOtpSent({
    required this.flowMode,
    required this.phoneNumber,
    this.fullName,
    this.debugCode,
  });

  final AuthFlowMode flowMode;
  final String phoneNumber;
  final String? fullName;
  final String? debugCode;

  @override
  List<Object?> get props => [flowMode, phoneNumber, fullName, debugCode];
}

class AuthRegisterAwaitingPassword extends AuthState {
  const AuthRegisterAwaitingPassword({
    required this.phoneNumber,
    this.fullName,
  });

  final String phoneNumber;
  final String? fullName;

  @override
  List<Object?> get props => [phoneNumber, fullName];
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.authInfo, {this.message});

  final AuthInfo authInfo;
  final String? message;

  @override
  List<Object?> get props => [authInfo, message];
}

class AuthFailure extends AuthState {
  const AuthFailure({
    required this.message,
    this.previous,
  });

  final String message;
  final AuthState? previous;

  @override
  List<Object?> get props => [message, previous];
}
