import 'package:flutter/material.dart';
import 'package:frontend/pages/dashboard/dashboard_nav.dart';
import 'package:frontend/pages/dashboard/dashboard_routes.dart';
import 'package:frontend/pages/dashboard/game_editor/player_game.dart';
import 'package:frontend/pages/dashboard/widgets/dashboard_card.dart';
import 'package:frontend/pages/dashboard/widgets/dashboard_shell.dart';
import 'package:frontend/pages/game/models/game_kind.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';
import 'package:frontend/utils/jalali_date.dart';
import 'package:frontend/widgets/toast/app_toast.dart';

class DashboardGamesPage extends StatefulWidget {
  const DashboardGamesPage({super.key});

  @override
  State<DashboardGamesPage> createState() => _DashboardGamesPageState();
}

class _DashboardGamesPageState extends State<DashboardGamesPage> {
  GameKind? _filter;

  List<PlayerGame> get _filtered {
    final all = PlayerGamesStore.instance.all;
    if (_filter == null) return all;
    return all.where((g) => g.kind == _filter).toList();
  }

  void _createGame() {
    Navigator.of(context)
        .pushNamed(DashboardRoutes.gameCreate)
        .then((_) {
      if (mounted) setState(() {});
    });
  }

  void _editGame(PlayerGame game) {
    Navigator.of(context)
        .pushNamed(
          DashboardRoutes.gameEdit,
          arguments: game.id,
        )
        .then((_) {
      if (mounted) setState(() {});
    });
  }

  void _deleteGame(PlayerGame game) {
    showDialog<bool>(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: AppColors.surfaceCard,
          title: Text(
            'حذف بازی',
            style: AppTextTheme.getTextStyle(
              color: AppColors.textLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'آیا از حذف «${game.title}» مطمئن هستید؟',
            style: AppTextTheme.getTextStyle(color: AppColors.textMuted),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'انصراف',
                style: AppTextTheme.getTextStyle(color: AppColors.textMuted),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                'حذف',
                style: AppTextTheme.getTextStyle(color: AppColors.errorColor),
              ),
            ),
          ],
        ),
      ),
    ).then((confirmed) {
      if (confirmed != true || !mounted) return;
      setState(() => PlayerGamesStore.instance.delete(game.id));
      AppToast.success(context, 'بازی حذف شد');
    });
  }

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      active: DashboardSection.myQuizzes,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CreateSection(onCreate: _createGame),
          const SizedBox(height: 16),
          _GamesTableSection(
            games: _filtered,
            filter: _filter,
            onFilterChanged: (value) => setState(() => _filter = value),
            onEdit: _editGame,
            onDelete: _deleteGame,
          ),
        ],
      ),
    );
  }
}

class _CreateSection extends StatelessWidget {
  const _CreateSection({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ساخت بازی جدید',
                  style: AppTextTheme.getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'کوییز، تست یا نظرسنجی جدید بسازید و آن را منتشر کنید.',
                  style: AppTextTheme.getTextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            height: 44,
            child: ElevatedButton.icon(
              onPressed: onCreate,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGold,
                foregroundColor: AppColors.textBlack,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.add_rounded, size: 20),
              label: Text(
                'ساخت بازی جدید',
                style: AppTextTheme.getTextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GamesTableSection extends StatelessWidget {
  const _GamesTableSection({
    required this.games,
    required this.filter,
    required this.onFilterChanged,
    required this.onEdit,
    required this.onDelete,
  });

  final List<PlayerGame> games;
  final GameKind? filter;
  final ValueChanged<GameKind?> onFilterChanged;
  final ValueChanged<PlayerGame> onEdit;
  final ValueChanged<PlayerGame> onDelete;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: 'بازی‌های ساخته‌شده',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _FilterChip(
                label: 'همه',
                selected: filter == null,
                onTap: () => onFilterChanged(null),
              ),
              _FilterChip(
                label: 'کوییز',
                selected: filter == GameKind.quiz,
                onTap: () => onFilterChanged(GameKind.quiz),
              ),
              _FilterChip(
                label: 'تست',
                selected: filter == GameKind.personality,
                onTap: () => onFilterChanged(GameKind.personality),
              ),
              _FilterChip(
                label: 'نظرسنجی',
                selected: filter == GameKind.poll,
                onTap: () => onFilterChanged(GameKind.poll),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.cardBorder, height: 1),
          const SizedBox(height: 8),
          _TableHeader(),
          const Divider(color: AppColors.cardBorder, height: 1),
          if (games.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text(
                'بازی‌ای با این فیلتر یافت نشد.',
                textAlign: TextAlign.center,
                style: AppTextTheme.getTextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
              ),
            )
          else
            for (var i = 0; i < games.length; i++) ...[
              _GameRow(
                index: i + 1,
                game: games[i],
                onEdit: () => onEdit(games[i]),
                onDelete: () => onDelete(games[i]),
              ),
              if (i < games.length - 1)
                const Divider(color: AppColors.cardBorder, height: 1),
            ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryGold : AppColors.backgroundDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppColors.primaryGold
                : AppColors.cardBorder,
          ),
        ),
        child: Text(
          label,
          style: AppTextTheme.getTextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.textBlack : AppColors.textLight,
          ),
        ),
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          _cell('ردیف', flex: 1, muted: true),
          _cell('عنوان', flex: 4, muted: true),
          _cell('نوع', flex: 2, muted: true),
          _cell('تعداد سوال', flex: 2, muted: true),
          _cell('تاریخ ساخت', flex: 2, muted: true),
          _cell('وضعیت', flex: 2, muted: true),
          _cell('عملیات', flex: 2, muted: true, alignEnd: true),
        ],
      ),
    );
  }

  Widget _cell(
    String text, {
    required int flex,
    bool muted = false,
    bool alignEnd = false,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: alignEnd ? TextAlign.left : TextAlign.right,
        style: AppTextTheme.getTextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: muted ? AppColors.textMuted : AppColors.textLight,
        ),
      ),
    );
  }
}

class _GameRow extends StatelessWidget {
  const _GameRow({
    required this.index,
    required this.game,
    required this.onEdit,
    required this.onDelete,
  });

  final int index;
  final PlayerGame game;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final date = JalaliDate.format(game.createdAt);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              '$index',
              style: AppTextTheme.getTextStyle(
                fontSize: 13,
                color: AppColors.textLight,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              game.title,
              style: AppTextTheme.getTextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textLight,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              game.kindLabel,
              style: AppTextTheme.getTextStyle(
                fontSize: 13,
                color: AppColors.textLight,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${game.questions.length}',
              style: AppTextTheme.getTextStyle(
                fontSize: 13,
                color: AppColors.textLight,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              date,
              style: AppTextTheme.getTextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: game.isPublished
                      ? const Color(0xFF2D7D46)
                      : AppColors.hoverButton,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  game.isPublished ? 'منتشر شده' : 'پیش‌نویس',
                  style: AppTextTheme.getTextStyle(
                    fontSize: 11,
                    color: AppColors.textLight,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: onEdit,
                  tooltip: 'ویرایش',
                  iconSize: 18,
                  color: AppColors.primaryGold,
                  splashRadius: 18,
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  onPressed: onDelete,
                  tooltip: 'حذف',
                  iconSize: 18,
                  color: AppColors.errorColor,
                  splashRadius: 18,
                  icon: const Icon(Icons.delete_outline_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
