import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  int selectedTab = 0;

  final tabs = const ['All', 'Papers', 'Authors', 'Citations'];

  final selectedFilters = <String>{};

  bool isFilterSelected(String label) => selectedFilters.contains(label);

  void toggleFilter(String label) {
    setState(() {
      if (isFilterSelected(label)) {
        selectedFilters.remove(label);
      } else {
        selectedFilters.add(label);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        final horizontalPadding = isWide ? 48.0 : 24.0;

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              40,
              horizontalPadding,
              32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Hero Header ────────────────────────────────────────
                Text(
                  'Explore Research',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Discover papers, authors, ideas, and citations — naturally.',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 40),

                // ── Prominent Search Field ─────────────────────────────
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: SearchBar(
                      hintText: 'Ask a question or search papers, authors, concepts…',
                      leading: const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Icon(Icons.search_rounded),
                      ),
                      elevation: const MaterialStatePropertyAll(1),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      padding: const MaterialStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                      textStyle: MaterialStatePropertyAll(
                        theme.textTheme.bodyLarge,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // ── Tabs (modern underline style) ──────────────────────
                SizedBox(
                  height: 48,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: tabs.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 24),
                    itemBuilder: (context, index) {
                      final selected = index == selectedTab;
                      return InkWell(
                        onTap: () => setState(() => selectedTab = index),
                        borderRadius: BorderRadius.circular(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              tabs[index],
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                                color: selected
                                    ? colorScheme.primary
                                    : colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 6),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: 3,
                              width: 24,
                              decoration: BoxDecoration(
                                color: selected
                                    ? colorScheme.primary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 28),

                // ── Filters ─────────────────────────────────────────────
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _FilterChip(
                      label: '2020–2025',
                      selected: isFilterSelected('2020–2025'),
                      onSelected: (_) => toggleFilter('2020–2025'),
                    ),
                    _FilterChip(
                      label: 'Peer-reviewed',
                      selected: isFilterSelected('Peer-reviewed'),
                      onSelected: (_) => toggleFilter('Peer-reviewed'),
                    ),
                    _FilterChip(
                      label: 'Open access',
                      selected: isFilterSelected('Open access'),
                      onSelected: (_) => toggleFilter('Open access'),
                    ),
                    _FilterChip(
                      label: 'Highly cited',
                      selected: isFilterSelected('Highly cited'),
                      onSelected: (_) => toggleFilter('Highly cited'),
                    ),
                    _FilterChip(
                      label: 'arXiv',
                      selected: isFilterSelected('arXiv'),
                      onSelected: (_) => toggleFilter('arXiv'),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // ── Results ─────────────────────────────────────────────
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 2, // demo
                  separatorBuilder: (_, __) => const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    return _PaperCard(
                      title: index == 0
                          ? 'Attention Is All You Need'
                          : 'BERT: Pre-training of Deep Bidirectional Transformers for Language Understanding',
                      authors: index == 0 ? 'Ashish Vaswani et al.' : 'Jacob Devlin et al.',
                      venue: index == 0 ? 'NeurIPS 2017' : 'NAACL 2019',
                      abstract: index == 0
                          ? 'We propose a new simple network architecture, the Transformer, based solely on attention mechanisms, dispensing with recurrence and convolutions entirely...'
                          : 'We introduce a new language representation model called BERT, which stands for Bidirectional Encoder Representations from Transformers...',
                      citations: index == 0 ? 185000 : 140000,
                      year: index == 0 ? 2017 : 2019,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      showCheckmark: false,
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      selectedColor: theme.colorScheme.primaryContainer,
      side: selected
          ? BorderSide(color: theme.colorScheme.primary, width: 1.2)
          : null,
      labelStyle: TextStyle(
        color: selected
            ? theme.colorScheme.onPrimaryContainer
            : theme.colorScheme.onSurfaceVariant,
        fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

class _PaperCard extends StatelessWidget {
  final String title;
  final String authors;
  final String venue;
  final String abstract;
  final int citations;
  final int year;

  const _PaperCard({
    required this.title,
    required this.authors,
    required this.venue,
    required this.abstract,
    required this.citations,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.4)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // → navigate to detail / pdf
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  _CitationBadge(citations: citations),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '$authors  ·  $venue  ·  $year',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                abstract,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.5,
                  color: colorScheme.onSurface.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  FilledButton.tonal(
                    onPressed: () {},
                    child: const Text('Read paper'),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.bookmark_border_rounded, size: 18),
                    label: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CitationBadge extends StatelessWidget {
  final int citations;

  const _CitationBadge({required this.citations});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.trending_up_rounded,
            size: 16,
            color: theme.colorScheme.secondary,
          ),
          const SizedBox(width: 4),
          Text(
            '$citations',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}