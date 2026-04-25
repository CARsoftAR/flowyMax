import 'dart:ui';
import 'package:flutter/material.dart';

class FloatingNavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const FloatingNavbar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      height: 60, // Slightly more compact
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NavbarItem(
                  icon: Icons.home_rounded,
                  isSelected: selectedIndex == 0,
                  onTap: () => onTap(0),
                ),
                _NavbarItem(
                  icon: Icons.search_rounded,
                  isSelected: selectedIndex == 1,
                  onTap: () => onTap(1),
                ),
                _NavbarItem(
                  icon: Icons.library_music_rounded,
                  isSelected: selectedIndex == 2,
                  onTap: () => onTap(2),
                ),
                _NavbarItem(
                  icon: Icons.bar_chart_rounded,
                  isSelected: selectedIndex == 3,
                  onTap: () => onTap(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavbarItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavbarItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? const Color(0xFFFF4D00) : Colors.white.withOpacity(0.5);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
            shadows: isSelected ? [
              Shadow(
                color: const Color(0xFFFF4D00).withOpacity(0.5),
                blurRadius: 15,
              ),
            ] : null,
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 4,
              width: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFFF4D00),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF4D00).withOpacity(0.8),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
