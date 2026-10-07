import 'package:flutter/material.dart';
import '../data/content.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'topic_actions_screen.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Reveal(
          child: Row(children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n(context, 'Learn', 'Matuto'),
                        style: const TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold)),
                    Text(
                        l10n(context, 'Choose a topic to get started.',
                            'Pumili ng paksa upang magsimula.'),
                        style: TextStyle(color: subText(context))),
                  ]),
            ),
          ]),
        ),
        const SizedBox(height: 14),
        PageHeader(
          l10n(context, 'Topics', 'Mga Paksa'),
          subtitle: l10n(context, 'Finish each difficulty to unlock the next.',
              'Tapusin ang bawat antas upang mabuksan ang kasunod.'),
        ),
        for (int d = 0; d < levels.length; d++) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 8),
            child: Row(children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: s.isDifficultyUnlocked(d + 1)
                    ? levels[d].color
                    : subText(context),
                child: Text('${d + 1}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(levels[d].nameFor(s.tagalog),
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold))),
              if (!s.isDifficultyUnlocked(d + 1)) ...[
                Icon(Icons.lock_rounded, size: 16, color: subText(context)),
                const SizedBox(width: 4),
                Text(
                    '${l10n(context, 'Finish', 'Tapusin')} ${levels[d - 1].nameFor(s.tagalog)}',
                    style: TextStyle(fontSize: 11, color: subText(context))),
              ],
            ]),
          ),
          for (final lesson
              in lessons.where((item) => item.difficulty == d + 1))
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Reveal(
                index: lesson.id,
                child: AppCard(
                  onTap: s.isDifficultyUnlocked(d + 1)
                      ? () => go(context, TopicActionsScreen(lesson: lesson))
                      : null,
                  color: s.isDifficultyUnlocked(d + 1)
                      ? null
                      : subText(context).withValues(alpha: 0.06),
                  child: Row(children: [
                    CircleAvatar(
                        radius: 20,
                        backgroundColor: lesson.color,
                        child: Text('${lesson.id}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold))),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(lesson.titleFor(s.tagalog),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text(lesson.shortFor(s.tagalog),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: subText(context), fontSize: 13)),
                        ])),
                    Icon(
                      !s.isDifficultyUnlocked(d + 1)
                          ? Icons.lock_rounded
                          : (s.completed.contains(lesson.id)
                              ? Icons.check_circle
                              : Icons.chevron_right),
                      color: s.completed.contains(lesson.id)
                          ? C.green
                          : subText(context),
                    ),
                  ]),
                ),
              ),
            ),
        ],
      ],
    );
  }
}
