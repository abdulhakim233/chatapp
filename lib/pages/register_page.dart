// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/components/my_button.dart';
import 'package:flutter/material.dart';
import '../components/my_textfield.dart';

class RegisterPage extends StatelessWidget {
  // email and pw controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  // tap to go to register page
  final void Function()? onTap;

  RegisterPage({
    super.key,
    required this.onTap,
  });

  // register method
  void register(BuildContext context) {
    // get auth service
    final authService = AuthService();

    // create user if only pw and confirmation pw match
    if (_pwController.text == _confirmPwController.text) {
      try {
        authService.signUpWithEmailAndPassword(
          _emailController.text,
          _pwController.text,
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }
    // if don't math, tell user to fix it
    else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Passwords don't match!"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Hudi',
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),

            // little bit of space
            SizedBox(height: 50),

            // Welcome back message
            Text(
              "Let's create an account for you",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),

            // little bit of space
            SizedBox(height: 25),

            // Email text Field
            MyTextfield(
              hintText: "Email",
              masked: false,
              controller: _emailController,
            ),

            // little bit of space
            SizedBox(height: 10),

            // Pw text field
            MyTextfield(
              hintText: "Password",
              masked: true,
              controller: _pwController,
            ),

            // little bit of space
            SizedBox(height: 10),

            // confim pw text field
            MyTextfield(
              hintText: "Confirm Password",
              masked: true,
              controller: _confirmPwController,
            ),

            // little bit of space
            SizedBox(height: 25),

            // Login Button
            MyButton(
              buttonText: 'Register',
              onTap: () => register(context),
            ),

            // little bit of space
            SizedBox(height: 25),

            // Register Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    'Login now',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
