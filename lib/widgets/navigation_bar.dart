import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PortfolioNavigationBar extends StatelessWidget {
  final Function(int) onSectionTap;
  final bool isMobileDrawer;

  const PortfolioNavigationBar({
    super.key,
    required this.onSectionTap,
    this.isMobileDrawer = false,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> sections = [
      'Home',
      'About',
      'Experience',
      'Education',
      'Projects',
      'Skills',
      'Contact',
    ];

    if (isMobileDrawer) {
      return ListView(
        padding: const EdgeInsets.only(top: 60),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Menu',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...sections.asMap().entries.map((entry) {
            return ListTile(
              title: Text(
                entry.value,
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 16),
              ),
              onTap: () => onSectionTap(entry.key),
            );
          }).toList(),
        ],
      );
    }

    return Positioned(
      top: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: sections.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: GestureDetector(
                onTap: () => onSectionTap(entry.key),
                child: Text(
                  entry.value,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: ResponsiveBreakpoints.of(context).isMobile
                        ? 12.0
                        : 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
