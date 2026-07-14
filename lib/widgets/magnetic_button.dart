import 'package:flutter/material.dart';
import '../theme.dart';
import 'custom_cursor.dart';

class MagneticButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double magneticRadius;
  final double pullStrength; // 0..1 representing how strong the pull is
  final Color? glowColor;
  final bool fillGlow;

  const MagneticButton({
    super.key,
    required this.child,
    required this.onTap,
    this.magneticRadius = 80.0,
    this.pullStrength = 0.35,
    this.glowColor,
    this.fillGlow = false,
  });

  @override
  State<MagneticButton> createState() => _MagneticButtonState();
}

class _MagneticButtonState extends State<MagneticButton> with SingleTickerProviderStateMixin {
  double _offsetX = 0.0;
  double _offsetY = 0.0;
  bool _isHovered = false;

  void _onPointerMove(PointerEvent event, RenderBox box) {
    final center = box.size.center(Offset.zero);
    final localPos = event.localPosition;
    
    // Vector from button center to mouse cursor
    final double dx = localPos.dx - center.dx;
    final double dy = localPos.dy - center.dy;

    setState(() {
      _offsetX = dx * widget.pullStrength;
      _offsetY = dy * widget.pullStrength;
    });
  }

  void _onPointerExit() {
    setState(() {
      _offsetX = 0.0;
      _offsetY = 0.0;
      _isHovered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cyberTheme = theme.extension<CyberTheme>()!;
    final color = widget.glowColor ?? cyberTheme.primaryGlow;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => _onPointerExit(),
      child: CustomCursorArea(
        type: CursorType.magnetic,
        colorOverride: color,
        child: Listener(
          onPointerMove: (event) {
            final box = context.findRenderObject() as RenderBox?;
            if (box != null) {
              _onPointerMove(event, box);
            }
          },
          child: TweenAnimationBuilder<Offset>(
            tween: Tween<Offset>(
              begin: Offset.zero,
              end: Offset(_offsetX, _offsetY),
            ),
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOutCubic,
            builder: (context, offset, childWidget) {
              return Transform.translate(
                offset: offset,
                child: InkWell(
                  onTap: widget.onTap,
                  borderRadius: BorderRadius.circular(30),
                  splashColor: color.withOpacity(0.3),
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: _isHovered ? color.withOpacity(0.5) : Colors.transparent,
                          blurRadius: _isHovered ? 20 : 0,
                          spreadRadius: _isHovered ? 2 : 0,
                        ),
                        BoxShadow(
                          color: cyberTheme.cardBackgroundColor.withOpacity(0.4),
                          offset: const Offset(0, 4),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: childWidget,
                  ),
                ),
              );
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
