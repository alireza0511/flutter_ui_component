import 'package:flutter/material.dart';

class AccountGroupHeader extends StatelessWidget {
  const AccountGroupHeader({
    super.key,
    required this.label,
    this.subLabel,
  });

  final String label;
  final Widget? subLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (subLabel != null) ...[
            const SizedBox(height: 4),
            subLabel!,
          ],
        ],
      ),
    );
  }
}
