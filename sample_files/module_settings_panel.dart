import 'package:blinkcard_flutter/blinkcard_flutter.dart';
import 'package:flutter/material.dart';
import 'sample_settings_widgets.dart';
import 'scanning_settings_config.dart';

const _tiltSensitivityLevels = <SensitivityLevel>[
  SensitivityLevel.off,
  SensitivityLevel.low,
  SensitivityLevel.mid,
  SensitivityLevel.high,
];

class ModuleSettingsPanel extends StatelessWidget {
  final ScanningSettingsConfig config;
  final VoidCallback onChanged;

  const ModuleSettingsPanel({
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
          'Scanning settings',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Settings apply to all scan actions below.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        SampleExpansionSettingsCard(
          title: 'Image quality & framing',
          subtitle: 'Input image margin applies to camera scan (video) only',
          children: [
            SampleBoolSettingTile(
              title: 'Skip images with blur',
              subtitle: 'Reject blurred frames during scanning',
              value: config.skipImagesWithBlur,
              onChanged: (value) {
                config.skipImagesWithBlur = value;
                onChanged();
              },
            ),
            SampleEnumDropdown<SensitivityLevel>(
              label: 'Tilt sensitivity level',
              value: config.tiltSensitivityLevel,
              options: _tiltSensitivityLevels,
              onChanged: (level) {
                config.tiltSensitivityLevel = level;
                onChanged();
              },
            ),
            SampleDoubleSettingField(
              label: 'Input image margin',
              value: config.inputImageMargin,
              min: 0.0,
              max: 1.0,
              onChanged: (value) {
                config.inputImageMargin = value;
                onChanged();
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        SampleExpansionSettingsCard(
          title: 'Extraction',
          subtitle: 'Fields to read from the card',
          children: [
            SampleBoolSettingTile(
              title: 'Extract IBAN',
              value: config.extractIban,
              onChanged: (value) {
                config.extractIban = value;
                onChanged();
              },
            ),
            SampleBoolSettingTile(
              title: 'Extract expiry date',
              value: config.extractExpiryDate,
              onChanged: (value) {
                config.extractExpiryDate = value;
                onChanged();
              },
            ),
            SampleBoolSettingTile(
              title: 'Extract cardholder name',
              value: config.extractCardholderName,
              onChanged: (value) {
                config.extractCardholderName = value;
                onChanged();
              },
            ),
            SampleBoolSettingTile(
              title: 'Extract CVV',
              value: config.extractCvv,
              onChanged: (value) {
                config.extractCvv = value;
                onChanged();
              },
            ),
            SampleBoolSettingTile(
              title: 'Extract invalid card number',
              subtitle: 'Accept card numbers that fail Luhn checksum',
              value: config.extractInvalidCardNumber,
              onChanged: (value) {
                config.extractInvalidCardNumber = value;
                onChanged();
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        SampleExpansionSettingsCard(
          title: 'Cropped image',
          subtitle: 'Card image returned in the scan result',
          children: [
            SampleBoolSettingTile(
              title: 'Return card image',
              value: config.returnCardImage,
              onChanged: (value) {
                config.returnCardImage = value;
                onChanged();
              },
            ),
            SampleIntSettingField(
              label: 'Dots per inch',
              value: config.croppedImageDotsPerInch,
              min: 100,
              max: 400,
              onChanged: (value) {
                config.croppedImageDotsPerInch = value;
                onChanged();
              },
            ),
            SampleDoubleSettingField(
              label: 'Extension factor',
              value: config.croppedImageExtensionFactor,
              min: 0.0,
              max: 1.0,
              onChanged: (value) {
                config.croppedImageExtensionFactor = value;
                onChanged();
              },
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              config.resetScanningSettingsToDefaults();
              onChanged();
            },
            child: const Text('Reset scanning settings to defaults'),
          ),
        ),
        const Divider(height: 24),
      ],
    );
  }
}
