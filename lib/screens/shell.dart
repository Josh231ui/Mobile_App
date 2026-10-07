import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'difficulty_screen.dart';
import 'challenge_screen.dart';
import 'explore_screen.dart';
import 'learn_screen.dart';
import 'practice_screen.dart';
import 'progress_screen.dart';

class _Dest {
  final String label;
  final String labelTl;
  final IconData icon;
  final Widget Function(void Function(int) goToTab) build;
  const _Dest(this.label, this.labelTl, this.icon, this.build);
}

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int tab = 0;
  final _scrollCtrl = ScrollController();
  final List<GlobalKey> _itemKeys = [];

  static final List<_Dest> _dests = [
    _Dest(
        'Learn', 'Matuto', Icons.menu_book_rounded, (_) => const LearnScreen()),
    _Dest('Explore', 'Mag-explore', Icons.science_rounded,
        (_) => const ExploreScreen()),
    _Dest('Practice', 'Magsanay', Icons.edit_rounded,
        (_) => const PracticeScreen()),
    _Dest('Challenge', 'Hamunin', Icons.flag_rounded,
        (_) => const ChallengeScreen()),
    _Dest('Difficulty', 'Antas', Icons.stairs_rounded,
        (_) => const DifficultyScreen()),
    _Dest('Progress', 'Pag-unlad', Icons.bar_chart_rounded,
        (_) => const ProgressScreen()),
  ];

  @override
  void initState() {
    super.initState();
    _itemKeys.addAll(List.generate(_dests.length, (_) => GlobalKey()));
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _selectTab(int i) {
    setState(() => tab = i);
    // Keep the tapped item scrolled into view.
    final ctx = _itemKeys[i].currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        alignment: 0.5,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: KeyedSubtree(
            key: ValueKey(tab),
            child: _dests[tab].build(_selectTab),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 68,
          decoration: BoxDecoration(
            color: cardColor(context),
            border: Border(
              top: BorderSide(
                  color: isDark(context) ? Colors.white12 : Colors.black12),
            ),
          ),
          child: SingleChildScrollView(
            controller: _scrollCtrl,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              children: [
                for (int i = 0; i < _dests.length; i++)
                  _NavItem(
                    key: _itemKeys[i],
                    dest: _dests[i],
                    selected: tab == i,
                    onTap: () => _selectTab(i),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final _Dest dest;
  final bool selected;
  final VoidCallback onTap;
  const _NavItem(
      {super.key,
      required this.dest,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = selected ? C.blue : subText(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(dest.icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              l10n(context, dest.label, dest.labelTl),
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
