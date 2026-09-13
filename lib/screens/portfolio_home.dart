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
import '../widgets/visual_effects.dart';

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
  final ValueNotifier<double> _scrollProgress = ValueNotifier(0);
  final ValueNotifier<double> _scrollOffset = ValueNotifier(0);
  final ValueNotifier<Offset> _pointer = ValueNotifier(Offset.zero);
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
    _scrollProgress.dispose();
    _scrollOffset.dispose();
    _pointer.dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    final max = position.maxScrollExtent;
    _scrollOffset.value = position.pixels;
    _scrollProgress.value = max <= 0 ? 0 : (position.pixels / max).clamp(0.0, 1.0);

    if (_isScrollingProgrammatically) return;

    int newActiveSection = 0;

    for (int i = _sectionKeys.length - 1; i >= 0; i--) {
      final key = _sectionKeys[i];
      final context = key.currentContext;

      if (context != null) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final pos = box.localToGlobal(Offset.zero);

        if (pos.dy <= 100) {
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
        duration: Motion.reduce(this.context)
            ? Duration.zero
            : const Duration(milliseconds: 850),
        curve: Curves.easeInOutCubic,
      ).then((_) {
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
    final reduce = Motion.reduce(context);
    final fine = Motion.isFinePointer(context);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: MouseRegion(
        onHover: fine && !reduce
            ? (event) => _pointer.value = event.position
            : null,
        onExit: fine ? (_) => _pointer.value = Offset.zero : null,
        child: Stack(
          children: [
            Positioned.fill(
              child: AmbientBackground(
                pointer: _pointer,
                scrollOffset: _scrollOffset,
                enabled: !reduce && !isMobile,
              ),
            ),
            SingleChildScrollView(
              controller: _scrollController,
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    key: _sectionKeys[0],
                    child: HeaderSection(
                      onContactTap: () => scrollToSection(6),
                      pointer: _pointer,
                      scrollOffset: _scrollOffset,
                    ),
                  ),
                  Container(key: _sectionKeys[1], child: const AboutSection()),
                  Container(
                    key: _sectionKeys[2],
                    child: const ExperienceSection(),
                  ),
                  Container(
                    key: _sectionKeys[3],
                    child: const EducationSection(),
                  ),
                  Container(key: _sectionKeys[4], child: const ProjectsSection()),
                  Container(key: _sectionKeys[5], child: const SkillsSection()),
                  Container(key: _sectionKeys[6], child: const ContactSection()),
                ],
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: ValueListenableBuilder<double>(
                  valueListenable: _scrollProgress,
                  builder: (context, p, _) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Color.lerp(
                              Colors.transparent,
                              const Color(0xFF061411),
                              (p * 1.2).clamp(0.0, 0.35),
                            )!,
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned.fill(
              child: CursorLight(pointer: _pointer, enabled: fine && !reduce),
            ),
            if (!isMobile)
              PortfolioNavigationBar(
                onSectionTap: scrollToSection,
                activeIndex: _activeSection,
                scrollOffset: _scrollOffset,
              ),
            if (isMobile)
              _MobileMenuButton(scrollOffset: _scrollOffset),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: ScrollProgressBar(progress: _scrollProgress),
              ),
            ),
          ],
        ),
      ),
      drawer: isMobile
          ? Drawer(
              backgroundColor: const Color(0xFF1A1A1A).withValues(alpha: 0.96),
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

class _MobileMenuButton extends StatelessWidget {
  final ValueNotifier<double> scrollOffset;

  const _MobileMenuButton({required this.scrollOffset});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: scrollOffset,
      builder: (context, offset, _) {
        final visible = offset > 80;
        return AnimatedPositioned(
          duration: Motion.normal,
          curve: Motion.curve,
          top: visible ? 16 : -60,
          right: 16,
          child: AnimatedOpacity(
            duration: Motion.normal,
            opacity: visible ? 1 : 0,
            child: Builder(
              builder: (context) => Material(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  onTap: () => Scaffold.of(context).openDrawer(),
                  borderRadius: BorderRadius.circular(14),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.menu, color: Colors.white, size: 22),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
