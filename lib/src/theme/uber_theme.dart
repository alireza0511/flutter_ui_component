import 'package:flutter/material.dart';

class UberColorTokens {
  static const Color primary900 = Color(0xFF000000);
  static const Color primary800 = Color(0xFF142333);
  static const Color primary700 = Color(0xFF1A1A1A);
  static const Color primary600 = Color(0xFF333333);
  static const Color primary500 = Color(0xFF545454);
  static const Color primary400 = Color(0xFF767676);
  static const Color primary300 = Color(0xFF999999);
  static const Color primary200 = Color(0xFFBDBDBD);
  static const Color primary100 = Color(0xFFE0E0E0);
  static const Color primary50 = Color(0xFFF5F5F5);

  static const Color green900 = Color(0xFF0E7722);
  static const Color green800 = Color(0xFF10A635);
  static const Color green700 = Color(0xFF06D742);
  static const Color green600 = Color(0xFF41E976);
  static const Color green500 = Color(0xFF7EEAA0);
  static const Color green400 = Color(0xFFA6F5C1);
  static const Color green300 = Color(0xFFC7F9D6);
  static const Color green200 = Color(0xFFE3FCEB);
  static const Color green100 = Color(0xFFF4FDF7);

  static const Color blue900 = Color(0xFF042C5C);
  static const Color blue800 = Color(0xFF053F7F);
  static const Color blue700 = Color(0xFF0653A2);
  static const Color blue600 = Color(0xFF276EF1);
  static const Color blue500 = Color(0xFF5B91F5);
  static const Color blue400 = Color(0xFF7FABF2);
  static const Color blue300 = Color(0xFFA7C7F5);
  static const Color blue200 = Color(0xFFCEE2FA);
  static const Color blue100 = Color(0xFFECF4FD);

  static const Color red900 = Color(0xFF7F1D1D);
  static const Color red800 = Color(0xFF991B1B);
  static const Color red700 = Color(0xFFDC2626);
  static const Color red600 = Color(0xFFEF4444);
  static const Color red500 = Color(0xFFF87171);
  static const Color red400 = Color(0xFFFCA5A5);
  static const Color red300 = Color(0xFFFDCBCB);
  static const Color red200 = Color(0xFFFEE2E2);
  static const Color red100 = Color(0xFFFEF2F2);

  static const Color yellow900 = Color(0xFF92400E);
  static const Color yellow800 = Color(0xFFB45309);
  static const Color yellow700 = Color(0xFFD97706);
  static const Color yellow600 = Color(0xFFF59E0B);
  static const Color yellow500 = Color(0xFFFBBF24);
  static const Color yellow400 = Color(0xFFFCE96A);
  static const Color yellow300 = Color(0xFFFEF3C7);
  static const Color yellow200 = Color(0xFFFEF7E0);
  static const Color yellow100 = Color(0xFFFFFBEB);

  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF000000);
  static const Color outline = Color(0xFFE0E0E0);
}

class UberTypography {
  static const TextStyle displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    height: 1.12,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.16,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.22,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.25,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.29,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.33,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.27,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.50,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.50,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.33,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.45,
  );
}

class UberTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: UberColorTokens.primary900,
      primaryContainer: UberColorTokens.primary100,
      secondary: UberColorTokens.blue700,
      secondaryContainer: UberColorTokens.blue100,
      tertiary: UberColorTokens.green700,
      tertiaryContainer: UberColorTokens.green100,
      surface: UberColorTokens.surface,
      surfaceContainerHighest: UberColorTokens.primary50,
      background: UberColorTokens.background,
      error: UberColorTokens.red600,
      errorContainer: UberColorTokens.red100,
      onPrimary: UberColorTokens.onPrimary,
      onSecondary: UberColorTokens.white,
      onTertiary: UberColorTokens.white,
      onSurface: UberColorTokens.onSurface,
      onBackground: UberColorTokens.primary900,
      onError: UberColorTokens.white,
      outline: UberColorTokens.outline,
      outlineVariant: UberColorTokens.primary200,
    ),
    textTheme: const TextTheme(
      displayLarge: UberTypography.displayLarge,
      displayMedium: UberTypography.displayMedium,
      displaySmall: UberTypography.displaySmall,
      headlineLarge: UberTypography.headlineLarge,
      headlineMedium: UberTypography.headlineMedium,
      headlineSmall: UberTypography.headlineSmall,
      titleLarge: UberTypography.titleLarge,
      titleMedium: UberTypography.titleMedium,
      titleSmall: UberTypography.titleSmall,
      bodyLarge: UberTypography.bodyLarge,
      bodyMedium: UberTypography.bodyMedium,
      bodySmall: UberTypography.bodySmall,
      labelLarge: UberTypography.labelLarge,
      labelMedium: UberTypography.labelMedium,
      labelSmall: UberTypography.labelSmall,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: UberTypography.labelLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: UberTypography.labelLarge,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: UberColorTokens.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: UberColorTokens.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: UberColorTokens.blue700, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: UberColorTokens.red600),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: UberColorTokens.red600, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: UberTypography.bodyMedium,
      hintStyle: UberTypography.bodyMedium.copyWith(color: UberColorTokens.primary400),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return UberColorTokens.blue700;
        }
        return UberColorTokens.outline;
      }),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: UberColorTokens.white,
      primaryContainer: UberColorTokens.primary800,
      secondary: UberColorTokens.blue400,
      secondaryContainer: UberColorTokens.blue900,
      tertiary: UberColorTokens.green400,
      tertiaryContainer: UberColorTokens.green900,
      surface: UberColorTokens.primary900,
      surfaceContainerHighest: UberColorTokens.primary800,
      background: UberColorTokens.primary900,
      error: UberColorTokens.red400,
      errorContainer: UberColorTokens.red900,
      onPrimary: UberColorTokens.primary900,
      onSecondary: UberColorTokens.primary900,
      onTertiary: UberColorTokens.primary900,
      onSurface: UberColorTokens.white,
      onBackground: UberColorTokens.white,
      onError: UberColorTokens.primary900,
      outline: UberColorTokens.primary600,
      outlineVariant: UberColorTokens.primary700,
    ),
    textTheme: const TextTheme(
      displayLarge: UberTypography.displayLarge,
      displayMedium: UberTypography.displayMedium,
      displaySmall: UberTypography.displaySmall,
      headlineLarge: UberTypography.headlineLarge,
      headlineMedium: UberTypography.headlineMedium,
      headlineSmall: UberTypography.headlineSmall,
      titleLarge: UberTypography.titleLarge,
      titleMedium: UberTypography.titleMedium,
      titleSmall: UberTypography.titleSmall,
      bodyLarge: UberTypography.bodyLarge,
      bodyMedium: UberTypography.bodyMedium,
      bodySmall: UberTypography.bodySmall,
      labelLarge: UberTypography.labelLarge,
      labelMedium: UberTypography.labelMedium,
      labelSmall: UberTypography.labelSmall,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: UberTypography.labelLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: UberTypography.labelLarge,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: UberColorTokens.primary600),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: UberColorTokens.primary600),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: UberColorTokens.blue400, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: UberColorTokens.red400),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: UberColorTokens.red400, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: UberTypography.bodyMedium,
      hintStyle: UberTypography.bodyMedium.copyWith(color: UberColorTokens.primary400),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return UberColorTokens.blue400;
        }
        return UberColorTokens.primary600;
      }),
    ),
  );
}