import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelgo/screens/screens.dart';
import 'package:travelgo/services/notifications_service.dart';
import 'package:travelgo/services/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:travelgo/services/travels_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});  

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => TravelsService()),
      ],      
      child: const MyApp(),      
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Viagens fantásticas',
      initialRoute: 'checking',
      routes: {
        'login': (_) => const LoginScreen(),
        'register': (_) => const RegisterScreen(),
        'checking': (_) => const CheckAuthScreen(),
        'home': (_) => const HomeScreen(),
        'travel': (_) => const TravelScreen(),
      },
     scaffoldMessengerKey: NotificationsService.messengerKey, //* Global key
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          color: Colors.indigo,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.indigo,
          elevation: 0,
        ),
      ),
    );
  }
}
