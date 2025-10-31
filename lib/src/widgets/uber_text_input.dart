import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum UberTextInputType { text, email, password, multiline }

class UberTextInput extends StatefulWidget {
  const UberTextInput({
    super.key,
    required this.onChanged,
    this.initialValue,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.type = UberTextInputType.text,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.semanticLabel,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
  });

  final ValueChanged<String> onChanged;
  final String? initialValue;
  final String? label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final bool enabled;
  final UberTextInputType type;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final String? semanticLabel;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<UberTextInput> createState() => _UberTextInputState();
}

class _UberTextInputState extends State<UberTextInput> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _obscureText = false;
  String? _internalErrorText;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _obscureText = widget.type == UberTextInputType.password;
    
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
    
    _controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleTextChange() {
    final text = _controller.text;
    
    if (widget.validator != null) {
      setState(() {
        _internalErrorText = widget.validator!(text);
      });
    }
    
    widget.onChanged(text);
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  TextInputType get _keyboardType {
    switch (widget.type) {
      case UberTextInputType.email:
        return TextInputType.emailAddress;
      case UberTextInputType.multiline:
        return TextInputType.multiline;
      case UberTextInputType.text:
      case UberTextInputType.password:
        return TextInputType.text;
    }
  }

  int? get _effectiveMaxLines {
    if (widget.type == UberTextInputType.multiline) {
      return widget.maxLines ?? 5;
    }
    return widget.maxLines ?? 1;
  }

  int? get _effectiveMinLines {
    if (widget.type == UberTextInputType.multiline) {
      return widget.minLines ?? 3;
    }
    return widget.minLines;
  }

  Widget? get _effectiveSuffixIcon {
    if (widget.type == UberTextInputType.password) {
      return IconButton(
        icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        onPressed: _togglePasswordVisibility,
        tooltip: _obscureText ? 'Show password' : 'Hide password',
      );
    }
    return widget.suffixIcon;
  }

  List<TextInputFormatter>? get _effectiveInputFormatters {
    List<TextInputFormatter> formatters = widget.inputFormatters ?? [];
    
    if (widget.type == UberTextInputType.email) {
      formatters.add(FilteringTextInputFormatter.deny(RegExp(r'\s')));
    }
    
    if (widget.maxLength != null) {
      formatters.add(LengthLimitingTextInputFormatter(widget.maxLength));
    }
    
    return formatters.isNotEmpty ? formatters : null;
  }

  InputDecoration get _decoration {
    return InputDecoration(
      labelText: widget.label,
      hintText: widget.hintText,
      helperText: widget.helperText,
      errorText: widget.errorText ?? _internalErrorText,
      prefixIcon: widget.prefixIcon,
      suffixIcon: _effectiveSuffixIcon,
      enabled: widget.enabled,
      counterText: widget.maxLength != null ? '${_controller.text.length}/${widget.maxLength}' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Semantics(
      label: widget.semanticLabel ?? widget.label,
      textField: true,
      enabled: widget.enabled,
      obscured: widget.type == UberTextInputType.password && _obscureText,
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        enabled: widget.enabled,
        autofocus: widget.autofocus,
        textAlign: widget.textAlign,
        textCapitalization: widget.textCapitalization,
        keyboardType: _keyboardType,
        obscureText: widget.type == UberTextInputType.password && _obscureText,
        maxLines: _effectiveMaxLines,
        minLines: _effectiveMinLines,
        inputFormatters: _effectiveInputFormatters,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: widget.enabled ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withOpacity(0.38),
        ),
        decoration: _decoration,
      ),
    );
  }
}