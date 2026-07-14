import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../utils/audio_helper.dart';

enum CursorType { normal, hover, magnetic, click }

class CursorState {
  final Offset position;
  final CursorType type;
  final double scale;
  final Color? colorOverride;

  CursorState({
    required this.position,
    this.type = CursorType.normal,
    this.scale = 1.0,
    this.colorOverride,
  });

  CursorState copyWith({
    Offset? position,
    CursorType? type,
    double? scale,
    Color? colorOverride,
  }) {
    return CursorState(
      position: position ?? this.position,
      type: type ?? this.type,
      scale: scale ?? this.scale,
      colorOverride: colorOverride ?? this.colorOverride,
    );
  }
}

class CursorProvider extends InheritedNotifier<ValueNotifier<CursorState>> {
  const CursorProvider({
    super.key,
    required ValueNotifier<CursorState> notifier,
    required super.child,
  }) : super(notifier: notifier);

  static ValueNotifier<CursorState> of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<CursorProvider>();
    assert(provider != null, 'No CursorProvider found in context');
    return provider!.notifier!;
  }
}

class CustomCursor extends StatefulWidget {
  final Widget child;

  const CustomCursor({super.key, required this.child});

  @override
  State<CustomCursor> createState() => _CustomCursorState();
}

class _CustomCursorState extends State<CustomCursor> with TickerProviderStateMixin {
  late final ValueNotifier<CursorState> _cursorNotifier;
  
  // Outer circle position lags behind for a smooth trail effect
  double _outerX = 0;
  double _outerY = 0;
  
  late final AnimationController _trailController;

  @override
  void initState() {
    super.initState();
    _cursorNotifier = ValueNotifier<CursorState>(
      CursorState(position: Offset.zero),
    );
    
    // Ticker to animate the outer circle trailing the inner dot
    _trailController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16), // ~60fps updates
    )..addListener(_updateTrail);
    _trailController.repeat();
  }

  void _updateTrail() {
    final target = _cursorNotifier.value.position;
    // Simple lerp equation for smooth tracking trail
    final double lerpFactor = _cursorNotifier.value.type == CursorType.magnetic ? 0.3 : 0.15;
    setState(() {
      _outerX += (target.dx - _outerX) * lerpFactor;
      _outerY += (target.dy - _outerY) * lerpFactor;
    });
  }

  @override
  void dispose() {
    _trailController.dispose();
    _cursorNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We always render the trailing halo ring on Web
    const bool shouldRenderTrail = kIsWeb;

    return CursorProvider(
      notifier: _cursorNotifier,
      child: MouseRegion(
        cursor: MouseCursor.defer, // Keep native system pointer visible
        onHover: (event) {
          _cursorNotifier.value = _cursorNotifier.value.copyWith(
            position: event.position,
          );
        },
        child: Stack(
          children: [
            widget.child,
            if (shouldRenderTrail)
              ValueListenableBuilder<CursorState>(
                valueListenable: _cursorNotifier,
                builder: (context, state, _) {
                  final cyberTheme = Theme.of(context).extension<CyberTheme>()!;
                  
                  // Style configurations based on cursor state
                  double outerSize = 38.0;
                  Color glowColor = state.colorOverride ?? cyberTheme.primaryGlow;
                  
                  if (state.type == CursorType.hover) {
                    outerSize = 64.0;
                  } else if (state.type == CursorType.magnetic) {
                    outerSize = 72.0;
                  } else if (state.type == CursorType.click) {
                    outerSize = 28.0;
                  }

                  return IgnorePointer(
                    child: Stack(
                      children: [
                        // Large Outer Glow Halo Ring
                        Positioned(
                          left: _outerX - (outerSize / 2),
                          top: _outerY - (outerSize / 2),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            curve: Curves.easeOutCubic,
                            width: outerSize,
                            height: outerSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: glowColor.withOpacity(0.55),
                                width: state.type == CursorType.magnetic ? 2.5 : 1.25,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: glowColor.withOpacity(0.18),
                                  blurRadius: state.type == CursorType.hover ? 16 : 8,
                                  spreadRadius: 1,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class CustomCursorArea extends StatelessWidget {
  final Widget child;
  final CursorType type;
  final Color? colorOverride;

  const CustomCursorArea({
    super.key,
    required this.child,
    this.type = CursorType.hover,
    this.colorOverride,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        CursorProvider.of(context).value = CursorProvider.of(context).value.copyWith(
          type: type,
          colorOverride: colorOverride,
        );
        // Play synthesized cyber tick sound
        AudioHelper.playHover();
      },
      onExit: (_) {
        // Reset cursor to normal state
        CursorProvider.of(context).value = CursorProvider.of(context).value.copyWith(
          type: CursorType.normal,
          colorOverride: null,
        );
      },
      child: child,
    );
  }
}
