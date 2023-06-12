import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/service/auth/bloc/auth_bloc.dart';
import 'package:movies/service/auth/bloc/auth_events.dart';
import 'package:movies/utilities/dialogs/logout_dialog.dart';

import '../../service/auth/firebase_auth_provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final user = FirebaseAuthProvider().currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "MY PROFILE",
              style: TextStyle(color: Colors.white,fontSize: 30),
            ),
            const SizedBox(height: 20),
            const Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            const Text(
              "Welcome to your profile page ",
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              user!.email,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                final shouldLogout = await showLogOutDialog(context);
                if (shouldLogout) {
                  // ignore: use_build_context_synchronously
                  context.read<AuthBloc>().add(
                        const AuthEventLogOut(),
                      );
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  textStyle: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
