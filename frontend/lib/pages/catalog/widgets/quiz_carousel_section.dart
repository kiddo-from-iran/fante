import 'package:flutter/material.dart';
import 'package:frontend/pages/catalog/widgets/quiz_selection_card.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

class QuizCarouselItem {
  const QuizCarouselItem({
    required this.id,
    required this.title,
    required this.image,
    this.playerGameId,
  });

  final int id;
  final String title;
  final String image;
  final String? playerGameId;
}

class QuizCarouselSection extends StatefulWidget {
  const QuizCarouselSection({
    super.key,
    required this.title,
    required this.items,
    required this.onItemPressed,
    this.onSeeAll,
  });

  final String title;
  final List<QuizCarouselItem> items;
  final ValueChanged<QuizCarouselItem> onItemPressed;
  final VoidCallback? onSeeAll;

  @override
  State<QuizCarouselSection> createState() => _QuizCarouselSectionState();
}

class _QuizCarouselSectionState extends State<QuizCarouselSection> {
  final ScrollController _controller = ScrollController();

  static const _cardSize = 248.0;
  static const _gap = 12.0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scrollBy(double delta) {
    if (!_controller.hasClients) return;
    final target = (_controller.offset + delta).clamp(
      0.0,
      _controller.position.maxScrollExtent,
    );
    _controller.animateTo(
      target,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          _SectionHeader(
            title: widget.title,
            onSeeAll: widget.onSeeAll,
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: _cardSize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ListView.separated(
                  controller: _controller,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  itemCount: widget.items.length,
                  separatorBuilder: (_, __) => const SizedBox(width: _gap),
                  itemBuilder: (context, index) {
                    final item = widget.items[index];
                    return SizedBox(
                      width: _cardSize,
                      height: _cardSize,
                      child: QuizSelectionCard(
                        title: item.title,
                        image: item.image,
                        onPressed: () => widget.onItemPressed(item),
                      ),
                    );
                  },
                ),
                Positioned(
                  left: 0,
                  child: _CarouselArrow(
                    icon: Icons.chevron_right_rounded,
                    onPressed: () => _scrollBy(-(_cardSize + _gap)),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: _CarouselArrow(
                    icon: Icons.chevron_left_rounded,
                    onPressed: () => _scrollBy(_cardSize + _gap),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CreatorsCarouselSection extends StatefulWidget {
  const CreatorsCarouselSection({
    super.key,
    required this.title,
    required this.children,
    this.onSeeAll,
  });

  final String title;
  final List<Widget> children;
  final VoidCallback? onSeeAll;

  @override
  State<CreatorsCarouselSection> createState() =>
      _CreatorsCarouselSectionState();
}

class _CreatorsCarouselSectionState extends State<CreatorsCarouselSection> {
  final ScrollController _controller = ScrollController();

  static const _step = 160.0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scrollBy(double delta) {
    if (!_controller.hasClients) return;
    final target = (_controller.offset + delta).clamp(
      0.0,
      _controller.position.maxScrollExtent,
    );
    _controller.animateTo(
      target,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          _SectionHeader(
            title: widget.title,
            onSeeAll: widget.onSeeAll,
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 248,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ListView.separated(
                  controller: _controller,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  itemCount: widget.children.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) => widget.children[index],
                ),
                Positioned(
                  left: 0,
                  child: _CarouselArrow(
                    icon: Icons.chevron_right_rounded,
                    onPressed: () => _scrollBy(-_step),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: _CarouselArrow(
                    icon: Icons.chevron_left_rounded,
                    onPressed: () => _scrollBy(_step),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.onSeeAll,
  });

  final String title;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextTheme.getTextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textLight,
          ),
        ),
        if (onSeeAll != null)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: onSeeAll,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryGold,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'مشاهده همه',
                    style: AppTextTheme.getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryGold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 14,
                    color: AppColors.primaryGold,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _CarouselArrow extends StatelessWidget {
  const _CarouselArrow({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.textLight.withValues(alpha: 0.85),
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            icon,
            size: 28,
            color: AppColors.textBlack,
          ),
        ),
      ),
    );
  }
}
