import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PortfolioNavigationBar extends StatelessWidget {
  final Function(int) onSectionTap;
  final bool isMobileDrawer;
  final int activeIndex;

  const PortfolioNavigationBar({
    super.key,
    required this.onSectionTap,
    this.isMobileDrawer = false,
    this.activeIndex = 0,
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
            final isActive = entry.key == activeIndex;
            return ListTile(
              title: Text(
                entry.value,
                style: GoogleFonts.poppins(
                  color: isActive ? Colors.white : Colors.white70,
                  fontSize: 16,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              leading: isActive
                  ? Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
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
          mainAxisSize: MainAxisSize.max,
          children: sections.asMap().entries.map((entry) {
            final isActive = entry.key == activeIndex;
            return GestureDetector(
              onTap: () => onSectionTap(entry.key),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: isActive
                          ? EdgeInsets.symmetric(horizontal: 12, vertical: 6)
                          : null,
                      decoration: BoxDecoration(
                        color: isActive
                            ? Color(0xFF64FFDA)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        entry.value,
                        style: TextStyle(
                          color: isActive ? Colors.black : Colors.white70,
                          fontSize: ResponsiveBreakpoints.of(context).isMobile
                              ? 12.0
                              : 14.0,
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                    // if (isActive)
                    //   Container(
                    //     margin: const EdgeInsets.only(top: 4),
                    //     height: 2,
                    //     width: 40,
                    //     constraints: const BoxConstraints(),
                    //     decoration: BoxDecoration(
                    //       color: Colors.blueAccent,
                    //       borderRadius: BorderRadius.circular(2),
                    //     ),
                    //   ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
