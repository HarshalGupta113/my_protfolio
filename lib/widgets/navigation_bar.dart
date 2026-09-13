import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'visual_effects.dart';

final ValueNotifier<double> _zeroScroll = ValueNotifier(0);

class PortfolioNavigationBar extends StatelessWidget {
  final Function(int) onSectionTap;
  final bool isMobileDrawer;
  final int activeIndex;
  final ValueNotifier<double>? scrollOffset;

  const PortfolioNavigationBar({
    super.key,
    required this.onSectionTap,
    this.isMobileDrawer = false,
    this.activeIndex = 0,
    this.scrollOffset,
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
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 280 + entry.key * 50),
              curve: Motion.curve,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(16 * (1 - value), 0),
                    child: child,
                  ),
                );
              },
              child: _DrawerTile(
                label: entry.value,
                isActive: isActive,
                onTap: () => onSectionTap(entry.key),
              ),
            );
          }),
        ],
      );
    }

    return AnimatedPositioned(
      duration: Motion.normal,
      curve: Motion.curve,
      top: 0,
      right: 0,
      left: 0,
      child: ValueListenableBuilder<double>(
        valueListenable: scrollOffset ?? _zeroScroll,
        builder: (context, offset, _) {
          final t = (offset / 140).clamp(0.0, 1.0);
          final compact = t > 0.35;
          return ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 4 + 14 * t,
                sigmaY: 4 + 14 * t,
              ),
              child: AnimatedContainer(
                duration: Motion.normal,
                curve: Motion.curve,
                padding: EdgeInsets.symmetric(
                  horizontal: 20 + 12 * t,
                  vertical: compact ? 8 : 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.12 + 0.5 * t),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withValues(alpha: 0.04 + 0.12 * t),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: sections.asMap().entries.map((entry) {
                    final isActive = entry.key == activeIndex;
                    return _NavItem(
                      label: entry.value,
                      isActive: isActive,
                      isMobile: ResponsiveBreakpoints.of(context).isMobile,
                      compact: compact,
                      onTap: () => onSectionTap(entry.key),
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DrawerTile extends StatefulWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _DrawerTile({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_DrawerTile> createState() => _DrawerTileState();
}

class _DrawerTileState extends State<_DrawerTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: ListTile(
        title: Text(
          widget.label,
          style: GoogleFonts.poppins(
            color: widget.isActive || _hover ? Colors.white : Colors.white70,
            fontSize: 16,
            fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        leading: AnimatedContainer(
          duration: Motion.fast,
          width: 4,
          height: widget.isActive ? 18 : 4,
          decoration: BoxDecoration(
            color: widget.isActive
                ? AppColors.accent
                : (_hover ? AppColors.accent.withValues(alpha: 0.5) : Colors.transparent),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        onTap: widget.onTap,
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String label;
  final bool isActive;
  final bool isMobile;
  final bool compact;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.isActive,
    required this.isMobile,
    required this.onTap,
    this.compact = false,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final highlighted = widget.isActive || _hover;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: widget.isActive
                ? EdgeInsets.symmetric(
                    horizontal: widget.compact ? 10 : 12,
                    vertical: widget.compact ? 4 : 6,
                  )
                : EdgeInsets.symmetric(
                    horizontal: widget.compact ? 6 : 8,
                    vertical: widget.compact ? 4 : 6,
                  ),
            decoration: BoxDecoration(
              color: widget.isActive
                  ? const Color(0xFF64FFDA)
                  : (_hover
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.transparent),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                color: widget.isActive
                    ? Colors.black
                    : (highlighted ? Colors.white : Colors.white70),
                fontSize: widget.isMobile ? 12.0 : 14.0,
                fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
