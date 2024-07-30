import 'package:flutter/material.dart';

Color primaryColor = const Color(0xFFE2E4D9); // 003A9B
Color secondary = const Color(0xFFFFF6E9);
Color deepPrimary = const Color(0xFF4B5011);
Color boxColor = const Color(0xFF455A64);

Color darkPrimary = const Color(0xFF422D20);
Color backgroundDark = const Color(0xff231F20);
Color backgroundLight = const Color(0xffffffff);

const Color textPrimary = Color(0xff292D32);
const Color textSecondary = Color(0xff6B6B6B);
Map<int, Color> color = const {
  50: Color.fromRGBO(255, 244, 149, .1),
  100: Color.fromRGBO(255, 244, 149, .2),
  200: Color.fromRGBO(255, 244, 149, .3),
  300: Color.fromRGBO(255, 244, 149, .4),
  400: Color.fromRGBO(255, 244, 149, .5),
  500: Color.fromRGBO(255, 244, 149, .6),
  600: Color.fromRGBO(255, 244, 149, .7),
  700: Color.fromRGBO(255, 244, 149, .8),
  800: Color.fromRGBO(255, 244, 149, .9),
  900: Color.fromRGBO(255, 244, 149, 1),
};
MaterialColor colorCustom = MaterialColor(0XFFFFF495, color);

class CustomTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    fontFamily: "Segoeui",
    scaffoldBackgroundColor: backgroundLight,
    hintColor: Colors.grey[200],
    primarySwatch: colorCustom,
    canvasColor: primaryColor,
    primaryColorLight: primaryColor,
    splashColor: primaryColor,
    shadowColor: Colors.grey[600],
    cardColor: const Color(0xFFFFFFFF),
    primaryColor: deepPrimary,
    dividerColor: const Color(0xFF2A2A2A),
    primaryColorDark: Colors.black,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: deepPrimary,
      onPrimary: deepPrimary,
      secondary: primaryColor,
      onSecondary: primaryColor,
      error: const Color(0xFFCF6679),
      onError: const Color(0xFFCF6679),
      background: backgroundLight,
      onBackground: backgroundLight,
      surface: backgroundDark,
      onSurface: backgroundDark,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      actionsIconTheme: IconThemeData(
        color: deepPrimary,
      ),
      iconTheme: IconThemeData(
        color: deepPrimary,
      ),
      // systemOverlayStyle: const SystemUiOverlayStyle(
      //   // Status bar color
      //   statusBarColor: Colors.white,
      //   // Status bar brightness (optional)
      //   statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
      //   statusBarBrightness: Brightness.light, // For iOS (dark icons)
      // ),
    ),
    typography: Typography.material2021(),
    // textTheme: TextTheme(
    //   labelLarge: GoogleFonts.montserrat(
    //     fontWeight: FontWeight.w400,
    //     color: textSecondary,
    //     fontSize: 14.0,
    //   ),
    //   displayLarge: GoogleFonts.openSans(fontWeight: FontWeight.w400),
    //   displayMedium: GoogleFonts.openSans(fontWeight: FontWeight.w400),
    //   displaySmall: GoogleFonts.openSans(fontWeight: FontWeight.w400),
    //   titleLarge: GoogleFonts.openSans(fontWeight: FontWeight.w400),
    //   titleMedium: GoogleFonts.openSans(fontWeight: FontWeight.w400),
    //   titleSmall: GoogleFonts.openSans(fontWeight: FontWeight.w400),
    //   bodyLarge: GoogleFonts.openSans(fontWeight: FontWeight.w400),
    //   bodyMedium: GoogleFonts.openSans(fontWeight: FontWeight.w400),
    //   bodySmall: GoogleFonts.openSans(fontWeight: FontWeight.w400),
    // ),
  );
}
