import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'providers/app_state.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // For Web, this will fail if options are not provided.
    // On Mobile, it will look for google-services.json / GoogleService-Info.plist.
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
    // We continue so the app can still run with dummy data fallbacks
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, BookmarkProvider>(
          create: (_) => BookmarkProvider(),
          update: (_, auth, bookmark) => bookmark!..updateUserId(auth.user?.uid),
        ),
        ChangeNotifierProvider(create: (_) => DestinationProvider()),
      ],
      child: const TouristGuideApp(),
    ),
  );
}

class TouristGuideApp extends StatelessWidget {
  const TouristGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tourist Guide',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F2C59), // Deep Navy
          primary: const Color(0xFF0F2C59),
          secondary: const Color(0xFFDAC0A3), // Sand/Gold
          background: const Color(0xFFF8F0E5), // Off-white/Cream
          surface: Colors.white,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
