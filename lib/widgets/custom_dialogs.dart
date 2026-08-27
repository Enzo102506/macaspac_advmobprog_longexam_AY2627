import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constant.dart';

class CustomDialogs {
  /// Existing message dialog (unchanged)
  static Future<void> showMessage({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Existing option dialog (unchanged)
  static Future<void> showOptionDialog({
    required BuildContext context,
    required String title,
    required String content,
    required VoidCallback onYes,
  }) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: FB_DARK_PRIMARY,
          ),
        ),
        content: Text(content),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: FB_LIGHT_PRIMARY),
            onPressed: () {
              Navigator.pop(context);
              onYes();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  /// ✅ Image preview dialog
  /// - No white background
  /// - Close button attached to image
  static Future<void> showImageDialog({
    required BuildContext context,
    required String imageUrl,
    double height = 320,
  }) {
    final bool isNetwork =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

    final Widget imageWidget = isNetwork
        ? CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            errorWidget: (_, __, ___) => const Icon(Icons.error),
          )
        : Image.asset(imageUrl, fit: BoxFit.cover);

    return showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: height,
              child: Stack(
                children: [
                  // 🔹 IMAGE
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: imageWidget,
                  ),

                  // ❌ CLOSE BUTTON (top-right of image)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
