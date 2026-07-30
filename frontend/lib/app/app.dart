import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:frontend/data/repository/auth_repository.dart';
import 'package:frontend/pages/auth/auth_landing_page.dart';
import 'package:frontend/pages/auth/auth_routes.dart';
import 'package:frontend/pages/auth/bloc/auth_bloc.dart';
import 'package:frontend/pages/auth/login_page.dart';
import 'package:frontend/pages/auth/otp_page.dart';
import 'package:frontend/pages/auth/register_page.dart';
import 'package:frontend/pages/auth/register_phone_page.dart';
import 'package:frontend/pages/auth/set_password_page.dart';
import 'package:frontend/pages/home/home_page.dart';
import 'package:frontend/pages/home/home_routes.dart';
import 'package:frontend/pages/catalog/catalog_routes.dart';
import 'package:frontend/pages/dashboard/dashboard_routes.dart';
import 'package:frontend/pages/game/game_routes.dart';
import 'package:frontend/pages/info/info_routes.dart';
import 'package:frontend/pages/profile/profile_page.dart';
import 'package:frontend/pages/profile/profile_routes.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';
import 'package:frontend/widgets/toast/app_toast.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppToast.navigatorKey = appNavigatorKey;

    return BlocProvider(
      create: (_) => AuthBloc(authRepository)..add(const AuthAppStarted()),
      child: MaterialApp(
        title: 'Fante Quiz',
        navigatorKey: appNavigatorKey,
        debugShowCheckedModeBanner: false,
        locale: const Locale('fa', 'IR'),
        supportedLocales: const [
          Locale('fa', 'IR'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: ThemeData(
          fontFamily: AppTextTheme.defaultFont,
          scaffoldBackgroundColor: AppColors.scaffoldBackground,
          textTheme: AppTextTheme.lightTextTheme,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primaryGold,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        builder: (context, child) {
          return BlocListener<AuthBloc, AuthState>(
            listenWhen: (previous, current) {
              if (current is AuthAuthenticated) {
                return current.message != null;
              }
              if (current is AuthUnauthenticated) {
                return current.message != null;
              }
              return false;
            },
            listener: (context, state) {
              if (state is AuthAuthenticated && state.message != null) {
                AppToast.success(null, state.message!);
              } else if (state is AuthUnauthenticated &&
                  state.message != null) {
                AppToast.success(null, state.message!);
              }
            },
            child: child ?? const SizedBox.shrink(),
          );
        },
        initialRoute: HomeRoutes.home,
        routes: {
          HomeRoutes.home: (_) => const HomePage(),
          ProfileRoutes.profile: (_) => const ProfilePage(),
          AuthRoutes.landing: (_) => const AuthLandingPage(),
          AuthRoutes.login: (_) => const LoginPage(),
          AuthRoutes.register: (_) => const RegisterPage(),
          AuthRoutes.registerPhone: (_) => const RegisterPhonePage(),
          AuthRoutes.otp: (_) => const OtpPage(),
          AuthRoutes.setPassword: (_) => const SetPasswordPage(),
          ...GameRoutes.routes,
          ...CatalogRoutes.routes,
          ...DashboardRoutes.routes,
          ...InfoRoutes.routes,
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                child: Text(
                  'Route not found: ${settings.name}',
                  style:
                      AppTextTheme.getTextStyle(color: AppColors.textPrimary),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
