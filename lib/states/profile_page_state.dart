import 'package:flutter/material.dart';
import '../pages/profile_page.dart';
import '../utils/network_utils.dart';
import '../utils/url_launcher_utils.dart';
import '../widgets/profile_header.dart';
import '../widgets/posts_grid.dart';
import '../widgets/media_dialogs.dart';

class ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _profileData;
  bool _isLoading = false;

  Future<void> _fetchProfile(String username) async {
    setState(() {
      _isLoading = true;
    });

    _profileData = await fetchProfileData(username);

    if (_profileData == null) {
      _showError('User not found or an error occurred.');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showError(String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
    }
  }

  void _showSearch() {
    showDialog(
      context: context,
      builder: (context) {
        String inputUsername = '';
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: const Text('Search Username'),
          content: TextField(
            onChanged: (value) {
              inputUsername = value;
            },
            decoration:
                const InputDecoration(hintText: "Enter Instagram username"),
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
          ),
          actions: [
            TextButton(
              child: const Text('Search'),
              onPressed: () {
                Navigator.of(context).pop();
                if (inputUsername.isNotEmpty) {
                  _fetchProfile(inputUsername);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfile() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ProfileHeader(
            profileData: _profileData!,
            onImageTap: (imageUrl) => showImageDialog(context, imageUrl),
            onLinkTap: (url) => launchURL(context, url),
          ),
          if (_profileData?['is_private'] == true)
            Text(
              'This account is private',
              style: Theme.of(context).textTheme.bodyLarge,
            )
          else
            PostsGrid(
              posts: _profileData!['edge_owner_to_timeline_media']['edges'],
              onImageTap: (imageUrl) => showImageDialog(context, imageUrl),
              onVideoTap: (videoUrl) => showVideoDialog(context, videoUrl),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instagram Profile Viewer'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _profileData == null
              ? const Center(
                  child: Text(
                    'No profile data',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : _buildProfile(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showSearch();
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}
