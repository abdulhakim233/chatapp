import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/components/my_button.dart';
import 'package:flutter/material.dart';
import '../components/my_textfield.dart';
import 'package:chatapp/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  // email and pw controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
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

    if (_pwController.text.length < 6) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Password must be at least 6 characters long."),
        ),
      );
      return;
    }

    // create user if only pw and confirmation pw match
    if (_pwController.text == _confirmPwController.text) {
      try {
        // Split the email by '@' symbol
        List<String> parts = _emailController.text.split('@');

        authService.signUpWithEmailAndPassword(
          email: _emailController.text,
          password: _pwController.text,
          fullName: _fullNameController.text,
          userName: parts[0].toLowerCase(),
          phone: _phoneController.text,
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
        builder: (context) => const AlertDialog(
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
        actions: [
          IconButton(
            icon: Icon(
              // Change the icon based on dark mode status
              Provider.of<ThemeProvider>(context).isDarkMode
                  ? Icons.light_mode // Icon for dark mode
                  : Icons.dark_mode, // Icon for light mode
            ),
            onPressed: () {
              // Toggle the theme when the button is pressed
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
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
              const SizedBox(height: 50),

              // Welcome back message
              Text(
                "Let's create an account for you",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),

              // little bit of space
              const SizedBox(height: 25),

              // Email text Field
              MyTextfield(
                hintText: "Full Name",
                masked: false,
                controller: _fullNameController,
                focusNode: null,
              ),

              // little bit of space
              const SizedBox(height: 10),

              // Email text Field
              MyTextfield(
                hintText: "Email",
                masked: false,
                controller: _emailController,
                focusNode: null,
              ),

              // little bit of space
              const SizedBox(height: 10),

              // Email text Field
              MyTextfield(
                hintText: "Phone Number",
                masked: false,
                controller: _phoneController,
                focusNode: null,
              ),

              // little bit of space
              const SizedBox(height: 10),

              // Pw text field
              MyTextfield(
                hintText: "Password",
                masked: true,
                controller: _pwController,
                focusNode: null,
              ),

              // little bit of space
              const SizedBox(height: 10),

              // confim pw text field
              MyTextfield(
                hintText: "Confirm Password",
                masked: true,
                controller: _confirmPwController,
                focusNode: null,
              ),

              // little bit of space
              const SizedBox(height: 25),

              // Login Button
              MyButton(
                buttonText: 'Register',
                onTap: () => register(context),
              ),

              // little bit of space
              const SizedBox(height: 25),

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
      ),
    );
  }
}
