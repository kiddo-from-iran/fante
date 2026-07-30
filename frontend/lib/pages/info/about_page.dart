import 'package:flutter/material.dart';
import 'package:frontend/pages/home/home_assets.dart';
import 'package:frontend/pages/info/widgets/info_page_scaffold.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoPageScaffold(
      title: 'درباره ما',
      subtitle:
          'فانته کوییز خانه‌ای برای طرفداران دنیای فانتزی، انیمه و فیلم است.',
      belowSubtitle: Center(
        child: Image.asset(
          HomeAssets.aboutProudGirl,
          height: 280,
          fit: BoxFit.contain,
        ),
      ),
      child: Column(
        children: [
          const InfoSectionCard(
            title: 'داستان فانته کوییز',
            child: InfoBodyText(
              'فانته کوییز با هدف ساختن فضایی سرگرم‌کننده و رقابتی برای '
              'علاقه‌مندان به جهان‌های خیالی شکل گرفته است. اینجا می‌توانید '
              'دانش خود را با کوییزهای متنوع بسنجید، تست‌های شخصیت انجام دهید، '
              'در نظرسنجی‌ها شرکت کنید و حتی کوییز اختصاصی خودتان را بسازید '
              'و با دیگران به اشتراک بگذارید.',
            ),
          ),
          const SizedBox(height: 20),
          const InfoSectionCard(
            title: 'ماموریت ما',
            child: InfoBodyText(
              'ما می‌خواهیم تجربه بازی و یادگیری درباره دنیای فانتزی را '
              'ساده‌تر، زیباتر و اجتماعی‌تر کنیم. تمرکز ما روی کیفیت محتوا، '
              'رابط کاربری روان و ایجاد جامعه‌ای دوستانه از خالقان و بازیکنان است.',
            ),
          ),
          const SizedBox(height: 20),
          InfoSectionCard(
            title: 'آنچه در فانته کوییز پیدا می‌کنید',
            child: InfoBulletList(const [
              'کوییزهای رقابتی درباره فیلم، سریال، انیمه و بازی‌های فانتزی',
              'تست‌های شخصیت و روانشناسی با تم‌های جذاب',
              'نظرسنجی‌ها و چالش‌های جمعی برای تعامل بیشتر',
              'امکان طراحی و انتشار کوییز توسط خودتان',
              'جدول رنکینگ و پیگیری پیشرفت بازیکنان',
            ]),
          ),
          const SizedBox(height: 20),
          InfoSectionCard(
            child: Column(
              children: [
                Text(
                  'همراه ما باشید',
                  style: AppTextTheme.getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGold,
                  ),
                ),
                const SizedBox(height: 12),
                const InfoBodyText(
                  'اگر عاشق ماجراجویی در دنیای فانتزی هستید، فانته کوییز '
                  'جای شماست. بازی کنید، بسازید و بخشی از این جامعه باشید.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
