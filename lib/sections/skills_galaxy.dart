import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme.dart';
import '../widgets/custom_cursor.dart';
import '../utils/audio_helper.dart';

class SkillsGalaxy extends StatefulWidget {
  const SkillsGalaxy({super.key});

  @override
  State<SkillsGalaxy> createState() => _SkillsGalaxyState();
}

class _SkillsGalaxyState extends State<SkillsGalaxy> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  final Map<String, ui.Image> _loadedImages = {};
  bool _imagesLoaded = false;
  Offset _hoveredMousePosition = Offset.zero;
  bool _isMouseInside = false;

  // Selected skill state
  String _selectedSkill = "React";

  // List of orbiting technologies arranged on 4 tilted orbits (Bohr atomic orbits)
  final List<_GalaxyNodeConfig> _nodesConfig = [
    _GalaxyNodeConfig(name: "React", assetPath: "assets/icons/react.png", orbitRadiusX: 180, orbitRadiusY: 75, speed: 0.8, tiltAngle: 0.0, initialAngle: 0.0),
    _GalaxyNodeConfig(name: "NodeJS", assetPath: "assets/icons/nodejs.png", orbitRadiusX: 230, orbitRadiusY: 95, speed: -0.6, tiltAngle: 0.45, initialAngle: 1.2),
    _GalaxyNodeConfig(name: "MongoDB", assetPath: "assets/icons/mongo-db.png", orbitRadiusX: 270, orbitRadiusY: 110, speed: 0.5, tiltAngle: -0.45, initialAngle: 2.5),
    _GalaxyNodeConfig(name: "ExpressJS", assetPath: "assets/icons/expressjs.png", orbitRadiusX: 320, orbitRadiusY: 130, speed: -0.4, tiltAngle: 1.2, initialAngle: 3.8),
    
    _GalaxyNodeConfig(name: "JavaScript", assetPath: "assets/icons/js.png", orbitRadiusX: 180, orbitRadiusY: 75, speed: 0.9, tiltAngle: 0.0, initialAngle: 3.1),
    _GalaxyNodeConfig(name: "TypeScript", assetPath: "assets/icons/ts.png", orbitRadiusX: 230, orbitRadiusY: 95, speed: -0.7, tiltAngle: 0.45, initialAngle: 4.3),
    _GalaxyNodeConfig(name: "PostgreSQL", assetPath: "assets/icons/postsql.png", orbitRadiusX: 270, orbitRadiusY: 110, speed: 0.5, tiltAngle: -0.45, initialAngle: 5.6),
    _GalaxyNodeConfig(name: "SQL", assetPath: "assets/icons/sql.png", orbitRadiusX: 320, orbitRadiusY: 130, speed: -0.3, tiltAngle: 1.2, initialAngle: 0.8),
    
    // Additional Languages
    _GalaxyNodeConfig(name: "Java", assetPath: "assets/icons/java.png", orbitRadiusX: 320, orbitRadiusY: 130, speed: 0.3, tiltAngle: 1.2, initialAngle: 2.1),
    _GalaxyNodeConfig(name: "HTML/CSS", assetPath: "assets/icons/html.png", orbitRadiusX: 180, orbitRadiusY: 75, speed: -0.85, tiltAngle: 0.0, initialAngle: 1.5),
    _GalaxyNodeConfig(name: "C Language", assetPath: "assets/icons/c.png", orbitRadiusX: 230, orbitRadiusY: 95, speed: 0.55, tiltAngle: 0.45, initialAngle: 2.9),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    
    _loadImages();
  }

  Future<void> _loadImages() async {
    try {
      final centerImage = await _loadImageAsset("assets/icons/mern.png");
      _loadedImages["mern"] = centerImage;

      for (var node in _nodesConfig) {
        if (node.assetPath.contains("java.png") || node.assetPath.contains("html.png") || node.assetPath.contains("c.png")) {
          continue;
        }
        final img = await _loadImageAsset(node.assetPath);
        _loadedImages[node.name] = img;
      }
      
      if (mounted) {
        setState(() {
          _imagesLoaded = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _imagesLoaded = true;
        });
      }
    }
  }

  Future<ui.Image> _loadImageAsset(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onCanvasTap(TapDownDetails details, double cx, double cy) {
    final Offset tapPos = details.localPosition;
    
    double mouseTiltX = 0.0;
    double mouseTiltY = 0.0;
    if (_isMouseInside) {
      mouseTiltX = (_hoveredMousePosition.dx - cx) / cx;
      mouseTiltY = (_hoveredMousePosition.dy - cy) / cy;
    }

    final double progress = _animationController.value;
    final bool isHoveredSlowdown = _isMouseInside;

    for (var node in _nodesConfig) {
      double hoverFactor = isHoveredSlowdown ? 0.35 : 1.0;
      double angle = node.initialAngle + (progress * 2 * math.pi * node.speed * hoverFactor);
      
      double rawX = math.cos(angle) * node.orbitRadiusX;
      double tilt = node.tiltAngle + (mouseTiltY * 0.2);
      double rotatedY = math.cos(angle) * node.orbitRadiusY * math.sin(tilt) + 
                         math.sin(angle) * node.orbitRadiusY * math.cos(tilt);
      
      double screenX = rawX + (mouseTiltX * 15.0);
      double screenY = rotatedY;

      final double nodeScreenX = cx + screenX;
      final double nodeScreenY = cy + screenY;
      final Offset nodeCenter = Offset(nodeScreenX, nodeScreenY);
      final double distance = (tapPos - nodeCenter).distance;

      if (distance < 28.0) {
        setState(() {
          _selectedSkill = node.name;
        });
        AudioHelper.playClick();
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cyberTheme = theme.extension<CyberTheme>()!;
    final double screenWidth = MediaQuery.of(context).size.width;

    final String skillDesc = _getSkillDescription(_selectedSkill);
    final String skillRole = _getSkillRole(_selectedSkill);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth > 1200 ? 120 : (screenWidth > 600 ? 48 : 24),
      ),
      child: Column(
        children: [
          // Title
          Text(
            "Skills Galaxy",
            style: TextStyle(
              color: cyberTheme.textColor,
              fontSize: screenWidth > 800 ? 36 : 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Tap any technology icon to load its engineering details in the typing reader below.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: cyberTheme.subtitleColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          
          // Full-width Galaxy Canvas
          _buildGalaxyCanvas(cyberTheme, screenWidth > 800 ? 480 : 360),
          
          const SizedBox(height: 16),
          
          // Typewriter explanation panel with responsive BoxConstraints to prevent layout shifting
          _buildTypewriterPanel(cyberTheme, _selectedSkill, skillRole, skillDesc, screenWidth),
        ],
      ),
    );
  }

  Widget _buildGalaxyCanvas(CyberTheme cyberTheme, double height) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double cx = constraints.maxWidth / 2;
        final double cy = height / 2;
        
        double mouseTiltX = 0.0;
        double mouseTiltY = 0.0;
        if (_isMouseInside) {
          mouseTiltX = (_hoveredMousePosition.dx - cx) / cx;
          mouseTiltY = (_hoveredMousePosition.dy - cy) / cy;
        }

        return GestureDetector(
          onTapDown: (details) => _onCanvasTap(details, cx, cy),
          child: MouseRegion(
            onEnter: (event) => setState(() {
              _isMouseInside = true;
              _hoveredMousePosition = event.localPosition;
            }),
            onHover: (event) => setState(() {
              _hoveredMousePosition = event.localPosition;
            }),
            onExit: (_) => setState(() {
              _isMouseInside = false;
            }),
            child: CustomCursorArea(
              type: CursorType.hover,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, _) {
                  return CustomPaint(
                    size: Size(constraints.maxWidth, height),
                    painter: _GalaxyPainter(
                      images: _loadedImages,
                      imagesLoaded: _imagesLoaded,
                      nodesConfig: _nodesConfig,
                      progress: _animationController.value,
                      cyberTheme: cyberTheme,
                      mousePos: _hoveredMousePosition,
                      isMouseInside: _isMouseInside,
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTypewriterPanel(CyberTheme cyberTheme, String skill, String role, String desc, double screenWidth) {
    // Set a responsive fixed height constraint to prevent vertical layout jiggling
    final double fixedHeight = screenWidth > 600 ? 160 : 250;

    return Container(
      width: math.min(screenWidth, 850),
      padding: const EdgeInsets.all(24),
      constraints: BoxConstraints(minHeight: fixedHeight, maxHeight: fixedHeight),
      decoration: BoxDecoration(
        color: cyberTheme.cardBackgroundColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cyberTheme.primaryGlow.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: cyberTheme.primaryGlow.withOpacity(0.05),
            blurRadius: 16,
            spreadRadius: 1,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                "[ SYS ]: EXPLAINING_${skill.toUpperCase()}",
                style: TextStyle(
                  color: cyberTheme.accent,
                  fontFamily: 'monospace',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: cyberTheme.primaryGlow.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: cyberTheme.primaryGlow.withOpacity(0.3)),
                ),
                child: Text(
                  role,
                  style: TextStyle(
                    color: cyberTheme.textColor,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.none,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Colors.white10),
          const SizedBox(height: 12),
          
          // Typewriter Text
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: _TypewriterText(
                key: ValueKey<String>(skill),
                text: desc,
                style: TextStyle(
                  color: cyberTheme.textColor.withOpacity(0.85),
                  fontSize: 13.5,
                  height: 1.6,
                  fontFamily: 'monospace',
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getSkillRole(String skill) {
    switch (skill) {
      case "MongoDB":
        return "Database Schema Design & Aggregations";
      case "ExpressJS":
        return "Server Routing & API Middleware";
      case "React":
        return "Frontend Client Views & Dynamic SPA";
      case "NodeJS":
        return "Non-Blocking Async Backend Engine";
      case "TypeScript":
        return "Static Typing & Structural Interfaces";
      case "JavaScript":
        return "Dynamic scripting & Async callbacks";
      case "PostgreSQL":
      case "SQL":
        return "Relational Table Queries & Normalization";
      case "Java":
        return "Object Oriented Core Logic & Structures";
      case "HTML/CSS":
        return "Responsive Styling & Flex layout";
      case "C Language":
        return "System logic & algorithmic syntax";
      default:
        return "Full Stack Development Skill";
    }
  }

  String _getSkillDescription(String skill) {
    switch (skill) {
      case "MongoDB":
        return "Designs flexible document schemas using Mongoose, writes complex aggregation pipelines (utilizing math, lookup stages, and sorting), manages cluster indexing optimizations, and conducts multi-document transactions.";
      case "ExpressJS":
        return "Configures decoupled routes, enforces security parameters (helmet, cors, rate-limits), sets up controller routers, and designs modular middleware hooks checking JSON Web Tokens (JWT) and request parameters.";
      case "React":
        return "Constructs modular Single Page Applications (SPAs), implements client-side state hooks (Context, Redux), structures reusable components, and leverages lazy-loading routes for optimized loading times.";
      case "NodeJS":
        return "Writes asynchronous non-blocking services, works with file systems streams, implements WebSockets via Socket.IO, and orchestrates process threads across clusters.";
      case "TypeScript":
        return "TypeScript is integrated to enforce structural type safety. Implements typed parameter interfaces, compiler configurations, and type-checks databases schemas, preventing runtime exceptions before builds reach staging.";
      case "JavaScript":
        return "Highly fluent in ECMA standards (ES6+). Utilizes Promises, async/await constructs, event loop callbacks, array manipulators, and local storage operations to write premium logic wrappers.";
      case "PostgreSQL":
      case "SQL":
        return "Designs normal schema forms, manages foreign constraints keys, writes joins queries, and optimizes database transactions.";
      case "Java":
        return "Verified in core OOP principles, abstract structures (queues, stacks, trees), algorithms, and thread execution frameworks.";
      case "HTML/CSS":
        return "Codes responsive layouts using modern layout architectures (Flexbox, Grid). Utilizes media queries, keyframe custom animations, CSS styling properties, and glassmorphic variables.";
      case "C Language":
        return "C Language provides foundational computer engineering details, helping master memory management, pointers, logical algorithmic flows, and low-level data structures.";
      default:
        return "Highly versatile skill utilized by Monu to build robust digital solutions, APIs, and responsive customer interfaces.";
    }
  }
}

// Typewriter text animation class
class _TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const _TypewriterText({required this.text, required this.style, super.key});

  @override
  State<_TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<_TypewriterText> {
  String _displayedText = "";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  @override
  void didUpdateWidget(covariant _TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _startTyping();
    }
  }

  void _startTyping() {
    _timer?.cancel();
    _displayedText = "";
    int index = 0;
    
    AudioHelper.playHover();
    
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (!mounted) return;
      if (index < widget.text.length) {
        setState(() {
          _displayedText += widget.text[index];
        });
        
        if (index % 3 == 0) {
          AudioHelper.playKey();
        }
        index++;
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayedText,
      style: widget.style,
    );
  }
}

class _GalaxyNodeConfig {
  final String name;
  final String assetPath;
  final double orbitRadiusX;
  final double orbitRadiusY;
  final double speed;
  final double tiltAngle;
  final double initialAngle;

  _GalaxyNodeConfig({
    required this.name,
    required this.assetPath,
    required this.orbitRadiusX,
    required this.orbitRadiusY,
    required this.speed,
    required this.tiltAngle,
    required this.initialAngle,
  });
}

class _GalaxyNode3D {
  final String name;
  final ui.Image? image;
  final double x;
  final double y;
  final double z;
  final double scale;
  final double size;
  final _GalaxyNodeConfig config;

  _GalaxyNode3D({
    required this.name,
    required this.image,
    required this.x,
    required this.y,
    required this.z,
    required this.scale,
    required this.size,
    required this.config,
  });
}

class _GalaxyPainter extends CustomPainter {
  final Map<String, ui.Image> images;
  final bool imagesLoaded;
  final List<_GalaxyNodeConfig> nodesConfig;
  final double progress;
  final CyberTheme cyberTheme;
  final Offset mousePos;
  final bool isMouseInside;

  _GalaxyPainter({
    required this.images,
    required this.imagesLoaded,
    required this.nodesConfig,
    required this.progress,
    required this.cyberTheme,
    required this.mousePos,
    required this.isMouseInside,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final Offset center = Offset(cx, cy);

    double mouseTiltX = 0.0;
    double mouseTiltY = 0.0;
    if (isMouseInside) {
      mouseTiltX = (mousePos.dx - cx) / cx;
      mouseTiltY = (mousePos.dy - cy) / cy;
    }

    final Paint orbitPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final List<_GalaxyNode3D> nodes = [];
    
    for (var node in nodesConfig) {
      double hoverFactor = isMouseInside ? 0.35 : 1.0;
      double angle = node.initialAngle + (progress * 2 * math.pi * node.speed * hoverFactor);
      
      double rawX = math.cos(angle) * node.orbitRadiusX;
      double tilt = node.tiltAngle + (mouseTiltY * 0.2);
      double rotatedY = math.cos(angle) * node.orbitRadiusY * math.sin(tilt) + 
                         math.sin(angle) * node.orbitRadiusY * math.cos(tilt);
      
      double screenX = rawX + (mouseTiltX * 15.0);
      double screenY = rotatedY;
      
      double zVal = math.sin(angle);
      
      double scale = 0.75 + (zVal + 1.0) * 0.22;
      double nodeSize = 40.0 * scale;

      nodes.add(_GalaxyNode3D(
        name: node.name,
        image: images[node.name],
        x: screenX,
        y: screenY,
        z: zVal,
        scale: scale,
        size: nodeSize,
        config: node,
      ));
    }

    nodes.sort((a, b) => a.z.compareTo(b.z));

    // Draw the 4 Bohr atomic orbits trails
    for (var node in nodesConfig) {
      orbitPaint.color = cyberTheme.primaryGlow.withOpacity(0.08 * cyberTheme.glowIntensity);
      
      canvas.save();
      canvas.translate(cx, cy);
      canvas.rotate(node.tiltAngle + (mouseTiltY * 0.1));
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(mouseTiltX * 5.0, 0),
          width: node.orbitRadiusX * 2,
          height: node.orbitRadiusY * 2,
        ),
        orbitPaint,
      );
      canvas.restore();
    }

    bool centerDrawn = false;
    final double centerLogoSize = 85.0;

    for (var node in nodes) {
      if (node.z >= 0 && !centerDrawn) {
        _drawCenterCore(canvas, center, centerLogoSize, cyberTheme);
        centerDrawn = true;
      }

      final Offset nodeCenter = Offset(cx + node.x, cy + node.y);
      _drawOrbitingNode(canvas, nodeCenter, node, cyberTheme);
    }

    if (!centerDrawn) {
      _drawCenterCore(canvas, center, centerLogoSize, cyberTheme);
    }
  }

  void _drawCenterCore(Canvas canvas, Offset center, double size, CyberTheme cyberTheme) {
    final Paint paint = Paint()..style = PaintingStyle.fill;
    final double radius = size / 2;

    if (cyberTheme.glowIntensity > 0.2) {
      paint.color = cyberTheme.primaryGlow.withOpacity(0.25);
      canvas.drawCircle(center, radius + 14, paint);
      
      paint.color = cyberTheme.secondaryGlow.withOpacity(0.15);
      canvas.drawCircle(center, radius + 7, paint);
    }

    paint.color = cyberTheme.cardBackgroundColor;
    canvas.drawCircle(center, radius, paint);

    final Paint borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = cyberTheme.accent.withOpacity(0.6)
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, radius, borderPaint);

    final ui.Image? centerImg = images["mern"];
    if (centerImg != null) {
      final double imgSize = size * 0.7;
      final Rect destRect = Rect.fromCenter(center: center, width: imgSize, height: imgSize);
      canvas.drawImageRect(
        centerImg,
        Rect.fromLTWH(0, 0, centerImg.width.toDouble(), centerImg.height.toDouble()),
        destRect,
        Paint()..filterQuality = ui.FilterQuality.high,
      );
    } else {
      final TextPainter tp = TextPainter(
        text: TextSpan(
          text: "MERN",
          style: TextStyle(
            color: cyberTheme.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: 1.0,
            decoration: TextDecoration.none,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
    }
  }

  void _drawOrbitingNode(Canvas canvas, Offset pos, _GalaxyNode3D node, CyberTheme cyberTheme) {
    final Paint paint = Paint()..style = PaintingStyle.fill;
    final double radius = node.size / 2;

    if (node.z > -0.2 && cyberTheme.glowIntensity > 0.2) {
      paint.color = cyberTheme.secondaryGlow.withOpacity(0.2 * node.scale);
      canvas.drawCircle(pos, radius + 5, paint);
    }

    paint.color = cyberTheme.backgroundColor;
    canvas.drawCircle(pos, radius, paint);

    final Paint borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = cyberTheme.primaryGlow.withOpacity(0.55 * node.scale)
      ..strokeWidth = 1.5;
    canvas.drawCircle(pos, radius, borderPaint);

    if (node.image != null) {
      final double imgSize = node.size * 0.6;
      final Rect destRect = Rect.fromCenter(center: pos, width: imgSize, height: imgSize);
      canvas.drawImageRect(
        node.image!,
        Rect.fromLTWH(0, 0, node.image!.width.toDouble(), node.image!.height.toDouble()),
        destRect,
        Paint()..filterQuality = ui.FilterQuality.high,
      );
    } else {
      // Missing icons: draw detailed custom vector graphics!
      if (node.name == "Java") {
        _drawJavaVectorIcon(canvas, pos, radius, cyberTheme, node.scale);
      } else if (node.name == "HTML/CSS") {
        _drawHtmlCssVectorIcon(canvas, pos, radius, cyberTheme, node.scale);
      } else if (node.name == "C Language") {
        _drawCVectorIcon(canvas, pos, radius, cyberTheme, node.scale);
      } else {
        // Fallback text initials
        final String initials = node.name.substring(0, math.min(node.name.length, 2)).toUpperCase();
        final TextPainter tp = TextPainter(
          text: TextSpan(
            text: initials,
            style: TextStyle(
              color: cyberTheme.textColor.withOpacity(0.85 * node.scale),
              fontWeight: FontWeight.bold,
              fontSize: 10 * node.scale,
              decoration: TextDecoration.none,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(pos.dx - tp.width / 2, pos.dy - tp.height / 2));
      }
    }

    if (node.z > -0.2) {
      final TextPainter labelPainter = TextPainter(
        text: TextSpan(
          text: node.name,
          style: TextStyle(
            color: cyberTheme.textColor.withOpacity(0.8 * node.scale),
            fontSize: 9.5 * node.scale,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
            decoration: TextDecoration.none,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      labelPainter.paint(
        canvas,
        Offset(pos.dx - labelPainter.width / 2, pos.dy + radius + 4),
      );
    }
  }

  // Draw custom vector Java Coffee Cup icon
  void _drawJavaVectorIcon(Canvas canvas, Offset pos, double radius, CyberTheme cyberTheme, double scale) {
    final double sz = radius * 1.1;
    final Paint paint = Paint()
      ..color = cyberTheme.accent.withOpacity(0.9 * scale)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8 * scale;

    // 1. Draw Coffee Cup body path
    final Path cupPath = Path();
    cupPath.moveTo(pos.dx - sz * 0.45, pos.dy - sz * 0.1);
    cupPath.lineTo(pos.dx + sz * 0.45, pos.dy - sz * 0.1);
    cupPath.quadraticBezierTo(pos.dx + sz * 0.4, pos.dy + sz * 0.45, pos.dx + sz * 0.25, pos.dy + sz * 0.45);
    cupPath.lineTo(pos.dx - sz * 0.25, pos.dy + sz * 0.45);
    cupPath.quadraticBezierTo(pos.dx - sz * 0.4, pos.dy + sz * 0.45, pos.dx - sz * 0.45, pos.dy - sz * 0.1);
    canvas.drawPath(cupPath, paint);

    // 2. Draw Cup handle
    final Path handlePath = Path();
    handlePath.moveTo(pos.dx + sz * 0.42, pos.dy);
    handlePath.quadraticBezierTo(pos.dx + sz * 0.72, pos.dy + sz * 0.05, pos.dx + sz * 0.42, pos.dy + sz * 0.28);
    canvas.drawPath(handlePath, paint);

    // 3. Draw cup base plate line
    canvas.drawLine(
      Offset(pos.dx - sz * 0.35, pos.dy + sz * 0.52),
      Offset(pos.dx + sz * 0.35, pos.dy + sz * 0.52),
      paint,
    );

    // 4. Draw wavy steam lines
    final Paint steamPaint = Paint()
      ..color = cyberTheme.accent.withOpacity(0.6 * scale)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2 * scale;
    
    for (double xo in [-sz * 0.18, 0.0, sz * 0.18]) {
      final Path steam = Path();
      steam.moveTo(pos.dx + xo, pos.dy - sz * 0.2);
      steam.quadraticBezierTo(pos.dx + xo + sz * 0.08, pos.dy - sz * 0.35, pos.dx + xo, pos.dy - sz * 0.48);
      canvas.drawPath(steam, steamPaint);
    }
  }

  // Draw custom vector HTML/CSS code brackets `< >` icon
  void _drawHtmlCssVectorIcon(Canvas canvas, Offset pos, double radius, CyberTheme cyberTheme, double scale) {
    final double sz = radius * 1.0;
    final Paint paint = Paint()
      ..color = cyberTheme.accent.withOpacity(0.95 * scale)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0 * scale
      ..strokeCap = StrokeCap.round;

    // 1. Draw Left Bracket `<`
    final Path left = Path();
    left.moveTo(pos.dx - sz * 0.18, pos.dy - sz * 0.32);
    left.lineTo(pos.dx - sz * 0.52, pos.dy);
    left.lineTo(pos.dx - sz * 0.18, pos.dy + sz * 0.32);
    canvas.drawPath(left, paint);

    // 2. Draw Right Bracket `>`
    final Path right = Path();
    right.moveTo(pos.dx + sz * 0.18, pos.dy - sz * 0.32);
    right.lineTo(pos.dx + sz * 0.52, pos.dy);
    right.lineTo(pos.dx + sz * 0.18, pos.dy + sz * 0.32);
    canvas.drawPath(right, paint);

    // 3. Draw middle slash `/`
    canvas.drawLine(
      Offset(pos.dx + sz * 0.08, pos.dy - sz * 0.42),
      Offset(pos.dx - sz * 0.08, pos.dy + sz * 0.42),
      paint,
    );
  }

  // Draw custom vector C Language Hexagon icon
  void _drawCVectorIcon(Canvas canvas, Offset pos, double radius, CyberTheme cyberTheme, double scale) {
    final double sz = radius * 0.95;
    
    // 1. Draw outer hexagon frame
    final Paint hexPaint = Paint()
      ..color = cyberTheme.accent.withOpacity(0.45 * scale)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0 * scale;

    final Path hex = Path();
    for (int i = 0; i < 6; i++) {
      double angle = i * math.pi / 3;
      double hx = pos.dx + sz * math.cos(angle);
      double hy = pos.dy + sz * math.sin(angle);
      if (i == 0) {
        hex.moveTo(hx, hy);
      } else {
        hex.lineTo(hx, hy);
      }
    }
    hex.close();
    canvas.drawPath(hex, hexPaint);

    // 2. Draw bold letter 'C' in the center
    final TextPainter tp = TextPainter(
      text: TextSpan(
        text: "C",
        style: TextStyle(
          color: cyberTheme.accent.withOpacity(0.95 * scale),
          fontWeight: FontWeight.w900,
          fontSize: 16 * scale,
          fontFamily: 'monospace',
          decoration: TextDecoration.none,
          shadows: [
            Shadow(color: cyberTheme.accent.withOpacity(0.5), blurRadius: 4),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(canvas, Offset(pos.dx - tp.width / 2, pos.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _GalaxyPainter oldDelegate) {
    return oldDelegate.progress != progress ||
           oldDelegate.imagesLoaded != imagesLoaded ||
           oldDelegate.mousePos != mousePos ||
           oldDelegate.isMouseInside != isMouseInside ||
           oldDelegate.cyberTheme != cyberTheme;
  }
}
