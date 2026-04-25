import 'package:flutter/material.dart';

class BackgroundPalette {
  final Color primaryNeon;
  final Color secondaryNeon;

  BackgroundPalette({
    required this.primaryNeon,
    required this.secondaryNeon,
  });

  static List<BackgroundPalette> get presets => [
    BackgroundPalette(primaryNeon: const Color(0xFF00FFFF), secondaryNeon: const Color(0xFF8A2BE2)), // Cyan/Violet
    BackgroundPalette(primaryNeon: const Color(0xFFFF4500), secondaryNeon: const Color(0xFFFF0000)), // Orange/Red
    BackgroundPalette(primaryNeon: const Color(0xFF32CD32), secondaryNeon: const Color(0xFF1E90FF)), // Lime/Electric Blue
    BackgroundPalette(primaryNeon: const Color(0xFFFF1493), secondaryNeon: const Color(0xFFFFD700)), // Pink/Gold
    BackgroundPalette(primaryNeon: const Color(0xFF9400D3), secondaryNeon: const Color(0xFF00CED1)), // Purple/Teal
    BackgroundPalette(primaryNeon: const Color(0xFF00008B), secondaryNeon: const Color(0xFFFF00FF)), // Deep Blue/Magenta
    BackgroundPalette(primaryNeon: const Color(0xFFADFF2F), secondaryNeon: const Color(0xFF008000)), // Green/Yellow
    BackgroundPalette(primaryNeon: const Color(0xFFFF7F50), secondaryNeon: const Color(0xFF000080)), // Coral/Navy
    BackgroundPalette(primaryNeon: const Color(0xFFE6E6FA), secondaryNeon: const Color(0xFF3EB489)), // Lavender/Mint
    BackgroundPalette(primaryNeon: const Color(0xFFDC143C), secondaryNeon: const Color(0xFF4B0082)), // Crimson/Indigo
    BackgroundPalette(primaryNeon: const Color(0xFF00FF7F), secondaryNeon: const Color(0xFF4169E1)), // SpringGreen/RoyalBlue
    BackgroundPalette(primaryNeon: const Color(0xFFFF8C00), secondaryNeon: const Color(0xFF8B0000)), // DarkOrange/DarkRed
    BackgroundPalette(primaryNeon: const Color(0xFF40E0D0), secondaryNeon: const Color(0xFFEE82EE)), // Turquoise/Violet
    BackgroundPalette(primaryNeon: const Color(0xFF00BFFF), secondaryNeon: const Color(0xFFFFDAB9)), // DeepSkyBlue/Peach
    BackgroundPalette(primaryNeon: const Color(0xFF7B68EE), secondaryNeon: const Color(0xFF48D1CC)), // MediumSlateBlue/MediumTurquoise
    BackgroundPalette(primaryNeon: const Color(0xFFFF69B4), secondaryNeon: const Color(0xFF87CEEB)), // HotPink/SkyBlue
    BackgroundPalette(primaryNeon: const Color(0xFF00FA9A), secondaryNeon: const Color(0xFFBA55D3)), // MediumSpringGreen/MediumOrchid
    BackgroundPalette(primaryNeon: const Color(0xFFF4A460), secondaryNeon: const Color(0xFF2F4F4F)), // SandyBrown/DarkSlateGray
    BackgroundPalette(primaryNeon: const Color(0xFFC71585), secondaryNeon: const Color(0xFF00FF00)), // MediumVioletRed/Lime
    BackgroundPalette(primaryNeon: const Color(0xFF191970), secondaryNeon: const Color(0xFFFF6347)), // MidnightBlue/Tomato
  ];
}
