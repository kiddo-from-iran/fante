import 'package:flutter/material.dart';
import 'package:frontend/pages/dashboard/dashboard_nav.dart';
import 'package:frontend/pages/dashboard/dashboard_routes.dart';
import 'package:frontend/pages/dashboard/tickets/player_ticket.dart';
import 'package:frontend/pages/dashboard/widgets/dashboard_card.dart';
import 'package:frontend/pages/dashboard/widgets/dashboard_shell.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';
import 'package:frontend/widgets/toast/app_toast.dart';

class DashboardTicketsPage extends StatefulWidget {
  const DashboardTicketsPage({super.key});

  @override
  State<DashboardTicketsPage> createState() => _DashboardTicketsPageState();
}

class _DashboardTicketsPageState extends State<DashboardTicketsPage> {
  TicketStatus? _filter;

  List<PlayerTicket> get _filtered {
    final all = PlayerTicketsStore.instance.all;
    if (_filter == null) return all;
    return all.where((t) => t.status == _filter).toList();
  }

  void _createTicket() {
    Navigator.of(context).pushNamed(DashboardRoutes.ticketCreate).then((_) {
      if (mounted) setState(() {});
    });
  }

  void _editTicket(PlayerTicket ticket) {
    Navigator.of(context)
        .pushNamed(DashboardRoutes.ticketEdit, arguments: ticket.id)
        .then((_) {
      if (mounted) setState(() {});
    });
  }

  void _deleteTicket(PlayerTicket ticket) {
    showDialog<bool>(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: AppColors.surfaceCard,
          title: Text(
            'حذف تیکت',
            style: AppTextTheme.getTextStyle(
              color: AppColors.textLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'آیا از حذف «${ticket.subject}» مطمئن هستید؟',
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
      setState(() => PlayerTicketsStore.instance.delete(ticket.id));
      AppToast.success(context, 'تیکت حذف شد');
    });
  }

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      active: DashboardSection.tickets,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CreateSection(onCreate: _createTicket),
          const SizedBox(height: 16),
          _TicketsTableSection(
            tickets: _filtered,
            filter: _filter,
            onFilterChanged: (value) => setState(() => _filter = value),
            onEdit: _editTicket,
            onDelete: _deleteTicket,
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
                  'ثبت تیکت جدید',
                  style: AppTextTheme.getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'سوال، مشکل یا درخواست خود را به صورت تیکت ثبت کنید.',
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
                'تیکت جدید',
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

class _TicketsTableSection extends StatelessWidget {
  const _TicketsTableSection({
    required this.tickets,
    required this.filter,
    required this.onFilterChanged,
    required this.onEdit,
    required this.onDelete,
  });

  final List<PlayerTicket> tickets;
  final TicketStatus? filter;
  final ValueChanged<TicketStatus?> onFilterChanged;
  final ValueChanged<PlayerTicket> onEdit;
  final ValueChanged<PlayerTicket> onDelete;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: 'تیکت‌های من',
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
              for (final status in TicketStatus.values)
                _FilterChip(
                  label: status.label,
                  selected: filter == status,
                  onTap: () => onFilterChanged(status),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.cardBorder, height: 1),
          const SizedBox(height: 8),
          const _TableHeader(),
          const Divider(color: AppColors.cardBorder, height: 1),
          if (tickets.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text(
                'تیکتی با این فیلتر یافت نشد.',
                textAlign: TextAlign.center,
                style: AppTextTheme.getTextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
              ),
            )
          else
            for (var i = 0; i < tickets.length; i++) ...[
              _TicketRow(
                index: i + 1,
                ticket: tickets[i],
                onEdit: () => onEdit(tickets[i]),
                onDelete: () => onDelete(tickets[i]),
              ),
              if (i < tickets.length - 1)
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
            color: selected ? AppColors.primaryGold : AppColors.cardBorder,
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
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          _cell('ردیف', flex: 1, muted: true),
          _cell('موضوع', flex: 5, muted: true),
          _cell('وضعیت', flex: 2, muted: true),
          _cell('آخرین بروزرسانی', flex: 3, muted: true),
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

class _TicketRow extends StatelessWidget {
  const _TicketRow({
    required this.index,
    required this.ticket,
    required this.onEdit,
    required this.onDelete,
  });

  final int index;
  final PlayerTicket ticket;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
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
            flex: 5,
            child: Text(
              ticket.subject,
              style: AppTextTheme.getTextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textLight,
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
                  color: ticket.status.color,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  ticket.status.label,
                  style: AppTextTheme.getTextStyle(
                    fontSize: 11,
                    color: AppColors.textLight,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              _formatDate(ticket.updatedAt),
              style: AppTextTheme.getTextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
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
