import 'package:flutter/material.dart';

class UberRadio<T> extends StatefulWidget {
  const UberRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.enabled = true,
    this.semanticLabel,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final bool enabled;
  final String? semanticLabel;

  @override
  State<UberRadio<T>> createState() => _UberRadioState<T>();
}

class _UberRadioState<T> extends State<UberRadio<T>> with TickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.ease,
    );
    
    if (widget.value == widget.groupValue) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(UberRadio<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == widget.groupValue) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isSelected => widget.value == widget.groupValue;

  Color get _fillColor {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    if (!widget.enabled) {
      return colorScheme.onSurface.withOpacity(0.38);
    }
    
    if (_isSelected) {
      if (_isPressed) {
        return colorScheme.primary.withOpacity(0.8);
      } else if (_isHovered) {
        return colorScheme.primary.withOpacity(0.9);
      }
      return colorScheme.primary;
    }
    
    if (_isPressed) {
      return colorScheme.outline.withOpacity(0.8);
    } else if (_isHovered) {
      return colorScheme.outline.withOpacity(0.9);
    }
    return colorScheme.outline;
  }

  Color get _backgroundColor {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    if (!widget.enabled) {
      return Colors.transparent;
    }
    
    if (_isPressed) {
      if (_isSelected) {
        return colorScheme.primary.withOpacity(0.08);
      }
      return colorScheme.onSurface.withOpacity(0.08);
    } else if (_isHovered) {
      if (_isSelected) {
        return colorScheme.primary.withOpacity(0.04);
      }
      return colorScheme.onSurface.withOpacity(0.04);
    }
    
    return Colors.transparent;
  }

  void _handleTap() {
    if (widget.enabled && widget.onChanged != null) {
      widget.onChanged!(widget.value);
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.enabled) {
      setState(() {
        _isPressed = true;
      });
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.enabled) {
      setState(() {
        _isPressed = false;
      });
    }
  }

  void _handleTapCancel() {
    if (widget.enabled) {
      setState(() {
        _isPressed = false;
      });
    }
  }

  void _handleHover(bool isHovered) {
    if (widget.enabled) {
      setState(() {
        _isHovered = isHovered;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const size = 20.0;
    const strokeWidth = 2.0;
    
    return Semantics(
      label: widget.semanticLabel,
      inMutuallyExclusiveGroup: true,
      checked: _isSelected,
      enabled: widget.enabled,
      child: GestureDetector(
        onTap: _handleTap,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: MouseRegion(
          onEnter: (_) => _handleHover(true),
          onExit: (_) => _handleHover(false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: SizedBox(
                width: size,
                height: size,
                child: CustomPaint(
                  painter: _UberRadioPainter(
                    fillColor: _fillColor,
                    animation: _animation,
                    isSelected: _isSelected,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UberRadioPainter extends CustomPainter {
  const _UberRadioPainter({
    required this.fillColor,
    required this.animation,
    required this.isSelected,
  });

  final Color fillColor;
  final Animation<double> animation;
  final bool isSelected;

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 2.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    final paint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius - strokeWidth / 2, paint);

    if (isSelected) {
      final innerRadius = (radius - strokeWidth - 3) * animation.value;
      if (innerRadius > 0) {
        final innerPaint = Paint()
          ..color = fillColor
          ..style = PaintingStyle.fill;
        
        canvas.drawCircle(center, innerRadius, innerPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_UberRadioPainter oldDelegate) {
    return oldDelegate.fillColor != fillColor ||
           oldDelegate.animation != animation ||
           oldDelegate.isSelected != isSelected;
  }
}

class UberRadioListTile<T> extends StatelessWidget {
  const UberRadioListTile({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.enabled = true,
    this.contentPadding,
    this.semanticLabel,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final Widget title;
  final Widget? subtitle;
  final bool enabled;
  final EdgeInsetsGeometry? contentPadding;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: enabled && onChanged != null ? () => onChanged!(value) : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            UberRadio<T>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              enabled: enabled,
              semanticLabel: semanticLabel,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DefaultTextStyle(
                    style: theme.textTheme.bodyLarge!.copyWith(
                      color: enabled ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withOpacity(0.38),
                    ),
                    child: title,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    DefaultTextStyle(
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: enabled ? theme.colorScheme.onSurface.withOpacity(0.7) : theme.colorScheme.onSurface.withOpacity(0.38),
                      ),
                      child: subtitle!,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}