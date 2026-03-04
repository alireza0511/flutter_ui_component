import 'package:flutter/material.dart';
import 'package:flutter_ui_component/flutter_ui_component.dart';

final List<AccountItem> sampleAccounts = [
  const AccountItem(
    id: 'checking_1',
    displayName: 'Checking Account...1234',
    group: 'cash',
    details: [
      (label: 'Account Type', value: 'Checking'),
      (label: 'Account Balance', value: '\$5,432.10'),
    ],
  ),
  AccountItem(
    id: 'savings_1',
    displayName: 'Savings Account...5678',
    group: 'cash',
    details: const [
      (label: 'Account Type', value: 'Savings'),
      (label: 'Account Balance', value: '\$12,750.00'),
    ],
    subItems: const [
      SubAccountItem(
        id: 'goal_vacation',
        displayName: 'Vacation to Switzerland...',
        balance: 3200.00,
        icon: Icons.flight,
      ),
      SubAccountItem(
        id: 'goal_emergency',
        displayName: 'Emergency Fund',
        balance: 8500.00,
        icon: Icons.shield,
      ),
      SubAccountItem(
        id: 'goal_car',
        displayName: 'New Car Savings',
        balance: 1050.00,
        icon: Icons.directions_car,
      ),
    ],
  ),
  const AccountItem(
    id: 'pcl_1',
    displayName: 'Personal Credit Line...9012',
    group: 'credit',
    details: [
      (label: 'Account Type', value: 'Personal Credit Line'),
      (label: 'Available Credit', value: '\$7,500.00'),
    ],
  ),
  const AccountItem(
    id: 'cc_1',
    displayName: 'Platinum Credit Card...3456',
    group: 'credit',
    details: [
      (label: 'Account Type', value: 'Credit Card'),
      (label: 'Available Credit', value: '\$4,200.00'),
      (label: 'Current Balance', value: '\$1,823.45'),
    ],
  ),
  const AccountItem(
    id: 'cc_2',
    displayName: 'Business Credit Card...7890',
    group: 'credit',
    details: [
      (label: 'Account Type', value: 'Credit Card'),
      (label: 'Available Credit', value: '\$10,000.00'),
      (label: 'Current Balance', value: '\$456.78'),
    ],
    isEnabled: false,
  ),
];

class AccountSelectionExampleScreen extends StatefulWidget {
  const AccountSelectionExampleScreen({super.key});

  @override
  State<AccountSelectionExampleScreen> createState() =>
      _AccountSelectionExampleScreenState();
}

class _AccountSelectionExampleScreenState
    extends State<AccountSelectionExampleScreen> {
  String? _selectedAccountId;
  String _lastAction = 'No selection yet';

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Selection'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Selection Component',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Presentation-agnostic account selector with multiple display modes',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),

            // Status display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _lastAction,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Presentation mode buttons
            Text(
              'Presentation Modes',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // Bottom Sheet
            SizedBox(
              width: double.infinity,
              child: UberElevatedButton(
                onPressed: () async {
                  final result = await showAccountSelectionBottomSheet(
                    context,
                    title: 'Transfer From',
                    subtitle: 'Select an eligible account.',
                    accounts: sampleAccounts,
                    selectedAccountId: 'checking_1',
                    
                    // _selectedAccountId,
                    showInfoBanner: true,
                    infoMessage:
                        'Only accounts with sufficient balance are available for transfer.',
                  );
                  if (result != null) {
                    setState(() {
                      _selectedAccountId = result.id;
                      _lastAction =
                          'Bottom Sheet → Selected: ${result.displayName}';
                    });
                    _showSnackBar('Selected: ${result.displayName}');
                  }
                },
                child: const Text('Open as Bottom Sheet'),
              ),
            ),
            const SizedBox(height: 12),

            // Full-screen modal
            SizedBox(
              width: double.infinity,
              child: UberElevatedButton(
                onPressed: () async {
                  final result = await showAccountSelectionModal(
                    context,
                    title: 'Transfer From',
                    subtitle: 'Select an eligible account.',
                    accounts: sampleAccounts,
                    selectedAccountId: _selectedAccountId,
                    showInfoBanner: true,
                    infoMessage:
                        'Only accounts with sufficient balance are available for transfer.',
                  );
                  if (result != null) {
                    setState(() {
                      _selectedAccountId = result.id;
                      _lastAction =
                          'Full-Screen Modal → Selected: ${result.displayName}';
                    });
                    _showSnackBar('Selected: ${result.displayName}');
                  }
                },
                variant: UberElevatedButtonVariant.secondary,
                child: const Text('Open as Full-Screen Modal'),
              ),
            ),
            const SizedBox(height: 12),

            // Standalone screen
            SizedBox(
              width: double.infinity,
              child: UberElevatedButton(
                onPressed: () async {
                  final result = await Navigator.of(context).push<AccountItem>(
                    MaterialPageRoute(
                      builder: (context) => AccountSelectionScreen(
                        title: 'Transfer From',
                        subtitle: 'Select an eligible account.',
                        accounts: sampleAccounts,
                        selectedAccountId: _selectedAccountId,
                        showInfoBanner: true,
                        infoMessage:
                            'Only accounts with sufficient balance are available for transfer.',
                      ),
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      _selectedAccountId = result.id;
                      _lastAction =
                          'Screen Route → Selected: ${result.displayName}';
                    });
                    _showSnackBar('Selected: ${result.displayName}');
                  }
                },
                variant: UberElevatedButtonVariant.secondary,
                child: const Text('Open as Standalone Screen'),
              ),
            ),
            const SizedBox(height: 32),

            // Inline embed section
            Text(
              'Inline Embed',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'The same content widget embedded directly in the page',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 12),

            Container(
              height: 420,
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outline),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AccountSelectionContent(
                  title: 'Transfer From',
                  subtitle: 'Select an eligible account.',
                  accounts: sampleAccounts,
                  selectedAccountId: _selectedAccountId,
                  showCloseButton: false,
                  onAccountSelected: (account, sub) {
                    setState(() {
                      _selectedAccountId = account.id;
                      _lastAction =
                          'Inline → Selected: ${account.displayName}';
                    });
                    _showSnackBar('Selected: ${account.displayName}');
                  },
                  showInfoBanner: true,
                  infoMessage:
                      'Only accounts with sufficient balance are available for transfer.',
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
