import 'package:flutter/material.dart';
import '../data/content.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'lesson_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  final void Function(int) goToTab;
  const HomeScreen({super.key, required this.goToTab});

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final next = lessons.firstWhere(
      (l) => !s.completed.contains(l.id) && s.isDifficultyUnlocked(l.difficulty),
      orElse: () => lessons.first,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Reveal(
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Hello, Learner! 👋',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text('Ready to explore acceleration?',
                    style: TextStyle(color: subText(context))),
              ]),
            ),
            IconButton(
              icon: const Icon(Icons.settings_rounded),
              onPressed: () => go(context, const SettingsScreen()),
            ),
          ]),
        ),
        const SizedBox(height: 14),
        Reveal(
          index: 1,
          child: AppCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Learning Progress', style: TextStyle(fontWeight: FontWeight.w600)),
                Text('${(s.overall * 100).round()}%',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ]),
              const SizedBox(height: 10),
              AnimatedBar(value: s.overall, color: C.green),
            ]),
          ),
        ),
        const SizedBox(height: 14),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.35,
          children: [
            Reveal(
              index: 2,
              child: _Tile('LEARN', 'Understand acceleration', Icons.menu_book_rounded, C.sky,
                  () => goToTab(1)),
            ),
            Reveal(
              index: 3,
              child: _Tile('EXPLORE', 'Experiment with motion', Icons.science_rounded, C.teal,
                  () => goToTab(2)),
            ),
            Reveal(
              index: 4,
              child: _Tile('CHALLENGE', 'Test your Physics skills', Icons.flag_rounded, C.orange,
                  () => goToTab(4)),
            ),
            Reveal(
              index: 5,
              child: _Tile('PROGRESS', 'See your difficulty level', Icons.stairs_rounded,
                  C.purple, () => goToTab(6)),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Reveal(
          index: 6,
          child: AppCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 84,
                    height: 62,
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.only(bottom: 6),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF7CC4F2), Color(0xFFDFF1FF)],
                      ),
                    ),
                    child: const CarWidget(width: 60),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Continue Learning',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('"${next.title}"', style: TextStyle(color: subText(context))),
                  ]),
                ),
              ]),
              const SizedBox(height: 12),
              BigButton('CONTINUE →',
                  color: C.orange, onTap: () => go(context, LessonScreen(lesson: next))),
            ]),
          ),
        ),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  final String title;
  final String sub;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _Tile(this.title, this.sub, this.icon, this.color, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.white, size: 30),
              const SizedBox(height: 6),
              Text(title,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              Text(sub, style: const TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }
}
