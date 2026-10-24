import 'package:flutter/material.dart';

import '../data/content.dart';
import '../theme.dart';
import 'common.dart';
import '../screens/force_motion_explore_screen.dart';
import '../screens/graph_screen.dart';
import '../screens/individual_challenge_screen.dart';
import '../screens/lab_screen.dart';
import '../screens/lesson_screen.dart';
import '../screens/practice_screen.dart';
import '../screens/session_challenge_screen.dart';
import '../screens/session_one_quiz_screen.dart';
import '../screens/whatif_screen.dart';

enum SessionPage { learn, explore, practice, challenge, quiz }

class SessionPageNavigationBar extends StatelessWidget {
  final int sessionId;
  final SessionPage currentPage;

  const SessionPageNavigationBar({
    super.key,
    required this.sessionId,
    required this.currentPage,
  });

  static const _items = <(SessionPage, String, String, IconData, Color)>[
    (SessionPage.learn, 'Learn', 'Matuto', Icons.menu_book_rounded, C.sky),
    (
      SessionPage.explore,
      'Explore',
      'Mag-explore',
      Icons.science_rounded,
      C.teal
    ),
    (
      SessionPage.practice,
      'Practice',
      'Pagsasanay',
      Icons.edit_note_rounded,
      C.orange
    ),
    (SessionPage.challenge, 'Challenge', 'Hamon', Icons.flag_rounded, C.purple),
    (SessionPage.quiz, 'Quiz', 'Pagsusulit', Icons.quiz_rounded, C.red),
  ];

  void _openPage(BuildContext context, SessionPage page) {
    if (page == currentPage) return;
    final Widget destination;
    switch (page) {
      case SessionPage.learn:
        destination = LessonScreen(lesson: lessons[sessionId - 1]);
      case SessionPage.explore:
        destination = switch (sessionId) {
          1 || 4 || 8 => LabScreen(sessionId: sessionId),
          2 || 3 => ForceMotionExploreScreen(sessionId: sessionId),
          6 => GraphScreen(sessionId: sessionId),
          _ => WhatIfScreen(sessionId: sessionId),
        };
      case SessionPage.practice:
        destination = sessionId == 8
            ? const SessionEightPracticeScreen()
            : PracticeScreen(sessionId: sessionId);
      case SessionPage.challenge:
        destination = sessionId == 8
            ? const SessionEightChallengeScreen()
            : sessionId == 1 || sessionId == 2 || sessionId == 7
                ? SessionChallengeScreen(sessionId: sessionId)
                : IndividualChallengeScreen(
                    sessionId: sessionId, stageTitle: 'Challenge');
      case SessionPage.quiz:
        destination = sessionId == 1
            ? const SessionOneQuizScreen()
            : IndividualChallengeScreen(
                sessionId: sessionId, stageTitle: 'Quiz');
    }
    Navigator.of(context).pushReplacement(appRoute<void>(context, destination));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 68,
        decoration: BoxDecoration(
          color: cardColor(context),
          border: Border(
            top: BorderSide(color: subText(context).withValues(alpha: .2)),
          ),
        ),
        child: Row(
          children: [
            for (final item in _items)
              Expanded(
                child: InkWell(
                  onTap: () => _openPage(context, item.$1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 38,
                        height: 27,
                        decoration: BoxDecoration(
                          color: currentPage == item.$1
                              ? item.$5.withValues(alpha: .16)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          item.$4,
                          color: currentPage == item.$1
                              ? item.$5
                              : subText(context),
                          size: 21,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        l10n(context, item.$2, item.$3),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          color: currentPage == item.$1
                              ? item.$5
                              : subText(context),
                          fontWeight: currentPage == item.$1
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 3),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: currentPage == item.$1 ? 20 : 4,
                        height: 3,
                        decoration: BoxDecoration(
                          color: currentPage == item.$1
                              ? item.$5
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
