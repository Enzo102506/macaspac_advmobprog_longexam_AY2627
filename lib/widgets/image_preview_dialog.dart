import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImagePreviewDialog {
  static void show(BuildContext context, {required String imageUrl}) {
    final bool isNetwork =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: isNetwork
                  ? CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover)
                  : Image.asset(imageUrl, fit: BoxFit.cover),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
