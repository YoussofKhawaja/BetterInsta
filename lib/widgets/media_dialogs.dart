import 'package:flutter/material.dart';
import '../video_player_widget.dart';

void showImageDialog(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: InteractiveViewer(
            child: Image.network(imageUrl),
          ),
        ),
      );
    },
  );
}

void showVideoDialog(BuildContext context, String videoUrl) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: VideoPlayerWidget(videoUrl: videoUrl),
        ),
      );
    },
  );
}
