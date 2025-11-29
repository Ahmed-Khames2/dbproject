import 'package:flutter/material.dart';
import 'package:dbproject/core/theme/colors.dart';
import 'package:dbproject/core/theme/spacing.dart';
import 'package:dbproject/core/theme/text_style.dart';

enum AppTheme {
  light,
  dark;

  const AppTheme();
}

final appThemeData = {
  AppTheme.light: ThemeData(
    fontFamily: 'Cairo',
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.white,
      secondary: AppColors.lightSecondary,
      onSecondary: AppColors.lightTextPrimary,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
      background: AppColors.lightBackground,
      onBackground: AppColors.lightTextPrimary,
      error: AppColors.lightError,
      onError: AppColors.white,
      surfaceVariant: AppColors.lightCardBackground,
      onSurfaceVariant: AppColors.lightTextSecondary,
      outline: AppColors.lightBorder,
      shadow: AppColors.lightShadow,
      inversePrimary: AppColors.lightPrimary.withOpacity(0.8),
      inverseSurface: AppColors.lightTextPrimary,
      onInverseSurface: AppColors.white,
      tertiary: AppColors.orange,
      onTertiary: AppColors.white,
    ),
    scaffoldBackgroundColor: AppColors.lightBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightPrimary,
      foregroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.headline6.copyWith(color: AppColors.white),
      iconTheme: IconThemeData(color: AppColors.white),
      actionsIconTheme: IconThemeData(color: AppColors.white),
    ),
    listTileTheme: ListTileThemeData(
      tileColor: AppColors.lightCardBackground,
      textColor: AppColors.lightTextPrimary,
      iconColor: AppColors.lightPrimary,
      titleTextStyle: AppTextStyles.bodyMedium,
      subtitleTextStyle: AppTextStyles.bodySmall,
      contentPadding: EdgeInsets.symmetric(
        horizontal: Spacing.mdH,
        vertical: Spacing.sm,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Spacing.mdRadius),
      ),
      dense: false,
    ),
    cardTheme: CardThemeData(
      color: AppColors.lightCardBackground,
      elevation: Spacing.smElevation,
      shadowColor: AppColors.lightShadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Spacing.lgRadius),
      ),
      margin: EdgeInsets.all(Spacing.mdMargin),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightBackground,
      selectedItemColor: AppColors.lightPrimary,
      unselectedItemColor: AppColors.lightTextSecondary,
      showUnselectedLabels: true,
      elevation: Spacing.smElevation,
      type: BottomNavigationBarType.fixed,
      landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.lightPrimary,
        textStyle: AppTextStyles.button,
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.lgH,
          vertical: Spacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Spacing.xlRadius),
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.white,
        elevation: Spacing.smElevation,
        textStyle: AppTextStyles.button,
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.lgH,
          vertical: Spacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Spacing.xlRadius),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.lightPrimary,
        textStyle: AppTextStyles.button,
        side: BorderSide(color: AppColors.lightPrimary, width: 1.5),
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.lgH,
          vertical: Spacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Spacing.xlRadius),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightCardBackground,
      hintStyle: AppTextStyles.bodySmall.copyWith(
        color: AppColors.lightTextSecondary,
      ),
      labelStyle: AppTextStyles.labelMedium,
      errorStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.lightError),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      contentPadding: EdgeInsets.symmetric(
        horizontal: Spacing.mdH,
        vertical: Spacing.sm,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Spacing.xlRadius),
        borderSide: BorderSide(color: AppColors.lightBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Spacing.xlRadius),
        borderSide: BorderSide(color: AppColors.lightBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Spacing.xlRadius),
        borderSide: BorderSide(color: AppColors.lightPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Spacing.xlRadius),
        borderSide: BorderSide(color: AppColors.lightError),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Spacing.xlRadius),
        borderSide: BorderSide(color: AppColors.lightError, width: 2),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyles.headline1,
      displayMedium: AppTextStyles.headline2,
      displaySmall: AppTextStyles.headline3,
      headlineMedium: AppTextStyles.headline4,
      headlineSmall: AppTextStyles.headline5,
      titleLarge: AppTextStyles.headline6,
      titleMedium: AppTextStyles.labelLarge,
      titleSmall: AppTextStyles.labelMedium,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.labelLarge,
      labelMedium: AppTextStyles.labelMedium,
      labelSmall: AppTextStyles.labelSmall,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.lightCardBackground,
      deleteIconColor: AppColors.lightTextSecondary,
      disabledColor: AppColors.lightTextSecondary.withOpacity(0.5),
      selectedColor: AppColors.lightPrimary.withOpacity(0.1),
      secondarySelectedColor: AppColors.lightPrimary.withOpacity(0.05),
      shadowColor: AppColors.lightShadow,
      selectedShadowColor: AppColors.lightShadow,
      checkmarkColor: AppColors.lightPrimary,
      labelStyle: AppTextStyles.bodySmall,
      secondaryLabelStyle: AppTextStyles.bodySmall.copyWith(
        color: AppColors.lightPrimary,
      ),
      brightness: Brightness.light,
      elevation: Spacing.smElevation,
      pressElevation: Spacing.mdElevation,
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.smH,
        vertical: Spacing.xs,
      ),
      labelPadding: EdgeInsets.symmetric(horizontal: Spacing.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Spacing.xlRadius),
      ),
      side: BorderSide(color: AppColors.lightBorder),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.lightBorder,
      thickness: 1,
      space: 1,
      indent: 0,
      endIndent: 0,
    ),
  ),

  AppTheme.dark: ThemeData(
    fontFamily: 'Cairo',
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.white,
      secondary: AppColors.darkSecondary,
      onSecondary: AppColors.darkTextPrimary,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      background: AppColors.darkBackground,
      onBackground: AppColors.darkTextPrimary,
      error: AppColors.darkError,
      onError: AppColors.white,
      surfaceVariant: AppColors.darkCardBackground,
      onSurfaceVariant: AppColors.darkTextSecondary,
      outline: AppColors.darkBorder,
      shadow: AppColors.darkShadow,
      inversePrimary: AppColors.darkPrimary.withOpacity(0.8),
      inverseSurface: AppColors.darkTextPrimary,
      onInverseSurface: AppColors.white,
      tertiary: AppColors.orange,
      onTertiary: AppColors.white,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkPrimary,
      foregroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.headline6.copyWith(color: AppColors.white),
      iconTheme: IconThemeData(color: AppColors.white),
      actionsIconTheme: IconThemeData(color: AppColors.white),
    ),
    listTileTheme: ListTileThemeData(
      tileColor: AppColors.darkCardBackground,
      textColor: AppColors.darkTextPrimary,
      iconColor: AppColors.darkPrimary,
      titleTextStyle: AppTextStyles.bodyMedium,
      subtitleTextStyle: AppTextStyles.bodySmall,
      contentPadding: EdgeInsets.symmetric(
        horizontal: Spacing.mdH,
        vertical: Spacing.sm,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Spacing.mdRadius),
      ),
      dense: false,
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkCardBackground,
      elevation: Spacing.smElevation,
      shadowColor: AppColors.darkShadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Spacing.lgRadius),
      ),
      margin: EdgeInsets.all(Spacing.mdMargin),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkBackground,
      selectedItemColor: AppColors.darkPrimary,
      unselectedItemColor: AppColors.darkTextSecondary,
      showUnselectedLabels: true,
      elevation: Spacing.smElevation,
      type: BottomNavigationBarType.fixed,
      landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.darkPrimary,
        textStyle: AppTextStyles.button,
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.lgH,
          vertical: Spacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Spacing.xlRadius),
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.white,
        elevation: Spacing.smElevation,
        textStyle: AppTextStyles.button,
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.lgH,
          vertical: Spacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Spacing.xlRadius),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.darkPrimary,
        textStyle: AppTextStyles.button,
        side: BorderSide(color: AppColors.darkPrimary, width: 1.5),
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.lgH,
          vertical: Spacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Spacing.xlRadius),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkCardBackground,
      hintStyle: AppTextStyles.bodySmall.copyWith(
        color: AppColors.darkTextSecondary,
      ),
      labelStyle: AppTextStyles.labelMedium,
      errorStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.darkError),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      contentPadding: EdgeInsets.symmetric(
        horizontal: Spacing.mdH,
        vertical: Spacing.sm,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Spacing.xlRadius),
        borderSide: BorderSide(color: AppColors.darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Spacing.xlRadius),
        borderSide: BorderSide(color: AppColors.darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Spacing.xlRadius),
        borderSide: BorderSide(color: AppColors.darkPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Spacing.xlRadius),
        borderSide: BorderSide(color: AppColors.darkError),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Spacing.xlRadius),
        borderSide: BorderSide(color: AppColors.darkError, width: 2),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyles.headline1,
      displayMedium: AppTextStyles.headline2,
      displaySmall: AppTextStyles.headline3,
      headlineMedium: AppTextStyles.headline4,
      headlineSmall: AppTextStyles.headline5,
      titleLarge: AppTextStyles.headline6,
      titleMedium: AppTextStyles.labelLarge,
      titleSmall: AppTextStyles.labelMedium,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.labelLarge,
      labelMedium: AppTextStyles.labelMedium,
      labelSmall: AppTextStyles.labelSmall,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.darkCardBackground,
      deleteIconColor: AppColors.darkTextSecondary,
      disabledColor: AppColors.darkTextSecondary.withOpacity(0.5),
      selectedColor: AppColors.darkPrimary.withOpacity(0.1),
      secondarySelectedColor: AppColors.darkPrimary.withOpacity(0.05),
      shadowColor: AppColors.darkShadow,
      selectedShadowColor: AppColors.darkShadow,
      checkmarkColor: AppColors.darkPrimary,
      labelStyle: AppTextStyles.bodySmall,
      secondaryLabelStyle: AppTextStyles.bodySmall.copyWith(
        color: AppColors.darkPrimary,
      ),
      brightness: Brightness.dark,
      elevation: Spacing.smElevation,
      pressElevation: Spacing.mdElevation,
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.smH,
        vertical: Spacing.xs,
      ),
      labelPadding: EdgeInsets.symmetric(horizontal: Spacing.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Spacing.xlRadius),
      ),
      side: BorderSide(color: AppColors.darkBorder),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.darkBorder,
      thickness: 1,
      space: 1,
      indent: 0,
      endIndent: 0,
    ),
  ),
};
