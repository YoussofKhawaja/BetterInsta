import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final Map<String, dynamic> profileData;
  final Function(String) onImageTap;
  final Function(String) onLinkTap;

  const ProfileHeader({
    Key? key,
    required this.profileData,
    required this.onImageTap,
    required this.onLinkTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? originalProfilePicUrl = profileData['profile_pic_url_hd'];
    String? proxiedProfilePicUrl;
    if (originalProfilePicUrl != null) {
      String encodedUrl = Uri.encodeComponent(originalProfilePicUrl);
      proxiedProfilePicUrl =
          'https://cors-bypass.youssofkhawaja.com/image?url=$encodedUrl';
    }

    List<dynamic>? bioLinks = profileData['bio_links'];

    return Column(
      children: [
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            if (proxiedProfilePicUrl != null) {
              onImageTap(proxiedProfilePicUrl);
            }
          },
          child: CircleAvatar(
            radius: 50,
            backgroundImage: proxiedProfilePicUrl != null
                ? NetworkImage(proxiedProfilePicUrl)
                : null,
            backgroundColor: Colors.grey,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          profileData['username'] ?? '',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 5),
        Text(
          profileData['full_name'] ?? '',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            profileData['biography'] ?? '',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 10),
        if (bioLinks != null && bioLinks.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: bioLinks.map<Widget>((link) {
                String title = link['title'] ?? 'Link';
                String url = link['url'] ?? '';
                return GestureDetector(
                  onTap: () {
                    if (url.isNotEmpty) {
                      onLinkTap(url);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const Icon(
                          Icons.open_in_new,
                          color: Colors.black,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text('Followers',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
                Text(
                  (profileData['edge_followed_by']?['count'] ?? 0).toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            Column(
              children: [
                Text('Following',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
                Text(
                  (profileData['edge_follow']?['count'] ?? 0).toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
