import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebasestoragemanager/firebasestoragemanager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UploaderCubit(),
      child: MaterialApp(
        title: 'Firebase Storage Manager',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const UploaderPage(),
      ),
    );
  }
}

class UploaderPage extends StatelessWidget {
  const UploaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Storage Manager'),
      ),
      body: Center(
        child: UploaderView(
          user: FirebaseAuth.instance.currentUser!,
          isWeb: kIsWeb,
        ),
      ),
    );
  }
}
