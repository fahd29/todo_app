import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/home/settings/language_bottom_sheet.dart';
import 'package:todo_app/home/settings/theme_bottom_sheet.dart';
import 'package:todo_app/provider/app_config_provider.dart';
import 'package:todo_app/provider/app_theme_provider.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    var providerTheme = Provider.of<AppThemeProvider>(context);

    return Container(
      margin: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.language,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: providerTheme.isDarkMode()
                    ? AppColors.whiteColor
                    : AppColors.blackDarkColor),
          ),
          SizedBox(
            height: 15,
          ),
          InkWell(
            onTap: () {
              showLanguageBottomsheet();
            },
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    provider.appLanguage == 'en'
                        ? AppLocalizations.of(context)!.english
                        : AppLocalizations.of(context)!.arabic,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.whiteColor),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    size: 40,
                    color: AppColors.whiteColor,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            AppLocalizations.of(context)!.theme,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: providerTheme.isDarkMode()
                    ? AppColors.whiteColor
                    : AppColors.blackDarkColor),
          ),
          SizedBox(
            height: 15,
          ),
          InkWell(
            onTap: () {
              showThemeBottomsheet();
            },
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      providerTheme.isDarkMode()
                          ? AppLocalizations.of(context)!.dark
                          : AppLocalizations.of(context)!.light,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: AppColors.whiteColor)),
                  Icon(
                    Icons.arrow_drop_down,
                    size: 40,
                    color: AppColors.whiteColor,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showLanguageBottomsheet() {
    showModalBottomSheet(
        backgroundColor: AppColors.greenColor,
        context: context,
        builder: (context) => LanguageBottomSheet());
  }

  void showThemeBottomsheet() {
    showModalBottomSheet(
        backgroundColor: AppColors.greenColor,
        context: context,
        builder: (context) => ThemeBottomSheet());
  }
}
