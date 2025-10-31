import 'package:flutter/material.dart';

enum UberTextButtonSize { small, medium, large }

enum UberTextButtonVariant { primary, secondary, destructive }

class UberTextButton extends StatefulWidget {
  const UberTextButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.size = UberTextButtonSize.medium,
    this.variant = UberTextButtonVariant.primary,
    this.isLoading = false,
    this.enabled = true,
    this.fullWidth = false,
    this.semanticLabel,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final UberTextButtonSize size;
  final UberTextButtonVariant variant;
  final bool isLoading;
  final bool enabled;
  final bool fullWidth;
  final String? semanticLabel;

  @override
  State<UberTextButton> createState() => _UberTextButtonState();
}

class _UberTextButtonState extends State<UberTextButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  EdgeInsets get _padding {
    switch (widget.size) {
      case UberTextButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case UberTextButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
      case UberTextButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    }
  }

  TextStyle get _textStyle {
    final theme = Theme.of(context);
    switch (widget.size) {
      case UberTextButtonSize.small:
        return theme.textTheme.labelMedium!;
      case UberTextButtonSize.medium:
        return theme.textTheme.labelLarge!;
      case UberTextButtonSize.large:
        return theme.textTheme.titleMedium!;
    }
  }

  Color get _textColor {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    if (!widget.enabled) {
      return colorScheme.onSurface.withOpacity(0.38);
    }

    switch (widget.variant) {
      case UberTextButtonVariant.primary:
        if (_isPressed) {
          return colorScheme.primary.withOpacity(0.8);
        } else if (_isHovered) {
          return colorScheme.primary.withOpacity(0.9);
        }
        return colorScheme.primary;
      case UberTextButtonVariant.secondary:
        if (_isPressed) {
          return colorScheme.secondary.withOpacity(0.8);
        } else if (_isHovered) {
          return colorScheme.secondary.withOpacity(0.9);
        }
        return colorScheme.secondary;
      case UberTextButtonVariant.destructive:
        if (_isPressed) {
          return colorScheme.error.withOpacity(0.8);
        } else if (_isHovered) {
          return colorScheme.error.withOpacity(0.9);
        }
        return colorScheme.error;
    }
  }

  Color get _backgroundColor {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    if (!widget.enabled) {
      return Colors.transparent;
    }

    if (_isPressed) {
      switch (widget.variant) {
        case UberTextButtonVariant.primary:
          return colorScheme.primary.withOpacity(0.08);
        case UberTextButtonVariant.secondary:
          return colorScheme.secondary.withOpacity(0.08);
        case UberTextButtonVariant.destructive:
          return colorScheme.error.withOpacity(0.08);
      }
    } else if (_isHovered) {
      switch (widget.variant) {
        case UberTextButtonVariant.primary:
          return colorScheme.primary.withOpacity(0.04);
        case UberTextButtonVariant.secondary:
          return colorScheme.secondary.withOpacity(0.04);
        case UberTextButtonVariant.destructive:
          return colorScheme.error.withOpacity(0.04);
      }
    }

    return Colors.transparent;
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
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(8),
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
            child: DefaultTextStyle(
              style: _textStyle.copyWith(color: _textColor),
              child: buttonChild,
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