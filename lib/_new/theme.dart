import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4287581240),
      surfaceTint: Color(4287581240),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4294958033),
      onPrimaryContainer: Color(4281993985),
      secondary: Color(4286011214),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4294958033),
      onSecondaryContainer: Color(4281079055),
      tertiary: Color(4285291823),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4294304167),
      onTertiaryContainer: Color(4280490752),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      background: Color(4294965494),
      onBackground: Color(4280490263),
      surface: Color(4294965494),
      onSurface: Color(4280490263),
      surfaceVariant: Color(4294303448),
      onSurfaceVariant: Color(4283646783),
      outline: Color(4286935918),
      outlineVariant: Color(4292395708),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281937451),
      inverseOnSurface: Color(4294962664),
      inversePrimary: Color(4294948256),
      primaryFixed: Color(4294958033),
      onPrimaryFixed: Color(4281993985),
      primaryFixedDim: Color(4294948256),
      onPrimaryFixedVariant: Color(4285674787),
      secondaryFixed: Color(4294958033),
      onSecondaryFixed: Color(4281079055),
      secondaryFixedDim: Color(4293377458),
      onSecondaryFixedVariant: Color(4284301367),
      tertiaryFixed: Color(4294304167),
      onTertiaryFixed: Color(4280490752),
      tertiaryFixedDim: Color(4292396429),
      onTertiaryFixedVariant: Color(4283647513),
      surfaceDim: Color(4293449426),
      surfaceBright: Color(4294965494),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294963693),
      surfaceContainer: Color(4294765285),
      surfaceContainerHigh: Color(4294436064),
      surfaceContainerHighest: Color(4294041562),
    );
  }

  ThemeData light() {
    return theme(lightScheme().toColorScheme());
  }

  static MaterialScheme lightMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4285346079),
      surfaceTint: Color(4287581240),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4289356108),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4284038196),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4287589731),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4283318806),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4286805058),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      background: Color(4294965494),
      onBackground: Color(4280490263),
      surface: Color(4294965494),
      onSurface: Color(4280490263),
      surfaceVariant: Color(4294303448),
      onSurfaceVariant: Color(4283383611),
      outline: Color(4285291351),
      outlineVariant: Color(4287199090),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281937451),
      inverseOnSurface: Color(4294962664),
      inversePrimary: Color(4294948256),
      primaryFixed: Color(4289356108),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4287383862),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4287589731),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4285813835),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4286805058),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4285094700),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4293449426),
      surfaceBright: Color(4294965494),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294963693),
      surfaceContainer: Color(4294765285),
      surfaceContainerHigh: Color(4294436064),
      surfaceContainerHighest: Color(4294041562),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme lightHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4282585348),
      surfaceTint: Color(4287581240),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4285346079),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4281605141),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4284038196),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4281016576),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4283318806),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      background: Color(4294965494),
      onBackground: Color(4280490263),
      surface: Color(4294965494),
      onSurface: Color(4278190080),
      surfaceVariant: Color(4294303448),
      onSurfaceVariant: Color(4281213213),
      outline: Color(4283383611),
      outlineVariant: Color(4283383611),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281937451),
      inverseOnSurface: Color(4294967295),
      inversePrimary: Color(4294961121),
      primaryFixed: Color(4285346079),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4283505676),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4284038196),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4282394143),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4283318806),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4281805826),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4293449426),
      surfaceBright: Color(4294965494),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294963693),
      surfaceContainer: Color(4294765285),
      surfaceContainerHigh: Color(4294436064),
      surfaceContainerHighest: Color(4294041562),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme().toColorScheme());
  }

  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4294948256),
      surfaceTint: Color(4294948256),
      onPrimary: Color(4283834127),
      primaryContainer: Color(4285674787),
      onPrimaryContainer: Color(4294958033),
      secondary: Color(4293377458),
      onSecondary: Color(4282657314),
      secondaryContainer: Color(4284301367),
      onSecondaryContainer: Color(4294958033),
      tertiary: Color(4292396429),
      onTertiary: Color(4282068741),
      tertiaryContainer: Color(4283647513),
      onTertiaryContainer: Color(4294304167),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      background: Color(4279898383),
      onBackground: Color(4294041562),
      surface: Color(4279898383),
      onSurface: Color(4294041562),
      surfaceVariant: Color(4283646783),
      onSurfaceVariant: Color(4292395708),
      outline: Color(4288711815),
      outlineVariant: Color(4283646783),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4294041562),
      inverseOnSurface: Color(4281937451),
      inversePrimary: Color(4287581240),
      primaryFixed: Color(4294958033),
      onPrimaryFixed: Color(4281993985),
      primaryFixedDim: Color(4294948256),
      onPrimaryFixedVariant: Color(4285674787),
      secondaryFixed: Color(4294958033),
      onSecondaryFixed: Color(4281079055),
      secondaryFixedDim: Color(4293377458),
      onSecondaryFixedVariant: Color(4284301367),
      tertiaryFixed: Color(4294304167),
      onTertiaryFixed: Color(4280490752),
      tertiaryFixedDim: Color(4292396429),
      onTertiaryFixedVariant: Color(4283647513),
      surfaceDim: Color(4279898383),
      surfaceBright: Color(4282529588),
      surfaceContainerLowest: Color(4279503882),
      surfaceContainerLow: Color(4280490263),
      surfaceContainer: Color(4280753435),
      surfaceContainerHigh: Color(4281477157),
      surfaceContainerHighest: Color(4282200623),
    );
  }

  ThemeData dark() {
    return theme(darkScheme().toColorScheme());
  }

  static MaterialScheme darkMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4294949799),
      surfaceTint: Color(4294948256),
      onPrimary: Color(4281403136),
      primaryContainer: Color(4291525733),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4293706166),
      onSecondary: Color(4280684554),
      secondaryContainer: Color(4289628286),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4292725393),
      onTertiary: Color(4280096256),
      tertiaryContainer: Color(4288712796),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      background: Color(4279898383),
      onBackground: Color(4294041562),
      surface: Color(4279898383),
      onSurface: Color(4294965752),
      surfaceVariant: Color(4283646783),
      onSurfaceVariant: Color(4292658880),
      outline: Color(4289961625),
      outlineVariant: Color(4287790970),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4294041562),
      inverseOnSurface: Color(4281477157),
      inversePrimary: Color(4285806116),
      primaryFixed: Color(4294958033),
      onPrimaryFixed: Color(4280812800),
      primaryFixedDim: Color(4294948256),
      onPrimaryFixedVariant: Color(4284294420),
      secondaryFixed: Color(4294958033),
      onSecondaryFixed: Color(4280290054),
      secondaryFixedDim: Color(4293377458),
      onSecondaryFixedVariant: Color(4283117352),
      tertiaryFixed: Color(4294304167),
      onTertiaryFixed: Color(4279701760),
      tertiaryFixedDim: Color(4292396429),
      onTertiaryFixedVariant: Color(4282463498),
      surfaceDim: Color(4279898383),
      surfaceBright: Color(4282529588),
      surfaceContainerLowest: Color(4279503882),
      surfaceContainerLow: Color(4280490263),
      surfaceContainer: Color(4280753435),
      surfaceContainerHigh: Color(4281477157),
      surfaceContainerHighest: Color(4282200623),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme darkHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4294965752),
      surfaceTint: Color(4294948256),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4294949799),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294965752),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4293706166),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294966006),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4292725393),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      background: Color(4279898383),
      onBackground: Color(4294041562),
      surface: Color(4279898383),
      onSurface: Color(4294967295),
      surfaceVariant: Color(4283646783),
      onSurfaceVariant: Color(4294965752),
      outline: Color(4292658880),
      outlineVariant: Color(4292658880),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4294041562),
      inverseOnSurface: Color(4278190080),
      inversePrimary: Color(4283242761),
      primaryFixed: Color(4294959320),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4294949799),
      onPrimaryFixedVariant: Color(4281403136),
      secondaryFixed: Color(4294959320),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4293706166),
      onSecondaryFixedVariant: Color(4280684554),
      tertiaryFixed: Color(4294633131),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4292725393),
      onTertiaryFixedVariant: Color(4280096256),
      surfaceDim: Color(4279898383),
      surfaceBright: Color(4282529588),
      surfaceContainerLowest: Color(4279503882),
      surfaceContainerLow: Color(4280490263),
      surfaceContainer: Color(4280753435),
      surfaceContainerHigh: Color(4281477157),
      surfaceContainerHighest: Color(4282200623),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme().toColorScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.background,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class MaterialScheme {
  const MaterialScheme({
    required this.brightness,
    required this.primary, 
    required this.surfaceTint, 
    required this.onPrimary, 
    required this.primaryContainer, 
    required this.onPrimaryContainer, 
    required this.secondary, 
    required this.onSecondary, 
    required this.secondaryContainer, 
    required this.onSecondaryContainer, 
    required this.tertiary, 
    required this.onTertiary, 
    required this.tertiaryContainer, 
    required this.onTertiaryContainer, 
    required this.error, 
    required this.onError, 
    required this.errorContainer, 
    required this.onErrorContainer, 
    required this.background, 
    required this.onBackground, 
    required this.surface, 
    required this.onSurface, 
    required this.surfaceVariant, 
    required this.onSurfaceVariant, 
    required this.outline, 
    required this.outlineVariant, 
    required this.shadow, 
    required this.scrim, 
    required this.inverseSurface, 
    required this.inverseOnSurface, 
    required this.inversePrimary, 
    required this.primaryFixed, 
    required this.onPrimaryFixed, 
    required this.primaryFixedDim, 
    required this.onPrimaryFixedVariant, 
    required this.secondaryFixed, 
    required this.onSecondaryFixed, 
    required this.secondaryFixedDim, 
    required this.onSecondaryFixedVariant, 
    required this.tertiaryFixed, 
    required this.onTertiaryFixed, 
    required this.tertiaryFixedDim, 
    required this.onTertiaryFixedVariant, 
    required this.surfaceDim, 
    required this.surfaceBright, 
    required this.surfaceContainerLowest, 
    required this.surfaceContainerLow, 
    required this.surfaceContainer, 
    required this.surfaceContainerHigh, 
    required this.surfaceContainerHighest, 
  });

  final Brightness brightness;
  final Color primary;
  final Color surfaceTint;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color inversePrimary;
  final Color primaryFixed;
  final Color onPrimaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color onSecondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color onTertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixedVariant;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
}

extension MaterialSchemeUtils on MaterialScheme {
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      background: background,
      onBackground: onBackground,
      surface: surface,
      onSurface: onSurface,
      surfaceVariant: surfaceVariant,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: shadow,
      scrim: scrim,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
    );
  }
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
