import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/constants/routes.dart';
import 'package:movies/service/api/movies_provider.dart';
import 'package:movies/service/auth/bloc/auth_bloc.dart';
import 'package:movies/service/auth/bloc/auth_events.dart';
import 'package:movies/service/auth/bloc/auth_state.dart';
import 'package:movies/service/auth/firebase_auth_provider.dart';
import 'package:movies/views/auth/forgot_password_view.dart';
import 'package:movies/views/auth/login_view.dart';
import 'package:movies/views/auth/register_view.dart';
import 'package:movies/views/auth/verify_email_view.dart';
import 'package:movies/views/movies/details_view.dart';
import 'package:movies/views/movies/home_view.dart';
import 'package:movies/views/movies/movies_view.dart';
import 'package:provider/provider.dart';
import 'helpers/loading/loading_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MoviesProvider(),lazy: false,
        ),
      ],
      child: const MyApp(),
    );
  }
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Bebas Neue',
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        movieRoute: (context) => const MoviesView(),
        'home': (context) => const HomeView(),
        'details': (context) => const MovieDetails(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const MoviesView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}



