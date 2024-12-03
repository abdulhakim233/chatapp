import 'package:flutter/material.dart';

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
        )),
      ),
    );
  }
}
