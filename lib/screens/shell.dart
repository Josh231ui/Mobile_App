import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'learn_screen.dart';
import 'progress_screen.dart';
import 'settings_screen.dart';

class _Dest {
  final String label;
  final String labelTl;
  final IconData icon;
  final Widget Function() build;
  const _Dest(this.label, this.labelTl, this.icon, this.build);
}

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int tab = 0;

  static final List<_Dest> _dests = [
    _Dest(
        'Learn', 'Matuto', Icons.menu_book_rounded, () => const LearnScreen()),
    _Dest('Progress', 'Pag-unlad', Icons.bar_chart_rounded,
        () => const ProgressScreen()),
    _Dest('Settings', 'Mga Setting', Icons.settings_rounded,
        () => const SettingsScreen()),
  ];

  void _selectTab(int i) {
    setState(() => tab = i);
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
            child: _dests[tab].build(),
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
          child: Row(
            children: [
              for (int i = 0; i < _dests.length; i++)
                Expanded(
                  child: _NavItem(
                    dest: _dests[i],
                    selected: tab == i,
                    onTap: () => _selectTab(i),
                  ),
                ),
            ],
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
      {required this.dest, required this.selected, required this.onTap});

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
