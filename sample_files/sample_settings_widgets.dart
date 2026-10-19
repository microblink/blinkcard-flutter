import 'package:flutter/material.dart';

class SampleModuleCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool enabled;
  final ValueChanged<bool> onEnabledChanged;
  final List<Widget> children;

  const SampleModuleCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.enabled,
    required this.onEnabledChanged,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: enabled
          ? theme.colorScheme.surfaceContainerLow
          : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: false,
          enabled: enabled,
          title: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: enabled
                            ? null
                            : theme.colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              Switch(
                value: enabled,
                onChanged: onEnabledChanged,
              ),
            ],
          ),
          children: enabled
              ? [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
                    child: Column(children: children),
                  ),
                ]
              : const [],
        ),
      ),
    );
  }
}

class SampleBoolSettingTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SampleBoolSettingTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      value: value,
      onChanged: onChanged,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

class SampleSectionLabel extends StatelessWidget {
  final String text;

  const SampleSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class SampleMultilineStringSettingField extends StatefulWidget {
  final String label;
  final String value;
  final int minLines;
  final int maxLines;
  final ValueChanged<String> onChanged;

  const SampleMultilineStringSettingField({
    super.key,
    required this.label,
    required this.value,
    this.minLines = 3,
    this.maxLines = 6,
    required this.onChanged,
  });

  @override
  State<SampleMultilineStringSettingField> createState() =>
      _SampleMultilineStringSettingFieldState();
}

class _SampleMultilineStringSettingFieldState
    extends State<SampleMultilineStringSettingField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(SampleMultilineStringSettingField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _commit() {
    widget.onChanged(_controller.text);
  }

  void _commitAndDismiss() {
    _commit();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: widget.label,
          isDense: true,
          border: const OutlineInputBorder(),
          alignLabelWithHint: true,
        ),
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        autocorrect: false,
        enableSuggestions: false,
        textInputAction: TextInputAction.done,
        onTapOutside: (_) => _commitAndDismiss(),
        onFieldSubmitted: (_) => _commitAndDismiss(),
        onEditingComplete: _commitAndDismiss,
      ),
    );
  }
}

class SampleEnumDropdown<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<T> options;
  final ValueChanged<T> onChanged;

  const SampleEnumDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  String _labelFor(T option) {
    if (option is Enum) {
      return option.name;
    }
    return option.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: DropdownButtonFormField<T>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          border: const OutlineInputBorder(),
        ),
        items: options
            .map(
              (option) => DropdownMenuItem(
                value: option,
                child: Text(_labelFor(option)),
              ),
            )
            .toList(),
        onChanged: (selected) {
          if (selected != null) {
            onChanged(selected);
          }
        },
      ),
    );
  }
}

class SampleExpansionSettingsCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> children;

  const SampleExpansionSettingsCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
              child: Column(children: children),
            ),
          ],
        ),
      ),
    );
  }
}

class SampleDoubleSettingField extends StatefulWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const SampleDoubleSettingField({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  State<SampleDoubleSettingField> createState() =>
      _SampleDoubleSettingFieldState();
}

class _SampleDoubleSettingFieldState extends State<SampleDoubleSettingField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
  }

  @override
  void didUpdateWidget(SampleDoubleSettingField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value &&
        _controller.text != widget.value.toString()) {
      _controller.text = widget.value.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _commit() {
    final parsed = double.tryParse(_controller.text);
    if (parsed != null && parsed >= widget.min && parsed <= widget.max) {
      widget.onChanged(parsed);
    } else {
      _controller.text = widget.value.toString();
    }
  }

  void _commitAndDismiss() {
    _commit();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: widget.label,
          helperText: '${widget.min}–${widget.max}',
          isDense: true,
          border: const OutlineInputBorder(),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.done,
        onTapOutside: (_) => _commitAndDismiss(),
        onFieldSubmitted: (_) => _commitAndDismiss(),
        onEditingComplete: _commitAndDismiss,
      ),
    );
  }
}

class SampleIntSettingField extends StatefulWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  /// When true, [onChanged] is invoked whenever the text field contains a valid
  /// value in range (not only on blur/submit).
  final bool updateOnEveryChange;

  const SampleIntSettingField({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.updateOnEveryChange = false,
  });

  @override
  State<SampleIntSettingField> createState() => _SampleIntSettingFieldState();
}

class _SampleIntSettingFieldState extends State<SampleIntSettingField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '${widget.value}');
    if (widget.updateOnEveryChange) {
      _controller.addListener(_onControllerChanged);
    }
  }

  @override
  void didUpdateWidget(SampleIntSettingField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.updateOnEveryChange != widget.updateOnEveryChange) {
      if (widget.updateOnEveryChange) {
        _controller.addListener(_onControllerChanged);
      } else {
        _controller.removeListener(_onControllerChanged);
      }
    }
    if (oldWidget.value != widget.value &&
        _controller.text != '${widget.value}') {
      _controller.text = '${widget.value}';
    }
  }

  @override
  void dispose() {
    if (widget.updateOnEveryChange) {
      _controller.removeListener(_onControllerChanged);
    }
    _controller.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    final parsed = int.tryParse(_controller.text);
    if (parsed != null &&
        parsed >= widget.min &&
        parsed <= widget.max &&
        parsed != widget.value) {
      widget.onChanged(parsed);
    }
  }

  void _commit() {
    final parsed = int.tryParse(_controller.text);
    if (parsed != null && parsed >= widget.min && parsed <= widget.max) {
      widget.onChanged(parsed);
    } else {
      _controller.text = '${widget.value}';
    }
  }

  void _commitAndDismiss() {
    _commit();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: widget.label,
          helperText: '${widget.min}–${widget.max}',
          isDense: true,
          border: const OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        onTapOutside: (_) => _commitAndDismiss(),
        onFieldSubmitted: (_) => _commitAndDismiss(),
        onEditingComplete: _commitAndDismiss,
      ),
    );
  }
}
