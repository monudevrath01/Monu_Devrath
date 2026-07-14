import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme.dart';
import 'custom_cursor.dart';

class SpaceBackground extends StatefulWidget {
  final Widget child;

  const SpaceBackground({super.key, required this.child});

  @override
  State<SpaceBackground> createState() => _SpaceBackgroundState();
}

class _SpaceBackgroundState extends State<SpaceBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  final List<_StarParticle> _stars = [];
  final int _starCount = 100;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Initialize stars
    for (int i = 0; i < _starCount; i++) {
      _stars.add(_StarParticle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 2.5 + 0.5,
        speed: _random.nextDouble() * 0.02 + 0.005,
        alpha: _random.nextDouble() * 0.7 + 0.3,
        pulseSpeed: _random.nextDouble() * 2 + 1,
      ));
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We listen to cursor position for parallax offset
    Offset cursorPosition = Offset.zero;
    try {
      cursorPosition = CursorProvider.of(context).value.position;
    } catch (_) {}

    return Stack(
      children: [
        // Background Paint
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, _) {
            final theme = Theme.of(context);
            final cyberTheme = theme.extension<CyberTheme>()!;
            
            return CustomPaint(
              painter: _SpacePainter(
                stars: _stars,
                progress: _animationController.value,
                cyberTheme: cyberTheme,
                cursorPos: cursorPosition,
                mediaQuery: MediaQuery.of(context),
              ),
              child: Container(),
            );
          },
        ),
        // Child Content
        widget.child,
      ],
    );
  }
}

class _StarParticle {
  double x; // normalized 0..1
  double y; // normalized 0..1
  final double size;
  final double speed;
  double alpha;
  final double pulseSpeed;

  _StarParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.alpha,
    required this.pulseSpeed,
  });

  void update(double progress) {
    // Drift stars slowly upwards
    y -= speed * 0.05;
    if (y < 0) {
      y = 1.0;
      x = math.Random().nextDouble();
    }
    
    // Pulse transparency slightly
    alpha = (0.5 + 0.4 * math.sin(progress * math.pi * pulseSpeed * 10)).clamp(0.1, 1.0);
  }
}

class _SpacePainter extends CustomPainter {
  final List<_StarParticle> stars;
  final double progress;
  final CyberTheme cyberTheme;
  final Offset cursorPos;
  final MediaQueryData mediaQuery;

  _SpacePainter({
    required this.stars,
    required this.progress,
    required this.cyberTheme,
    required this.cursorPos,
    required this.mediaQuery,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    
    // Parallax mouse offsets (strength determined by screen size)
    final double mouseXPercent = (cursorPos.dx / (width > 0 ? width : 1.0)) - 0.5;
    final double mouseYPercent = (cursorPos.dy / (height > 0 ? height : 1.0)) - 0.5;
    
    final double parallaxOffset1X = mouseXPercent * -20.0;
    final double parallaxOffset1Y = mouseYPercent * -20.0;
    final double parallaxOffset2X = mouseXPercent * -40.0;
    final double parallaxOffset2Y = mouseYPercent * -40.0;

    final Paint paint = Paint()..style = PaintingStyle.fill;

    // 1. Draw base background color
    paint.color = cyberTheme.backgroundColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), paint);

    // 2. Draw Nebula glows (Radial Gradients) - only prominent in dark mode
    if (cyberTheme.glowIntensity > 0.2) {
      // Top Left Nebula (Purple)
      final Offset nebula1Center = Offset(width * 0.2 + parallaxOffset1X, height * 0.3 + parallaxOffset1Y);
      final double nebula1Radius = width * 0.5;
      final RadialGradient gradient1 = RadialGradient(
        colors: [
          cyberTheme.primaryGlow.withOpacity(0.15 * cyberTheme.glowIntensity),
          cyberTheme.primaryGlow.withOpacity(0.0),
        ],
      );
      paint.shader = gradient1.createShader(Rect.fromCircle(center: nebula1Center, radius: nebula1Radius));
      canvas.drawCircle(nebula1Center, nebula1Radius, paint);

      // Bottom Right Nebula (Indigo / Violet)
      final Offset nebula2Center = Offset(width * 0.85 + parallaxOffset2X, height * 0.7 + parallaxOffset2Y);
      final double nebula2Radius = width * 0.6;
      final RadialGradient gradient2 = RadialGradient(
        colors: [
          cyberTheme.secondaryGlow.withOpacity(0.12 * cyberTheme.glowIntensity),
          cyberTheme.secondaryGlow.withOpacity(0.0),
        ],
      );
      paint.shader = gradient2.createShader(Rect.fromCircle(center: nebula2Center, radius: nebula2Radius));
      canvas.drawCircle(nebula2Center, nebula2Radius, paint);
      
      // Middle Right Nebula (Cyan/Pink Accent)
      final Offset nebula3Center = Offset(width * 0.9 + parallaxOffset1X * 1.5, height * 0.25 + parallaxOffset1Y * 1.5);
      final double nebula3Radius = width * 0.35;
      final RadialGradient gradient3 = RadialGradient(
        colors: [
          cyberTheme.accent.withOpacity(0.08 * cyberTheme.glowIntensity),
          cyberTheme.accent.withOpacity(0.0),
        ],
      );
      paint.shader = gradient3.createShader(Rect.fromCircle(center: nebula3Center, radius: nebula3Radius));
      canvas.drawCircle(nebula3Center, nebula3Radius, paint);
    } else {
      // Light Mode Soft Lavendar Gradients
      final Offset lightGlowCenter = Offset(width * 0.5, height * 0.5);
      final double lightGlowRadius = width * 0.8;
      final RadialGradient lightGradient = RadialGradient(
        colors: [
          cyberTheme.cardBackgroundColor.withOpacity(0.5),
          cyberTheme.backgroundColor,
        ],
      );
      paint.shader = lightGradient.createShader(Rect.fromCircle(center: lightGlowCenter, radius: lightGlowRadius));
      canvas.drawCircle(lightGlowCenter, lightGlowRadius, paint);
    }
    paint.shader = null;

    // 3. Draw Orbit Rings (space science theme)
    final Paint orbitPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = cyberTheme.primaryGlow.withOpacity(0.06 * cyberTheme.glowIntensity)
      ..strokeWidth = 1.0;

    final Offset center = Offset(width / 2 + parallaxOffset1X * 0.3, height / 2 + parallaxOffset1Y * 0.3);
    // Draw 3 orbit lines
    canvas.drawCircle(center, width * 0.25, orbitPaint);
    
    orbitPaint.color = cyberTheme.secondaryGlow.withOpacity(0.04 * cyberTheme.glowIntensity);
    canvas.drawOval(
      Rect.fromCenter(center: center, width: width * 0.65, height: height * 0.45),
      orbitPaint,
    );

    // 4. Draw Stars/Particles
    for (var star in stars) {
      star.update(progress);
      
      final double starX = star.x * width + parallaxOffset2X * (star.size / 3.0);
      final double starY = star.y * height + parallaxOffset2Y * (star.size / 3.0);
      
      final Paint starPaint = Paint()
        ..color = (cyberTheme.glowIntensity > 0.2
            ? cyberTheme.accent.withOpacity(star.alpha)
            : cyberTheme.accent.withOpacity(star.alpha * 0.3))
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(Offset(starX, starY), star.size, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SpacePainter oldDelegate) {
    return oldDelegate.progress != progress ||
           oldDelegate.cursorPos != cursorPos ||
           oldDelegate.cyberTheme != cyberTheme;
  }
}
