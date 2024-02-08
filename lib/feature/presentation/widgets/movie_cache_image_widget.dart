import 'package:flutter/material.dart';

class MovieCacheImage extends StatelessWidget {
  final String imageUrl;
  final double? width, height;

  const MovieCacheImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
  }) : super(key: key);

  Widget _imageWidget(ImageProvider imageProvider) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      // width: width,
      // height: height,
      fit: BoxFit.cover,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        return _imageWidget(const AssetImage('assets/images/empty_image.jpg'));
      },
      frameBuilder: (BuildContext context, Widget child, int? frame,
          bool wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          return child;
        }
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: frame != null
              ? child
              : const Center(child: CircularProgressIndicator()),
        );
      },
      // frameBuilder: (BuildContext context, Widget child, int? frame,
      //     bool wasSynchronouslyLoaded) {
      //   if (wasSynchronouslyLoaded) {
      //     return child;
      //   }
      //   return _imageWidget(NetworkImage(imageUrl));
      // },
    );
  }
}
