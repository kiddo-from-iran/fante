import 'package:flutter/material.dart';
import 'package:frontend/pages/game/models/game_session_data.dart';
import 'package:frontend/pages/game/widgets/game_author_header.dart';
import 'package:frontend/pages/game/widgets/game_glass_card.dart';
import 'package:frontend/pages/game/widgets/game_option_widgets.dart';
import 'package:frontend/pages/game/widgets/game_play_below_section.dart';
import 'package:frontend/pages/game/widgets/game_scaffold.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

/// Shell for all play-phase screens (quiz, poll, etc.).
class GamePlayPage extends StatelessWidget {
  const GamePlayPage({
    super.key,
    required this.data,
  });

  final GameSessionData data;

  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      backgroundAsset: data.background,
      child: GameSessionLayout(
        sidebar: GameSidebar(data: data.sidebar),
        main: _PlayMainCard(data: data),
        footer: const GamePlayBelowSection(),
      ),
    );
  }
}

class _PlayMainCard extends StatelessWidget {
  const _PlayMainCard({required this.data});

  final GameSessionData data;

  @override
  Widget build(BuildContext context) {
    return GameGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GameAuthorHeader(
            title: data.title,
            designerName: data.designerName,
            designerAvatar: data.designerAvatar,
          ),
          const SizedBox(height: 20),
          const Divider(color: AppColors.cardBorder, height: 1),
          const SizedBox(height: 20),
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (data is QuizPlayData) {
      return QuizPlayView(data: data as QuizPlayData);
    }
    if (data is PollPlayData) {
      return PollPlayView(data: data as PollPlayData);
    }
    return const SizedBox.shrink();
  }
}

class QuizPlayView extends StatefulWidget {
  const QuizPlayView({super.key, required this.data});

  final QuizPlayData data;

  @override
  State<QuizPlayView> createState() => _QuizPlayViewState();
}

class _QuizPlayViewState extends State<QuizPlayView> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.data.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${data.questionNumber}- ${data.question}',
          textAlign: TextAlign.right,
          style: AppTextTheme.getTextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.textLight,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
        GameOptionsList(
          labels: data.options,
          images: data.optionImages,
          columns: data.imageCardColumns,
          selectedIndex: _selectedIndex,
          onSelect: (index) {
            if (_selectedIndex == index) return;
            setState(() => _selectedIndex = index);
          },
        ),
      ],
    );
  }
}

class PollPlayView extends StatefulWidget {
  const PollPlayView({super.key, required this.data});

  final PollPlayData data;

  @override
  State<PollPlayView> createState() => _PollPlayViewState();
}

class _PollPlayViewState extends State<PollPlayView> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.data.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          data.question,
          textAlign: TextAlign.center,
          style: AppTextTheme.getTextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.textLight,
          ),
        ),
        const SizedBox(height: 20),
        if (data.useImageCards)
          GameOptionsList(
            labels: data.options.map((o) => o.label).toList(),
            images: data.options.map((o) => o.image).toList(),
            columns: data.imageCardColumns,
            selectedIndex: _selectedIndex,
            onSelect: (index) {
              if (_selectedIndex == index) return;
              setState(() => _selectedIndex = index);
            },
          )
        else
          ...List.generate(data.options.length, (index) {
            final option = data.options[index];
            return GameResultBar(
              option: option,
              highlighted: _selectedIndex == index,
              showPercent: data.showPercentages,
              onTap: () {
                if (_selectedIndex == index) return;
                setState(() => _selectedIndex = index);
              },
            );
          }),
        const SizedBox(height: 12),
        GameOrangeButton(
          label: 'ثبت رای',
          outlined: true,
          onPressed: () {},
        ),
      ],
    );
  }
}
