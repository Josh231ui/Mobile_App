import 'package:flutter/material.dart';
import '../data/content.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'lesson_screen.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final completedCount = s.completed.length.clamp(0, lessons.length);
    final progress = lessons.isEmpty ? 0.0 : completedCount / lessons.length;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Reveal(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xff0755ce), Color(0xff168df0), C.teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: C.blue.withValues(alpha: .2),
                  blurRadius: 16,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .18),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Icon(Icons.menu_book_rounded,
                        color: Colors.white, size: 23),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n(context, 'ACCELLAB · LEARN',
                                'ACCELLAB · MATUTO'),
                            style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1),
                          ),
                          Text(
                            l10n(context, 'Learn', 'Matuto'),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                height: 1.1,
                                fontWeight: FontWeight.w900),
                          ),
                        ]),
                  ),
                  const Icon(Icons.speed_rounded, color: C.yellow, size: 34),
                ]),
                const SizedBox(height: 8),
                Text(
                  l10n(context, 'Choose a session to get started.',
                      'Pumili ng sesyon upang magsimula.'),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 7,
                        backgroundColor: Colors.white24,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(C.yellow),
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Text(
                    '$completedCount/${lessons.length}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 12),
                  ),
                ]),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        PageHeader(
          l10n(context, 'Sessions', 'Mga Sesyon'),
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
                      ? () => go(context, LessonScreen(lesson: lesson))
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
                          Text(
                              '${l10n(context, 'Session', 'Sesyon')} ${lesson.id}: ${lesson.titleFor(s.tagalog)}',
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
