import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/components/my_button.dart';
import 'package:flutter/material.dart';
import '../components/my_textfield.dart';
import 'package:chatapp/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  // email and pw controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  // tap to go to register page
  final void Function()? onTap;

  LoginPage({
    super.key,
    required this.onTap,
  });

  // login method
  void login(BuildContext context) async {
    // auth service
    final authService = AuthService();

    // try login
    try {
      await authService.signInWithEmailAndPassword(
        _emailController.text,
        _pwController.text,
      );
    }

    // catch errors
    catch (e) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
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
              "Welcome back, you've been missed!",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),

            // little bit of space
            const SizedBox(height: 25),

            // Email text Field
            MyTextfield(
              hintText: "Email",
              masked: false,
              controller: _emailController,
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
            const SizedBox(height: 25),

            // Login Button
            MyButton(
              buttonText: 'Log in',
              onTap: () => login(context),
            ),

            // little bit of space
            const SizedBox(height: 25),

            // Register Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Not a member? ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    'Register now',
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
