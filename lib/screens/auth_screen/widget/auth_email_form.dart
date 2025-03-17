


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:flutter/material.dart';
import 'package:todo_app/utils/custom_dialogue.dart';
import '../../../utils/snack_bar_service.dart';

typedef EmailFormSubmitCallback = void Function(String email, String password,bool isSignUp);

class AuthEmailForm extends StatelessWidget {
  final fba.FirebaseAuth? auth;
  final bool isSignUp;
  final EmailFormSubmitCallback? onSubmit;
  final String? email;
  final String? actionButtonLabelOverride;
  final bool showPasswordVisibilityToggle;

  const AuthEmailForm({
    super.key,
    this.auth,
    this.isSignUp = false,
    this.onSubmit,
    this.email,
    this.actionButtonLabelOverride,
    this.showPasswordVisibilityToggle = false,
  });

  @override
  Widget build(BuildContext context) {
    return _SignInFormContent(
      auth: auth,
      isSignUp: isSignUp,
      onSubmit: onSubmit,
      email: email,
      actionButtonLabelOverride: actionButtonLabelOverride,
      showPasswordVisibilityToggle: showPasswordVisibilityToggle,
    );
  }
}

class _SignInFormContent extends StatefulWidget {
  final fba.FirebaseAuth? auth;
  final bool isSignUp;
  final EmailFormSubmitCallback? onSubmit;
  final String? email;
  final String? actionButtonLabelOverride;
  final bool showPasswordVisibilityToggle;

  const _SignInFormContent({
    this.auth,
    this.isSignUp = false,
    this.onSubmit,
    this.email,
    this.actionButtonLabelOverride,
    this.showPasswordVisibilityToggle = false,
  });

  @override
  _SignInFormContentState createState() => _SignInFormContentState();
}

class _SignInFormContentState extends State<_SignInFormContent> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final CustomDialogue customDialogue = CustomDialogue();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.dispose();
  }




  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (formKey.currentState!.validate()) {
      final email = (widget.email ?? emailCtrl.text).trim();
      final password = passwordCtrl.text.trim();
      customDialogue.showDialogue(context);
      try {
        if (widget.isSignUp) {
          await fba.FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          ).then((value)async{
            await FirebaseFirestore.instance.collection("userTask").doc(value.user?.uid).set({
              'todoList' : [],
            });
          });
        } else {
          await fba.FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
        }
        Navigator.pop(context);
        widget.onSubmit?.call(email, password, widget.isSignUp);
      } catch (e) {
        Navigator.pop(context);
        if(e.toString().contains("invalid-credential")){
          SnackBarService.showError(message: "User not found. Email or Password is incorrect");
        }
        SnackBarService.showError();
      }
    }
  }

  String? _validatePassword(String? value, bool isSignUp) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }

    if(isSignUp) {
      final regex = RegExp(r"^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*\W)(?!.* ).{8,}$");
      if (!regex.hasMatch(value)) {
        return "Password must be at least 8 characters, include uppercase, lowercase, digit, and special character.";
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final labelText = widget.isSignUp ? "Register" : "Login";

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.email == null)
            TextFormField(
              controller: emailCtrl,
              decoration: InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              enableSuggestions: false,
              onFieldSubmitted: (_) => _submit(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Email is required";
                }
                return null;
              },
            ),
          const SizedBox(height: 16),
          TextFormField(
            controller: passwordCtrl,
            obscureText: !isPasswordVisible,
            autocorrect: false,
            enableSuggestions: false,
            decoration: InputDecoration(
              labelText: "Password",
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              ),
            ),
            onFieldSubmitted: (_) => _submit(),
            validator: (value) => _validatePassword(value, widget.isSignUp),
          ),
          if (widget.isSignUp) ... [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextFormField(
                controller: confirmPasswordCtrl,
                obscureText: !isConfirmPasswordVisible,
                autocorrect: false,
                enableSuggestions: false,
                decoration: InputDecoration(
                  labelText: "Confirm password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isConfirmPasswordVisible = !isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
                onFieldSubmitted: (_) => _submit(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Confirm your password";
                  }
                  if (value != passwordCtrl.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),
            ),
          ],
          const SizedBox(height: 16),
          ElevatedButton( // submit action button
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
            child: Text(
              widget.actionButtonLabelOverride ?? labelText,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}