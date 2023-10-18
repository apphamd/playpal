import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  LikeButton({
    super.key,
    required this.isLiked,
    required this.onTap,
    required this.size,
  });
  final bool isLiked;
  final double size;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        Icons.favorite,
        color: isLiked ? Colors.red : Colors.white54,
        size: size,
      ),
    );
  }
}
