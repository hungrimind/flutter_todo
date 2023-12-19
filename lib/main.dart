import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo/auth_state.dart';
import 'package:todo/firebase_options.dart';
import 'package:todo/pages/home.dart';
import 'package:todo/pages/signin.dart';
import 'package:todo/todo_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const AuthStateHolder(
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<User?>(
        stream: AuthenticationProvider.of(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (user == null) {
              return const SignIn();
            } else {
              return TodoStateHolder(
                child: MyHomePage(
                  user: user.displayName ?? "Friend",
                ),
              );
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Colors.black,
        ),
      ),
    );
  }
}
