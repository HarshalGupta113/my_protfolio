import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const bg = Color(0xFF0A0A0A);
  static const bgAlt = Color(0xFF111111);
  static const card = Color(0xFF1A1A1A);
  static const accent = Color(0xFF64FFDA);
}

class Motion {
  static const fast = Duration(milliseconds: 180);
  static const normal = Duration(milliseconds: 280);
  static const reveal = Duration(milliseconds: 700);
  static const hero = Duration(milliseconds: 900);
  static const curve = Curves.easeOutCubic;

  static bool reduce(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context);

  static bool isFinePointer(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return kIsWeb && width > 800;
  }
}

enum RevealStyle { fadeUp, fadeLeft, fadeRight, scale, blurUp, clipUp }

class ScrollReveal extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final double dy;
  final int staggerIndex;
  final RevealStyle style;

  const ScrollReveal({
    super.key,
    required this.child,
    this.duration = Motion.reveal,
    this.delay = Duration.zero,
    this.dy = 28,
    this.staggerIndex = 0,
    this.style = RevealStyle.fadeUp,
  });

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _t;
  ScrollPosition? _position;
  bool _started = false;
  int _retries = 0;

  Duration get _totalDelay =>
      widget.delay + Duration(milliseconds: 80 * widget.staggerIndex);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _t = CurvedAnimation(parent: _controller, curve: Motion.curve);
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final position = Scrollable.maybeOf(context)?.position;
    if (position != _position) {
      _position?.removeListener(_check);
      _position = position;
      _position?.addListener(_check);
    }
  }

  void _check() {
    if (!mounted || _started) return;
    if (Motion.reduce(context)) {
      _started = true;
      _controller.value = 1;
      return;
    }
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize) {
      if (_retries++ < 12) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _check());
      }
      return;
    }
    final offset = box.localToGlobal(Offset.zero);
    final viewHeight = MediaQuery.sizeOf(context).height;
    if (offset.dy < viewHeight * 0.9) {
      _started = true;
      Future.delayed(_totalDelay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _position?.removeListener(_check);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _t,
      builder: (context, child) {
        final t = _t.value;
        final mobile = MediaQuery.sizeOf(context).width <= 800;
        final childWidget = child!;
        return switch (widget.style) {
          RevealStyle.fadeLeft => Transform.translate(
              offset: Offset(-36 * (1 - t), 0),
              child: Opacity(opacity: t, child: childWidget),
            ),
          RevealStyle.fadeRight => Transform.translate(
              offset: Offset(36 * (1 - t), 0),
              child: Opacity(opacity: t, child: childWidget),
            ),
          RevealStyle.scale => Opacity(
              opacity: t,
              child: Transform.scale(
                scale: 0.92 + 0.08 * t,
                alignment: Alignment.centerLeft,
                child: childWidget,
              ),
            ),
          RevealStyle.blurUp => Transform.translate(
              offset: Offset(0, 40 * (1 - t)),
              child: Opacity(
                opacity: t,
                child: mobile || t >= 0.99
                    ? childWidget
                    : ImageFiltered(
                        imageFilter: ImageFilter.blur(
                          sigmaX: 8 * (1 - t),
                          sigmaY: 8 * (1 - t),
                        ),
                        child: childWidget,
                      ),
              ),
            ),
          RevealStyle.clipUp => ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: t.clamp(0.0, 1.0),
                child: Opacity(
                  opacity: t,
                  child: Transform.translate(
                    offset: Offset(0, 24 * (1 - t)),
                    child: childWidget,
                  ),
                ),
              ),
            ),
          RevealStyle.fadeUp => Opacity(
              opacity: t,
              child: Transform.translate(
                offset: Offset(0, widget.dy * (1 - t)),
                child: childWidget,
              ),
            ),
        };
      },
      child: widget.child,
    );
  }
}

class HoverCard extends StatefulWidget {
  final Widget child;
  final BorderRadius borderRadius;
  final EdgeInsets? padding;
  final Color? color;

  const HoverCard({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(15)),
    this.padding,
    this.color,
  });

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final reduce = Motion.reduce(context);
    final fine = Motion.isFinePointer(context);
    return MouseRegion(
      onEnter: fine && !reduce ? (_) => setState(() => _hover = true) : null,
      onExit: fine && !reduce ? (_) => setState(() => _hover = false) : null,
      child: AnimatedScale(
        scale: _hover ? 1.012 : 1,
        duration: reduce ? Duration.zero : Motion.normal,
        curve: Motion.curve,
        child: AnimatedContainer(
          duration: reduce ? Duration.zero : Motion.normal,
          curve: Motion.curve,
          transform: Matrix4.identity()
            ..translateByDouble(0, _hover ? -6 : 0, 0, 1),
          transformAlignment: Alignment.center,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: widget.color ?? AppColors.card,
            borderRadius: widget.borderRadius,
            border: Border.all(
              color: _hover
                  ? AppColors.accent.withValues(alpha: 0.45)
                  : Colors.white.withValues(alpha: 0.1),
              width: _hover ? 1.4 : 1,
            ),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.12),
                      blurRadius: 28,
                      offset: const Offset(0, 12),
                    ),
                  ]
                : const [],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class GlowButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool filled;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final bool magnetic;

  const GlowButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.filled = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
    this.borderRadius = const BorderRadius.all(Radius.circular(30)),
    this.magnetic = false,
  });

  @override
  State<GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<GlowButton> {
  bool _hover = false;
  bool _down = false;
  Offset _magnet = Offset.zero;

  void _onHover(PointerEvent event) {
    if (!widget.magnetic) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final local = box.globalToLocal(event.position);
    final center = box.size.center(Offset.zero);
    final delta = local - center;
    setState(() {
      _magnet = Offset(
        (delta.dx / box.size.width) * 8,
        (delta.dy / box.size.height) * 6,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final reduce = Motion.reduce(context);
    final fine = Motion.isFinePointer(context);
    final lift = _down ? 0.97 : (_hover ? 1.03 : 1.0);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: fine && !reduce ? (_) => setState(() => _hover = true) : null,
      onExit: fine && !reduce
          ? (_) => setState(() {
              _hover = false;
              _magnet = Offset.zero;
            })
          : null,
      onHover: fine && !reduce && widget.magnetic ? _onHover : null,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _down = true),
        onTapUp: (_) => setState(() => _down = false),
        onTapCancel: () => setState(() => _down = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: reduce ? Duration.zero : Motion.fast,
          curve: Motion.curve,
          transform: Matrix4.identity()
            ..translateByDouble(
              _magnet.dx,
              (_hover ? -2 : 0) + _magnet.dy,
              0,
              1,
            )
            ..scaleByDouble(lift, lift, 1, 1),
          transformAlignment: Alignment.center,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: widget.filled
                ? AppColors.accent
                : AppColors.accent.withValues(alpha: _hover ? 0.16 : 0.1),
            borderRadius: widget.borderRadius,
            border: widget.filled
                ? null
                : Border.all(color: AppColors.accent, width: 2),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: AppColors.accent.withValues(
                        alpha: widget.filled ? 0.35 : 0.22,
                      ),
                      blurRadius: 22,
                      spreadRadius: 0,
                    ),
                  ]
                : const [],
          ),
          child: DefaultTextStyle.merge(
            style: GoogleFonts.poppins(
              color: widget.filled ? Colors.black : AppColors.accent,
              fontWeight: FontWeight.w600,
            ),
            child: IconTheme(
              data: IconThemeData(
                color: widget.filled ? Colors.black : AppColors.accent,
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  final String title;
  final bool isMobile;

  const SectionHeading({
    super.key,
    required this.title,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final words = title.split(' ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          children: [
            for (var i = 0; i < words.length; i++)
              ScrollReveal(
                staggerIndex: i,
                style: RevealStyle.blurUp,
                dy: 40,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    words[i],
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: isMobile ? 28 : 42,
                      fontWeight: FontWeight.bold,
                      height: 1.15,
                      letterSpacing: -0.6,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        ScrollReveal(
          style: RevealStyle.clipUp,
          child: Container(
            width: 60,
            height: 4,
            decoration: const BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.all(Radius.circular(2)),
            ),
          ),
        ),
      ],
    );
  }
}

class AmbientBackground extends StatefulWidget {
  final ValueNotifier<Offset> pointer;
  final ValueNotifier<double> scrollOffset;
  final bool enabled;

  const AmbientBackground({
    super.key,
    required this.pointer,
    required this.scrollOffset,
    required this.enabled,
  });

  @override
  State<AmbientBackground> createState() => _AmbientBackgroundState();
}

class _AmbientBackgroundState extends State<AmbientBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    );
    if (widget.enabled) _controller.repeat();
  }

  @override
  void didUpdateWidget(covariant AmbientBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.enabled && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _controller,
          widget.pointer,
          widget.scrollOffset,
        ]),
        builder: (context, _) {
          final t = widget.enabled ? _controller.value : 0.0;
          final pointer = widget.pointer.value;
          final size = MediaQuery.sizeOf(context);
          final nx = size.width == 0 ? 0.0 : (pointer.dx / size.width * 2 - 1);
          final ny = size.height == 0 ? 0.0 : (pointer.dy / size.height * 2 - 1);
          final scroll = widget.scrollOffset.value;
          return Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(painter: _GridPainter(scroll: scroll)),
              ),
              _blob(
                alignment: Alignment(
                  -0.85 + math.sin(t * math.pi * 2) * 0.08 + nx * 0.04,
                  -0.7 + math.cos(t * math.pi * 2) * 0.06 + ny * 0.04,
                ),
                color: AppColors.accent.withValues(alpha: 0.07),
                size: 420,
              ),
              _blob(
                alignment: Alignment(
                  0.9 + math.cos(t * math.pi * 2) * 0.06 - nx * 0.03,
                  0.35 + math.sin(t * math.pi * 2) * 0.08 - ny * 0.03,
                ),
                color: const Color(0xFF3B82F6).withValues(alpha: 0.06),
                size: 380,
              ),
              _blob(
                alignment: Alignment(
                  0.1 + math.sin(t * math.pi * 2 + 1) * 0.1,
                  1.05,
                ),
                color: AppColors.accent.withValues(alpha: 0.04),
                size: 500,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _blob({
    required Alignment alignment,
    required Color color,
    required double size,
  }) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final double scroll;
  _GridPainter({required this.scroll});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.028)
      ..strokeWidth = 1;
    const gap = 56.0;
    final shift = (scroll * 0.08) % gap;
    for (double x = 0; x < size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = -shift; y < size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) =>
      oldDelegate.scroll != scroll;
}

class CursorLight extends StatelessWidget {
  final ValueNotifier<Offset> pointer;
  final bool enabled;

  const CursorLight({
    super.key,
    required this.pointer,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return const SizedBox.shrink();
    return IgnorePointer(
      child: ValueListenableBuilder<Offset>(
        valueListenable: pointer,
        builder: (context, offset, _) {
          if (offset == Offset.zero) return const SizedBox.shrink();
          return CustomPaint(
            painter: _CursorLightPainter(offset),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _CursorLightPainter extends CustomPainter {
  final Offset offset;
  _CursorLightPainter(this.offset);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.accent.withValues(alpha: 0.09),
          AppColors.accent.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: offset, radius: 220));
    canvas.drawCircle(offset, 220, paint);
  }

  @override
  bool shouldRepaint(covariant _CursorLightPainter oldDelegate) =>
      oldDelegate.offset != offset;
}

class ScrollProgressBar extends StatelessWidget {
  final ValueNotifier<double> progress;

  const ScrollProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: progress,
      builder: (context, value, _) {
        return Align(
          alignment: Alignment.topLeft,
          child: FractionallySizedBox(
            widthFactor: value.clamp(0.0, 1.0),
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                color: AppColors.accent,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.5),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class HeroParticles extends StatefulWidget {
  final bool enabled;
  final ValueNotifier<Offset> pointer;

  const HeroParticles({
    super.key,
    required this.enabled,
    required this.pointer,
  });

  @override
  State<HeroParticles> createState() => _HeroParticlesState();
}

class _HeroParticlesState extends State<HeroParticles>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    final random = math.Random(7);
    _particles = List.generate(22, (i) {
      return _Particle(
        dx: random.nextDouble(),
        dy: random.nextDouble(),
        r: 1.0 + random.nextDouble() * 1.8,
        speed: 0.15 + random.nextDouble() * 0.35,
        phase: random.nextDouble() * math.pi * 2,
      );
    });
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    );
    if (widget.enabled) _controller.repeat();
  }

  @override
  void didUpdateWidget(covariant HeroParticles oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.enabled && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: Listenable.merge([_controller, widget.pointer]),
        builder: (context, _) {
          return CustomPaint(
            painter: _HeroParticlePainter(
              particles: _particles,
              t: widget.enabled ? _controller.value : 0,
              pointer: widget.pointer.value,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _Particle {
  final double dx;
  final double dy;
  final double r;
  final double speed;
  final double phase;
  _Particle({
    required this.dx,
    required this.dy,
    required this.r,
    required this.speed,
    required this.phase,
  });
}

class _HeroParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double t;
  final Offset pointer;

  _HeroParticlePainter({
    required this.particles,
    required this.t,
    required this.pointer,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final p in particles) {
      final nx = size.width == 0 ? 0.0 : (pointer.dx / size.width - 0.5);
      final ny = size.height == 0 ? 0.0 : (pointer.dy / size.height - 0.5);
      final x =
          (p.dx * size.width) +
          math.sin((t * math.pi * 2 * p.speed) + p.phase) * 18 +
          nx * 24;
      final y =
          (p.dy * size.height) +
          math.cos((t * math.pi * 2 * p.speed) + p.phase) * 14 +
          ny * 18;
      paint.color = AppColors.accent.withValues(alpha: 0.18);
      canvas.drawCircle(Offset(x, y), p.r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _HeroParticlePainter oldDelegate) =>
      oldDelegate.t != t || oldDelegate.pointer != pointer;
}

class HeroEntrance extends StatelessWidget {
  final Widget child;
  final int index;
  final bool reduce;

  const HeroEntrance({
    super.key,
    required this.child,
    required this.index,
    required this.reduce,
  });

  @override
  Widget build(BuildContext context) {
    if (reduce) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 700 + index * 90),
      curve: Motion.curve,
      builder: (context, value, child) {
        final clamped = value.clamp(0.0, 1.0);
        return Opacity(
          opacity: clamped,
          child: Transform.translate(
            offset: Offset(0, 22 * (1 - clamped)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class HoverIconButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final EdgeInsets padding;

  const HoverIconButton({
    super.key,
    required this.child,
    required this.onTap,
    this.padding = const EdgeInsets.all(12),
  });

  @override
  State<HoverIconButton> createState() => _HoverIconButtonState();
}

class _HoverIconButtonState extends State<HoverIconButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final reduce = Motion.reduce(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: reduce ? Duration.zero : Motion.fast,
          padding: widget.padding,
          transform: Matrix4.identity()
            ..translateByDouble(0, _hover ? -3 : 0, 0, 1)
            ..scaleByDouble(_hover ? 1.06 : 1, _hover ? 1.06 : 1, 1, 1),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            color: _hover
                ? AppColors.accent.withValues(alpha: 0.12)
                : Colors.transparent,
            border: Border.all(
              color: _hover
                  ? AppColors.accent.withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.18),
                      blurRadius: 16,
                    ),
                  ]
                : const [],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class SkillHoverTile extends StatefulWidget {
  final Widget child;
  const SkillHoverTile({super.key, required this.child});

  @override
  State<SkillHoverTile> createState() => _SkillHoverTileState();
}

class _SkillHoverTileState extends State<SkillHoverTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final reduce = Motion.reduce(context);
    final fine = Motion.isFinePointer(context);
    return MouseRegion(
      onEnter: fine ? (_) => setState(() => _hover = true) : null,
      onExit: fine ? (_) => setState(() => _hover = false) : null,
      child: AnimatedContainer(
        duration: reduce ? Duration.zero : Motion.normal,
        curve: Motion.curve,
        padding: const EdgeInsets.all(20),
        transform: Matrix4.identity()
          ..translateByDouble(0, _hover ? -3 : 0, 0, 1),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _hover
                ? AppColors.accent.withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
          boxShadow: _hover
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.1),
                    blurRadius: 16,
                  ),
                ]
              : const [],
        ),
        child: widget.child,
      ),
    );
  }
}

class AnimatedSkillBar extends StatelessWidget {
  final double progress;
  const AnimatedSkillBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: progress),
        duration: Motion.reduce(context)
            ? Duration.zero
            : const Duration(milliseconds: 900),
        curve: Motion.curve,
        builder: (context, value, _) {
          return Container(
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: value.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.45),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
  }
}

class StickyViewport extends StatefulWidget {
  final int pages;
  final Widget Function(BuildContext context, double progress) builder;

  const StickyViewport({
    super.key,
    required this.pages,
    required this.builder,
  });

  @override
  State<StickyViewport> createState() => _StickyViewportState();
}

class _StickyViewportState extends State<StickyViewport> {
  ScrollPosition? _position;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final next = Scrollable.maybeOf(context)?.position;
    if (next != _position) {
      _position?.removeListener(_tick);
      _position = next;
      _position?.addListener(_tick);
    }
  }

  void _tick() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _position?.removeListener(_tick);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vh = MediaQuery.sizeOf(context).height;
    final pages = widget.pages.clamp(1, 20);
    final height = vh * pages;

    double stick = 0;
    double progress = 0;
    final box = context.findRenderObject();
    if (box is RenderBox && box.hasSize) {
      final top = box.localToGlobal(Offset.zero).dy;
      final maxStick = (height - vh).clamp(0.0, double.infinity);
      stick = (-top).clamp(0.0, maxStick);
      progress = maxStick <= 0 ? 0 : (stick / maxStick).clamp(0.0, 1.0);
    }

    return SizedBox(
      height: height,
      child: Stack(
        children: [
          Positioned(
            top: stick,
            left: 0,
            right: 0,
            height: vh,
            child: widget.builder(context, progress),
          ),
        ],
      ),
    );
  }
}
