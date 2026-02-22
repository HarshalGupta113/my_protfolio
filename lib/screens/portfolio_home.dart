import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../widgets/header_section.dart';
import '../widgets/about_section.dart';
import '../widgets/experience_section.dart';
import '../widgets/education_section.dart';
import '../widgets/projects_section.dart';
import '../widgets/skills_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/navigation_bar.dart';

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = [
    GlobalKey(), // Header
    GlobalKey(), // About
    GlobalKey(), // Experience
    GlobalKey(), // Education
    GlobalKey(), // Projects
    GlobalKey(), // Skills
    GlobalKey(), // Contact
  ];
  int _activeSection = 0;
  bool _isScrollingProgrammatically = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isScrollingProgrammatically) return;

    // Get the current scroll position
    final scrollPosition = _scrollController.position.pixels;

    // Find which section is currently visible
    int newActiveSection = 0;

    for (int i = _sectionKeys.length - 1; i >= 0; i--) {
      final key = _sectionKeys[i];
      final context = key.currentContext;

      if (context != null) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero);

        // If the section is at or above the top of the screen (with some offset)
        if (position.dy <= 100) {
          newActiveSection = i;
          break;
        }
      }
    }

    if (newActiveSection != _activeSection) {
      setState(() {
        _activeSection = newActiveSection;
      });
    }
  }

  void scrollToSection(int index) {
    _isScrollingProgrammatically = true;
    setState(() {
      _activeSection = index;
    });
    final context = _sectionKeys[index].currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      ).then((_) {
        // Reset the flag after scrolling is complete
        Future.delayed(const Duration(milliseconds: 100), () {
          _isScrollingProgrammatically = false;
        });
      });
    } else {
      _isScrollingProgrammatically = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Header Section
                Container(
                  key: _sectionKeys[0],
                  child: HeaderSection(onContactTap: () => scrollToSection(6)),
                ),

                // About Section
                Container(key: _sectionKeys[1], child: const AboutSection()),

                // Experience Section
                Container(
                  key: _sectionKeys[2],
                  child: const ExperienceSection(),
                ),

                // Education Section
                Container(
                  key: _sectionKeys[3],
                  child: const EducationSection(),
                ),

                // Projects Section
                Container(key: _sectionKeys[4], child: const ProjectsSection()),

                // Skills Section
                Container(key: _sectionKeys[5], child: const SkillsSection()),

                // Contact Section
                Container(key: _sectionKeys[6], child: const ContactSection()),
              ],
            ),
          ),

          // Navigation Bar
          if (!isMobile)
            PortfolioNavigationBar(
              onSectionTap: scrollToSection,
              activeIndex: _activeSection,
            ),
        ],
      ),
      // Mobile drawer
      drawer: isMobile
          ? Drawer(
              backgroundColor: const Color(0xFF1A1A1A),
              child: PortfolioNavigationBar(
                onSectionTap: (index) {
                  Navigator.pop(context);
                  scrollToSection(index);
                },
                isMobileDrawer: true,
                activeIndex: _activeSection,
              ),
            )
          : null,
    );
  }
}
