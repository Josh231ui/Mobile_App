import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'lab_screen.dart';
import 'practice_screen.dart';
import 'whatif_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_Item>[
      _Item(
          'Acceleration Lab',
          'Laboratoryo ng Akselerasyon',
          'Simulate a moving car',
          'Gayahin ang galaw ng kotse',
          Icons.speed,
          C.sky,
          () => go(context, const LabScreen())),
      _Item(
          'What Happens If…?',
          'Ano ang Mangyayari Kung…?',
          'Change acceleration and compare',
          'Baguhin at paghambingin ang akselerasyon',
          Icons.lightbulb,
          C.orange,
          () => go(context, const WhatIfScreen())),
      _Item(
          'Calculation Practice',
          'Pagsasanay sa Pagkalkula',
          'Solve acceleration problems',
          'Lutasin ang mga problema sa akselerasyon',
          Icons.calculate,
          C.purple,
          () => go(context, const PracticeScreen())),
    ];

    final canPop = Navigator.canPop(context);

    return Scaffold(
      appBar: canPop
          ? AppBar(
              title: Text(l10n(context, 'Explore', 'Mag-explore')),
            )
          : null,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Reveal(
              child: PageHeader(l10n(context, 'Explore', 'Mag-explore'),
                  subtitle: l10n(context, 'Experiment with motion',
                      'Magsagawa ng eksperimento sa galaw'))),
          for (int i = 0; i < items.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Reveal(
                index: i + 1,
                child: AppCard(
                  onTap: items[i].onTap,
                  child: Row(children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: items[i].color,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(items[i].icon, color: Colors.white),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n(context, items[i].title, items[i].titleTl),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Text(l10n(context, items[i].sub, items[i].subTl),
                                style: TextStyle(
                                    color: subText(context), fontSize: 13)),
                          ]),
                    ),
                    Icon(Icons.chevron_right, color: subText(context)),
                  ]),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Item {
  final String title;
  final String titleTl;
  final String sub;
  final String subTl;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  _Item(this.title, this.titleTl, this.sub, this.subTl, this.icon, this.color,
      this.onTap);
}
