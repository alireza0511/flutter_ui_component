import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UberAmountInput extends StatefulWidget {
  const UberAmountInput({
    super.key,
    required this.onChanged,
    this.initialValue,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.currency = '\$',
    this.maxDecimalPlaces = 2,
    this.maxAmount,
    this.minAmount,
    this.semanticLabel,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.textAlign = TextAlign.start,
  });

  final ValueChanged<double?> onChanged;
  final double? initialValue;
  final String? label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final bool enabled;
  final String currency;
  final int maxDecimalPlaces;
  final double? maxAmount;
  final double? minAmount;
  final String? semanticLabel;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextAlign textAlign;

  @override
  State<UberAmountInput> createState() => _UberAmountInputState();
}

class _UberAmountInputState extends State<UberAmountInput> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  String? _internalErrorText;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    
    if (widget.initialValue != null) {
      _controller.text = _formatAmount(widget.initialValue!);
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

  String _formatAmount(double amount) {
    return amount.toStringAsFixed(widget.maxDecimalPlaces).replaceAll(RegExp(r'\.?0+$'), '');
  }

  void _handleTextChange() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() {
        _internalErrorText = null;
      });
      widget.onChanged(null);
      return;
    }

    final parsedValue = double.tryParse(text);
    if (parsedValue == null) {
      setState(() {
        _internalErrorText = 'Please enter a valid amount';
      });
      widget.onChanged(null);
      return;
    }

    if (widget.minAmount != null && parsedValue < widget.minAmount!) {
      setState(() {
        _internalErrorText = 'Amount must be at least ${widget.currency}${_formatAmount(widget.minAmount!)}';
      });
      widget.onChanged(null);
      return;
    }

    if (widget.maxAmount != null && parsedValue > widget.maxAmount!) {
      setState(() {
        _internalErrorText = 'Amount cannot exceed ${widget.currency}${_formatAmount(widget.maxAmount!)}';
      });
      widget.onChanged(null);
      return;
    }

    setState(() {
      _internalErrorText = null;
    });
    widget.onChanged(parsedValue);
  }

  InputDecoration get _decoration {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return InputDecoration(
      labelText: widget.label,
      hintText: widget.hintText ?? 'Enter amount',
      helperText: widget.helperText,
      errorText: widget.errorText ?? _internalErrorText,
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: Text(
          widget.currency,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: widget.enabled ? colorScheme.onSurface : colorScheme.onSurface.withOpacity(0.38),
          ),
        ),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      contentPadding: const EdgeInsets.only(left: 8, right: 16, top: 16, bottom: 16),
      enabled: widget.enabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Semantics(
      label: widget.semanticLabel ?? widget.label,
      textField: true,
      enabled: widget.enabled,
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        enabled: widget.enabled,
        autofocus: widget.autofocus,
        textAlign: widget.textAlign,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,' + widget.maxDecimalPlaces.toString() + r'}')),
        ],
        style: theme.textTheme.bodyLarge?.copyWith(
          color: widget.enabled ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withOpacity(0.38),
        ),
        decoration: _decoration,
      ),
    );
  }
}