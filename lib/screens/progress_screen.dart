import 'package:flutter/material.dart';
import '../data/content.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'difficulty_screen.dart';
import 'review_screen.dart';
import 'settings_screen.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  Widget _bar(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text('${(value * 100).round()}%',
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
        const SizedBox(height: 6),
        AnimatedBar(value: value, color: color),
      ]),
    );
  }

  Widget _stat(IconData icon, Color color, String value, String label) {
    return Expanded(
      child: AppCard(
        child: Column(children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(
                begin: 0, end: double.parse(value.split('/').first)),
            duration: const Duration(milliseconds: 900),
            builder: (_, v, __) => Text(
              value.contains('/')
                  ? '${v.round()}/${value.split('/').last}'
                  : '${v.round()}',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
          Text(label, style: const TextStyle(fontSize: 12)),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final lv = levels[s.level - 1];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Reveal(
          child: PageHeader(l10n(context, 'My Progress', 'Aking Pag-unlad'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.stairs_rounded),
                  onPressed: () => go(context, const DifficultyScreen()),
                ),
                IconButton(
                  icon: const Icon(Icons.settings_rounded),
                  onPressed: () => go(context, const SettingsScreen()),
                ),
              ]),
        ),
        Reveal(
          index: 1,
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(colors: [C.navy, lv.color]),
            ),
            child: Row(children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white24,
                child: Text('${s.level}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          l10n(context, 'Current Difficulty',
                              'Kasalukuyang Antas'),
                          style: const TextStyle(color: Colors.white70)),
                      Text(lv.nameFor(s.tagalog),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      Text(
                          l10n(
                              context,
                              'Difficulty ${s.level} of ${levels.length}',
                              'Antas ${s.level} sa ${levels.length}'),
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12)),
                    ]),
              ),
            ]),
          ),
        ),
        const SizedBox(height: 14),
        Reveal(
          index: 2,
          child: AppCard(
            child: Column(children: [
              _bar(l10n(context, 'Lessons', 'Mga Aralin'), s.lessonsPct,
                  C.green),
              _bar(l10n(context, 'Practice', 'Pagsasanay'), s.practicePct,
                  C.blue),
              _bar(l10n(context, 'Challenge', 'Hamon'), s.challengePct,
                  C.orange),
            ]),
          ),
        ),
        const SizedBox(height: 14),
        Reveal(
          index: 3,
          child: Row(children: [
            _stat(Icons.calculate, C.blue, '${s.problemsSolved}',
                l10n(context, 'Problems solved', 'Mga Nalutas na Problema')),
            const SizedBox(width: 12),
            _stat(Icons.stairs_rounded, C.yellow, '${s.level}/${levels.length}',
                l10n(context, 'Difficulty', 'Antas')),
          ]),
        ),
        const SizedBox(height: 18),
        Reveal(
          index: 4,
          child: Text(
              l10n(context, 'Difficulty Levels', 'Mga Antas ng Kahirapan'),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 10),
        for (int i = 0; i < levels.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Reveal(
              index: 5 + i,
              child: AppCard(
                padding: const EdgeInsets.all(12),
                color: s.level == i + 1
                    ? levels[i].color.withValues(alpha: 0.18)
                    : null,
                child: Row(children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: levels[i].color,
                    child: Text('${i + 1}',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(levels[i].nameFor(s.tagalog),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text(levels[i].descFor(s.tagalog),
                              style: TextStyle(
                                  fontSize: 12, color: subText(context))),
                        ]),
                  ),
                  if (s.level > i + 1)
                    const Icon(Icons.check_circle, color: C.green)
                  else if (s.level == i + 1)
                    Text(l10n(context, 'You are here', 'Nandito ka'),
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold))
                  else
                    Icon(Icons.chevron_right,
                        color: subText(context), size: 20),
                ]),
              ),
            ),
          ),
        const SizedBox(height: 18),
        Reveal(
          index: 9,
          child: Row(children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => go(context, const DifficultyScreen()),
                icon: const Icon(Icons.stairs_rounded),
                label: Text(l10n(context, 'Difficulties', 'Mga Antas')),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => go(context, const ReviewScreen()),
                icon: const Icon(Icons.replay_rounded),
                label: Text(l10n(context, 'Review', 'Balikan')),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
