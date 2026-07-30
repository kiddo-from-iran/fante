import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/auth_repository.dart';
import 'package:frontend/pages/auth/bloc/auth_event.dart';
import 'package:frontend/pages/auth/bloc/auth_state.dart';
import 'package:frontend/pages/auth/models/auth_flow_args.dart';
import 'package:frontend/pages/auth/utils/phone_utils.dart';

export 'auth_event.dart';
export 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._authRepository) : super(const AuthInitial()) {
    on<AuthAppStarted>(_onAppStarted);
    on<AuthFlowModeSelected>(_onFlowModeSelected);
    on<AuthRegisterNameSubmitted>(_onRegisterNameSubmitted);
    on<AuthPasswordLoginSubmitted>(_onPasswordLoginSubmitted);
    on<AuthLoginOtpRequested>(_onLoginOtpRequested);
    on<AuthPhoneSubmitted>(_onPhoneSubmitted);
    on<AuthOtpSubmitted>(_onOtpSubmitted);
    on<AuthRegisterPasswordSubmitted>(_onRegisterPasswordSubmitted);
    on<AuthResendOtpRequested>(_onResendOtpRequested);
    on<AuthGoogleSignInRequested>(_onGoogleSignInRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  final AuthRepository _authRepository;

  AuthFlowMode _sessionFlowMode = AuthFlowMode.login;
  String? _sessionFullName;
  String? _sessionPhoneNumber;
  String? _sessionOtpCode;

  void _clearSession() {
    _sessionFlowMode = AuthFlowMode.login;
    _sessionFullName = null;
    _sessionPhoneNumber = null;
    _sessionOtpCode = null;
  }

  Future<void> _onAppStarted(
    AuthAppStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'در حال بارگذاری...'));
    await _authRepository.loadAuthInfo();
    final authInfo = AuthRepository.authChangeNotifier.value;
    if (authInfo != null && authInfo.isAuthenticated) {
      emit(AuthAuthenticated(authInfo));
    } else {
      _clearSession();
      emit(const AuthUnauthenticated());
    }
  }

  void _onFlowModeSelected(
    AuthFlowModeSelected event,
    Emitter<AuthState> emit,
  ) {
    _sessionFlowMode =
        event.isRegister ? AuthFlowMode.register : AuthFlowMode.login;
    if (_sessionFlowMode != AuthFlowMode.register) {
      _sessionFullName = null;
    }
    _sessionOtpCode = null;
    emit(AuthUnauthenticated(flowMode: _sessionFlowMode));
  }

  void _onRegisterNameSubmitted(
    AuthRegisterNameSubmitted event,
    Emitter<AuthState> emit,
  ) {
    _sessionFlowMode = AuthFlowMode.register;
    _sessionFullName =
        '${event.firstName.trim()} ${event.lastName.trim()}'.trim();
    _sessionOtpCode = null;
    emit(AuthUnauthenticated(
      flowMode: _sessionFlowMode,
      fullName: _sessionFullName,
    ));
  }

  Future<void> _onPasswordLoginSubmitted(
    AuthPasswordLoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    final phone = normalizeIranPhone(event.phoneNumber.trim());
    final password = event.password;

    if (!isValidIranPhone(phone)) {
      emit(const AuthFailure(message: 'شماره موبایل باید ۱۱ رقم و با ۰۹ شروع شود'));
      return;
    }
    if (password.length < 6) {
      emit(const AuthFailure(message: 'رمز عبور باید حداقل ۶ کاراکتر باشد'));
      return;
    }

    _sessionPhoneNumber = phone;
    _sessionFlowMode = AuthFlowMode.login;

    emit(const AuthLoading(message: 'در حال ورود...'));
    try {
      final authInfo =
          await _authRepository.loginWithPassword(phone, password);
      emit(AuthAuthenticated(
        authInfo,
        message: 'ورود با موفقیت انجام شد',
      ));
    } catch (e) {
      emit(AuthFailure(message: _mapError(e)));
    }
  }

  Future<void> _onLoginOtpRequested(
    AuthLoginOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    final phone = normalizeIranPhone(event.phoneNumber.trim());
    if (!isValidIranPhone(phone)) {
      emit(const AuthFailure(message: 'شماره موبایل باید ۱۱ رقم و با ۰۹ شروع شود'));
      return;
    }

    _sessionPhoneNumber = phone;
    _sessionFlowMode = AuthFlowMode.login;
    _sessionOtpCode = null;

    emit(const AuthLoading(message: 'در حال ارسال کد...'));
    try {
      final result = await _authRepository.requestLoginOtp(phone);
      emit(AuthOtpSent(
        flowMode: AuthFlowMode.login,
        phoneNumber: phone,
        debugCode: result.debugCode,
      ));
    } catch (e) {
      emit(AuthFailure(message: _mapError(e)));
    }
  }

  Future<void> _onPhoneSubmitted(
    AuthPhoneSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    final phone = normalizeIranPhone(event.phoneNumber.trim());
    if (!isValidIranPhone(phone)) {
      emit(AuthFailure(
        message: 'شماره موبایل باید ۱۱ رقم و با ۰۹ شروع شود',
        previous: state,
      ));
      return;
    }

    _sessionPhoneNumber = phone;

    emit(const AuthLoading(message: 'در حال ارسال کد...'));
    try {
      final result = await _authRepository.requestRegisterOtp(phone);
      emit(AuthOtpSent(
        flowMode: _sessionFlowMode,
        phoneNumber: phone,
        fullName: _sessionFullName,
        debugCode: result.debugCode,
      ));
    } catch (e) {
      emit(AuthFailure(
        message: _mapError(e),
        previous: AuthUnauthenticated(
          flowMode: _sessionFlowMode,
          fullName: _sessionFullName,
          phoneNumber: phone,
        ),
      ));
    }
  }

  Future<void> _onOtpSubmitted(
    AuthOtpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    final phone = normalizeIranPhone(
      (event.phoneNumber ?? _sessionPhoneNumber ?? '').trim(),
    );
    if (!isValidIranPhone(phone)) {
      emit(const AuthFailure(message: 'شماره موبایل یافت نشد'));
      return;
    }
    _sessionPhoneNumber = phone;

    final code = event.code.trim();
    if (code.length != 5) {
      emit(AuthFailure(
        message: 'کد تأیید باید ۵ رقم باشد',
        previous: state,
      ));
      return;
    }

    emit(const AuthLoading(message: 'در حال تأیید...'));
    try {
      if (_sessionFlowMode == AuthFlowMode.register) {
        // OTP is validated when the user submits their password on the next step.
        _sessionOtpCode = code;
        emit(AuthRegisterAwaitingPassword(
          phoneNumber: phone,
          fullName: _sessionFullName,
        ));
        return;
      }

      final authInfo = await _authRepository.verifyOtpLogin(phone, code);
      emit(AuthAuthenticated(
        authInfo,
        message: 'ورود با موفقیت انجام شد',
      ));
    } catch (e) {
      emit(AuthFailure(
        message: _mapError(e),
        previous: AuthOtpSent(
          flowMode: _sessionFlowMode,
          phoneNumber: phone,
          fullName: _sessionFullName,
        ),
      ));
    }
  }

  Future<void> _onRegisterPasswordSubmitted(
    AuthRegisterPasswordSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    final phone = _sessionPhoneNumber;
    final code = _sessionOtpCode;
    final fullName = _sessionFullName;
    final password = event.password;

    if (phone == null || code == null) {
      emit(const AuthFailure(
        message: 'اطلاعات ثبت‌نام ناقص است. لطفاً از ابتدا شروع کنید.',
      ));
      return;
    }
    if (fullName == null || fullName.isEmpty) {
      emit(const AuthFailure(message: 'نام کاربر یافت نشد'));
      return;
    }
    if (password.length < 6) {
      emit(const AuthFailure(message: 'رمز عبور باید حداقل ۶ کاراکتر باشد'));
      return;
    }

    emit(const AuthLoading(message: 'در حال ثبت‌نام...'));
    try {
      final authInfo = await _authRepository.registerWithOtp(
        phoneNumber: phone,
        code: code,
        fullName: fullName,
        password: password,
      );
      emit(AuthAuthenticated(
        authInfo,
        message: 'ثبت‌نام با موفقیت انجام شد',
      ));
    } catch (e) {
      emit(AuthFailure(
        message: _mapError(e),
        previous: AuthRegisterAwaitingPassword(
          phoneNumber: phone,
          fullName: fullName,
        ),
      ));
    }
  }

  Future<void> _onGoogleSignInRequested(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'در حال ورود با گوگل...'));
    try {
      final authInfo = await _authRepository.signInWithGoogle();
      emit(AuthAuthenticated(
        authInfo,
        message: 'ورود با موفقیت انجام شد',
      ));
    } catch (e) {
      emit(AuthFailure(message: _mapError(e)));
    }
  }

  Future<void> _onResendOtpRequested(
    AuthResendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    final phone = _sessionPhoneNumber;
    if (phone == null) return;
    if (_sessionFlowMode == AuthFlowMode.login) {
      add(AuthLoginOtpRequested(phone));
    } else {
      add(AuthPhoneSubmitted(phone));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.signOut();
    _clearSession();
    emit(const AuthUnauthenticated(
      message: 'خروج با موفقیت انجام شد',
    ));
  }

  String _mapError(Object error) {
    final text = error.toString();
    if (text.contains('Invalid or expired')) {
      return 'کد تأیید نامعتبر یا منقضی شده است';
    }
    if (text.contains('GOOGLE_SIGN_IN_CANCELLED')) {
      return 'ورود با گوگل لغو شد';
    }
    if (text.contains('Google web client ID is not configured')) {
      return 'ورود با گوگل پیکربندی نشده است';
    }
    if (text.contains('Invalid Google')) {
      return 'ورود با گوگل ناموفق بود';
    }
    if (text.contains('USER_NOT_FOUND')) {
      return 'کاربری با این شماره یافت نشد. لطفاً ثبت‌نام کنید.';
    }
    if (text.contains('11 digits') || text.contains('starting with 09')) {
      return 'شماره موبایل باید ۱۱ رقم و با ۰۹ شروع شود';
    }
    if (text.contains('Incorrect phone') || text.contains('Incorrect username')) {
      return 'شماره موبایل یا رمز عبور اشتباه است';
    }
    if (text.contains('already exists')) {
      return 'کاربری با این شماره قبلاً ثبت‌نام کرده است';
    }
    if (text.contains('72 bytes')) {
      return 'سرور قدیمی در حال اجراست. بکند را با run_backend.ps1 از ریشه پروژه ری‌استارت کنید.';
    }
    if (text.contains('Connection refused') ||
        text.contains('Failed host lookup')) {
      return 'اتصال به سرور برقرار نشد';
    }
    return 'خطایی رخ داد. لطفاً دوباره تلاش کنید';
  }
}
