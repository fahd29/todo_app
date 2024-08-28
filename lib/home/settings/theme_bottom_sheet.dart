import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/provider/app_config_provider.dart';
import 'package:todo_app/provider/app_theme_provider.dart';

class ThemeBottomSheet extends StatefulWidget {
  const ThemeBottomSheet({super.key});

  @override
  State<ThemeBottomSheet> createState() => _ThemeBottomSheetState();
}

class _ThemeBottomSheetState extends State<ThemeBottomSheet> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    var providerTheme = Provider.of<AppThemeProvider>(context);
    return Container(
      margin: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
              onTap: () {
                providerTheme.changeTheme(ThemeMode.dark);
              },
              child: providerTheme.isDarkMode()
                  ? getSelected(AppLocalizations.of(context)!.dark)
                  : getUnSelected(AppLocalizations.of(context)!.dark)),
          SizedBox(
            height: 20,
          ),
          InkWell(
              onTap: () {
                providerTheme.changeTheme(ThemeMode.light);
              },
              child: providerTheme.isDarkMode()
                  ? getUnSelected(AppLocalizations.of(context)!.light)
                  : getSelected(AppLocalizations.of(context)!.light)),
        ],
      ),
    );
  }

  Widget getSelected(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: AppColors.primaryColor),
        ),
        Icon(
          Icons.check,
          color: AppColors.primaryColor,
          size: 35,
        ),
      ],
    );
  }

  Widget getUnSelected(String text) {
    return Text(text, style: Theme.of(context).textTheme.bodyLarge);
  }
}
