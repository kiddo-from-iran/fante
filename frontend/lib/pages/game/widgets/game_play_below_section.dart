import 'package:flutter/material.dart';
import 'package:frontend/pages/game/utils/game_picture_helper.dart';
import 'package:frontend/pages/home/home_assets.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

class GameSuggestionItem {
  const GameSuggestionItem({
    required this.title,
    required this.description,
    required this.image,
  });

  final String title;
  final String description;
  final String image;
}

/// White ad placeholders + dark suggestions carousel under the play cards.
class GamePlayBelowSection extends StatelessWidget {
  const GamePlayBelowSection({
    super.key,
    this.suggestions = const [],
  });

  final List<GameSuggestionItem> suggestions;

  static const defaultSuggestions = [
    GameSuggestionItem(
      title: 'از بهمنِ کوهستان نجات پیدا میکنی؟',
      description:
          'با یک گروه کوهنورد در حال صعود به قله ی برفی بودین که بهمن میاد و زیر برف دفن شدی، اگه این کوییز رو درست جواب بدی یعنی زنده میمونی!',
      image: HomeAssets.game3,
    ),
    GameSuggestionItem(
      title: 'دنیای انیمه',
      description: 'دانش خود را درباره شخصیت‌های محبوب انیمه محک بزنید.',
      image: HomeAssets.game1,
    ),
    GameSuggestionItem(
      title: 'چالش فانتزی',
      description: 'در این ماجراجویی انتخاب‌های شما سرنوشت را تغییر می‌دهد.',
      image: HomeAssets.game2,
    ),
    GameSuggestionItem(
      title: 'بازی تاج و تخت',
      description: 'هفت پادشاهی را بشناس و اتحاد بساز.',
      image: HomeAssets.game4,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final items =
        suggestions.isEmpty ? defaultSuggestions : suggestions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 640;
            final ad = Container(
              height: 88,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            );
            if (!wide) {
              return Column(
                children: [
                  ad,
                  const SizedBox(height: 12),
                  ad,
                ],
              );
            }
            return Row(
              children: [
                Expanded(child: ad),
                const SizedBox(width: 14),
                Expanded(child: ad),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        _SuggestionsCarousel(items: items),
      ],
    );
  }
}

class _SuggestionsCarousel extends StatefulWidget {
  const _SuggestionsCarousel({required this.items});

  final List<GameSuggestionItem> items;

  @override
  State<_SuggestionsCarousel> createState() => _SuggestionsCarouselState();
}

class _SuggestionsCarouselState extends State<_SuggestionsCarousel> {
  final _controller = ScrollController();

  static const _cardWidth = 220.0;
  static const _gap = 12.0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scroll(double delta) {
    if (!_controller.hasClients) return;
    final target = (_controller.offset + delta).clamp(
      0.0,
      _controller.position.maxScrollExtent,
    );
    _controller.animateTo(
      target,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
      decoration: BoxDecoration(
        color: const Color(0xE60A0A0A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'پیشنهاد بازی‌های جدید',
            textAlign: TextAlign.right,
            style: AppTextTheme.getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 168,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ListView.separated(
                  controller: _controller,
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  itemCount: widget.items.length,
                  separatorBuilder: (_, __) => const SizedBox(width: _gap),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: _cardWidth,
                      child: _SuggestionCard(item: widget.items[index]),
                    );
                  },
                ),
                Positioned(
                  left: 0,
                  child: _ArrowButton(
                    icon: Icons.chevron_right_rounded,
                    onTap: () => _scroll(_cardWidth + _gap),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: _ArrowButton(
                    icon: Icons.chevron_left_rounded,
                    onTap: () => _scroll(-(_cardWidth + _gap)),
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

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({required this.item});

  final GameSuggestionItem item;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        fit: StackFit.expand,
        children: [
          GamePictureHelper.image(picture: item.image),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.85),
                ],
                stops: const [0.35, 1],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  item.title,
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextTheme.getTextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.description,
                  textAlign: TextAlign.right,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextTheme.getTextStyle(
                    fontSize: 10,
                    color: AppColors.textMuted,
                    height: 1.4,
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

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, color: AppColors.primaryGold, size: 22),
        ),
      ),
    );
  }
}
