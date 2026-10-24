import 'package:flutter/material.dart';
import '../data/content.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'force_motion_explore_screen.dart';
import 'graph_screen.dart';
import 'lab_screen.dart';
import 'lesson_screen.dart';
import 'individual_challenge_screen.dart';
import 'session_challenge_screen.dart';
import 'whatif_screen.dart';

class TopicActionsScreen extends StatelessWidget {
  final Lesson lesson;
  const TopicActionsScreen({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    if (!s.isDifficultyUnlocked(lesson.difficulty)) {
      return Scaffold(
        appBar: AppBar(
            title:
                Text(l10n(context, 'Session locked', 'Naka-lock ang sesyon'))),
        body: Center(
            child: Text(l10n(context, 'Finish the previous difficulty first.',
                'Tapusin muna ang naunang antas.'))),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title:
            Text(l10n(context, 'Session ${lesson.id}', 'Sesyon ${lesson.id}')),
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
            onTap: () {
              if (lesson.id == 1 || lesson.id == 4 || lesson.id == 8) {
                go(context, LabScreen(sessionId: lesson.id));
              } else if (lesson.id == 2 || lesson.id == 3) {
                go(context, ForceMotionExploreScreen(sessionId: lesson.id));
              } else if (lesson.id == 6) {
                go(context, GraphScreen(sessionId: lesson.id));
              } else {
                go(context, WhatIfScreen(sessionId: lesson.id));
              }
            },
          ),
          const SizedBox(height: 12),
          if (lesson.id == 1 || lesson.id == 2) ...[
            _TopicAction(
              title: l10n(context, 'Challenge', 'Hamon'),
              subtitle: l10n(context, 'Take on the session challenge.',
                  'Subukan ang hamon ng sesyon.'),
              icon: Icons.flag_rounded,
              color: C.orange,
              onTap: () =>
                  go(context, SessionChallengeScreen(sessionId: lesson.id)),
            ),
            const SizedBox(height: 12),
          ],
          _TopicAction(
            title: l10n(context, 'Quiz', 'Pagsusulit'),
            subtitle: l10n(context, 'Check what you learned in this session.',
                'Suriin ang iyong natutuhan sa sesyong ito.'),
            icon: Icons.quiz_rounded,
            color: C.red,
            onTap: () => go(
                context,
                IndividualChallengeScreen(
                    sessionId: lesson.id, stageTitle: 'Quiz')),
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
