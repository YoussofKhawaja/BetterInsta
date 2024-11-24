import 'package:flutter/material.dart';

class PostsGrid extends StatelessWidget {
  final List<dynamic> posts;
  final Function(String) onImageTap;
  final Function(String) onVideoTap;

  const PostsGrid({
    Key? key,
    required this.posts,
    required this.onImageTap,
    required this.onVideoTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return Text(
        'No posts available',
        style: Theme.of(context).textTheme.bodyLarge,
      );
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: posts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemBuilder: (context, index) {
        var node = posts[index]['node'];
        bool isVideo = node['is_video'] ?? false;
        String mediaUrl;
        String thumbnailUrl;

        if (isVideo) {
          if (node.containsKey('video_url') && node['video_url'] != null) {
            mediaUrl = node['video_url'];
          } else if (node.containsKey('video_resources') &&
              node['video_resources'].isNotEmpty) {
            mediaUrl = node['video_resources'].last['src'];
          } else {
            return Container();
          }
          thumbnailUrl = node['display_url'] ?? node['thumbnail_src'];
        } else {
          mediaUrl = node['display_url'];
          thumbnailUrl = mediaUrl;
        }

        String encodedMediaUrl = Uri.encodeComponent(mediaUrl);
        String proxiedMediaUrl =
            'https://cors-bypass.youssofkhawaja.com/media?url=$encodedMediaUrl';

        String encodedThumbnailUrl = Uri.encodeComponent(thumbnailUrl);
        String proxiedThumbnailUrl =
            'https://cors-bypass.youssofkhawaja.com/media?url=$encodedThumbnailUrl';

        int likeCount = node['edge_liked_by']['count'] ?? 0;
        int commentCount = node['edge_media_to_comment']['count'] ?? 0;

        return GestureDetector(
          onTap: () {
            if (isVideo) {
              onVideoTap(proxiedMediaUrl);
            } else {
              onImageTap(proxiedMediaUrl);
            }
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                proxiedThumbnailUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey,
                    child: const Icon(
                      Icons.broken_image,
                      color: Colors.white,
                    ),
                  );
                },
              ),
              if (isVideo)
                const Center(
                  child: Icon(
                    Icons.play_circle_outline,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black54,
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$likeCount',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.comment,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$commentCount',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
