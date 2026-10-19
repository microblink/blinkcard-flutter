import 'package:flutter/material.dart';
import 'sample_settings_widgets.dart';

class SdkLifecyclePanel extends StatelessWidget {
  final bool deleteCachedResourcesOnUnload;
  final ValueChanged<bool> onDeleteCachedResourcesOnUnloadChanged;
  final VoidCallback onLoadSdk;
  final VoidCallback onUnloadSdk;
  final bool actionsEnabled;

  const SdkLifecyclePanel({
    super.key,
    required this.deleteCachedResourcesOnUnload,
    required this.onDeleteCachedResourcesOnUnloadChanged,
    required this.onLoadSdk,
    required this.onUnloadSdk,
    required this.actionsEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'SDK lifecycle (optional)',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Not required for integration—scan actions initialize the SDK automatically. '
          'Use Load SDK to preload resources and Unload SDK to tear down the native instance.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        SampleExpansionSettingsCard(
          title: 'Load / unload SDK',
          children: [
            SampleBoolSettingTile(
              title: 'Delete cached resources on unload',
              subtitle: 'Full cleanup including downloaded SDK assets',
              value: deleteCachedResourcesOnUnload,
              onChanged: onDeleteCachedResourcesOnUnloadChanged,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: actionsEnabled ? onLoadSdk : null,
                      child: const Text('Load SDK'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: actionsEnabled ? onUnloadSdk : null,
                      child: const Text('Unload SDK'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Divider(height: 24),
      ],
    );
  }
}
