import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_view.dart';
import 'features/catalog/catalog_view.dart';
import 'features/admin/admin_login_view.dart';
import 'features/admin/admin_dashboard_view.dart';
import 'services/config_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    ConfigService.instance.init();
  } catch (e) {
    debugPrint("Firebase init notice: $e");
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      // Desactiva todas las líneas de scroll en la web
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        scrollbars: false,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeView(),
        '/catalog': (context) => const CatalogView(),
        '/admin': (context) => StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                backgroundColor: Color(0xFF070707),
                body: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              );
            }
            if (snapshot.hasData && snapshot.data != null) {
              return const AdminDashboardView();
            }
            return const AdminLoginView();
          },
        ),
      },
    );
  }
}