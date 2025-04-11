// lib/widgets/cached_image_widget.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mb/data/service/cache/cache_manager.dart';

class CachedImageWidget extends StatefulWidget {
  final String imageUrl;
  final String projectId;
  final String imageType;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;

  const CachedImageWidget({
    Key? key,
    required this.imageUrl,
    required this.projectId,
    required this.imageType,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
  }) : super(key: key);

  @override
  State<CachedImageWidget> createState() => _CachedImageWidgetState();
}

class _CachedImageWidgetState extends State<CachedImageWidget> {
  final CacheManager _cacheManager = CacheManager();
  late Future<String> _imageFuture;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(CachedImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl ||
        oldWidget.projectId != widget.projectId ||
        oldWidget.imageType != widget.imageType) {
      _loadImage();
    }
  }

  void _loadImage() {
    _imageFuture = _cacheManager.getImage(
      widget.imageUrl,
      widget.projectId,
      widget.imageType,
    );
  }

  @override
  Widget build(BuildContext context) {
    // For asset images or empty URLs, return a direct image
    if (widget.imageUrl.isEmpty || widget.imageUrl.startsWith('assets/')) {
      return _buildImageWidget(widget.imageUrl, isAsset: true);
    }

    // For HTTP URLs, use the cache
    return FutureBuilder<String>(
      future: _imageFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildPlaceholder();
        } else if (snapshot.hasError || !snapshot.hasData) {
          return _buildErrorWidget();
        } else {
          final String imagePath = snapshot.data!;
          return _buildImageWidget(imagePath);
        }
      },
    );
  }

  Widget _buildImageWidget(String path, {bool isAsset = false}) {
    Widget imageWidget;

    if (isAsset) {
      imageWidget = path.isEmpty
          ? _buildErrorWidget()
          : Image.asset(
              path,
              width: widget.width,
              height: widget.height,
              fit: widget.fit,
              errorBuilder: (_, __, ___) => _buildErrorWidget(),
            );
    } else if (path.startsWith('http')) {
      // For HTTP URLs that haven't been cached yet or failed to cache
      imageWidget = Image.network(
        path,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildPlaceholder();
        },
        errorBuilder: (_, __, ___) => _buildErrorWidget(),
      );
    } else {
      // For cached file paths
      imageWidget = Image.file(
        File(path),
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        errorBuilder: (_, __, ___) => _buildErrorWidget(),
      );
    }

    // Apply border radius if provided
    if (widget.borderRadius != null) {
      return ClipRRect(
        borderRadius: widget.borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildPlaceholder() {
    return widget.placeholder ??
        Container(
          width: widget.width,
          height: widget.height,
          color: Colors.grey[300],
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]!),
            ),
          ),
        );
  }

  Widget _buildErrorWidget() {
    return widget.errorWidget ??
        Container(
          width: widget.width,
          height: widget.height,
          color: Colors.grey[200],
          child: Icon(
            Icons.image_not_supported,
            color: Colors.grey[400],
            size: widget.width != null ? widget.width! / 3 : 48,
          ),
        );
  }
}
