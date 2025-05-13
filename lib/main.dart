// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'constants/app_strings.dart';
import 'constants/app_theme.dart';
import 'services/auth_service.dart';
import 'services/earnings_service.dart';
import 'services/ride_service.dart';
import 'views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.primaryColor,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  // Note: Firebase initialization is commented out for the demo version
  // We'll use mock data instead
  
  // Run the app in demo mode with mock data
  print('Running Slymon Captain app in DEMO MODE with mock data');
  print('All backend API calls are disabled and replaced with mock data');
  runApp(const MyApp(isDemoMode: true));
}

class MyApp extends StatelessWidget {
  final bool isDemoMode;
  
  const MyApp({super.key, this.isDemoMode = true});

  @override
  Widget build(BuildContext context) {
    // Create services
    final authService = AuthService();
    final rideService = RideService(authService: authService);
    final earningsService = EarningsService(authService: authService);
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authService),
        ChangeNotifierProvider.value(value: rideService),
        ChangeNotifierProvider.value(value: earningsService),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppTheme.primaryColor,
          scaffoldBackgroundColor: AppTheme.backgroundColor,
          fontFamily: 'Inter',
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: AppTheme.textColor,
            elevation: 0,
            titleTextStyle: TextStyle(
              fontFamily: 'SF Pro Display',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textColor,
              letterSpacing: -0.3,
            ),
            iconTheme: IconThemeData(
              color: AppTheme.primaryColor,
            ),
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppTheme.primaryColor,
            primary: AppTheme.primaryColor,
            secondary: AppTheme.secondaryColor,
            background: AppTheme.backgroundColor,
            surface: AppTheme.cardColor,
            onPrimary: Colors.white,
            onSecondary: AppTheme.textColor,
            onBackground: AppTheme.textColor,
            onSurface: AppTheme.textColor,
          ),
          cardTheme: CardTheme(
            color: AppTheme.cardColor,
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: AppTheme.primaryButtonStyle,
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: AppTheme.secondaryButtonStyle,
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(AppTheme.primaryColor),
              textStyle: MaterialStateProperty.all<TextStyle>(
                const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              borderSide: BorderSide(color: AppTheme.lightTextColor.withOpacity(0.1), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              borderSide: const BorderSide(color: AppTheme.primaryColor, width: 1.5),
            ),
          ),
        ),
        home: const SplashScreen(),
        builder: (context, child) {
          // Add a banner for demo mode
          if (isDemoMode) {
            return Banner(
              message: "DEMO MODE",
              location: BannerLocation.topEnd,
              color: Colors.red,
              child: child!,
            );
          }
          return child!;
        },
      ),
    );
  }
}
