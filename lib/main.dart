import 'package:aullet/viewmodel/auth_view_model.dart';
import 'package:aullet/viewmodel/profile_viewmodel.dart';
import 'package:aullet/views/auth/login_page.dart';
import 'package:aullet/views/auth/signup_view.dart';
import 'package:aullet/views/home_view.dart';
import 'package:aullet/views/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

  if (supabaseUrl == null || supabaseAnonKey == null) {
    throw Exception(
      'errore nel file .env : manca SUPABASE_URL o SUPABASE_ANON_KEY!',
    );
  }
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewmodel()),
      ],
      child: Consumer<AuthViewModel>(
        builder: (context, authVM, _) {
          return MaterialApp(
            title: 'Aullet',
            theme: ThemeData(useMaterial3: true),
            debugShowCheckedModeBanner: false,
            home: authVM.isLoggedIn ? const HomeView() : const LoginPage(),
            routes: {
              '/login': (_) => const LoginPage(),
              '/signup': (_) => const SignUpPage(),
              '/home': (_) => const HomeView(),
              '/profile': (_) => const ProfilePage(),
            },
          );
        },
      ),
    );
  }
}