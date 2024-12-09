import 'package:flutter/material.dart';
import 'package:chatapp/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Center(
          child: Text(
            'Profile page',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
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
    );
  }
}
