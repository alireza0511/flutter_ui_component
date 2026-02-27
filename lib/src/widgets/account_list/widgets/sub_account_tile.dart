import 'package:flutter/material.dart';
import 'package:flutter_ui_component/src/widgets/account_list/widgets/account_selection_bar.dart';
import '../models/sub_account_item.dart';

class SubAccountTile extends StatelessWidget {
  const SubAccountTile({
    super.key,
    required this.item,
    this.isSelected = false,
    this.onTap,
  });

  final SubAccountItem item;
  final bool isSelected;
  final VoidCallback? onTap;

  static const _selectedBarWidth = 4.0;
  static const _borderRadius = 8.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding:  EdgeInsets.fromLTRB( 12,2, 0, 2),
      child: Card(
        margin: EdgeInsets.zero,
        
        elevation: isSelected ? 2 : 1,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(_borderRadius),
        //   side: BorderSide(
        //     color: isSelected
        //         ? theme.colorScheme.tertiary
        //         : theme.colorScheme.outline.withOpacity(0.3),
        //     width: isSelected ? 1.5 : 1,
        //   ),
        // ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(_borderRadius),
          child: IntrinsicHeight(
            child: Row(
              children: [
                AccountSelectionBar(isSelected: isSelected),
                // AnimatedContainer(
                //   duration: const Duration(milliseconds: 200),
                //   width: _selectedBarWidth,
                //   decoration: BoxDecoration(
                //     color: isSelected
                //         ? theme.colorScheme.tertiary
                //         : Colors.transparent,
                //   ),
                // ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    child: Row(
                      children: [
                        if (item.icon != null) ...[
                          Icon(
                            item.icon,
                            size: 18,
                            color: theme.colorScheme.onSurface
                                .withOpacity(0.7),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Expanded(
                          child: Text(
                            item.displayName,
                            style: theme.textTheme.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '\$${item.balance.toStringAsFixed(2)}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
