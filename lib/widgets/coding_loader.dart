import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../utils/audio_helper.dart';

class CodingLoader extends StatefulWidget {
  final VoidCallback onFinish;

  const CodingLoader({super.key, required this.onFinish});

  @override
  State<CodingLoader> createState() => _CodingLoaderState();
}

class _CodingLoaderState extends State<CodingLoader> with TickerProviderStateMixin {
  final List<String> _consoleLines = [];
  bool _isBlinking = true;
  int _currentLineIndex = 0;
  Timer? _typewriterTimer;
  Timer? _blinkTimer;
  double _overlayOpacity = 1.0;
  double _scale = 1.0;
  double _loadPercent = 0.0;
  
  // Matrix rain animation controller
  late final AnimationController _matrixController;

  final List<String> _commands = [
    "[ SYS ] Initializing Core Architecture...",
    "[ ASST ] Fetching assets (profile image, resume, galaxy icons)...",
    "[ COMP ] Compiling UI widgets and CustomPainters...",
    "[ NET ] Opening Socket channels & database pools...",
    "[ OK ] Connection established. System launch ready.",
  ];

  @override
  void initState() {
    super.initState();
    
    // Matrix animation controller runs continuously
    _matrixController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _startTypewriterSequence();
    
    // Blinking cursor timer
    _blinkTimer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      if (mounted) {
        setState(() {
          _isBlinking = !_isBlinking;
        });
      }
    });
  }

  @override
  void dispose() {
    _typewriterTimer?.cancel();
    _blinkTimer?.cancel();
    _matrixController.dispose();
    super.dispose();
  }

  void _startTypewriterSequence() {
    if (_currentLineIndex < _commands.length) {
      String command = _commands[_currentLineIndex];
      int charIndex = 0;
      String currentBuffer = "> ";
      
      setState(() {
        _consoleLines.add(currentBuffer);
      });

      _typewriterTimer = Timer.periodic(const Duration(milliseconds: 25), (timer) {
        if (!mounted) return;
        
        if (charIndex < command.length) {
          currentBuffer += command[charIndex];
          setState(() {
            _consoleLines[_currentLineIndex] = currentBuffer;
            // Increment progress bar based on command typing progress
            _loadPercent = ((_currentLineIndex + (charIndex / command.length)) / _commands.length).clamp(0.0, 1.0);
          });
          
          // Play synth key sound
          AudioHelper.playKey();
          charIndex++;
        } else {
          timer.cancel();
          _currentLineIndex++;
          // Wait brief delay before typing next command
          Future.delayed(const Duration(milliseconds: 300), () {
            _startTypewriterSequence();
          });
        }
      });
    } else {
      // Typing finished
      setState(() {
        _loadPercent = 1.0;
      });
      // Play arpeggiated success arpeggio
      AudioHelper.playSuccess();
      
      // Transition out
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        setState(() {
          _overlayOpacity = 0.0;
          _scale = 1.08;
        });
        
        Future.delayed(const Duration(milliseconds: 600), () {
          widget.onFinish();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: AnimatedOpacity(
        opacity: _overlayOpacity,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutQuad,
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutQuad,
          child: Stack(
            children: [
              // 1. Matrix Digital Rain Canvas Background
              AnimatedBuilder(
                animation: _matrixController,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _MatrixRainPainter(progress: _matrixController.value),
                    child: Container(),
                  );
                },
              ),
              
              // Dark Tint overlay
              Container(color: const Color(0xff090014).withOpacity(0.75)),
              
              // 2. Translucent Glass Terminal
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Container(
                    width: 650,
                    constraints: const BoxConstraints(maxHeight: 450),
                    decoration: BoxDecoration(
                      color: const Color(0xff120329).withOpacity(0.85),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xff10B981).withOpacity(0.4),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff10B981).withOpacity(0.12),
                          blurRadius: 32,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header Bar
                        Container(
                          height: 44,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xff110B22).withOpacity(0.9),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            border: Border(
                              bottom: BorderSide(
                                color: const Color(0xff10B981).withOpacity(0.2),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              _buildCircleDot(const Color(0xffEF4444)), // Red
                              const SizedBox(width: 8),
                              _buildCircleDot(const Color(0xffF59E0B)), // Yellow
                              const SizedBox(width: 8),
                              _buildCircleDot(const Color(0xff10B981)), // Green
                              const Spacer(),
                              const Text(
                                "bash - portfolio_initialize.sh",
                                style: TextStyle(
                                  color: Color(0xff10B981),
                                  fontSize: 12,
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                        
                        // Body Console Terminal
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Command lines
                              ..._consoleLines.map((line) {
                                bool isSuccess = line.contains("[ OK ]") || line.contains("established");
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: Text(
                                    line,
                                    style: TextStyle(
                                      color: isSuccess ? const Color(0xff10B981) : const Color(0xffC084FC),
                                      fontSize: 13.5,
                                      fontFamily: 'monospace',
                                      fontWeight: isSuccess ? FontWeight.bold : FontWeight.normal,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                );
                              }),
                              
                              // Blinking Cursor Line
                              if (_currentLineIndex < _commands.length)
                                Row(
                                  children: [
                                    const Text(
                                      "> ",
                                      style: TextStyle(
                                        color: Color(0xffC084FC),
                                        fontSize: 13.5,
                                        fontFamily: 'monospace',
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    AnimatedOpacity(
                                      opacity: _isBlinking ? 1.0 : 0.0,
                                      duration: Duration.zero,
                                      child: Container(
                                        width: 8,
                                        height: 15,
                                        color: const Color(0xff10B981),
                                      ),
                                    )
                                  ],
                                ),
                              
                              const SizedBox(height: 32),
                              
                              // Glowing Loading progress bar
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff1A0933),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: FractionallySizedBox(
                                        alignment: Alignment.centerLeft,
                                        widthFactor: _loadPercent,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [Color(0xff10B981), Color(0xffC084FC)],
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xff10B981).withOpacity(0.5),
                                                blurRadius: 8,
                                                spreadRadius: 1,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    "${(_loadPercent * 100).toInt()}%",
                                    style: const TextStyle(
                                      color: Color(0xff10B981),
                                      fontFamily: 'monospace',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleDot(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

// Matrix falling rain characters custom painter
class _MatrixRainPainter extends CustomPainter {
  final double progress;
  final List<_MatrixColumn> _columns = [];
  final math.Random _random = math.Random();

  _MatrixRainPainter({required this.progress}) {
    // Generate code rain streams
    for (int i = 0; i < 40; i++) {
      _columns.add(_MatrixColumn(
        xPercent: i / 40.0,
        yStartPercent: _random.nextDouble() * -1.0,
        speed: _random.nextDouble() * 0.008 + 0.003,
        charLen: _random.nextInt(15) + 8,
      ));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    for (var col in _columns) {
      // Drift stream down
      col.yStartPercent += col.speed;
      if (col.yStartPercent > 1.0) {
        col.yStartPercent = -0.3;
        col.xPercent = _random.nextDouble();
      }

      final double px = col.xPercent * width;
      final double pyStart = col.yStartPercent * height;

      // Draw characters column
      for (int k = 0; k < col.charLen; k++) {
        final double charY = pyStart + (k * 18);
        if (charY < 0 || charY > height) continue;

        // Fading intensity closer to the trail end
        double alpha = (k / col.charLen).clamp(0.0, 1.0);
        
        // Random character
        final String codeChar = String.fromCharCode(_random.nextInt(90) + 33);
        
        // Glow styling for the front character
        final bool isLeading = k == col.charLen - 1;
        
        final TextPainter tp = TextPainter(
          text: TextSpan(
            text: codeChar,
            style: TextStyle(
              color: isLeading 
                  ? Colors.white.withOpacity(alpha) 
                  : const Color(0xff10B981).withOpacity(alpha * 0.4),
              fontSize: 11,
              fontFamily: 'monospace',
              fontWeight: isLeading ? FontWeight.bold : FontWeight.normal,
              decoration: TextDecoration.none,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        tp.paint(canvas, Offset(px, charY));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MatrixRainPainter oldDelegate) {
    return true; // Redraw matrix stream steps
  }
}

class _MatrixColumn {
  double xPercent;
  double yStartPercent;
  final double speed;
  final int charLen;

  _MatrixColumn({
    required this.xPercent,
    required this.yStartPercent,
    required this.speed,
    required this.charLen,
  });
}
