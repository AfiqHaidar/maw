import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerText<T> extends StatelessWidget {
  final T? data;
  final String Function(T) textExtractor;
  final TextStyle style;
  final double shimmerWidth;
  final double shimmerHeight;

  const ShimmerText({
    super.key,
    required this.data,
    required this.textExtractor,
    required this.style,
    required this.shimmerWidth,
    required this.shimmerHeight,
  });

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: shimmerWidth,
          height: shimmerHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      );
    }
    return Text(
      textExtractor(data as T),
      style: style,
    );
  }
}
