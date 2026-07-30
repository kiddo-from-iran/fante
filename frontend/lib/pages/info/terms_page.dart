import 'package:flutter/material.dart';
import 'package:frontend/pages/info/widgets/info_page_scaffold.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoPageScaffold(
      title: 'قوانین و مقررات',
      subtitle:
          'با استفاده از فانته کوییز، این قوانین و شرایط استفاده را می‌پذیرید.',
      child: Column(
        children: [
          InfoSectionCard(
            title: '۱. پذیرش شرایط',
            child: InfoBulletList(const [
              'ورود و استفاده از سرویس به منزله پذیرش کامل این قوانین است.',
              'در صورت عدم موافقت، لطفاً از استفاده از پلتفرم خودداری کنید.',
            ]),
          ),
          const SizedBox(height: 20),
          InfoSectionCard(
            title: '۲. حساب کاربری',
            child: InfoBulletList(const [
              'مسئولیت حفظ امنیت حساب و اطلاعات ورود بر عهده کاربر است.',
              'ارائه اطلاعات نادرست یا سوءاستفاده از حساب دیگران ممنوع است.',
              'فانته کوییز می‌تواند حساب‌های متخلف را محدود یا مسدود کند.',
            ]),
          ),
          const SizedBox(height: 20),
          InfoSectionCard(
            title: '۳. محتوا و مالکیت فکری',
            child: InfoBulletList(const [
              'محتوای تولیدشده توسط کاربران باید با قوانین کشور و عرف عمومی سازگار باشد.',
              'انتشار محتوای توهین‌آمیز، نفرت‌پراکن، اسپم یا ناقض حقوق دیگران ممنوع است.',
              'حقوق برند، لوگو و طراحی‌های فانته کوییز محفوظ است.',
              'با انتشار کوییز، به پلتفرم اجازه نمایش و توزیع آن در سرویس داده می‌شود.',
            ]),
          ),
          const SizedBox(height: 20),
          InfoSectionCard(
            title: '۴. رفتار در جامعه',
            child: InfoBulletList(const [
              'احترام به سایر بازیکنان و سازندگان الزامی است.',
              'تقلب، دستکاری امتیاز یا سوءاستفاده از باگ‌ها مجاز نیست.',
              'گزارش تخلفات به تیم پشتیبانی کمک می‌کند محیط سالم‌تری بسازیم.',
            ]),
          ),
          const SizedBox(height: 20),
          InfoSectionCard(
            title: '۵. مسئولیت‌ها و تغییرات',
            child: InfoBulletList(const [
              'سرویس «همان‌گونه که هست» ارائه می‌شود و ممکن است گاهی در دسترس نباشد.',
              'فانته کوییز می‌تواند این قوانین را به‌روزرسانی کند؛ نسخه جدید از زمان انتشار معتبر است.',
              'ادامه استفاده پس از تغییرات به معنای پذیرش نسخه جدید قوانین است.',
            ]),
          ),
          const SizedBox(height: 20),
          const InfoSectionCard(
            title: '۶. تماس درباره قوانین',
            child: InfoBodyText(
              'برای پرسش درباره این مقررات یا گزارش تخلف، از صفحه «تماس با ما» '
              'استفاده کنید یا از طریق ایمیل پشتیبانی با ما در ارتباط باشید.',
            ),
          ),
        ],
      ),
    );
  }
}
