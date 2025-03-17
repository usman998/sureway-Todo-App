


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:todo_app/screens/task_screen/task_screen.dart';

import 'package:todo_app/utils/snack_bar_service.dart';
import 'widget/auth_email_form.dart';


class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),
                    SignInView(
                      auth: fba.FirebaseAuth.instance,
                      isCreatingNewAccount: false,
                      onSubmit: (email, password, isSignUp) async {
                        if(isSignUp){
                          await fba.FirebaseAuth.instance.signOut();
                          SnackBarService.showSuccess("Account created for email $email");
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => AuthScreen()), // Replace with your screen widget
                          );
                        } else{
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => TaskScreen()), // Replace with your screen widget
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}

class SignInView extends StatefulWidget {
  final fba.FirebaseAuth? auth;
  final bool isCreatingNewAccount;
  final Function(String email, String password,bool isSignUp) onSubmit;

  const SignInView({
    super.key,
    required this.onSubmit,
    this.auth,
    this.isCreatingNewAccount = false,
  });

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  bool isSignUp = false;

  void _toggleAuthAction() {
    setState(() {
      isSignUp = !isSignUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final actionButtonLabel = isSignUp ? "Register" : "Login";
    final authText = isSignUp ? "Already have an account? Log in" : "Don't have an account? Register";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          actionButtonLabel,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        AuthEmailForm(
          auth: widget.auth,
          isSignUp: isSignUp,
          onSubmit: widget.onSubmit,
          actionButtonLabelOverride: actionButtonLabel,
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: _toggleAuthAction,
          child: Text(authText, style: const TextStyle(fontSize: 14)),
        ),
      ],
    );
  }



}