import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../services/constants.dart';
import '../../services/extensions.dart';
import '../../services/route_helper.dart';
import '../generated/assets.dart';


class CustomImage extends StatelessWidget {
  final String path;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final String? placeholder;
  final String? onError;
  final Color? color;
  final Alignment? alignment;
  final Function()? onTap;
  final bool viewFullScreen;
  final double radius;
  final int? maxHeightDiskCache;
  final int? maxWidthDiskCache;

  const CustomImage({
    super.key,
    required this.path,
    this.height,
    this.width,
    this.fit,
    this.placeholder,
    this.color,
    this.onError,
    this.alignment,
    this.onTap,
    this.radius = 0,
    this.viewFullScreen = false,
    this.maxHeightDiskCache,
    this.maxWidthDiskCache,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(radius),
      onTap: (onTap != null || viewFullScreen)
          ? () {

            }
          : null,
      child: Ink(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Builder(builder: (context) {
            if (path.startsWith('assets/')) {
              return _CustomAssetImage(
                path: path,
                fit: fit,
                height: height,
                width: width,
                color: color,
                alignment: alignment ?? Alignment.center,
              );
            }
            String url = path.replaceAll('\\', '/');
            if (!url.startsWith('http')) {
              url = AppConstants.baseUrl + url;
            }

            return CachedNetworkImage(
              imageUrl: url.url,
              height: height,
              width: width,
              fit: fit,
              maxHeightDiskCache: maxHeightDiskCache ?? 500,
              maxWidthDiskCache: maxWidthDiskCache ?? 500,
              placeholderFadeInDuration: const Duration(seconds: 1),
              alignment: alignment ?? Alignment.center,
              placeholder: (context, imageUrl) {
                return Center(
                  child: Transform(
                    transform: placeholder != null ? Matrix4.diagonal3Values(0.75, 0.75, 1) : Matrix4.diagonal3Values(1, 1, 1),
                    alignment: Alignment.center,
                    child: Image.asset(
                      placeholder != null ? placeholder! : Assets.imagesShimmer,
                      height: height,
                      width: width,
                      fit: fit,
                    ),
                  ),
                );
              },
              errorWidget: (context, imageUrl, stackTrace) {
                return Image.asset(
                  onError != null ? onError! : Assets.imagesPlaceholder,
                  height: height,
                  width: width,
                  fit: fit,
                  color: color,
                );
              },
            );
          }),
        ),
      ),
    );
  }
}

class _CustomAssetImage extends StatelessWidget {
  const _CustomAssetImage({
    super.key,
    required this.path,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment,
  });

  final String path;
  final Color? color;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Alignment? alignment;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage(path),
      fit: fit,
      height: height,
      width: width,
      color: color,
      alignment: alignment ?? Alignment.center,
    );
  }
}
