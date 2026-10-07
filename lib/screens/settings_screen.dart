import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n(context, 'Settings', 'Mga Setting'))),
      body: ListView(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.volume_up_rounded),
            title: Text(l10n(context, 'Sound', 'Tunog')),
            value: s.sound,
            onChanged: s.setSound,
          ),
          SwitchListTile(
            secondary: const Icon(Icons.auto_awesome_rounded),
            title: Text(l10n(context, 'Animation', 'Animasyon')),
            value: s.animation,
            onChanged: s.setAnimation,
          ),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_rounded),
            title: Text(l10n(context, 'Dark Mode', 'Madilim na Tema')),
            value: s.dark,
            onChanged: s.setDark,
          ),
          ListTile(
            leading: const Icon(Icons.text_fields_rounded),
            title: Text(l10n(context, 'Text Size', 'Laki ng Teksto')),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: SegmentedButton<double>(
                emptySelectionAllowed: true,
                showSelectedIcon: false,
                segments: [
                  ButtonSegment<double>(
                      value: 0.9,
                      label: Text(l10n(context, 'Small', 'Maliit'))),
                  ButtonSegment<double>(
                      value: 1.0,
                      label: Text(l10n(context, 'Medium', 'Katamtaman'))),
                  ButtonSegment<double>(
                      value: 1.15,
                      label: Text(l10n(context, 'Large', 'Malaki'))),
                ],
                selected: {s.textScale},
                onSelectionChanged: (v) {
                  if (v.isNotEmpty) s.setTextScale(v.first);
                },
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.restart_alt_rounded, color: C.red),
            title: Text(
                l10n(context, 'Reset Progress', 'I-reset ang Pag-unlad'),
                style: const TextStyle(color: C.red)),
            onTap: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(l10n(
                      context, 'Reset progress?', 'I-reset ang pag-unlad?')),
                  content: Text(l10n(
                      context,
                      'This clears your lessons, scores and difficulty progress on this device.',
                      'Buburahin nito ang mga aralin, marka, at pag-unlad ng antas sa device na ito.')),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text(l10n(context, 'Cancel', 'Kanselahin')),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(l10n(context, 'Reset', 'I-reset'),
                          style: const TextStyle(color: C.red)),
                    ),
                  ],
                ),
              );
              if (ok == true) s.resetProgress();
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: Text(l10n(context, 'About AccelLab', 'Tungkol sa AccelLab')),
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'AccelLab',
              applicationVersion: '1.0.0',
              children: [
                Text(l10n(
                    context,
                    'Learn. Move. Accelerate!\n\n'
                        'An offline app for learning acceleration. Everything, including your '
                        'progress, is stored on this device.',
                    'Matuto. Gumalaw. Bumilis!\n\nIsang offline na app para matutuhan ang akselerasyon. Naka-save sa device na ito ang lahat, pati ang iyong pag-unlad.')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
