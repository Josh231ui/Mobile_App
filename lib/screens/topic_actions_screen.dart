import 'package:flutter/material.dart';
import '../data/content.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'challenge_screen.dart';
import 'explore_screen.dart';
import 'lesson_screen.dart';

class TopicActionsScreen extends StatelessWidget {
  final Lesson lesson;
  const TopicActionsScreen({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    if (!s.isDifficultyUnlocked(lesson.difficulty)) {
      return Scaffold(
        appBar: AppBar(
            title: Text(l10n(context, 'Topic locked', 'Naka-lock ang paksa'))),
        body: Center(
            child: Text(l10n(context, 'Finish the previous difficulty first.',
                'Tapusin muna ang naunang antas.'))),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.titleFor(s.tagalog)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text(lesson.titleFor(s.tagalog),
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(lesson.shortFor(s.tagalog),
              style: TextStyle(color: subText(context), fontSize: 15)),
          const SizedBox(height: 22),
          Text(
              l10n(context, 'What would you like to do?',
                  'Ano ang gusto mong gawin?'),
              style:
                  const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _TopicAction(
            title: l10n(context, 'Learn', 'Matuto'),
            subtitle: l10n(
                context,
                'Read the lesson and see the motion animation.',
                'Basahin ang aralin at panoorin ang animasyon ng galaw.'),
            icon: Icons.menu_book_rounded,
            color: C.sky,
            onTap: () => go(context, LessonScreen(lesson: lesson)),
          ),
          const SizedBox(height: 12),
          _TopicAction(
            title: l10n(context, 'Explore', 'Mag-explore'),
            subtitle: l10n(context, 'Open the motion tools and experiments.',
                'Buksan ang mga kagamitan at eksperimento sa galaw.'),
            icon: Icons.science_rounded,
            color: C.teal,
            onTap: () => go(context, const ExploreScreen()),
          ),
          const SizedBox(height: 12),
          _TopicAction(
            title: l10n(context, 'Challenge', 'Hamon'),
            subtitle: l10n(context, 'Answer acceleration questions.',
                'Sagutin ang mga tanong tungkol sa akselerasyon.'),
            icon: Icons.flag_rounded,
            color: C.orange,
            onTap: () => go(context, const ChallengeScreen()),
          ),
        ],
      ),
    );
  }
}

class _TopicAction extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _TopicAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => AppCard(
        onTap: onTap,
        child: Row(children: [
          CircleAvatar(
              backgroundColor: color, child: Icon(icon, color: Colors.white)),
          const SizedBox(width: 14),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 3),
                Text(subtitle,
                    style: TextStyle(color: subText(context), fontSize: 13)),
              ])),
          const Icon(Icons.chevron_right_rounded),
        ]),
      );
}
