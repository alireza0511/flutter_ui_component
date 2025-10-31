import 'package:flutter/material.dart';

enum UberElevatedButtonSize { small, medium, large }

enum UberElevatedButtonVariant { primary, secondary, destructive }

class UberElevatedButton extends StatefulWidget {
  const UberElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.size = UberElevatedButtonSize.medium,
    this.variant = UberElevatedButtonVariant.primary,
    this.isLoading = false,
    this.enabled = true,
    this.fullWidth = false,
    this.semanticLabel,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final UberElevatedButtonSize size;
  final UberElevatedButtonVariant variant;
  final bool isLoading;
  final bool enabled;
  final bool fullWidth;
  final String? semanticLabel;

  @override
  State<UberElevatedButton> createState() => _UberElevatedButtonState();
}

class _UberElevatedButtonState extends State<UberElevatedButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  EdgeInsets get _padding {
    switch (widget.size) {
      case UberElevatedButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case UberElevatedButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
      case UberElevatedButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    }
  }

  double get _minHeight {
    switch (widget.size) {
      case UberElevatedButtonSize.small:
        return 32;
      case UberElevatedButtonSize.medium:
        return 40;
      case UberElevatedButtonSize.large:
        return 48;
    }
  }

  TextStyle get _textStyle {
    final theme = Theme.of(context);
    switch (widget.size) {
      case UberElevatedButtonSize.small:
        return theme.textTheme.labelMedium!;
      case UberElevatedButtonSize.medium:
        return theme.textTheme.labelLarge!;
      case UberElevatedButtonSize.large:
        return theme.textTheme.titleMedium!;
    }
  }

  Color get _backgroundColor {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    if (!widget.enabled) {
      return colorScheme.onSurface.withOpacity(0.12);
    }

    switch (widget.variant) {
      case UberElevatedButtonVariant.primary:
        if (_isPressed) {
          return colorScheme.primary.withOpacity(0.9);
        } else if (_isHovered) {
          return colorScheme.primary.withOpacity(0.95);
        }
        return colorScheme.primary;
      case UberElevatedButtonVariant.secondary:
        if (_isPressed) {
          return colorScheme.secondaryContainer.withOpacity(0.9);
        } else if (_isHovered) {
          return colorScheme.secondaryContainer.withOpacity(0.95);
        }
        return colorScheme.secondaryContainer;
      case UberElevatedButtonVariant.destructive:
        if (_isPressed) {
          return colorScheme.error.withOpacity(0.9);
        } else if (_isHovered) {
          return colorScheme.error.withOpacity(0.95);
        }
        return colorScheme.error;
    }
  }

  Color get _textColor {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    if (!widget.enabled) {
      return colorScheme.onSurface.withOpacity(0.38);
    }

    switch (widget.variant) {
      case UberElevatedButtonVariant.primary:
        return colorScheme.onPrimary;
      case UberElevatedButtonVariant.secondary:
        return colorScheme.onSecondaryContainer;
      case UberElevatedButtonVariant.destructive:
        return colorScheme.onError;
    }
  }

  double get _elevation {
    if (!widget.enabled) return 0;
    
    if (_isPressed) {
      return 1;
    } else if (_isHovered) {
      return 3;
    }
    return 2;
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.enabled && !widget.isLoading) {
      setState(() {
        _isPressed = true;
      });
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.enabled && !widget.isLoading) {
      setState(() {
        _isPressed = false;
      });
    }
  }

  void _handleTapCancel() {
    if (widget.enabled && !widget.isLoading) {
      setState(() {
        _isPressed = false;
      });
    }
  }

  void _handleHover(bool isHovered) {
    if (widget.enabled && !widget.isLoading) {
      setState(() {
        _isHovered = isHovered;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = widget.enabled && !widget.isLoading ? widget.onPressed : null;
    
    Widget buttonChild = widget.child;
    
    if (widget.isLoading) {
      buttonChild = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(_textColor),
            ),
          ),
          const SizedBox(width: 8),
          widget.child,
        ],
      );
    }

    Widget button = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      constraints: BoxConstraints(minHeight: _minHeight),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: _elevation > 0 ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: _elevation * 2,
            offset: Offset(0, _elevation),
          ),
        ] : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: effectiveOnPressed,
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          onHover: _handleHover,
          child: Padding(
            padding: _padding,
            child: Center(
              child: DefaultTextStyle(
                style: _textStyle.copyWith(color: _textColor),
                child: buttonChild,
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.fullWidth) {
      button = SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return Semantics(
      label: widget.semanticLabel,
      button: true,
      enabled: widget.enabled && !widget.isLoading,
      child: button,
    );
  }
}