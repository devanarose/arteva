import 'package:erp_demo/providers/cart_provider.dart';
import 'package:erp_demo/providers/wishlist_provider.dart';
import 'package:erp_demo/screens/cart_page.dart';
import 'package:erp_demo/screens/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());

  runApp(const ArtEva());
}

class ArtEva extends StatelessWidget {
  const ArtEva({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProxyProvider<AuthProvider, CartProvider>(
          create: (_) => CartProvider(),
          update: (_, authProvider, cartProvider) {
            cartProvider ??= CartProvider();
            final userId = authProvider.userId;
            if (userId != null) {
              cartProvider.setUserId(userId);
            }
            return cartProvider;
          },
        ),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            title: 'ArtEva',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: const Color(0xFFF5F7FA),
              primaryColor: const Color(0xFF009F82),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF0B0C1E),
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF00B894),
                primary: const Color(0xFF00B894),
                secondary: const Color(0xFFFFC107),
              ),
              cardColor: Colors.white,
              iconTheme: const IconThemeData(
                color: Color(0xFF00B894),
              ),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Color(0xFF333333)),
                bodyMedium: TextStyle(color: Color(0xFF555555)),
                titleLarge: TextStyle(
                  color: Color(0xFF0B0C1E),
                  fontWeight: FontWeight.bold,
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00B894),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              useMaterial3: true,
            ),
            home: FutureBuilder<bool>(
              future: authProvider.isAuth,
              builder: (context, snapshot) {
                FlutterNativeSplash.remove();

                if (snapshot.hasData && snapshot.data == true) {
                  authProvider.loadUserFromPrefs();
                  return const HomeScreen();
                } else {
                  return WelcomeScreen();
                }
              },
            ),


            routes: {
              '/homescreen': (context) => const HomeScreen(),
              LoginScreen.route: (context) => LoginScreen(),
              '/signup': (context) => SignupScreen(),
              '/welcome': (context) => WelcomeScreen(),
              '/cartpage': (context) => CartPage(),
            },
          );
        },
      ),
    );
  }
}
