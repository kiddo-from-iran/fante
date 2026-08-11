import 'package:flutter/material.dart';
import 'package:frontend/pages/dashboard/dashboard_nav.dart';
import 'package:frontend/pages/dashboard/dashboard_routes.dart';
import 'package:frontend/pages/dashboard/data/dashboard_controller.dart';
import 'package:frontend/pages/dashboard/tickets/player_ticket.dart';
import 'package:frontend/pages/dashboard/widgets/dashboard_shell.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';
import 'package:frontend/widgets/toast/app_toast.dart';

class DashboardTicketEditorPage extends StatefulWidget {
  const DashboardTicketEditorPage({
    super.key,
    this.ticketId,
  });

  final String? ticketId;

  @override
  State<DashboardTicketEditorPage> createState() =>
      _DashboardTicketEditorPageState();
}

class _DashboardTicketEditorPageState extends State<DashboardTicketEditorPage> {
  late final TextEditingController _subjectController;
  late final TextEditingController _descriptionController;
  late final bool _isEditing;
  PlayerTicket? _existing;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.ticketId != null;
    _existing = widget.ticketId == null
        ? null
        : PlayerTicketsStore.instance.byId(widget.ticketId!);

    _subjectController =
        TextEditingController(text: _existing?.subject ?? '');
    _descriptionController =
        TextEditingController(text: _existing?.description ?? '');
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _cancel() => Navigator.of(context).pop();

  void _save() {
    final subject = _subjectController.text.trim();
    final description = _descriptionController.text.trim();

    if (subject.isEmpty) {
      AppToast.warning(context, 'لطفاً موضوع تیکت را وارد کنید');
      return;
    }
    if (description.isEmpty) {
      AppToast.warning(context, 'لطفاً توضیحات تیکت را وارد کنید');
      return;
    }

    final now = DateTime.now();
    final ticket = PlayerTicket(
      id: _existing?.id ?? PlayerTicketsStore.instance.nextId(),
      subject: subject,
      description: description,
      priority: _existing?.priority ?? TicketPriority.medium,
      // Users cannot change status — keep existing or open for new tickets.
      status: _existing?.status ?? TicketStatus.open,
      createdAt: _existing?.createdAt ?? now,
      updatedAt: now,
    );

    PlayerTicketsStore.instance.upsert(ticket);
    dashboardController.refreshLocalSlices();
    AppToast.success(
      context,
      _isEditing ? 'تیکت با موفقیت ویرایش شد' : 'تیکت با موفقیت ثبت شد',
    );
    Navigator.of(context).pushNamedAndRemoveUntil(
      DashboardRoutes.tickets,
      (route) =>
          route.settings.name == DashboardRoutes.dashboard || route.isFirst,
    );
  }

  InputDecoration _fieldDecoration(String hint) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.primaryGold, width: 1.2),
    );
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextTheme.getTextStyle(
        fontSize: 13,
        color: AppColors.textMuted,
      ),
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(color: AppColors.primaryGold, width: 1.6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = _existing?.status;

    return DashboardShell(
      active: DashboardSection.tickets,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _isEditing ? 'ویرایش تیکت' : 'ثبت تیکت جدید',
                textAlign: TextAlign.center,
                style: AppTextTheme.getTextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_isEditing && status != null) ...[
                      Row(
                        children: [
                          Text(
                            'وضعیت:',
                            style: AppTextTheme.getTextStyle(
                              fontSize: 13,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: status.color,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              status.label,
                              style: AppTextTheme.getTextStyle(
                                fontSize: 12,
                                color: AppColors.textLight,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(فقط توسط پشتیبانی قابل تغییر است)',
                            style: AppTextTheme.getTextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                    ],
                    Text(
                      'موضوع',
                      style: AppTextTheme.getTextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _subjectController,
                      cursorColor: AppColors.primaryGold,
                      style: AppTextTheme.getTextStyle(
                        fontSize: 14,
                        color: AppColors.textLight,
                      ),
                      decoration: _fieldDecoration('مثلاً: مشکل در انتشار بازی'),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'توضیحات',
                      style: AppTextTheme.getTextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _descriptionController,
                      maxLines: 6,
                      cursorColor: AppColors.primaryGold,
                      style: AppTextTheme.getTextStyle(
                        fontSize: 14,
                        color: AppColors.textLight,
                      ),
                      decoration: _fieldDecoration(
                        'جزئیات مشکل یا درخواست خود را بنویسید...',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _cancel,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.surfaceCard,
                          foregroundColor: AppColors.textLight,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: AppColors.primaryGold.withValues(alpha: 0.7),
                              width: 1.2,
                            ),
                          ),
                        ),
                        child: Text(
                          'انصراف',
                          style: AppTextTheme.getTextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textLight,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGold,
                          foregroundColor: AppColors.textBlack,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _isEditing ? 'ذخیره تغییرات' : 'ثبت تیکت',
                          style: AppTextTheme.getTextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textBlack,
                          ),
                        ),
                      ),
                    ),
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
