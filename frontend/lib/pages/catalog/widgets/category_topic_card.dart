import 'package:flutter/material.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

class CategoryTopicItem {
  const CategoryTopicItem({
    required this.title,
    required this.grayImage,
    this.colorImage,
  });

  final String title;

  /// Grayscale / idle artwork. When [colorImage] is null, this path is shown
  /// with a grayscale filter until hover.
  final String grayImage;

  /// Optional full-color artwork shown on hover.
  final String? colorImage;
}

class CategoryTopicCard extends StatefulWidget {
  const CategoryTopicCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  final CategoryTopicItem item;
  final VoidCallback onTap;

  @override
  State<CategoryTopicCard> createState() => _CategoryTopicCardState();
}

class _CategoryTopicCardState extends State<CategoryTopicCard> {
  bool _hovered = false;

  static const _grayscale = ColorFilter.matrix(<double>[
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0, 0, 0, 1, 0,
  ]);

  static const _identity = ColorFilter.matrix(<double>[
    1, 0, 0, 0, 0,
    0, 1, 0, 0, 0,
    0, 0, 1, 0, 0,
    0, 0, 0, 1, 0,
  ]);

  @override
  Widget build(BuildContext context) {
    final hasColorVariant = widget.item.colorImage != null;
    final imagePath = (_hovered && hasColorVariant)
        ? widget.item.colorImage!
        : widget.item.grayImage;
    final applyFilter = !hasColorVariant && !_hovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hovered ? 1.03 : 1,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          child: AspectRatio(
            aspectRatio: 396 / 472,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ColorFiltered(
                    colorFilter: applyFilter ? _grayscale : _identity,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Image.asset(
                        imagePath,
                        key: ValueKey('$imagePath-$_hovered'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          Color(0xCC000000),
                        ],
                        stops: [0, 0.55, 1],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    right: 10,
                    bottom: 14,
                    child: Text(
                      widget.item.title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textLight,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
