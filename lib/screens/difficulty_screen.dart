import 'package:flutter/material.dart';
import '../data/content.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'topic_actions_screen.dart';

class DifficultyScreen extends StatelessWidget {
  const DifficultyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n(context, 'Difficulties', 'Mga Antas'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PageHeader(l10n(context, 'Choose a Difficulty', 'Pumili ng Antas'),
              subtitle: l10n(
                  context,
                  'Acceleration topics get more challenging at each level.',
                  'Mas nagiging mahirap ang mga paksa sa bawat antas.')),
          for (int i = 0; i < levels.length; i++) ...[
            const SizedBox(height: 12),
            _DifficultyGroup(
              levelIndex: i,
              completed: s.completed,
              unlocked: s.isDifficultyUnlocked(i + 1),
            ),
          ],
        ],
      ),
    );
  }
}

class _DifficultyGroup extends StatelessWidget {
  final int levelIndex;
  final Set<int> completed;
  final bool unlocked;
  const _DifficultyGroup({
    required this.levelIndex,
    required this.completed,
    required this.unlocked,
  });

  @override
  Widget build(BuildContext context) {
    final level = levels[levelIndex];
    final topics =
        lessons.where((lesson) => lesson.difficulty == levelIndex + 1).toList();
    final done = topics.where((lesson) => completed.contains(lesson.id)).length;
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(
            backgroundColor: unlocked ? level.color : subText(context),
            child: unlocked
                ? Text('${levelIndex + 1}',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold))
                : const Icon(Icons.lock_rounded, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(level.nameFor(AppScope.of(context).tagalog),
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold)),
                Text(level.descFor(AppScope.of(context).tagalog),
                    style: TextStyle(fontSize: 12, color: subText(context))),
              ])),
          Text(
              unlocked
                  ? '$done/${topics.length}'
                  : l10n(context, 'Locked', 'Naka-lock'),
              style: TextStyle(
                  color: subText(context), fontWeight: FontWeight.w600)),
        ]),
        if (!unlocked) ...[
          const SizedBox(height: 8),
          Text(
              l10n(
                  context,
                  'Complete all ${levels[levelIndex - 1].name} topics to unlock this difficulty.',
                  'Tapusin ang lahat ng paksa sa antas na ${levels[levelIndex - 1].nameFor(true)} upang mabuksan ito.'),
              style: TextStyle(fontSize: 12, color: subText(context))),
        ],
        const SizedBox(height: 8),
        for (final topic in topics)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
                completed.contains(topic.id)
                    ? Icons.check_circle
                    : Icons.menu_book_rounded,
                color: completed.contains(topic.id) ? C.green : level.color),
            title: Text(topic.titleFor(AppScope.of(context).tagalog),
                style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(topic.shortFor(AppScope.of(context).tagalog),
                maxLines: 2, overflow: TextOverflow.ellipsis),
            trailing: Icon(unlocked ? Icons.chevron_right : Icons.lock_rounded),
            onTap: unlocked
                ? () => go(context, TopicActionsScreen(lesson: topic))
                : null,
          ),
      ]),
    );
  }
}
