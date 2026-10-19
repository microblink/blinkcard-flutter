import 'package:flutter/material.dart';
import 'sample_license_config.dart';
import 'sample_settings_widgets.dart';

class LicenseSettingsPanel extends StatelessWidget {
  final SampleLicenseConfig config;
  final VoidCallback onChanged;

  const LicenseSettingsPanel({
    super.key,
    required this.config,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'License',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Editing the license key for ${config.activePlatformName} on this device. '
          'Changing the key unloads the SDK before the next scan.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        SampleExpansionSettingsCard(
          title: 'License key (${config.activePlatformName})',
          children: [
            SampleMultilineStringSettingField(
              label: 'License key',
              value: config.activeLicenseKey,
              minLines: 3,
              maxLines: 6,
              onChanged: (value) {
                config.activeLicenseKey = value;
                onChanged();
              },
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              config.resetActivePlatformToDefault();
              onChanged();
            },
            child: const Text('Reset license to sample default'),
          ),
        ),
        const Divider(height: 24),
      ],
    );
  }
}
