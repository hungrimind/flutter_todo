import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/state/auth_state.dart';

class UserStateHolder extends StatefulWidget {
  const UserStateHolder({required this.child, Key? key}) : super(key: key);

  final Widget child;

  static UserStateHolderState of(BuildContext context) {
    return context.findAncestorStateOfType<UserStateHolderState>()!;
  }

  @override
  UserStateHolderState createState() => UserStateHolderState();
}

class UserStateHolderState extends State<UserStateHolder> {
  final _firestore = FirebaseFirestore.instance;
  UserState? _userState;
  @override
  Widget build(BuildContext context) {
    return UserProvider(
      _userState,
      child: widget.child,
    );
  }

  @override
  void initState() {
    super.initState();
    //if user is already logged in, if not the function simply returns
    setCurrentUser();
  }

  void addUser() async {
    User? user = await AuthStateHolder.of(context).getCurrentUser();
    if (user == null) return;
    await _firestore.collection('users').doc(user.uid).set({
      'name': user.displayName,
      'email': user.email,
    });
    setCurrentUser();
  }

  void setCurrentUser() async {
    User? user = await AuthStateHolder.of(context).getCurrentUser();
    if (user == null) return;
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(user.uid).get();

    setState(() {
      _userState = UserState(
        name: documentSnapshot['name'],
        email: documentSnapshot['email'],
      );
    });
  }

  void removeCurrentUser() {
    setState(() {
      _userState = null;
    });
  }
}

class UserState {
  UserState({
    this.name,
    required this.email,
  });

  final String? name;
  final String email;

  UserState copyWith({
    String? name,
    String? email,
  }) {
    return UserState(
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
    };
  }

  factory UserState.fromMap(Map<String, dynamic> map) {
    return UserState(
      name: map['name'],
      email: map['email'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserState.fromJson(String source) =>
      UserState.fromMap(json.decode(source));
}

class UserProvider extends InheritedWidget {
  const UserProvider(this.data, {Key? key, required Widget child})
      : super(key: key, child: child);

  final UserState? data;

  static UserState? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UserProvider>()!.data;
  }

  @override
  bool updateShouldNotify(UserProvider oldWidget) {
    return data != oldWidget.data;
  }
}
