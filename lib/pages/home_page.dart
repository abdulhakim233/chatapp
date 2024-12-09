import 'package:chatapp/components/my_drawer.dart';
import 'package:chatapp/pages/chat_page.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/services/chat/chat_services.dart';
import 'package:flutter/material.dart';
import '../components/user_tile.dart';
import 'package:chatapp/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    // Listen to changes in the search query
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Center(
          child: Text('Home'),
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
      drawer: const MyDrawer(),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search for a username or email...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          // User List
          Expanded(child: _buildUserList()),
        ],
      ),
    );
  }

  // Build the user list stream
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading users'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final users = snapshot.data!;

        // Filter users by the search query (email or username)
        final filteredUsers = users.where((userData) {
          final email = userData['email'].toString().toLowerCase();
          final username = userData['username'].toString().toLowerCase();
          return email.contains(_searchQuery) ||
              username.contains(_searchQuery);
        }).toList();

        if (filteredUsers.isEmpty) {
          return const Center(child: Text('No users found'));
        }

        return ListView(
          children: filteredUsers.map<Widget>((userData) {
            return _buildUserListItem(userData, context);
          }).toList(),
        );
      },
    );
  }

  // Build individual list tile for each user
  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    // Display users except for the current logged-in user
    if (userData['email'] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData['email'],
        onTap: () {
          // Navigate to the chat page when tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                recieverID: userData['uid'],
                recieverEmail: userData['email'],
              ),
            ),
          );
        },
      );
    } else {
      return Container(); // Don't show the logged-in user in the list
    }
  }
}
