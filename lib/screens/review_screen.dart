import 'package:flutter/material.dart';
import '../data/content.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'graph_screen.dart';
import 'topic_actions_screen.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);

    // Lessons you haven't completed come first.
    final sorted = [...lessons]..sort((a, b) {
        final da = s.completed.contains(a.id) ? 1 : 0;
        final db = s.completed.contains(b.id) ? 1 : 0;
        return da != db ? da - db : a.id - b.id;
      });

    return Scaffold(
      appBar: AppBar(title: Text(l10n(context, 'Review', 'Balikan'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
              l10n(context, 'You may want to review:',
                  'Mga paksa na maaari mong balikan:'),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          for (int i = 0; i < sorted.length; i++)
            Builder(builder: (context) {
              final unlocked = s.isDifficultyUnlocked(sorted[i].difficulty);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Reveal(
                  index: i,
                  child: AppCard(
                    child: Row(children: [
                      CircleAvatar(
                        backgroundColor:
                            unlocked ? sorted[i].color : subText(context),
                        child: unlocked
                            ? Text('${sorted[i].id}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))
                            : const Icon(Icons.lock_rounded,
                                color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(sorted[i].titleFor(s.tagalog),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text(
                                unlocked
                                    ? (s.completed.contains(sorted[i].id)
                                        ? l10n(
                                            context, 'Completed', 'Nakumpleto')
                                        : l10n(context, 'Not completed yet',
                                            'Hindi pa tapos'))
                                    : l10n(
                                        context,
                                        'Complete ${levels[sorted[i].difficulty - 2].name} first',
                                        'Tapusin muna ang antas na ${levels[sorted[i].difficulty - 2].nameFor(true)}'),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: unlocked &&
                                            s.completed.contains(sorted[i].id)
                                        ? C.green
                                        : subText(context)),
                              ),
                            ]),
                      ),
                      FilledButton(
                        onPressed: unlocked
                            ? () => go(
                                context, TopicActionsScreen(lesson: sorted[i]))
                            : null,
                        child: Text(unlocked
                            ? l10n(context, 'REVIEW', 'BALIKAN')
                            : l10n(context, 'LOCKED', 'NAKA-LOCK')),
                      ),
                    ]),
                  ),
                ),
              );
            }),
          Reveal(
            index: sorted.length,
            child: AppCard(
              child: Row(children: [
                const CircleAvatar(
                  backgroundColor: C.teal,
                  child: Icon(Icons.show_chart, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                      l10n(context, 'Velocity-Time Graph',
                          'Grap ng Bilis at Oras'),
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                FilledButton(
                  onPressed: () => go(context, const GraphScreen()),
                  child: Text(l10n(context, 'REVIEW', 'BALIKAN')),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
