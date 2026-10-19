import 'package:blinkcard_flutter/blinkcard_flutter.dart';
import 'package:flutter/material.dart';
import 'sample_redaction_options.dart';
import 'sample_settings_widgets.dart';
import 'scanning_settings_config.dart';

class OptionalScanSettingsPanel extends StatelessWidget {
  final ScanningSettingsConfig config;
  final VoidCallback onChanged;

  const OptionalScanSettingsPanel({
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
          'Optional scan settings',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Redaction applies to all scan actions below. '
          'Toggle off: native SDK default policy (still redacts). '
          'Toggle on: custom settings. For unredacted data, set all modes to none.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        SampleModuleCard(
          title: 'Redaction settings',
          subtitle: config.redactionSettingsEnabled
              ? 'Custom redaction'
              : 'No custom redaction - SDK defaults apply',
          enabled: config.redactionSettingsEnabled,
          onEnabledChanged: (enabled) {
            config.redactionSettingsEnabled = enabled;
            onChanged();
          },
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Requires matching extraction flags (e.g. CVV redaction needs '
                'extractCvv). Use returned card images to verify image redaction.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            SampleEnumDropdown<RedactionMode>(
              label: 'Cardholder name',
              value: config.cardholderNameRedactionMode,
              options: redactionModes,
              onChanged: (mode) {
                config.cardholderNameRedactionMode = mode;
                onChanged();
              },
            ),
            SampleEnumDropdown<RedactionMode>(
              label: 'CVV',
              value: config.cvvRedactionMode,
              options: redactionModes,
              onChanged: (mode) {
                config.cvvRedactionMode = mode;
                onChanged();
              },
            ),
            SampleEnumDropdown<RedactionMode>(
              label: 'IBAN',
              value: config.ibanRedactionMode,
              options: redactionModes,
              onChanged: (mode) {
                config.ibanRedactionMode = mode;
                onChanged();
              },
            ),
            const SampleSectionLabel('Card number'),
            SampleEnumDropdown<RedactionMode>(
              label: 'Card number mode',
              value: config.cardNumberRedactionMode,
              options: redactionModes,
              onChanged: (mode) {
                config.cardNumberRedactionMode = mode;
                onChanged();
              },
            ),
            SampleIntSettingField(
              label: 'Prefix digits visible',
              value: config.cardNumberPrefixDigitsVisible,
              min: 0,
              max: 20,
              updateOnEveryChange: true,
              onChanged: (value) {
                config.cardNumberPrefixDigitsVisible = value;
                onChanged();
              },
            ),
            SampleIntSettingField(
              label: 'Suffix digits visible',
              value: config.cardNumberSuffixDigitsVisible,
              min: 0,
              max: 20,
              updateOnEveryChange: true,
              onChanged: (value) {
                config.cardNumberSuffixDigitsVisible = value;
                onChanged();
              },
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              config.resetRedactionToDefaults();
              onChanged();
            },
            child: const Text('Reset redaction to defaults'),
          ),
        ),
        const Divider(height: 24),
      ],
    );
  }
}
