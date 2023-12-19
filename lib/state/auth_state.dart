import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthStateHolder extends StatefulWidget {
  const AuthStateHolder({required this.child, Key? key}) : super(key: key);

  final Widget child;

  static AuthStateHolderState of(BuildContext context) {
    return context.findAncestorStateOfType<AuthStateHolderState>()!;
  }

  @override
  AuthStateHolderState createState() => AuthStateHolderState();
}

class AuthStateHolderState extends State<AuthStateHolder> {
  final _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return AuthenticationProvider(
      _firebaseAuth.authStateChanges(),
      child: widget.child,
    );
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw ('No user found for that email.');
      } else {
        throw (e.message ?? 'Unknown issue occured.');
      }
    } catch (e) {
      throw ("Unknown issue occured.");
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw (e.message ?? 'Unknown issue occured.');
    } catch (e) {
      throw ("Unknown issue occured.");
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw (e.message ?? 'Unknown issue occured.');
    } catch (e) {
      throw ("Unknown issue occured.");
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      return _firebaseAuth.currentUser;
    } on FirebaseAuthException catch (e) {
      throw (e.message ?? 'Unknown issue occured.');
    } catch (e) {
      throw ("Unknown issue occured.");
    }
  }
}

class AuthenticationProvider extends InheritedWidget {
  const AuthenticationProvider(this.data, {Key? key, required Widget child})
      : super(key: key, child: child);

  final Stream<User?> data;

  static Stream<User?> of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AuthenticationProvider>()!
        .data;
  }

  @override
  bool updateShouldNotify(AuthenticationProvider oldWidget) {
    return data != oldWidget.data;
  }
}
