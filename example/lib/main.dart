import 'package:example/app_bloc_observer.dart';
import 'package:example/env.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebasestoragemanager/firebasestoragemanager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore:depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();

  // Removes the '#' from the URLs in web applications.
  usePathUrlStrategy();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UploaderCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          UploaderLocalizationsDelegate(),
        ],
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
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const SignInPage();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Storage Manager'),
      ),
      body: Center(
        child: UploaderView(
          user: user,
          isWeb: kIsWeb,
        ),
      ),
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Replace with your test credentials
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print(e); // In a real app, handle the error more gracefully
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _signIn,
                child: const Text('Sign In with Test Account'),
              ),
      ),
    );
  }
}
