import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../data/content.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/session_page_navigation.dart';
import 'force_motion_explore_screen.dart';
import 'graph_screen.dart';
import 'lab_screen.dart';
import 'whatif_screen.dart';

class LessonScreen extends StatelessWidget {
  final Lesson lesson;
  const LessonScreen({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final title = lesson.titleFor(s.tagalog);
    if (!s.isDifficultyUnlocked(lesson.difficulty)) {
      final prerequisite = levels[lesson.difficulty - 2].nameFor(s.tagalog);
      return Scaffold(
        appBar: AppBar(
            title: Text(
                l10n(context, 'Session ${lesson.id}', 'Sesyon ${lesson.id}'))),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.lock_rounded, size: 48, color: C.orange),
              const SizedBox(height: 12),
              Text(
                  l10n(
                      context,
                      '${levels[lesson.difficulty - 1].name} is locked',
                      'Naka-lock ang antas na ${levels[lesson.difficulty - 1].nameFor(true)}'),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                  l10n(
                      context,
                      'Complete all sessions in $prerequisite to unlock this difficulty.',
                      'Tapusin ang lahat ng sesyon sa antas na $prerequisite upang mabuksan ito.'),
                  textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n(context, 'GO BACK', 'BUMALIK'))),
            ]),
          ),
        ),
      );
    }
    final done = s.completed.contains(lesson.id);

    return Scaffold(
      appBar: AppBar(
        title:
            Text(l10n(context, 'Session ${lesson.id}', 'Sesyon ${lesson.id}')),
        actions: [LanguageSwitchButton(state: s)],
      ),
      bottomNavigationBar: SessionPageNavigationBar(
        sessionId: lesson.id,
        currentPage: SessionPage.learn,
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Reveal(
            child: lesson.id == 3
                ? const _SessionThreeBanner()
                : lesson.id == 4
                    ? const _SessionFourBanner()
                    : lesson.id == 5
                        ? const _SessionFiveBanner()
                        : lesson.id == 6
                            ? const _SessionSixBanner()
                            : lesson.id == 8
                                ? const _SessionEightBanner()
                                : Text(title,
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold)),
          ),
          if (lesson.id == 1) ...[
            const SizedBox(height: 8),
            Text(
                l10n(
                    context,
                    'Acceleration is the rate at which an object’s velocity changes over time.',
                    'Ang akselerasyon ay bilis ng pagbabago ng velocity ng isang bagay sa paglipas ng oras.'),
                style: TextStyle(color: subText(context), height: 1.35)),
            const SizedBox(height: 12),
            Reveal(
              index: 1,
              child: AppCard(
                padding: const EdgeInsets.all(10),
                color: const Color(0xffe7f5ff),
                child: Column(children: [
                  const MotionScene(
                    motion: Motion.intro,
                    color: C.sky,
                    initialVehicle: VehicleType.autoRickshaw,
                  ),
                  const SizedBox(height: 8),
                  Text(
                      l10n(
                          context,
                          'A vehicle accelerates when its velocity changes as time passes.',
                          'Umaarangkada ang sasakyan kapag nagbabago ang velocity nito habang lumilipas ang oras.'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isDark(context) ? C.navy : null,
                      )),
                ]),
              ),
            ),
            const SizedBox(height: 14),
            _LearnSectionTitle(
                title: l10n(context, 'SHORT DISCUSSION', 'MAIKLING TALAKAYAN'),
                icon: Icons.lightbulb_rounded,
                color: C.blue),
            const SizedBox(height: 8),
            AppCard(
              padding: const EdgeInsets.all(13),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                    child: Text(
                        l10n(
                            context,
                            'Acceleration describes how quickly velocity changes over time.',
                            'Inilalarawan ng akselerasyon kung gaano kabilis nagbabago ang velocity sa paglipas ng oras.'),
                        style: const TextStyle(height: 1.4))),
                const SizedBox(width: 10),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(
                          l10n(context, 'An object accelerates when it:',
                              'May akselerasyon ang bagay kapag ito ay:'),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      _MiniPoint(
                          icon: Icons.arrow_upward_rounded,
                          color: C.green,
                          text: l10n(context, 'speeds up', 'bumibilis')),
                      _MiniPoint(
                          icon: Icons.arrow_downward_rounded,
                          color: C.orange,
                          text: l10n(context, 'slows down', 'bumabagal')),
                      _MiniPoint(
                          icon: Icons.swap_horiz_rounded,
                          color: C.red,
                          text: l10n(context, 'changes direction',
                              'nagbabago ng direksiyon')),
                    ])),
              ]),
            ),
            const SizedBox(height: 14),
            _LearnSectionTitle(
                title: l10n(context, 'EXAMPLES', 'MGA HALIMBAWA'),
                icon: Icons.star_rounded,
                color: C.orange),
            const SizedBox(height: 8),
            LayoutBuilder(builder: (context, constraints) {
              final compact = constraints.maxWidth < 400;
              final cardWidth = compact
                  ? (constraints.maxWidth - 8) / 2
                  : (constraints.maxWidth - 16) / 3;
              return Wrap(spacing: 8, runSpacing: 8, children: [
                _ExampleTile(
                    width: cardWidth,
                    title: l10n(context, 'Speeding Up', 'Pagbilis'),
                    icon: Icons.trending_up,
                    color: C.green,
                    text: l10n(context, 'A car goes from 4 m/s to 10 m/s.',
                        'Mula 4 m/s ay naging 10 m/s ang takbo ng kotse.'),
                    formula: 'a > 0'),
                _ExampleTile(
                    width: cardWidth,
                    title: l10n(context, 'Slowing Down', 'Pagbagal'),
                    icon: Icons.trending_down,
                    color: C.blue,
                    text: l10n(context, 'A bus brakes from 12 m/s to 6 m/s.',
                        'Nagpreno ang bus mula 12 m/s hanggang 6 m/s.'),
                    formula: 'a < 0'),
                _ExampleTile(
                    width: cardWidth,
                    title: l10n(context, 'Changing Direction', 'Pagliko'),
                    icon: Icons.turn_right,
                    color: C.orange,
                    text: l10n(
                        context,
                        'A bicycle turns while keeping the same speed.',
                        'Lumuliko ang bisikleta kahit pareho ang bilis.'),
                    formula: l10n(
                        context, 'velocity changes', 'nagbabago ang velocity')),
              ]);
            }),
            const SizedBox(height: 14),
            _LearnSectionTitle(
                title: l10n(context, 'KEY TERMS', 'MAHAHALAGANG TERMINO'),
                icon: Icons.key_rounded,
                color: C.teal),
            const SizedBox(height: 8),
            LayoutBuilder(builder: (context, constraints) {
              final width = (constraints.maxWidth - 8) / 2;
              return Wrap(spacing: 8, runSpacing: 8, children: [
                _TermTile(
                    width: width,
                    number: '1',
                    color: C.teal,
                    term: l10n(context, 'Initial velocity (vi)',
                        'Panimulang velocity (vi)'),
                    meaning: l10n(context, 'Velocity at the start.',
                        'Velocity sa simula.'),
                    formula: 'vi = starting value'),
                _TermTile(
                    width: width,
                    number: '2',
                    color: C.purple,
                    term: l10n(context, 'Final velocity (vf)',
                        'Panghuling velocity (vf)'),
                    meaning: l10n(
                        context, 'Velocity at the end.', 'Velocity sa dulo.'),
                    formula: 'vf = ending value'),
                _TermTile(
                    width: width,
                    number: '3',
                    color: C.green,
                    term: l10n(context, 'Time (t)', 'Oras (t)'),
                    meaning: l10n(context, 'How long the velocity changes.',
                        'Gaano katagal nagbago ang velocity.'),
                    formula: 'measured in seconds'),
                _TermTile(
                    width: width,
                    number: '4',
                    color: C.orange,
                    term: l10n(context, 'Acceleration (a)', 'Akselerasyon (a)'),
                    meaning: l10n(context, 'Change in velocity per second.',
                        'Pagbabago ng velocity bawat segundo.'),
                    formula: 'a = (vf − vi) / t'),
              ]);
            }),
          ] else if (lesson.id == 2) ...[
            const SizedBox(height: 14),
            const _SessionTwoLessonContent(),
          ] else if (lesson.id == 3) ...[
            const SizedBox(height: 12),
            const _SessionThreeLessonContent(),
          ] else if (lesson.id == 4) ...[
            const SizedBox(height: 12),
            const _SessionFourLessonContent(),
          ] else if (lesson.id == 5) ...[
            const SizedBox(height: 12),
            const _SessionFiveLessonContent(),
          ] else if (lesson.id == 6) ...[
            const SizedBox(height: 12),
            const _SessionSixLessonContent(),
          ] else if (lesson.id == 7) ...[
            const SizedBox(height: 8),
            const _SessionSevenContent(),
          ] else if (lesson.id == 8) ...[
            const SizedBox(height: 8),
            const _SessionEightContent(),
          ] else ...[
            const SizedBox(height: 14),
            Reveal(
              index: 1,
              child: MotionScene(
                motion: lesson.motion,
                color: lesson.color,
                initialVehicle: lesson.id == 2
                    ? VehicleType.bicycle
                    : lesson.id == 7
                        ? VehicleType.bus
                        : lesson.id == 3
                            ? VehicleType.car
                            : VehicleType.autoRickshaw,
              ),
            ),
            const SizedBox(height: 16),
            Reveal(
                index: 2,
                child: Text(lesson.bodyFor(s.tagalog),
                    style: const TextStyle(fontSize: 16, height: 1.5))),
            if (lesson.formula != null) ...[
              const SizedBox(height: 14),
              Reveal(
                index: 3,
                child: AppCard(
                    color: lesson.color.withValues(alpha: 0.15),
                    child: Center(
                        child: Text(lesson.formula!,
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold)))),
              ),
            ],
            if (lesson.exampleFor(s.tagalog) != null) ...[
              const SizedBox(height: 14),
              Reveal(
                  index: 4,
                  child: AppCard(
                      child: Text(lesson.exampleFor(s.tagalog)!,
                          style: const TextStyle(fontSize: 15, height: 1.5)))),
            ],
            if (lesson.rememberFor(s.tagalog) != null) ...[
              const SizedBox(height: 14),
              Reveal(
                  index: 4,
                  child: AppCard(
                      color: lesson.color.withValues(alpha: 0.15),
                      child: Text.rich(TextSpan(children: [
                        TextSpan(
                            text: l10n(context, 'Remember: ', 'Tandaan: '),
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: lesson.rememberFor(s.tagalog))
                      ])))),
            ],
          ],
          const SizedBox(height: 24),
          Reveal(
            index: 5,
            child: BigButton(
              done
                  ? l10n(context, 'SESSION COMPLETED', 'KUMPLETO NA ANG SESYON')
                  : l10n(context, 'NEXT: EXPLORE →', 'SUSUNOD: MAG-EXPLORE →'),
              icon: done ? Icons.check_circle : Icons.arrow_forward_rounded,
              color: done ? C.green : lesson.color,
              onTap: () {
                if (done) {
                  Navigator.of(context).pop();
                  return;
                }
                _openSessionExplore(context, lesson);
              },
            ),
          ),
        ],
      ),
    );
  }
}

void _openSessionExplore(BuildContext context, Lesson lesson) {
  if (lesson.id == 1 || lesson.id == 4 || lesson.id == 8) {
    go(context, LabScreen(sessionId: lesson.id));
  } else if (lesson.id == 2 || lesson.id == 3) {
    go(context, ForceMotionExploreScreen(sessionId: lesson.id));
  } else if (lesson.id == 6) {
    go(context, GraphScreen(sessionId: lesson.id));
  } else {
    go(context, WhatIfScreen(sessionId: lesson.id));
  }
}

class _SessionThreeBanner extends StatelessWidget {
  const _SessionThreeBanner();

  @override
  Widget build(BuildContext context) {
    final tagalog = AppScope.of(context).tagalog;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff0755ce), Color(0xff168df0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(children: [
        Text(tagalog ? 'MATUTO' : 'LEARN',
            style: const TextStyle(
                color: Color(0xFFFFD83D),
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.2)),
        const SizedBox(height: 3),
        Text(
          tagalog
              ? 'Ang Netong Puwersa ay Nagdudulot ng Akselerasyon'
              : 'Net Force Causes Acceleration',
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              height: 1.12,
              fontWeight: FontWeight.w900,
              letterSpacing: -.2),
        ),
      ]),
    );
  }
}

class _SessionThreeLessonContent extends StatelessWidget {
  const _SessionThreeLessonContent();

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 600;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      if (wide)
        const Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(child: _NetForceKeyIdea()),
          SizedBox(width: 10),
          Expanded(child: _NewtonLawCard()),
        ])
      else ...[
        const _NetForceKeyIdea(),
        const SizedBox(height: 9),
        const _NewtonLawCard(),
      ],
      const SizedBox(height: 12),
      _LearnSectionTitle(
        title: l10n(context, 'EXAMPLES', 'MGA HALIMBAWA'),
        icon: Icons.star_rounded,
        color: C.orange,
      ),
      const SizedBox(height: 8),
      LayoutBuilder(builder: (context, constraints) {
        final columns = constraints.maxWidth >= 500 ? 2 : 1;
        final gap = 8.0;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(spacing: gap, runSpacing: gap, children: [
          _ForceExampleCard(
            width: width,
            color: const Color(0xffe653a3),
            icon: Icons.bolt_rounded,
            title: l10n(
                context, 'Greater net force', 'Mas malaking netong puwersa'),
            caption: l10n(
                context, 'Greater acceleration', 'Mas malaking akselerasyon'),
            person: Icons.directions_run_rounded,
            blocks: 1,
            arrowSize: 31,
          ),
          _ForceExampleCard(
            width: width,
            color: C.teal,
            icon: Icons.inventory_2_rounded,
            title: l10n(context, 'Greater mass', 'Mas malaking masa'),
            caption: l10n(context, 'Less acceleration for the same net force',
                'Mas maliit na akselerasyon sa parehong netong puwersa'),
            person: Icons.directions_walk_rounded,
            blocks: 2,
            arrowSize: 20,
          ),
        ]);
      }),
      const SizedBox(height: 12),
      LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          return const Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _NetForceRoadScene()),
                SizedBox(width: 10),
                Expanded(child: _RememberNetForceCard()),
              ]);
        }
        return const Column(children: [
          _NetForceRoadScene(),
          SizedBox(height: 9),
          _RememberNetForceCard(),
        ]);
      }),
    ]);
  }
}

class _NetForceKeyIdea extends StatelessWidget {
  const _NetForceKeyIdea();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xfffff8df),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.lightbulb_rounded,
                color: Color(0xFFC98A00), size: 16),
            const SizedBox(width: 5),
            Text(l10n(context, 'KEY IDEA', 'MAHALAGANG IDEYA'),
                style: const TextStyle(
                    color: Color(0xFFC98A00),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2)),
          ]),
          const SizedBox(height: 6),
          Text.rich(
              TextSpan(children: [
                TextSpan(
                    text: l10n(context, 'A net force ', 'Ang netong puwersa '),
                    style: const TextStyle(fontWeight: FontWeight.w900)),
                TextSpan(
                    text: l10n(
                        context,
                        'is an unbalanced force that causes an object to accelerate in the direction of the net force.',
                        'ay hindi balanseng puwersa na nagpapabilis sa isang bagay sa direksiyon ng netong puwersa.')),
              ]),
              style: const TextStyle(
                  color: C.navy, fontSize: 14, height: 1.32)),
        ]),
      );
}

class _NewtonLawCard extends StatelessWidget {
  const _NewtonLawCard();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xfffff3cf),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.functions_rounded,
                color: Color(0xFFB45309), size: 16),
            const SizedBox(width: 5),
            Text(
                l10n(context, 'NEWTON’S SECOND LAW', 'IKALAWANG BATAS NI NEWTON'),
                style: const TextStyle(
                    color: Color(0xFFB45309),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2)),
          ]),
          const SizedBox(height: 8),
          Center(
            child: Text.rich(
                TextSpan(children: [
                  const TextSpan(text: 'F', style: TextStyle(color: C.red)),
                  const TextSpan(
                      text: 'ₙₑₜ',
                      style: TextStyle(color: C.red, fontSize: 17)),
                  const TextSpan(
                      text: ' = ma', style: TextStyle(color: C.blue)),
                ]),
                style: const TextStyle(
                    fontSize: 36, height: 1.05, fontWeight: FontWeight.w900)),
          ),
          const SizedBox(height: 6),
          Text(
              l10n(
                  context,
                  'Fₙₑₜ = net force (N)\nm = mass (kg)\na = acceleration (m/s²)',
                  'Fₙₑₜ = netong puwersa (N)\nm = masa (kg)\na = akselerasyon (m/s²)'),
              style: const TextStyle(
                  color: C.navy,
                  fontSize: 12,
                  height: 1.3,
                  fontWeight: FontWeight.w600)),
        ]),
      );
}

class _ForceExampleCard extends StatelessWidget {
  final double width;
  final Color color;
  final IconData icon;
  final String title;
  final String caption;
  final IconData person;
  final int blocks;
  final double arrowSize;

  const _ForceExampleCard(
      {required this.width,
      required this.color,
      required this.icon,
      required this.title,
      required this.caption,
      required this.person,
      required this.blocks,
      required this.arrowSize});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: color.withValues(alpha: .15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: .45))),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.w900, fontSize: 13)),
            const SizedBox(height: 6),
            Row(children: [
              Icon(person,
                  color: isDark(context) ? Colors.white : C.navy, size: 31),
              const SizedBox(width: 3),
              for (var i = 0; i < blocks; i++)
                Container(
                    width: 22,
                    height: 30,
                    margin: const EdgeInsets.only(right: 2),
                    decoration: BoxDecoration(
                        color: const Color(0xffad6b3b),
                        border: Border.all(
                            color: isDark(context)
                                ? Colors.white
                                : C.navy,
                            width: 1),
                        borderRadius: BorderRadius.circular(3)),
                    child: const Icon(Icons.grid_on_rounded,
                        size: 14, color: Color(0xffffd79b))),
              const SizedBox(width: 3),
              Icon(Icons.arrow_forward_rounded, color: C.red, size: arrowSize),
              const Spacer(),
              Icon(icon, color: color, size: 20),
            ]),
            const SizedBox(height: 5),
            Text(caption,
                style: const TextStyle(
                    fontSize: 12, height: 1.25, fontWeight: FontWeight.w700)),
          ]),
        ),
      );
}

class _NetForceRoadScene extends StatelessWidget {
  const _NetForceRoadScene();

  @override
  Widget build(BuildContext context) => Container(
        height: 118,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          gradient: const LinearGradient(
              colors: [Color(0xff9bddff), Color(0xffe6f8ff)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: Stack(children: [
          // Cartoon city skyline behind the car (like the lesson banner).
          Positioned(
              left: 0,
              right: 0,
              bottom: 29,
              height: 56,
              child: CustomPaint(painter: _NetForceCityPainter())),
          // Road with dashes.
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(height: 29, color: const Color(0xff35415a))),
          Positioned(
              left: 0,
              right: 0,
              bottom: 13,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                      5,
                      (_) => Container(
                          width: 30,
                          height: 3,
                          color: Colors.white.withValues(alpha: .85))))),
          // Bright red sports car, like the banner art.
          Positioned(
              right: 10,
              bottom: 3,
              width: 170,
              height: 70,
              child: CustomPaint(painter: _SportsCarPainter())),
          // Big red net-force arrow pointing at the car.
          Positioned(
            right: 14,
            top: 8,
            child: SizedBox(
              width: 195,
              height: 26,
              child: Stack(children: [
                Positioned.fill(
                    child: CustomPaint(painter: _NetForceArrowPainter())),
                Positioned(
                    left: 16,
                    top: 3,
                    bottom: 3,
                    child: Center(
                      child: Text(
                          l10n(context, 'Net Force', 'Netong Puwersa'),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 10.5)),
                    )),
              ]),
            ),
          ),
        ]),
      );
}

// Blocky cartoon buildings + trees, bases sitting on the road.
class _NetForceCityPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const buildings = <(double, double, double, Color)>[
      (0.02, .10, .55, Color(0xFFBFE3C2)),
      (0.14, .08, .40, Color(0xFF9FD8A8)),
      (0.24, .11, .62, Color(0xFFD2ECC6)),
      (0.37, .08, .46, Color(0xFFBFE3C2)),
      (0.52, .10, .58, Color(0xFFD2ECC6)),
      (0.64, .08, .38, Color(0xFF9FD8A8)),
      (0.74, .10, .52, Color(0xFFBFE3C2)),
      (0.86, .09, .44, Color(0xFFD2ECC6)),
    ];
    for (final (x, bw, bh, color) in buildings) {
      final rect = Rect.fromLTWH(size.width * x, size.height * (1 - bh),
          size.width * bw, size.height * bh);
      canvas.drawRect(rect, Paint()..color = color);
      final win = Paint()..color = Colors.white.withValues(alpha: .85);
      final cols = (size.width * bw / 10).floor();
      final rows = (size.height * bh / 12).floor();
      for (var r = 0; r < rows; r++) {
        for (var c = 0; c < cols; c++) {
          canvas.drawRect(
              Rect.fromLTWH(rect.left + 3 + c * 10, rect.top + 5 + r * 12,
                  4.5, 5),
              win);
        }
      }
      canvas.drawRect(Rect.fromLTWH(rect.left, rect.top, rect.width, 2.5),
          Paint()..color = Colors.white.withValues(alpha: .8));
    }
    // Trees between the buildings.
    final leaves = Paint()..color = const Color(0xFF4CAF50);
    final trunk = Paint()..color = const Color(0xFF8C5A35);
    for (final x in [0.44, 0.70]) {
      final px = size.width * x;
      canvas.drawRect(
          Rect.fromLTWH(px - 2, size.height - 16, 4, 16), trunk);
      canvas.drawCircle(Offset(px, size.height - 20), 10, leaves);
    }
  }

  @override
  bool shouldRepaint(covariant _NetForceCityPainter old) => false;
}

// Big thick red arrow pointing right.
class _NetForceArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(6, size.height * .18)
      ..lineTo(size.width * .78, size.height * .18)
      ..lineTo(size.width * .78, 0)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(size.width * .78, size.height)
      ..lineTo(size.width * .78, size.height * .82)
      ..lineTo(6, size.height * .82)
      ..quadraticBezierTo(0, size.height / 2, 6, size.height * .16)
      ..close();
    canvas.drawPath(path, Paint()..color = C.red);
  }

  @override
  bool shouldRepaint(covariant _NetForceArrowPainter old) => false;
}

// Bright red coupe facing right (unit space 160 x 70).
class _SportsCarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 160.0);

    // Shadow under the car.
    canvas.drawOval(
        Rect.fromLTWH(8, 55, 148, 8),
        Paint()..color = Colors.black.withValues(alpha: .18));

    const red = Color(0xFFE84118);
    // Lower body.
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(4, 32, 152, 22), const Radius.circular(9)),
        Paint()..color = red);
    // Cabin.
    final cabin = Path()
      ..moveTo(28, 34)
      ..lineTo(44, 16)
      ..quadraticBezierTo(47, 13, 52, 13)
      ..lineTo(92, 13)
      ..quadraticBezierTo(99, 13, 104, 19)
      ..lineTo(114, 34)
      ..close();
    canvas.drawPath(cabin, Paint()..color = red);
    // Windows.
    final window = Path()
      ..moveTo(50, 16.5)
      ..lineTo(91, 16.5)
      ..lineTo(101, 31)
      ..lineTo(46, 31)
      ..close();
    canvas.drawPath(window, Paint()..color = const Color(0xFF232A33));
    // Door pillar.
    canvas.drawRect(
        Rect.fromLTWH(70, 16.5, 4, 14.5), Paint()..color = red);
    // Door seam + handle.
    canvas.drawLine(
        const Offset(72, 36),
        const Offset(72, 52),
        Paint()
          ..color = const Color(0xFFB41F07)
          ..strokeWidth = 1.6);
    canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(84, 39, 11, 3),
            const Radius.circular(2)),
        Paint()..color = const Color(0xFFFFE1D9));
    // Headlight + taillight.
    canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(146, 37, 9, 5),
            const Radius.circular(2.5)),
        Paint()..color = const Color(0xFFFFF3C4));
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(5, 37, 6, 6), const Radius.circular(2)),
        Paint()..color = const Color(0xFFB41F07));
    // Front bumper accent.
    canvas.drawRect(
        Rect.fromLTWH(130, 48, 24, 4),
        Paint()..color = const Color(0xFFB41F07));

    // Wheel arches, tires, rims and hubs.
    final arch = Paint()..color = const Color(0xFF232A33);
    canvas.drawCircle(const Offset(40, 53), 17, arch);
    canvas.drawCircle(const Offset(122, 53), 17, arch);
    final tire = Paint()..color = const Color(0xFF17191D);
    canvas.drawCircle(const Offset(40, 53), 14, tire);
    canvas.drawCircle(const Offset(122, 53), 14, tire);
    final rim = Paint()..color = const Color(0xFFF2F4F6);
    canvas.drawCircle(const Offset(40, 53), 7, rim);
    canvas.drawCircle(const Offset(122, 53), 7, rim);
    final hub = Paint()..color = const Color(0xFF9AA2AB);
    canvas.drawCircle(const Offset(40, 53), 2.5, hub);
    canvas.drawCircle(const Offset(122, 53), 2.5, hub);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SportsCarPainter old) => false;
}

class _RememberNetForceCard extends StatelessWidget {
  const _RememberNetForceCard();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: const Color(0xfff0eaff),
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: C.purple, width: 1.5)),
        child: DefaultTextStyle.merge(
          style: TextStyle(color: isDark(context) ? C.navy : null),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const CircleAvatar(
                  radius: 14,
                  backgroundColor: C.purple,
                  child:
                      Icon(Icons.check_rounded, color: Colors.white, size: 19)),
              const SizedBox(width: 7),
              Text(l10n(context, 'Remember!', 'TANDAAN!'),
                  style: const TextStyle(
                      color: C.purple,
                      fontSize: 17,
                      fontWeight: FontWeight.w900)),
            ]),
            const SizedBox(height: 7),
            _rememberPoint(context, 'If Fₙₑₜ ≠ 0, the object accelerates.',
                'Kung Fₙₑₜ ≠ 0, umaarangkada ang bagay.'),
            const SizedBox(height: 5),
            _rememberPoint(
                context,
                'If Fₙₑₜ = 0, there is no acceleration (constant velocity).',
                'Kung Fₙₑₜ = 0, walang akselerasyon (pare-pareho ang velocity).'),
          ]),
        ),
      );

  Widget _rememberPoint(BuildContext context, String english, String tagalog) =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
              padding: EdgeInsets.only(top: 3),
              child: Icon(Icons.circle, color: C.purple, size: 7)),
          const SizedBox(width: 7),
          Expanded(
              child: Text(l10n(context, english, tagalog),
                  style: const TextStyle(fontSize: 12, height: 1.3))),
        ],
      );
}

class _SessionFourBanner extends StatelessWidget {
  const _SessionFourBanner();

  @override
  Widget build(BuildContext context) {
    final tagalog = AppScope.of(context).tagalog;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xff0755ce), Color(0xff168df0)]),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          decoration: BoxDecoration(
              color: C.yellow, borderRadius: BorderRadius.circular(11)),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.menu_book_rounded, color: C.navy, size: 19),
            Text(tagalog ? 'MATUTO' : 'LEARN',
                style: const TextStyle(
                    color: C.navy, fontSize: 12, fontWeight: FontWeight.w900)),
          ]),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            tagalog
                ? 'Pag-unawa sa Pormula ng Akselerasyon'
                : 'Understanding the Formula of Acceleration',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                height: 1.05,
                fontWeight: FontWeight.w900),
          ),
        ),
        const Icon(Icons.functions_rounded, color: C.yellow, size: 27),
      ]),
    );
  }
}

class _SessionFourLessonContent extends StatefulWidget {
  const _SessionFourLessonContent();

  @override
  State<_SessionFourLessonContent> createState() =>
      _SessionFourLessonContentState();
}

class _SessionFourLessonContentState extends State<_SessionFourLessonContent> {
  int? _selectedAnswer;
  bool _countedCorrect = false;

  void _answer(int answer) {
    if (_selectedAnswer != null) return;
    final state = AppScope.of(context);
    state.click();
    setState(() => _selectedAnswer = answer);
    if (answer == 0 && !_countedCorrect) {
      _countedCorrect = true;
      state.solvedOne();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tagalog = AppScope.of(context).tagalog;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(
        l10n(
            context,
            'Acceleration describes how quickly velocity changes over time.',
            'Inilalarawan ng akselerasyon kung gaano kabilis nagbabago ang velocity sa paglipas ng oras.'),
        style: TextStyle(color: subText(context), height: 1.35),
      ),
      const SizedBox(height: 12),
      _LearnSectionTitle(
        title: l10n(context, 'THE FORMULA', 'ANG PORMULA'),
        icon: Icons.functions_rounded,
        color: C.blue,
      ),
      const SizedBox(height: 8),
      AppCard(
        color: const Color(0xffeaf6ff),
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 7),
            decoration: BoxDecoration(
                color: const Color(0xfffff3cf),
                borderRadius: BorderRadius.circular(12)),
            child: Text(
                l10n(
                    context, 'Acceleration Formula', 'Pormula ng Akselerasyon'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: C.navy, fontWeight: FontWeight.w900, fontSize: 13)),
          ),
          const SizedBox(height: 4),
          const Text('a = (vf − vi) / t',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: C.navy, fontSize: 29, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          LayoutBuilder(builder: (context, constraints) {
            const gap = 6.0;
            final width = (constraints.maxWidth - gap) / 2;
            return Wrap(spacing: gap, runSpacing: gap, children: [
              _FormulaVariableTile(
                  width: width,
                  symbol: 'a',
                  color: C.purple,
                  label: l10n(context, 'Acceleration', 'Akselerasyon'),
                  unit: 'm/s²'),
              _FormulaVariableTile(
                  width: width,
                  symbol: 'vf',
                  color: C.teal,
                  label: l10n(context, 'Final velocity', 'Panghuling velocity'),
                  unit: 'm/s'),
              _FormulaVariableTile(
                  width: width,
                  symbol: 'vi',
                  color: C.blue,
                  label:
                      l10n(context, 'Initial velocity', 'Panimulang velocity'),
                  unit: 'm/s'),
              _FormulaVariableTile(
                  width: width,
                  symbol: 't',
                  color: C.purple,
                  label: l10n(context, 'Elapsed time', 'Lumipas na oras'),
                  unit: 'seconds (s)'),
            ]);
          }),
        ]),
      ),
      const SizedBox(height: 12),
      _LearnSectionTitle(
        title: l10n(
            context, 'HOW TO USE THE FORMULA', 'PAANO GAMITIN ANG PORMULA'),
        icon: Icons.format_list_numbered_rounded,
        color: C.blue,
      ),
      const SizedBox(height: 8),
      AppCard(
        padding: const EdgeInsets.all(11),
        child: Column(children: [
          _FormulaStep(
              number: '1',
              color: C.blue,
              title: l10n(context, 'Identify the given values',
                  'Tukuyin ang mga ibinigay na halaga'),
              detail: 'vi = 5 m/s     vf = 15 m/s     t = 5 s'),
          _FormulaStep(
              number: '2',
              color: C.green,
              title: l10n(context, 'Write the formula', 'Isulat ang pormula'),
              detail: 'a = (vf − vi) / t'),
          _FormulaStep(
              number: '3',
              color: C.orange,
              title: l10n(
                  context, 'Substitute the values', 'Ihalili ang mga halaga'),
              detail: 'a = (15 − 5) / 5'),
          _FormulaStep(
              number: '4',
              color: C.purple,
              title: l10n(context, 'Solve and add the unit',
                  'Kuwentahin at ilagay ang yunit'),
              detail: 'a = 10 / 5 = 2 m/s²'),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: const Color(0xffe6f7ea),
                borderRadius: BorderRadius.circular(10)),
            child: Row(children: [
              Expanded(
                  child: Text(
                      l10n(
                          context,
                          'A bicycle speeds up from 5 to 15 m/s in 5 s.',
                          'Bumilis ang bisikleta mula 5 hanggang 15 m/s sa loob ng 5 s.'),
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.25,
                        color: isDark(context) ? C.navy : null,
                      ))),
              const VehicleWidget(
                  type: VehicleType.bicycle, width: 77, color: C.orange),
            ]),
          ),
        ]),
      ),
      const SizedBox(height: 12),
      _LearnSectionTitle(
        title: l10n(
            context, 'REMEMBER THESE THREE RULES', 'TATLONG DAPAT TANDAAN'),
        icon: Icons.rule_rounded,
        color: C.purple,
      ),
      const SizedBox(height: 8),
      LayoutBuilder(builder: (context, constraints) {
        final columns = constraints.maxWidth >= 520 ? 3 : 1;
        const gap = 7.0;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(spacing: gap, runSpacing: gap, children: [
          _AccelerationRuleCard(
              width: width,
              color: C.green,
              icon: Icons.arrow_upward_rounded,
              title: l10n(
                  context, 'Positive acceleration', 'Positibong akselerasyon'),
              body: l10n(
                  context,
                  'Velocity increases in the positive direction.',
                  'Tumataas ang velocity sa positibong direksiyon.')),
          _AccelerationRuleCard(
              width: width,
              color: C.red,
              icon: Icons.arrow_downward_rounded,
              title: l10n(
                  context, 'Negative acceleration', 'Negatibong akselerasyon'),
              body: l10n(
                  context,
                  'Velocity changes in the negative direction. It may slow an object or speed it up to the left.',
                  'Nagbabago ang velocity sa negatibong direksiyon. Maaari itong magpabagal o magpabilis pakaliwa.')),
          _AccelerationRuleCard(
              width: width,
              color: C.blue,
              icon: Icons.horizontal_rule_rounded,
              title: l10n(context, 'Zero acceleration', 'Walang akselerasyon'),
              body: l10n(
                  context,
                  'Velocity stays constant, including when the object is at rest.',
                  'Hindi nagbabago ang velocity, pati kapag nakahinto ang bagay.')),
        ]);
      }),
      const SizedBox(height: 12),
      _LearnSectionTitle(
        title: l10n(context, 'CHECK YOUR UNDERSTANDING',
            'SURIIN ANG IYONG PAGKAKAUNAWA'),
        icon: Icons.quiz_rounded,
        color: C.blue,
      ),
      const SizedBox(height: 8),
      _FormulaQuizCard(
        selectedAnswer: _selectedAnswer,
        onAnswer: _answer,
        tagalog: tagalog,
        onTryAgain: () => setState(() => _selectedAnswer = null),
      ),
    ]);
  }
}

class _FormulaVariableTile extends StatelessWidget {
  final double width;
  final String symbol;
  final Color color;
  final String label;
  final String unit;
  const _FormulaVariableTile(
      {required this.width,
      required this.symbol,
      required this.color,
      required this.label,
      required this.unit});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
          decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(10)),
          child: Row(children: [
            CircleAvatar(
                radius: 12,
                backgroundColor: color,
                child: Text(symbol,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w900))),
            const SizedBox(width: 6),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.w900)),
                  Text(unit, style: const TextStyle(fontSize: 10)),
                ])),
          ]),
        ),
      );
}

class _FormulaStep extends StatelessWidget {
  final String number;
  final Color color;
  final String title;
  final String detail;
  const _FormulaStep(
      {required this.number,
      required this.color,
      required this.title,
      required this.detail});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
              color: color.withValues(alpha: .09),
              borderRadius: BorderRadius.circular(10)),
          child: Row(children: [
            CircleAvatar(
                radius: 12,
                backgroundColor: color,
                child: Text(number,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w900))),
            const SizedBox(width: 7),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(title,
                      style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w900,
                          fontSize: 11)),
                  Text(detail,
                      style: const TextStyle(fontSize: 11, height: 1.2)),
                ])),
          ]),
        ),
      );
}

class _AccelerationRuleCard extends StatelessWidget {
  final double width;
  final Color color;
  final IconData icon;
  final String title;
  final String body;
  const _AccelerationRuleCard(
      {required this.width,
      required this.color,
      required this.icon,
      required this.title,
      required this.body});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        child: AppCard(
          color: color.withValues(alpha: .1),
          padding: const EdgeInsets.all(10),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(icon, color: color, size: 23),
            const SizedBox(width: 7),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(title,
                      style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 3),
                  Text(body,
                      style: const TextStyle(fontSize: 11, height: 1.25)),
                ])),
          ]),
        ),
      );
}

class _FormulaQuizCard extends StatelessWidget {
  final int? selectedAnswer;
  final ValueChanged<int> onAnswer;
  final VoidCallback onTryAgain;
  final bool tagalog;
  const _FormulaQuizCard(
      {required this.selectedAnswer,
      required this.onAnswer,
      required this.onTryAgain,
      required this.tagalog});

  static const _answers = ['2 m/s²', '3 m/s²', '4 m/s²', '8 m/s²'];

  @override
  Widget build(BuildContext context) {
    final correct = selectedAnswer == 0;
    return AppCard(
      padding: const EdgeInsets.all(11),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Expanded(
              child: Text(
                  tagalog
                      ? 'Bumilis ang bisikleta mula 4 m/s hanggang 12 m/s sa loob ng 4 s. Ano ang akselerasyon?'
                      : 'A bicycle speeds up from 4 m/s to 12 m/s in 4 s. What is its acceleration?',
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w800))),
          const SizedBox(width: 6),
          const VehicleWidget(
              type: VehicleType.bicycle, width: 62, color: C.blue),
        ]),
        const SizedBox(height: 7),
        LayoutBuilder(builder: (context, constraints) {
          const gap = 6.0;
          final width = (constraints.maxWidth - gap) / 2;
          return Wrap(spacing: gap, runSpacing: gap, children: [
            for (var i = 0; i < _answers.length; i++)
              SizedBox(
                  width: width,
                  child: OutlinedButton(
                    onPressed:
                        selectedAnswer == null ? () => onAnswer(i) : null,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: selectedAnswer == i
                          ? (i == 0 ? C.green : C.red).withValues(alpha: .12)
                          : null,
                      side: BorderSide(
                          color: selectedAnswer == i
                              ? (i == 0 ? C.green : C.red)
                              : C.blue.withValues(alpha: .35)),
                    ),
                    child:
                        Text('${String.fromCharCode(65 + i)}   ${_answers[i]}'),
                  )),
          ]);
        }),
        if (selectedAnswer != null) ...[
          const SizedBox(height: 7),
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
                color: (correct ? C.green : C.red).withValues(alpha: .12),
                borderRadius: BorderRadius.circular(10)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                  correct
                      ? (tagalog ? 'Tama!' : 'Correct!')
                      : (tagalog ? 'Subukan muli.' : 'Not quite.'),
                  style: TextStyle(
                      color: correct ? C.green : C.red,
                      fontWeight: FontWeight.w900)),
              const SizedBox(height: 3),
              Text(
                  tagalog
                      ? 'Gamitin ang a = (vf − vi) / t: (12 − 4) / 4 = 2 m/s². Karaniwang pagkakamali ang hindi paghahati sa lumipas na oras.'
                      : 'Use a = (vf − vi) / t: (12 − 4) / 4 = 2 m/s². A common mistake is finding the velocity change but forgetting to divide by time.',
                  style: const TextStyle(fontSize: 12, height: 1.3)),
              if (!correct)
                Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: onTryAgain,
                        child: Text(tagalog ? 'SUBUKAN MULI' : 'TRY AGAIN'))),
            ]),
          ),
        ],
      ]),
    );
  }
}

class _SessionFiveBanner extends StatelessWidget {
  const _SessionFiveBanner();

  @override
  Widget build(BuildContext context) {
    final tagalog = AppScope.of(context).tagalog;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xff0755ce), Color(0xff168df0)]),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          decoration: BoxDecoration(
              color: C.yellow, borderRadius: BorderRadius.circular(11)),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.menu_book_rounded, color: C.navy, size: 19),
            Text(tagalog ? 'MATUTO' : 'LEARN',
                style: const TextStyle(
                    color: C.navy, fontSize: 12, fontWeight: FontWeight.w900)),
          ]),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            tagalog
                ? 'Positibo at Negatibong Akselerasyon'
                : 'Positive and Negative Acceleration',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
                height: 1.05,
                fontWeight: FontWeight.w900),
          ),
        ),
        const Icon(Icons.flag_rounded, color: C.yellow, size: 27),
      ]),
    );
  }
}

class _SessionFiveLessonContent extends StatelessWidget {
  const _SessionFiveLessonContent();

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(
        l10n(
            context,
            'Acceleration can be positive or negative depending on how velocity changes.',
            'Maaaring positibo o negatibo ang akselerasyon depende sa pagbabago ng velocity.'),
        style: TextStyle(color: subText(context), height: 1.35),
      ),
      const SizedBox(height: 12),
      const _AccelerationSignCard(
        positive: true,
        startSpeed: '5 m/s',
        endSpeed: '15 m/s',
      ),
      const SizedBox(height: 10),
      const _AccelerationSignCard(
        positive: false,
        startSpeed: '20 m/s',
        endSpeed: '10 m/s',
      ),
      const SizedBox(height: 10),
      LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth >= 520) {
          return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(
                child: _SessionFiveTipCard(
              important: true,
              title: l10n(context, 'IMPORTANT', 'MAHALAGA'),
              body: l10n(
                  context,
                  'Negative acceleration does not always mean slowing down. It depends on the direction of motion.',
                  'Hindi palaging nangangahulugan ng pagbagal ang negatibong akselerasyon. Depende ito sa direksiyon ng galaw.'),
            )),
            const SizedBox(width: 8),
            Expanded(
                child: _SessionFiveTipCard(
              important: false,
              title: l10n(context, 'SIMPLE IDEA', 'PAYAK NA IDEYA'),
              body: l10n(
                  context,
                  'Same direction: speed increases. Opposite directions: speed decreases.',
                  'Magkaparehong direksiyon: bumibilis. Magkasalungat na direksiyon: bumabagal.'),
            )),
          ]);
        }
        return Column(children: [
          _SessionFiveTipCard(
            important: true,
            title: l10n(context, 'IMPORTANT', 'MAHALAGA'),
            body: l10n(
                context,
                'Negative acceleration does not always mean slowing down. It depends on the direction of motion.',
                'Hindi palaging nangangahulugan ng pagbagal ang negatibong akselerasyon. Depende ito sa direksiyon ng galaw.'),
          ),
          const SizedBox(height: 8),
          _SessionFiveTipCard(
            important: false,
            title: l10n(context, 'SIMPLE IDEA', 'PAYAK NA IDEYA'),
            body: l10n(
                context,
                'Same direction: speed increases. Opposite directions: speed decreases.',
                'Magkaparehong direksiyon: bumibilis. Magkasalungat na direksiyon: bumabagal.'),
          ),
        ]);
      }),
    ]);
  }
}

class _AccelerationSignCard extends StatelessWidget {
  final bool positive;
  final String startSpeed;
  final String endSpeed;

  const _AccelerationSignCard({
    required this.positive,
    required this.startSpeed,
    required this.endSpeed,
  });

  @override
  Widget build(BuildContext context) {
    final color = positive ? C.green : C.red;
    final title = positive
        ? l10n(context, 'POSITIVE ACCELERATION', 'POSITIBONG AKSELERASYON')
        : l10n(context, 'NEGATIVE ACCELERATION', 'NEGATIBONG AKSELERASYON');
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cardColor(context),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: color, width: 1.5),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 8,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(11)),
          child: Row(children: [
            Icon(positive ? Icons.add_circle : Icons.remove_circle,
                color: Colors.white, size: 20),
            const SizedBox(width: 6),
            Expanded(
                child: Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 13))),
          ]),
        ),
        const SizedBox(height: 6),
        _SignBullet(
            color: color,
            text: positive
                ? l10n(context, 'Velocity increases in the positive direction.',
                    'Tumataas ang velocity sa positibong direksiyon.')
                : l10n(context, 'Velocity decreases in the positive direction.',
                    'Bumababa ang velocity sa positibong direksiyon.')),
        _SignBullet(
            color: color,
            text: positive
                ? l10n(context, 'The object is speeding up.',
                    'Bumibilis ang bagay.')
                : l10n(context, 'The object is slowing down.',
                    'Bumabagal ang bagay.')),
        _SignBullet(
            color: color,
            text: positive
                ? l10n(context, 'Example: a car changes from 5 m/s to 15 m/s.',
                    'Halimbawa: nagbago ang takbo ng kotse mula 5 m/s hanggang 15 m/s.')
                : l10n(context, 'Example: a car changes from 20 m/s to 10 m/s.',
                    'Halimbawa: nagbago ang takbo ng kotse mula 20 m/s hanggang 10 m/s.')),
        const SizedBox(height: 5),
        _AccelerationVehicleScene(
            color: color, startSpeed: startSpeed, endSpeed: endSpeed),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(10)),
          child: Text(
            positive
                ? l10n(
                    context, 'The car is speeding up.', 'Bumibilis ang kotse.')
                : l10n(context, 'The car is slowing down.',
                    'Bumabagal ang kotse.'),
            textAlign: TextAlign.center,
            style: TextStyle(color: color, fontWeight: FontWeight.w900),
          ),
        ),
      ]),
    );
  }
}

class _SignBullet extends StatelessWidget {
  final Color color;
  final String text;
  const _SignBullet({required this.color, required this.text});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Icon(Icons.circle, color: color, size: 6),
          ),
          const SizedBox(width: 6),
          Expanded(
              child: Text(text,
                  style: const TextStyle(fontSize: 12, height: 1.25))),
        ]),
      );
}

class _AccelerationVehicleScene extends StatelessWidget {
  final Color color;
  final String startSpeed;
  final String endSpeed;
  const _AccelerationVehicleScene(
      {required this.color, required this.startSpeed, required this.endSpeed});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(8, 5, 8, 7),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xffc8efff), Color(0xfff0fbff)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _SpeedLabel(text: 'v = $startSpeed', color: color),
            _SpeedLabel(text: 'v = $endSpeed', color: color),
          ]),
          const SizedBox(height: 3),
          Row(children: [
            CarWidget(width: 88, color: positiveCarColor(color)),
            Expanded(
              child: Icon(
                Icons.arrow_right_alt_rounded,
                color: color,
                size: 38,
              ),
            ),
            CarWidget(width: 88, color: positiveCarColor(color)),
          ]),
          const SizedBox(height: 3),
          Container(
              height: 5,
              decoration: BoxDecoration(
                  color: const Color(0xff536174),
                  borderRadius: BorderRadius.circular(5))),
        ]),
      );

  Color positiveCarColor(Color accent) => accent == C.green ? C.red : C.blue;
}

class _SpeedLabel extends StatelessWidget {
  final String text;
  final Color color;
  const _SpeedLabel({required this.text, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .8),
            borderRadius: BorderRadius.circular(8)),
        child: Text(text,
            style: TextStyle(color: color, fontWeight: FontWeight.w900)),
      );
}

class _SessionFiveTipCard extends StatelessWidget {
  final bool important;
  final String title;
  final String body;
  const _SessionFiveTipCard(
      {required this.important, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final color = important ? C.orange : C.blue;
    return AppCard(
      color: color.withValues(alpha: .12),
      padding: const EdgeInsets.all(10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(important ? Icons.warning_rounded : Icons.lightbulb_rounded,
            color: color, size: 22),
        const SizedBox(width: 7),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w900, fontSize: 12)),
          const SizedBox(height: 3),
          Text(body, style: const TextStyle(fontSize: 11, height: 1.3)),
        ])),
      ]),
    );
  }
}

class _SessionSixBanner extends StatelessWidget {
  const _SessionSixBanner();

  @override
  Widget build(BuildContext context) {
    final tagalog = AppScope.of(context).tagalog;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xff0755ce), Color(0xff168df0)]),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          decoration: BoxDecoration(
              color: C.yellow, borderRadius: BorderRadius.circular(11)),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.menu_book_rounded, color: C.navy, size: 19),
            Text(tagalog ? 'MATUTO' : 'LEARN',
                style: const TextStyle(
                    color: C.navy, fontSize: 12, fontWeight: FontWeight.w900)),
          ]),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            tagalog
                ? 'Pag-unawa sa mga Grap ng Akselerasyon'
                : 'Understanding Acceleration Graphs',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
                height: 1.05,
                fontWeight: FontWeight.w900),
          ),
        ),
        const Icon(Icons.show_chart_rounded, color: C.yellow, size: 28),
      ]),
    );
  }
}

class _SessionSixLessonContent extends StatelessWidget {
  const _SessionSixLessonContent();

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n(
                context,
                'Graphs help us see how motion changes over time. In this lesson, we will read a velocity–time graph.',
                'Ipinapakita ng grap kung paano nagbabago ang galaw sa paglipas ng oras. Babasahin natin ang velocity-time graph.'),
            style: TextStyle(color: subText(context), height: 1.35),
          ),
          const SizedBox(height: 11),
          _LearnSectionTitle(
            title: l10n(context, 'VELOCITY-TIME GRAPH', 'VELOCITY-TIME GRAPH'),
            icon: Icons.show_chart_rounded,
            color: C.blue,
          ),
          const SizedBox(height: 8),
          const _VelocityAxesGuide(),
          const SizedBox(height: 12),
          _LearnSectionTitle(
            title: l10n(context, 'WHAT THE GRAPH SHOWS', 'IPINAPAKITA NG GRAP'),
            icon: Icons.insights_rounded,
            color: C.blue,
          ),
          const SizedBox(height: 8),
          LayoutBuilder(builder: (context, constraints) {
            const gap = 7.0;
            final width = (constraints.maxWidth - 2 * gap) / 3;
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                  child: _VelocityTrendCard(
                width: width,
                title: l10n(context, 'Increasing line', 'Linyang pataas'),
                color: C.green,
                trend: _VelocityTrend.increasing,
                first: l10n(
                    context, 'Velocity increases.', 'Tumataas ang velocity.'),
                second: l10n(context, 'Positive acceleration.',
                    'Positibong akselerasyon.'),
                vehicleText: l10n(context, 'Speeding up', 'Bumibilis'),
                carColor: C.red,
              )),
              const SizedBox(width: gap),
              Expanded(
                  child: _VelocityTrendCard(
                width: width,
                title: l10n(context, 'Horizontal line', 'Pahalang na linya'),
                color: C.orange,
                trend: _VelocityTrend.constant,
                first: l10n(context, 'Velocity stays constant.',
                    'Hindi nagbabago ang velocity.'),
                second: l10n(
                    context, 'Acceleration is zero.', 'Walang akselerasyon.'),
                vehicleText:
                    l10n(context, 'Constant speed', 'Pare-parehong bilis'),
                carColor: C.blue,
              )),
              const SizedBox(width: gap),
              Expanded(
                  child: _VelocityTrendCard(
                width: width,
                title: l10n(context, 'Decreasing line', 'Linyang pababa'),
                color: C.red,
                trend: _VelocityTrend.decreasing,
                first: l10n(
                    context, 'Velocity decreases.', 'Bumababa ang velocity.'),
                second: l10n(context, 'Negative acceleration.',
                    'Negatibong akselerasyon.'),
                vehicleText: l10n(context, 'Slowing down', 'Bumabagal'),
                carColor: C.purple,
              )),
            ]);
          }),
          const SizedBox(height: 12),
          _VelocityWorkedExample(),
        ],
      );
}

class _VelocityAxesGuide extends StatelessWidget {
  const _VelocityAxesGuide();

  @override
  Widget build(BuildContext context) => AppCard(
        padding: const EdgeInsets.all(10),
        color: const Color(0xffeef8ff),
        child: Row(children: [
          const Expanded(
            flex: 5,
            child: SizedBox(
              height: 133,
              child: CustomPaint(
                  painter: _VelocityGraphPainter(
                      trend: _VelocityTrend.increasing, compact: false)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 6,
            child: Column(children: [
              _AxisExplanation(
                axis: 'X',
                title: l10n(context, 'X-axis → Time (s)', 'X-axis → Oras (s)'),
                body: l10n(context, 'Shows how time changes.',
                    'Ipinapakita ang pagbabago ng oras.'),
                color: C.blue,
              ),
              const SizedBox(height: 7),
              _AxisExplanation(
                axis: 'Y',
                title: l10n(context, 'Y-axis → Velocity (m/s)',
                    'Y-axis → Velocity (m/s)'),
                body: l10n(context, 'Shows how velocity changes.',
                    'Ipinapakita ang pagbabago ng velocity.'),
                color: C.purple,
              ),
            ]),
          ),
        ]),
      );
}

class _AxisExplanation extends StatelessWidget {
  final String axis;
  final String title;
  final String body;
  final Color color;
  const _AxisExplanation(
      {required this.axis,
      required this.title,
      required this.body,
      required this.color});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        decoration: BoxDecoration(
            color: color.withValues(alpha: .09),
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: color.withValues(alpha: .25))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: TextStyle(
                  color: color, fontSize: 12, fontWeight: FontWeight.w900)),
          Text(body, style: const TextStyle(fontSize: 10, height: 1.25)),
        ]),
      );
}

enum _VelocityTrend { increasing, constant, decreasing }

class _VelocityTrendCard extends StatelessWidget {
  final double width;
  final String title;
  final Color color;
  final _VelocityTrend trend;
  final String first;
  final String second;
  final String vehicleText;
  final Color carColor;
  const _VelocityTrendCard(
      {required this.width,
      required this.title,
      required this.color,
      required this.trend,
      required this.first,
      required this.second,
      required this.vehicleText,
      required this.carColor});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
              color: color.withValues(alpha: .09),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: .55))),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(title,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.w900, fontSize: 10)),
            const SizedBox(height: 3),
            SizedBox(
                height: 65,
                child: CustomPaint(
                    painter: _VelocityGraphPainter(
                        trend: trend, compact: true, color: color))),
            _VelocityBullet(color: color, text: first),
            _VelocityBullet(color: color, text: second),
            const SizedBox(height: 4),
            VehicleWidget(type: VehicleType.car, width: 66, color: carColor),
            Text(vehicleText,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.w800, fontSize: 9)),
          ]),
        ),
      );
}

class _VelocityBullet extends StatelessWidget {
  final Color color;
  final String text;
  const _VelocityBullet({required this.color, required this.text});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.check_circle, color: color, size: 11),
          const SizedBox(width: 3),
          Expanded(
              child: Text(text,
                  style: const TextStyle(fontSize: 9, height: 1.15))),
        ]),
      );
}

class _VelocityWorkedExample extends StatelessWidget {
  const _VelocityWorkedExample();

  @override
  Widget build(BuildContext context) => AppCard(
        color: const Color(0xffeaf6ff),
        padding: const EdgeInsets.all(11),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            const Icon(Icons.lightbulb_rounded, color: C.yellow, size: 22),
            const SizedBox(width: 6),
            Expanded(
                child: Text(
                    l10n(context, 'SIMPLE EXAMPLE', 'PAYAK NA HALIMBAWA'),
                    style: const TextStyle(
                        color: C.blue, fontWeight: FontWeight.w900))),
          ]),
          const SizedBox(height: 7),
          LayoutBuilder(builder: (context, constraints) {
            final wide = constraints.maxWidth >= 410;
            final text =
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                  l10n(
                      context,
                      'If a car changes velocity from 0 m/s to 20 m/s over 5 seconds, the graph will show an upward line.',
                      'Kung nagbago ang velocity ng kotse mula 0 m/s hanggang 20 m/s sa loob ng 5 segundo, pataas ang linya sa grap.'),
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 12, height: 1.3)),
              const SizedBox(height: 5),
              Text('a = (20 − 0) / 5 = 4 m/s²',
                  style: const TextStyle(
                      color: C.purple, fontWeight: FontWeight.w900)),
              const SizedBox(height: 5),
              const CarWidget(width: 90, color: C.red),
            ]);
            const graph = SizedBox(
                height: 120,
                child: CustomPaint(
                    painter: _VelocityGraphPainter(
                        trend: _VelocityTrend.increasing,
                        compact: false,
                        color: C.blue,
                        endpointLabel: '(5 s, 20 m/s)')));
            if (wide) {
              return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: text),
                    const SizedBox(width: 8),
                    const Expanded(child: graph),
                  ]);
            }
            return Column(children: [text, const SizedBox(height: 4), graph]);
          }),
        ]),
      );
}

class _VelocityGraphPainter extends CustomPainter {
  final _VelocityTrend trend;
  final bool compact;
  final Color color;
  final String? endpointLabel;
  const _VelocityGraphPainter(
      {required this.trend,
      required this.compact,
      this.color = C.blue,
      this.endpointLabel});

  @override
  void paint(Canvas canvas, Size size) {
    final left = compact ? 12.0 : 30.0;
    final top = compact ? 6.0 : 20.0;
    final right = compact ? 5.0 : 8.0;
    final bottom = compact ? 12.0 : 23.0;
    final plot =
        Rect.fromLTRB(left, top, size.width - right, size.height - bottom);
    if (plot.width <= 0 || plot.height <= 0) return;
    final grid = Paint()
      ..color = Colors.blueGrey.withValues(alpha: .18)
      ..strokeWidth = 1;
    for (var i = 0; i <= (compact ? 2 : 4); i++) {
      final y = plot.top + plot.height * i / (compact ? 2 : 4);
      canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), grid);
    }
    for (var i = 0; i <= (compact ? 2 : 5); i++) {
      final x = plot.left + plot.width * i / (compact ? 2 : 5);
      canvas.drawLine(Offset(x, plot.top), Offset(x, plot.bottom), grid);
    }
    final axis = Paint()
      ..color = const Color(0xff384b60)
      ..strokeWidth = 1.5;
    canvas.drawLine(plot.bottomLeft, plot.topLeft, axis);
    canvas.drawLine(plot.bottomLeft, plot.bottomRight, axis);
    final line = Paint()
      ..color = color
      ..strokeWidth = compact ? 2.3 : 3
      ..strokeCap = StrokeCap.round;
    final start = Offset(plot.left, plot.bottom);
    final end = switch (trend) {
      _VelocityTrend.increasing => Offset(plot.right, plot.top),
      _VelocityTrend.constant => Offset(plot.right, plot.center.dy),
      _VelocityTrend.decreasing => plot.topRight,
    };
    final actualEnd = trend == _VelocityTrend.decreasing
        ? Offset(plot.right, plot.bottom)
        : end;
    final actualStart =
        trend == _VelocityTrend.decreasing ? plot.topLeft : start;
    canvas.drawLine(actualStart, actualEnd, line);
    if (!compact) {
      _drawLabel(canvas, 'Velocity (m/s)', Offset(plot.left, 1));
      _drawLabel(canvas, 'Time (s)', Offset(plot.right, size.height - 1),
          anchorX: 1, anchorY: 1);
      _drawLabel(canvas, '0', Offset(plot.left - 4, plot.bottom),
          anchorX: 1, anchorY: 1);
      if (endpointLabel != null) {
        _drawLabel(canvas, endpointLabel!, Offset(plot.right, plot.top),
            anchorX: 1, anchorY: 0);
      }
    } else {
      _drawLabel(canvas, 'Time (s)', Offset(plot.right, size.height - 1),
          anchorX: 1, anchorY: 1);
    }
  }

  void _drawLabel(Canvas canvas, String text, Offset at,
      {double anchorX = 0, double anchorY = 0}) {
    final painter = TextPainter(
      text: TextSpan(
          text: text,
          style: const TextStyle(
              color: Color(0xff34465a), fontSize: 8, height: 1.1)),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
        canvas, at - Offset(painter.width * anchorX, painter.height * anchorY));
  }

  @override
  bool shouldRepaint(covariant _VelocityGraphPainter oldDelegate) =>
      oldDelegate.trend != trend ||
      oldDelegate.compact != compact ||
      oldDelegate.color != color ||
      oldDelegate.endpointLabel != endpointLabel;
}

class _SessionTwoLessonContent extends StatefulWidget {
  const _SessionTwoLessonContent();

  @override
  State<_SessionTwoLessonContent> createState() =>
      _SessionTwoLessonContentState();
}

class _SessionTwoLessonContentState extends State<_SessionTwoLessonContent> {
  VehicleType _vehicle = VehicleType.bicycle;

  @override
  Widget build(BuildContext context) {
    final tagalog = AppScope.of(context).tagalog;
    final vehicleOptions = <(VehicleType, String, String)>[
      (VehicleType.autoRickshaw, 'Auto rickshaw', 'Auto-rickshaw'),
      (VehicleType.car, 'Car', 'Kotse'),
      (VehicleType.bicycle, 'Bicycle', 'Bisikleta'),
      (VehicleType.bus, 'Bus', 'Bus'),
      (VehicleType.train, 'Train', 'Tren'),
    ];

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      AppCard(
        color: C.blue.withValues(alpha: .12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const CircleAvatar(
            backgroundColor: C.blue,
            child: Icon(Icons.compare_arrows_rounded, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                l10n(context, 'Speed vs. Velocity', 'Speed at Velocity'),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 5),
              Text(
                l10n(
                  context,
                  'Speed tells how fast an object moves. Velocity tells how fast and in which direction it moves.',
                  'Ipinapakita ng speed kung gaano kabilis gumagalaw ang isang bagay. Ipinapakita naman ng velocity ang bilis at direksiyon nito.',
                ),
                style: const TextStyle(height: 1.4),
              ),
            ]),
          ),
        ]),
      ),
      const SizedBox(height: 10),
      AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(children: [
          const Icon(Icons.directions_rounded, color: C.blue),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
                l10n(context, 'Choose a vehicle for the examples',
                    'Pumili ng sasakyan para sa mga halimbawa'),
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface)),
          ),
          DropdownButton<VehicleType>(
            value: _vehicle,
            underline: const SizedBox.shrink(),
            items: [
              for (final option in vehicleOptions)
                DropdownMenuItem(
                  value: option.$1,
                  child: Text(tagalog ? option.$3 : option.$2),
                ),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _vehicle = value);
            },
          ),
        ]),
      ),
      const SizedBox(height: 14),
      _LearnSectionTitle(
        title: l10n(context, 'THREE WAYS VELOCITY CHANGES',
            'TATLONG PARAAN NG PAGBABAGO NG VELOCITY'),
        icon: Icons.speed_rounded,
        color: C.blue,
      ),
      const SizedBox(height: 8),
      Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _SessionTwoMotionCard(
          width: double.infinity,
          number: '1',
          title: l10n(context, 'Speeding Up', 'Bumibilis'),
          color: C.green,
          vehicle: _vehicle,
          values: '5 → 10 → 15 m/s',
          explanation: l10n(
              context,
              'The speed increases, so velocity changes.',
              'Tumataas ang bilis kaya nagbabago ang velocity.'),
        ),
        const SizedBox(height: 8),
        _SessionTwoMotionCard(
          width: double.infinity,
          number: '2',
          title: l10n(context, 'Slowing Down', 'Bumabagal'),
          color: C.purple,
          vehicle: _vehicle,
          values: '15 → 10 → 5 m/s',
          explanation: l10n(
              context,
              'Braking changes velocity. Acceleration can point opposite the motion.',
              'Binabago ng pagpreno ang velocity. Maaaring kabaligtaran ng galaw ang akselerasyon.'),
        ),
        const SizedBox(height: 8),
        _SessionTwoMotionCard(
          width: double.infinity,
          number: '3',
          title: l10n(context, 'Changing Lane', 'Pagpapalit ng Lane'),
          color: C.teal,
          vehicle: _vehicle,
          values: '10 m/s · lane change',
          explanation: l10n(
              context,
              'The bicycle moves into the next lane. Its direction changes even though its speed stays the same.',
              'Lumilipat ang bisikleta sa katabing lane. Nagbabago ang direksiyon nito kahit pareho ang bilis.'),
          laneChange: true,
        ),
      ]),
      const SizedBox(height: 14),
      _LearnSectionTitle(
        title: l10n(context, 'SPEED AND VELOCITY: WHAT IS THE DIFFERENCE?',
            'SPEED AT VELOCITY: ANO ANG PAGKAKAIBA?'),
        icon: Icons.compare_arrows_rounded,
        color: C.blue,
      ),
      const SizedBox(height: 8),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: _SessionTwoDefinitionCard(
            title: l10n(context, 'SPEED', 'SPEED'),
            color: C.blue,
            icon: Icons.speed_rounded,
            body: l10n(
                context,
                'How fast an object moves. It has no direction.',
                'Gaano kabilis gumagalaw ang bagay. Wala itong direksiyon.'),
            example: '20 m/s',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SessionTwoDefinitionCard(
            title: l10n(context, 'VELOCITY', 'VELOCITY'),
            color: C.purple,
            icon: Icons.navigation_rounded,
            body: l10n(
                context,
                'How fast and in which direction an object moves.',
                'Gaano kabilis at saang direksiyon gumagalaw ang bagay.'),
            example: l10n(context, '20 m/s east', '20 m/s pasilangan'),
          ),
        ),
      ]),
      const SizedBox(height: 8),
      AppCard(
        color: C.orange.withValues(alpha: .12),
        child: Row(children: [
          const Icon(Icons.star_rounded, color: C.orange),
          const SizedBox(width: 8),
          Expanded(
            child: Text.rich(TextSpan(children: [
              TextSpan(
                  text: l10n(context, 'Key message: ', 'Mahalagang tandaan: '),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                text: l10n(
                    context,
                    'Speed tells how fast. Velocity tells how fast and the direction. Acceleration is a change in velocity.',
                    'Ipinapakita ng speed kung gaano kabilis. Ipinapakita ng velocity ang bilis at direksiyon. Ang akselerasyon ay pagbabago ng velocity.'),
              ),
            ])),
          ),
        ]),
      ),
      const SizedBox(height: 14),
      _LearnSectionTitle(
        title: l10n(
            context, 'PRACTICAL TAGBINA EXAMPLES', 'MGA HALIMBAWA SA TAGBINA'),
        icon: Icons.place_rounded,
        color: C.teal,
      ),
      const SizedBox(height: 8),
      LayoutBuilder(builder: (context, constraints) {
        const gap = 8.0;
        final columns = constraints.maxWidth >= 600 ? 4 : 2;
        final cardWidth =
            (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(spacing: gap, runSpacing: gap, children: [
          _SessionTwoPracticalCard(
            width: cardWidth,
            color: C.blue,
            vehicle: VehicleType.bus,
            heading: l10n(context, 'SPEED', 'BILIS'),
            text: l10n(context, 'A Bachelor Tours bus travels at 20 m/s.',
                'Tumatakbo ang bus ng Bachelor Tours nang 20 m/s.'),
            value: '20 m/s',
          ),
          _SessionTwoPracticalCard(
            width: cardWidth,
            color: C.purple,
            vehicle: VehicleType.bus,
            roadMarker: _RoadMarker.velocity,
            heading: l10n(context, 'VELOCITY', 'BILIS AT DIREKSIYON'),
            text: l10n(context, 'A Bachelor Tours bus travels at 20 m/s east.',
                'Tumatakbo pasilangan ang bus ng Bachelor Tours nang 20 m/s.'),
            value: l10n(context, '20 m/s east', '20 m/s pasilangan'),
          ),
          _SessionTwoPracticalCard(
            width: cardWidth,
            color: C.green,
            vehicle: VehicleType.bus,
            roadMarker: _RoadMarker.acceleration,
            heading: l10n(context, 'ACCELERATION', 'AKSELERASYON'),
            text: l10n(
                context,
                'The bus speeds up from 20 to 30 m/s east in 5 s.',
                'Bumilis ang bus mula 20 hanggang 30 m/s pasilangan sa loob ng 5 s.'),
            value: l10n(context, 'Speed changed · a = 2 m/s²',
                'Nagbago ang bilis · a = 2 m/s²'),
          ),
          _SessionTwoPracticalCard(
            width: cardWidth,
            color: C.teal,
            vehicle: VehicleType.bus,
            roadMarker: _RoadMarker.turn,
            curvedRoad: true,
            heading: l10n(context, 'ACCELERATION', 'AKSELERASYON'),
            text: l10n(context, 'The bus turns north while maintaining 20 m/s.',
                'Lumingon pahilaga ang bus habang nananatili sa 20 m/s ang bilis.'),
            value: l10n(context, 'Direction changed', 'Nagbago ang direksiyon'),
          ),
        ]);
      }),
    ]);
  }
}

class _SessionTwoMotionCard extends StatefulWidget {
  final double width;
  final String number;
  final String title;
  final Color color;
  final VehicleType vehicle;
  final String values;
  final String explanation;
  final bool laneChange;

  const _SessionTwoMotionCard({
    required this.width,
    required this.number,
    required this.title,
    required this.color,
    required this.vehicle,
    required this.values,
    required this.explanation,
    this.laneChange = false,
  });

  @override
  State<_SessionTwoMotionCard> createState() => _SessionTwoMotionCardState();
}

class _SessionTwoMotionCardState extends State<_SessionTwoMotionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _laneController;

  @override
  void initState() {
    super.initState();
    _laneController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2600));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateLaneAnimation();
  }

  @override
  void didUpdateWidget(covariant _SessionTwoMotionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.laneChange != widget.laneChange) _updateLaneAnimation();
  }

  void _updateLaneAnimation() {
    if (widget.laneChange && AppScope.of(context).animation) {
      if (!_laneController.isAnimating) _laneController.repeat(reverse: true);
    } else {
      _laneController
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _laneController.dispose();
    super.dispose();
  }

  Widget _laneChangeScene() => SizedBox(
        height: 86,
        child: LayoutBuilder(builder: (context, constraints) {
          return AnimatedBuilder(
            animation: _laneController,
            builder: (context, _) {
              final progress =
                  Curves.easeInOut.transform(_laneController.value);
              final bikeWidth = math.min(44.0, constraints.maxWidth * .2);
              final endX = math.max(0.0, constraints.maxWidth - bikeWidth);
              const sceneHeight = 86.0;
              final forward =
                  _laneController.status != AnimationStatus.reverse;
              var bikePos = Offset.zero;
              var bikeAngle = 0.0;
              if (widget.vehicle == VehicleType.bicycle) {
                final lanePath = _LaneChangeRoadPainter.lanePathOf(
                    Size(constraints.maxWidth, sceneHeight));
                final metric = lanePath.computeMetrics().first;
                final tangent = metric.getTangentForOffset(
                    (metric.length * progress).clamp(0.0, metric.length));
                if (tangent != null) {
                  bikePos = tangent.position;
                  var angle = math.atan2(tangent.vector.dy, tangent.vector.dx);
                  if (!forward) angle += math.pi;
                  // The sprite artwork faces down; align it with the ride.
                  bikeAngle = angle - math.pi / 2;
                }
              }
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _LaneChangeRoadPainter(color: widget.color),
                    ),
                  ),
                  if (widget.vehicle == VehicleType.bicycle)
                    Positioned(
                      left: bikePos.dx,
                      top: bikePos.dy,
                      child: FractionalTranslation(
                        translation: const Offset(-0.5, -0.5),
                        child: Transform.rotate(
                          angle: bikeAngle,
                          child: Image.asset(
                            'assets/images/top_down_biker.png',
                            width: 30,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    )
                  else
                    Positioned(
                      left: 6 + (endX - 6) * progress,
                      bottom: 1 + 40 * progress,
                      child: Transform.scale(
                        scaleX: _laneController.status == AnimationStatus.reverse
                            ? -1
                            : 1,
                        child: VehicleWidget(
                          type: widget.vehicle,
                          width: bikeWidth,
                          spin: math.sin(progress * math.pi) * 4,
                        ),
                      ),
                    ),
                ]),
              );
            },
          );
        }),
      );

  @override
  Widget build(BuildContext context) => SizedBox(
        width: widget.width,
        child: AppCard(
          padding: const EdgeInsets.all(8),
          color: widget.color.withValues(alpha: .1),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              CircleAvatar(
                radius: 11,
                backgroundColor: widget.color,
                child: Text(widget.number,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(widget.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: widget.color,
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
              ),
            ]),
            const SizedBox(height: 8),
            if (widget.laneChange)
              _laneChangeScene()
            else
              SizedBox(
                height: 40,
                child: Stack(alignment: Alignment.center, children: [
                  Container(
                    height: 13,
                    decoration: BoxDecoration(
                      color: const Color(0xff566174),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: VehicleWidget(
                      type: widget.vehicle,
                      width: widget.vehicle == VehicleType.bicycle ? 40 : 54,
                    ),
                  ),
                ]),
              ),
            Text(widget.values,
                maxLines: 2,
                style:
                    const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(widget.explanation,
                style: TextStyle(
                    fontSize: 10, height: 1.25, color: subText(context))),
          ]),
        ),
      );
}

class _LaneChangeRoadPainter extends CustomPainter {
  final Color color;
  const _LaneChangeRoadPainter({required this.color});

  // Shared lane geometry: rider enters from the right, rides straight to the
  // intersection, then turns right across it. Used by the road painter and by
  // the biker sprite overlay so they always line up.
  static Path lanePathOf(Size size) => Path()
    ..moveTo(size.width - 12, size.height * .55)
    ..lineTo(size.width * .42, size.height * .55)
    ..cubicTo(size.width * .30, size.height * .55, size.width * .26,
        size.height * .44, size.width * .26, size.height * .30);

  @override
  void paint(Canvas canvas, Size size) {
    // Concrete surroundings around the intersection.
    canvas.drawRect(
        Offset.zero & size, Paint()..color = const Color(0xFFA9ADB5));

    final road = Paint()..color = const Color(0xff45525f);
    final hTop = size.height * .20;
    final hBottom = size.height * .88;
    // Horizontal road.
    canvas.drawRect(Rect.fromLTWH(0, hTop, size.width, hBottom - hTop), road);
    // Vertical crossing road — centered where the rider makes the right turn.
    final vLeft = size.width * .13;
    final vRight = size.width * .37;
    canvas.drawRect(Rect.fromLTWH(vLeft, 0, vRight - vLeft, size.height), road);

    // White dashed lane markings on both roads.
    final laneMark = Paint()
      ..color = Colors.white.withValues(alpha: .85)
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    final midY = size.height * .54;
    for (var x = 6.0; x < size.width - 8; x += 22) {
      if (x + 12 > vLeft && x < vRight) continue;
      canvas.drawLine(Offset(x, midY),
          Offset(math.min(x + 10, size.width), midY), laneMark);
    }
    final midX = (vLeft + vRight) / 2;
    for (var y = 6.0; y < size.height - 8; y += 22) {
      if (y + 12 > hTop && y < hBottom) continue;
      canvas.drawLine(Offset(midX, y),
          Offset(midX, math.min(y + 10, size.height)), laneMark);
    }

    final lanePath = lanePathOf(size);
    canvas.drawPath(
      lanePath,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );
    final end = Offset(size.width * .26, size.height * .26);
    canvas.drawCircle(end, 3, Paint()..color = Colors.white);
    final arrow = Path()
      ..moveTo(end.dx - 5, end.dy + 7)
      ..lineTo(end.dx, end.dy)
      ..lineTo(end.dx + 5, end.dy + 7);
    canvas.drawPath(
      arrow,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _LaneChangeRoadPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _SessionTwoDefinitionCard extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  final String body;
  final String example;

  const _SessionTwoDefinitionCard({
    required this.title,
    required this.color,
    required this.icon,
    required this.body,
    required this.example,
  });

  @override
  Widget build(BuildContext context) => AppCard(
        padding: const EdgeInsets.all(12),
        color: color.withValues(alpha: .1),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Text(title,
                style: TextStyle(color: color, fontWeight: FontWeight.w900)),
          ]),
          const SizedBox(height: 6),
          Text(body, style: const TextStyle(fontSize: 12, height: 1.3)),
          const SizedBox(height: 8),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(20)),
              child: Text(example,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ]),
      );
}

enum _RoadMarker { none, velocity, acceleration, turn }

class _SessionTwoPracticalCard extends StatelessWidget {
  final double width;
  final Color color;
  final VehicleType vehicle;
  final _RoadMarker roadMarker;
  final bool curvedRoad;
  final String heading;
  final String text;
  final String value;

  const _SessionTwoPracticalCard({
    required this.width,
    required this.color,
    required this.vehicle,
    this.roadMarker = _RoadMarker.none,
    this.curvedRoad = false,
    required this.heading,
    required this.text,
    required this.value,
  });

  Widget _markerBadge() => DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .88),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .16),
              blurRadius: 4,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Icon(
            switch (roadMarker) {
              _RoadMarker.velocity => Icons.arrow_forward_rounded,
              _RoadMarker.acceleration => Icons.fast_forward_rounded,
              _RoadMarker.turn => Icons.turn_right_rounded,
              _RoadMarker.none => Icons.arrow_forward_rounded,
            },
            color: color,
            size: 25,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        child: Container(
          decoration: BoxDecoration(
            color: cardColor(context),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: color.withValues(alpha: .8), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: .12),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(7),
          child: Column(children: [
            SizedBox(
              height: 72,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: LayoutBuilder(builder: (context, constraints) {
                  final vehicleWidth = math.min(
                      constraints.maxWidth *
                          (roadMarker == _RoadMarker.none ? .70 : .58),
                      118.0);
                  if (curvedRoad) {
                    // Overhead intersection scene, same style as the lane
                    // change card: approach from the right, turn right at the
                    // crossing (the bus "turns north").
                    final metric = _LaneChangeRoadPainter.lanePathOf(
                            Size(constraints.maxWidth, 72))
                        .computeMetrics()
                        .first;
                    final tangent =
                        metric.getTangentForOffset(metric.length * .75)!;
                    final angle =
                        math.atan2(tangent.vector.dy, tangent.vector.dx) -
                            math.pi; // the bus artwork faces left
                    return Stack(children: [
                      Positioned.fill(
                        child: CustomPaint(
                            painter: _LaneChangeRoadPainter(color: color)),
                      ),
                      Positioned(
                        left: tangent.position.dx,
                        top: tangent.position.dy,
                        child: FractionalTranslation(
                          translation: const Offset(-0.5, -0.5),
                          child: Transform.rotate(
                            angle: angle,
                            child: _TopDownBus(
                                width:
                                    math.min(58.0, constraints.maxWidth * .48)),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 7,
                        top: 8,
                        child: _markerBadge(),
                      ),
                    ]);
                  }
                  return Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                            painter:
                                _TagbilaranRoadPainter(curved: curvedRoad)),
                      ),
                      if (roadMarker != _RoadMarker.none)
                        Positioned(
                          left: 5,
                          bottom: 1,
                          child: VehicleWidget(
                            type: vehicle,
                            width: vehicleWidth,
                          ),
                        )
                      else
                        Positioned(
                          bottom: 1,
                          child: VehicleWidget(
                            type: vehicle,
                            width: vehicleWidth,
                          ),
                        ),
                      if (roadMarker != _RoadMarker.none)
                        Positioned(
                          right: 7,
                          top: roadMarker == _RoadMarker.turn ? 8 : null,
                          bottom: roadMarker == _RoadMarker.turn ? null : 8,
                          child: _markerBadge(),
                        ),
                    ],
                  );
                }),
              ),
            ),
            const SizedBox(height: 5),
            Text(text,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 10, color: subText(context))),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(10)),
              child: Text('$heading · $value',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
            ),
          ]),
        ),
      );
}

// Overhead bus (placeholder matching the reference art: yellow body, green
// stripes, silver front cap, dark glass). Front points LEFT (-x).
class _TopDownBus extends StatelessWidget {
  final double width;
  const _TopDownBus({required this.width});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        height: width * .5,
        child: CustomPaint(
            size: Size(width, width * .5), painter: _TopDownBusPainter()),
      );
}

class _TopDownBusPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Unit space: bus is 52 long x 24 wide, centered at the origin.
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(size.width / 52.0);

    // Soft shadow under the bus.
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: const Offset(1, 2.5), width: 54, height: 24),
            const Radius.circular(8)),
        Paint()..color = Colors.black.withValues(alpha: .18));

    // Roof body.
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset.zero, width: 52, height: 24),
            const Radius.circular(7)),
        Paint()..color = const Color(0xFFFFC400));

    // Front silver cap + dark windshield (front at left).
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(-27, -10.5, 7, 21), const Radius.circular(5)),
        Paint()..color = const Color(0xFFB4BAC2));
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(-20, -9, 6.5, 18), const Radius.circular(2)),
        Paint()..color = const Color(0xFF2E3A46));

    // Green stripes across the front section.
    final stripe = Paint()..color = const Color(0xFF3E9B4F);
    canvas.drawRect(Rect.fromLTWH(-14, -12, 3.5, 24), stripe);
    canvas.drawRect(Rect.fromLTWH(-9, -12, 2.5, 24), stripe);

    // Roof hatch and rear AC unit.
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(1, -6, 9, 12), const Radius.circular(2)),
        Paint()..color = const Color(0xFFE8B421));
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(15, -6.5, 8, 13), const Radius.circular(2)),
        Paint()..color = const Color(0xFF9AA2AB));

    // Side windows.
    final glass = Paint()..color = const Color(0xFF2E3A46);
    for (var x = 3.0; x <= 21.0; x += 5.5) {
      canvas.drawRect(Rect.fromLTWH(x, -11, 3, 2.2), glass);
      canvas.drawRect(Rect.fromLTWH(x, 8.8, 3, 2.2), glass);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _TopDownBusPainter old) => false;
}

class _TagbilaranRoadPainter extends CustomPainter {
  final bool curved;
  const _TagbilaranRoadPainter({this.curved = false});

  @override
  void paint(Canvas canvas, Size size) {
    // Bright sky and a few soft clouds, like the illustrated lesson cards.
    final sky = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF49BDEC), Color(0xFFB9EDFA)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, sky);

    final cloud = Paint()..color = const Color(0xFFEAFBFF);
    canvas.drawOval(
        Rect.fromLTWH(size.width * .13, size.height * .12, size.width * .16,
            size.height * .12),
        cloud);
    canvas.drawOval(
        Rect.fromLTWH(size.width * .19, size.height * .08, size.width * .15,
            size.height * .17),
        cloud);
    canvas.drawOval(
        Rect.fromLTWH(size.width * .25, size.height * .12, size.width * .14,
            size.height * .12),
        cloud);

    // Layered tropical greenery along the far side of the road.
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * .55, size.width, size.height * .16),
      Paint()..color = const Color(0xFF9BD66B),
    );
    final trunk = Paint()..color = const Color(0xFF8C5A35);
    final leafBack = Paint()..color = const Color(0xFF258849);
    final leafFront = Paint()..color = const Color(0xFF39A957);
    for (final x in [size.width * .07, size.width * .50, size.width * .91]) {
      canvas.drawRect(
        Rect.fromLTWH(x - 1.5, size.height * .31, 3, size.height * .34),
        trunk,
      );
      canvas.drawCircle(
          Offset(x, size.height * .34), size.height * .16, leafBack);
      canvas.drawCircle(Offset(x - size.height * .10, size.height * .42),
          size.height * .12, leafFront);
      canvas.drawCircle(Offset(x + size.height * .10, size.height * .42),
          size.height * .12, leafFront);
    }

    if (curved) {
      // Road travels east, then bends smoothly toward the top right corner
      // like the turning example image — the bus "turns north".
      final roadPath = Path()
        ..moveTo(-size.width * .05, size.height * .80)
        ..lineTo(size.width * .42, size.height * .80)
        ..cubicTo(
            size.width * .70,
            size.height * .80,
            size.width * .86,
            size.height * .62,
            size.width * .96,
            size.height * .44)
        ..lineTo(size.width * 1.06, size.height * .38);
      canvas.drawPath(
        roadPath,
        Paint()
          ..color = const Color(0xFFF6F5E9)
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.height * .35
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
      canvas.drawPath(
        roadPath,
        Paint()
          ..color = const Color(0xFF59656A)
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.height * .29
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
      for (final metric in roadPath.computeMetrics()) {
        for (var distance = 0.0; distance < metric.length; distance += 14) {
          canvas.drawPath(
            metric.extractPath(distance, math.min(distance + 7, metric.length)),
            Paint()
              ..color = const Color(0xFFFFE082)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.7
              ..strokeCap = StrokeCap.round,
          );
        }
      }
    } else {
      final roadTop = size.height * .69;
      canvas.drawRect(
        Rect.fromLTWH(0, roadTop, size.width, size.height - roadTop),
        Paint()..color = const Color(0xFF59656A),
      );
      canvas.drawRect(
        Rect.fromLTWH(0, roadTop, size.width, 2.5),
        Paint()..color = const Color(0xFFF6F5E9),
      );
      final dash = Paint()
        ..color = const Color(0xFFFFE082)
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round;
      final centerY = roadTop + (size.height - roadTop) * .68;
      for (var x = size.width * .04; x < size.width; x += size.width * .24) {
        canvas.drawLine(
            Offset(x, centerY), Offset(x + size.width * .11, centerY), dash);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TagbilaranRoadPainter oldDelegate) =>
      oldDelegate.curved != curved;
}

class _LearnSectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  const _LearnSectionTitle(
      {required this.title, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(13)),
        child: Row(children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: .3),
            ),
          ),
        ]),
      );
}

class _MiniPoint extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  const _MiniPoint(
      {required this.icon, required this.color, required this.text});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Row(children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12))),
        ]),
      );
}

class _ExampleTile extends StatelessWidget {
  final double width;
  final String title;
  final IconData icon;
  final Color color;
  final String text;
  final String formula;
  const _ExampleTile(
      {required this.width,
      required this.title,
      required this.icon,
      required this.color,
      required this.text,
      required this.formula});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        child: AppCard(
          padding: const EdgeInsets.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 4),
              Expanded(
                  child: Text(title,
                      style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)))
            ]),
            const SizedBox(height: 7),
            Text(text, style: const TextStyle(fontSize: 12, height: 1.3)),
            const SizedBox(height: 7),
            Text(formula,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 11)),
          ]),
        ),
      );
}

class _TermTile extends StatelessWidget {
  final double width;
  final String number;
  final Color color;
  final String term;
  final String meaning;
  final String formula;
  const _TermTile(
      {required this.width,
      required this.number,
      required this.color,
      required this.term,
      required this.meaning,
      required this.formula});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        child: AppCard(
          color: color.withValues(alpha: .09),
          padding: const EdgeInsets.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              CircleAvatar(
                  radius: 11,
                  backgroundColor: color,
                  child: Text(number,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold))),
              const SizedBox(width: 5),
              Expanded(
                  child: Text(term,
                      style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)))
            ]),
            const SizedBox(height: 7),
            Text(meaning, style: const TextStyle(fontSize: 11, height: 1.25)),
            const SizedBox(height: 5),
            Text(formula,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.w600, fontSize: 10)),
          ]),
        ),
      );
}

// A looping animation: the car moves, and the dots show equal time steps.
// Dots spreading apart = speeding up, bunching up = slowing down.
class MotionScene extends StatefulWidget {
  final Motion motion;
  final Color color;
  final VehicleType initialVehicle;
  const MotionScene({
    super.key,
    required this.motion,
    required this.color,
    this.initialVehicle = VehicleType.autoRickshaw,
  });

  @override
  State<MotionScene> createState() => _MotionSceneState();
}

class _MotionSceneState extends State<MotionScene>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late int _vehicleIndex;

  static const _vehicles = <_VehicleOption>[
    _VehicleOption('Auto rickshaw', VehicleType.autoRickshaw, 'Auto-rickshaw'),
    _VehicleOption('Car', VehicleType.car, 'Kotse'),
    _VehicleOption('Bicycle', VehicleType.bicycle, 'Bisikleta'),
    _VehicleOption('Bus', VehicleType.bus, 'Bus'),
    _VehicleOption('Train', VehicleType.train, 'Tren'),
  ];

  @override
  void initState() {
    super.initState();
    _vehicleIndex =
        _vehicles.indexWhere((v) => v.type == widget.initialVehicle);
    if (_vehicleIndex < 0) _vehicleIndex = 0;
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3200))
      ..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppScope.of(context).animation) {
      if (!_c.isAnimating) _c.repeat();
    } else {
      _c.stop();
      _c.value = 0.7;
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Curve get _curve {
    switch (widget.motion) {
      case Motion.negative:
        return Curves.easeOut;
      case Motion.zero:
        return Curves.linear;
      default:
        return Curves.easeIn;
    }
  }

  String _labelFor(bool tagalog) {
    if (tagalog) {
      switch (widget.motion) {
        case Motion.intro:
          return 'Nagbabago ang bilis → may akselerasyon';
        case Motion.positive:
          return 'Bumibilis → positibong akselerasyon';
        case Motion.negative:
          return 'Bumabagal → negatibong akselerasyon';
        case Motion.zero:
          return 'Hindi nagbabagong bilis → serong akselerasyon';
        case Motion.formula:
          return 'a = Δv / t';
      }
    }
    switch (widget.motion) {
      case Motion.intro:
        return 'Velocity changes → acceleration';
      case Motion.positive:
        return 'Speeding up → positive acceleration';
      case Motion.negative:
        return 'Slowing down → negative acceleration';
      case Motion.zero:
        return 'Constant velocity → zero acceleration';
      case Motion.formula:
        return 'a = Δv / t';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Column(children: [
        Row(children: [
          const Icon(Icons.directions_rounded, size: 20),
          const SizedBox(width: 8),
          Text(l10n(context, 'Choose a vehicle', 'Pumili ng sasakyan'),
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600)),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButton<int>(
              value: _vehicleIndex,
              isExpanded: true,
              items: [
                for (int i = 0; i < _vehicles.length; i++)
                  DropdownMenuItem(
                    value: i,
                    child: Row(children: [
                      VehicleWidget(type: _vehicles[i].type, width: 32),
                      const SizedBox(width: 8),
                      Text(l10n(
                          context, _vehicles[i].name, _vehicles[i].nameTl)),
                    ]),
                  ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _vehicleIndex = value);
              },
            ),
          ),
        ]),
        const SizedBox(height: 6),
        SizedBox(
          height: 120,
          child: LayoutBuilder(builder: (context, box) {
            final w = box.maxWidth;
            const vehicleW = 64.0;
            return AnimatedBuilder(
              animation: _c,
              builder: (context, _) {
                final x = (w - vehicleW) * _curve.transform(_c.value);
                return Stack(children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 10,
                    height: 44,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF3A4252),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  for (int k = 0; k <= 6; k++)
                    Positioned(
                      left: (w - vehicleW) * _curve.transform(k / 6) +
                          vehicleW / 2 -
                          4,
                      bottom: 28,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: widget.color),
                      ),
                    ),
                  Positioned(
                    left: x,
                    bottom: 12,
                    width: vehicleW,
                    height: 48,
                    child: VehicleWidget(
                      type: _vehicles[_vehicleIndex].type,
                      width: vehicleW,
                      spin: _c.value * math.pi * 8,
                    ),
                  ),
                ]);
              },
            );
          }),
        ),
        const SizedBox(height: 8),
        Text(_labelFor(AppScope.of(context).tagalog),
            style: TextStyle(
                fontWeight: FontWeight.w600, color: subText(context))),
      ]),
    );
  }
}

class _VehicleOption {
  final String name;
  final VehicleType type;
  final String nameTl;
  const _VehicleOption(this.name, this.type, this.nameTl);
}

// ---------------- Session 8: Acceleration Review ----------------

class _SessionEightBanner extends StatelessWidget {
  const _SessionEightBanner();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xff0755ce), Color(0xff168df0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: C.blue.withValues(alpha: .3),
                blurRadius: 12,
                offset: const Offset(0, 5)),
          ],
        ),
        child: Row(children: [
          const Icon(Icons.menu_book_rounded, color: Colors.white, size: 32),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(
                color: C.yellow, borderRadius: BorderRadius.circular(11)),
            child: Text(l10n(context, 'LEARN', 'MATUTO'),
                style: const TextStyle(
                    color: C.navy, fontSize: 16, fontWeight: FontWeight.w900)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
                l10n(context, 'Acceleration Review',
                    'Pagbabalik-aral sa Akselerasyon'),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    height: 1.05)),
          ),
        ]),
      );
}

class _SessionEightContent extends StatelessWidget {
  const _SessionEightContent();

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n(context, 'Let’s review the main ideas about acceleration!',
                'Balikan natin ang mahahalagang ideya tungkol sa akselerasyon!'),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: subText(context),
                fontWeight: FontWeight.w700,
                height: 1.3),
          ),
          const SizedBox(height: 12),
          _LearnSectionTitle(
              title: l10n(context, '1  WHAT IS ACCELERATION?',
                  '1  ANO ANG AKSELERASYON?'),
              icon: Icons.bolt_rounded,
              color: C.red),
          const SizedBox(height: 7),
          _ReviewPanel(
            color: C.red,
            child: Text.rich(
                TextSpan(children: [
                  TextSpan(
                      text: l10n(context, 'Acceleration is the ',
                          'Ang akselerasyon ay ang '),
                      style: TextStyle(
                          color: isDark(context) ? Colors.white : C.navy)),
                  TextSpan(
                      text: l10n(context, 'change in velocity over time.',
                          'pagbabago ng velocity sa paglipas ng oras.'),
                      style: TextStyle(
                          color:
                              isDark(context) ? const Color(0xffff938b) : C.red,
                          fontWeight: FontWeight.w900)),
                ]),
                style: const TextStyle(fontSize: 15, height: 1.3)),
          ),
          const SizedBox(height: 12),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              flex: 3,
              child: _ReviewPanel(
                color: C.blue,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n(context, '2  FORMULA', '2  PORMULA'),
                          style: TextStyle(
                              color: isDark(context)
                                  ? const Color(0xff71bdff)
                                  : C.blue,
                              fontWeight: FontWeight.w900,
                              fontSize: 12)),
                      const SizedBox(height: 5),
                      FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text('a = (vᶠ − vᵢ) ÷ t',
                              style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w900,
                                  color: isDark(context)
                                      ? Colors.white
                                      : C.navy))),
                      const SizedBox(height: 5),
                      Text(
                          l10n(
                              context,
                              'a = acceleration   •   vf = final velocity\nvi = initial velocity   •   t = time',
                              'a = akselerasyon   •   vf = huling velocity\nvi = unang velocity   •   t = oras'),
                          style: TextStyle(
                              fontSize: 10.5,
                              height: 1.35,
                              color: subText(context))),
                    ]),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: _ReviewPanel(
                color: C.green,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(l10n(context, '3  UNIT', '3  YUNIT'),
                          style: TextStyle(
                              color: isDark(context)
                                  ? const Color(0xff72e0aa)
                                  : C.green,
                              fontWeight: FontWeight.w900,
                              fontSize: 12)),
                      const SizedBox(height: 5),
                      FittedBox(
                          child: Text('m/s²',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                  color: isDark(context)
                                      ? Colors.white
                                      : C.navy))),
                      Icon(Icons.speed_rounded,
                          color: isDark(context)
                              ? const Color(0xff71bdff)
                              : C.blue,
                          size: 27),
                    ]),
              ),
            ),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
                child: _AccelerationTypeCard(
                    number: '4',
                    title: l10n(context, 'Positive acceleration',
                        'Positibong akselerasyon'),
                    description: l10n(
                        context,
                        'Velocity increases in the positive direction.',
                        'Tumataas ang velocity sa positibong direksiyon.'),
                    caption: l10n(context, 'Speeding up', 'Bumibilis'),
                    color: C.green,
                    carColor: C.red,
                    accelerating: true)),
            const SizedBox(width: 8),
            Expanded(
                child: _AccelerationTypeCard(
                    number: '5',
                    title: l10n(context, 'Negative acceleration',
                        'Negatibong akselerasyon'),
                    description: l10n(
                        context,
                        'Velocity decreases in the positive direction.',
                        'Bumababa ang velocity sa positibong direksiyon.'),
                    caption: l10n(context, 'Slowing down', 'Bumabagal'),
                    color: C.red,
                    carColor: C.blue,
                    accelerating: false)),
          ]),
          const SizedBox(height: 12),
          _LearnSectionTitle(
              title: l10n(context, '6  VELOCITY–TIME GRAPHS',
                  '6  MGA GRAPH NG VELOCITY–TIME'),
              icon: Icons.show_chart_rounded,
              color: C.purple),
          const SizedBox(height: 7),
          Row(children: [
            Expanded(
                child: _ReviewGraphCard(
                    color: C.green,
                    trend: _VelocityTrend.increasing,
                    label: l10n(context, 'Upward line', 'Pataas'),
                    meaning: l10n(context, 'Positive acceleration',
                        'Positibong akselerasyon'))),
            const SizedBox(width: 7),
            Expanded(
                child: _ReviewGraphCard(
                    color: C.blue,
                    trend: _VelocityTrend.constant,
                    label: l10n(context, 'Horizontal line', 'Pahalang'),
                    meaning: l10n(
                        context, 'Zero acceleration', 'Walang akselerasyon'))),
            const SizedBox(width: 7),
            Expanded(
                child: _ReviewGraphCard(
                    color: C.red,
                    trend: _VelocityTrend.decreasing,
                    label: l10n(context, 'Downward line', 'Pababa'),
                    meaning: l10n(context, 'Negative acceleration',
                        'Negatibong akselerasyon'))),
          ]),
          const SizedBox(height: 12),
          _LearnSectionTitle(
              title: l10n(context, '7  REAL-LIFE EXAMPLES',
                  '7  MGA HALIMBAWA SA TUNAY NA BUHAY'),
              icon: Icons.public_rounded,
              color: C.orange),
          const SizedBox(height: 7),
          LayoutBuilder(builder: (context, constraints) {
            final cardWidth = (constraints.maxWidth - 7) / 2;
            return Wrap(spacing: 7, runSpacing: 7, children: [
              SizedBox(
                  width: cardWidth,
                  child: _ReviewExample(
                      vehicle: VehicleType.car,
                      motion: _ExampleMotion.accelerate,
                      color: C.red,
                      text: l10n(
                          context, 'Car speeding up', 'Koteng bumibilis'))),
              SizedBox(
                  width: cardWidth,
                  child: _ReviewExample(
                      vehicle: VehicleType.bus,
                      motion: _ExampleMotion.brake,
                      color: C.blue,
                      text: l10n(
                          context, 'Bus slowing down', 'Bus na bumabagal'))),
              SizedBox(
                  width: cardWidth,
                  child: _ReviewExample(
                      vehicle: VehicleType.bicycle,
                      motion: _ExampleMotion.turn,
                      color: C.green,
                      text: l10n(context, 'Bicycle changing direction',
                          'Bisikletang lumiliko'))),
              SizedBox(
                  width: cardWidth,
                  child: _ReviewExample(
                      vehicle: VehicleType.airplane,
                      motion: _ExampleMotion.takeoff,
                      color: C.purple,
                      text: l10n(context, 'Airplane taking off',
                          'Eroplanong lumilipad'))),
              SizedBox(
                  width: cardWidth,
                  child: _ReviewExample(
                      motion: _ExampleMotion.bounce,
                      color: C.orange,
                      text: l10n(context, 'Ball changing motion',
                          'Bolang nagbabago ng galaw'))),
            ]);
          }),
        ],
      );
}

class _ReviewPanel extends StatelessWidget {
  final Color color;
  final Widget child;
  const _ReviewPanel({required this.color, required this.child});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .09),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: .42)),
        ),
        child: DefaultTextStyle.merge(
          style: TextStyle(color: isDark(context) ? Colors.white : null),
          child: child,
        ),
      );
}

class _AccelerationTypeCard extends StatefulWidget {
  final String number, title, description, caption;
  final Color color, carColor;
  final bool accelerating;
  const _AccelerationTypeCard(
      {required this.number,
      required this.title,
      required this.description,
      required this.caption,
      required this.color,
      required this.carColor,
      required this.accelerating});

  @override
  State<_AccelerationTypeCard> createState() => _AccelerationTypeCardState();
}

class _AccelerationTypeCardState extends State<_AccelerationTypeCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _ReviewPanel(
        color: widget.color,
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            CircleAvatar(
                radius: 12,
                backgroundColor: widget.color,
                child: Text(widget.number,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 12))),
            const SizedBox(width: 5),
            Expanded(
                child: Text(widget.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: isDark(context)
                            ? Color.lerp(widget.color, Colors.white, .55)
                            : widget.color,
                        fontWeight: FontWeight.w900,
                        fontSize: 11))),
          ]),
          const SizedBox(height: 5),
          Text(widget.description,
              style: const TextStyle(
                  fontSize: 10.5, height: 1.25, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          _AnimatedReviewCar(
              animation: _controller,
              color: widget.carColor,
              accelerating: widget.accelerating),
          Text(widget.caption,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: isDark(context)
                      ? Color.lerp(widget.color, Colors.white, .55)
                      : widget.color,
                  fontWeight: FontWeight.w900,
                  fontSize: 10.5)),
        ]),
      );
}

class _AnimatedReviewCar extends StatelessWidget {
  final Animation<double> animation;
  final Color color;
  final bool accelerating;
  const _AnimatedReviewCar({
    required this.animation,
    required this.color,
    required this.accelerating,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 40,
        child: LayoutBuilder(builder: (context, constraints) {
          const carWidth = 68.0;
          final travel = math.max(0.0, constraints.maxWidth - carWidth);
          final motion = CurvedAnimation(
            parent: animation,
            curve: accelerating ? Curves.easeInCubic : Curves.easeOutCubic,
          );
          return Stack(alignment: Alignment.centerLeft, children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 4,
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .22),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: motion,
              builder: (context, child) => Positioned(
                left: travel * motion.value,
                bottom: 3,
                child: Opacity(
                  opacity: motion.value > .94 ? (1 - motion.value) / .06 : 1,
                  child: child,
                ),
              ),
              child: CarWidget(width: carWidth, color: color),
            ),
            Positioned(
              right: 2,
              top: 0,
              child: Icon(Icons.arrow_forward_rounded,
                  size: 17, color: color.withValues(alpha: .8)),
            ),
          ]);
        }),
      );
}

class _ReviewGraphCard extends StatelessWidget {
  final Color color;
  final _VelocityTrend trend;
  final String label, meaning;
  const _ReviewGraphCard(
      {required this.color,
      required this.trend,
      required this.label,
      required this.meaning});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
            color: color.withValues(alpha: .09),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: .4))),
        child: DefaultTextStyle.merge(
          style: TextStyle(color: isDark(context) ? Colors.white : null),
          child: Column(children: [
            SizedBox(
                height: 58,
                child: CustomPaint(
                    painter: _VelocityGraphPainter(
                        trend: trend, compact: true, color: color),
                    child: const SizedBox.expand())),
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: isDark(context)
                        ? Color.lerp(color, Colors.white, .55)
                        : color,
                    fontSize: 10,
                    fontWeight: FontWeight.w900)),
            Text(meaning,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(fontSize: 9, height: 1.15)),
          ]),
        ),
      );
}

enum _ExampleMotion { accelerate, brake, turn, takeoff, bounce }

class _ReviewExample extends StatefulWidget {
  final VehicleType? vehicle;
  final _ExampleMotion motion;
  final Color color;
  final String text;
  const _ReviewExample(
      {this.vehicle,
      required this.motion,
      required this.color,
      required this.text});

  @override
  State<_ReviewExample> createState() => _ReviewExampleState();
}

class _ReviewExampleState extends State<_ReviewExample>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2500),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        decoration: BoxDecoration(
            color: widget.color.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: widget.color.withValues(alpha: .35))),
        child: Column(children: [
          SizedBox(
            height: 52,
            child: LayoutBuilder(builder: (context, constraints) {
              final objectWidth =
                  widget.motion == _ExampleMotion.takeoff ? 60.0 : 52.0;
              final travel = math.max(0.0, constraints.maxWidth - objectWidth);
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final t = _controller.value;
                  final x = switch (widget.motion) {
                    _ExampleMotion.accelerate =>
                      travel * Curves.easeInCubic.transform(t),
                    _ExampleMotion.brake =>
                      travel * Curves.easeOutCubic.transform(t),
                    _ExampleMotion.turn =>
                      travel * (.5 + .5 * math.sin(t * math.pi * 2)),
                    _ExampleMotion.takeoff =>
                      travel * Curves.easeInOut.transform(t),
                    _ExampleMotion.bounce => travel * t,
                  };
                  final y = switch (widget.motion) {
                    _ExampleMotion.takeoff =>
                      22 * Curves.easeInOut.transform(t),
                    _ExampleMotion.bounce => -7 * math.sin(t * math.pi),
                    _ => 0.0,
                  };
                  final rotation = switch (widget.motion) {
                    _ExampleMotion.turn => .12 * math.sin(t * math.pi * 2),
                    _ExampleMotion.bounce => t * math.pi * 2,
                    _ExampleMotion.takeoff => -.12,
                    _ => 0.0,
                  };
                  final opacity = t > .94 ? (1 - t) / .06 : 1.0;
                  final vehicle = widget.motion == _ExampleMotion.takeoff
                      ? const _ReviewAirplane()
                      : widget.vehicle == null
                          ? const Icon(Icons.sports_soccer_rounded, size: 28)
                          : VehicleWidget(
                              type: widget.vehicle!,
                              width: 50,
                              color: widget.color);
                  return Stack(alignment: Alignment.bottomLeft, children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 3,
                      child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                              color: widget.color.withValues(alpha: .25),
                              borderRadius: BorderRadius.circular(2))),
                    ),
                    Positioned(
                      left: x,
                      bottom: 3 + y,
                      child: Opacity(
                        opacity: opacity.clamp(0.0, 1.0),
                        child:
                            Transform.rotate(angle: rotation, child: vehicle),
                      ),
                    ),
                  ]);
                },
              );
            }),
          ),
          Text(widget.text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: widget.color,
                  fontSize: 10,
                  fontWeight: FontWeight.w800)),
        ]),
      );
}

class _ReviewAirplane extends StatelessWidget {
  const _ReviewAirplane();

  @override
  Widget build(BuildContext context) => const CustomPaint(
        size: Size(60, 34),
        painter: _ReviewAirplanePainter(),
      );
}

class _ReviewAirplanePainter extends CustomPainter {
  const _ReviewAirplanePainter();

  @override
  void paint(Canvas canvas, Size size) {
    Offset p(double x, double y) => Offset(size.width * x, size.height * y);
    final outline = Paint()
      ..color = const Color(0xff254765)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..strokeJoin = StrokeJoin.round;
    final wingPaint = Paint()..color = const Color(0xff8fb5d1);
    final bodyPaint = Paint()..color = const Color(0xfff7fbff);
    final bluePaint = Paint()..color = const Color(0xff3285c6);

    // Broad swept wings and tail surfaces make the side-view aircraft
    // read as an airplane while its nose points forward along the runway.
    final wing = Path()
      ..moveTo(p(.43, .43).dx, p(.43, .43).dy)
      ..lineTo(p(.27, .98).dx, p(.27, .98).dy)
      ..lineTo(p(.48, .83).dx, p(.48, .83).dy)
      ..lineTo(p(.68, .57).dx, p(.68, .57).dy)
      ..close();
    canvas.drawPath(wing, wingPaint);
    canvas.drawPath(wing, outline);

    final tail = Path()
      ..moveTo(p(.19, .43).dx, p(.19, .43).dy)
      ..lineTo(p(.08, .14).dx, p(.08, .14).dy)
      ..lineTo(p(.29, .39).dx, p(.29, .39).dy)
      ..close();
    canvas.drawPath(tail, wingPaint);
    canvas.drawPath(tail, outline);
    final tailWing = Path()
      ..moveTo(p(.18, .48).dx, p(.18, .48).dy)
      ..lineTo(p(.04, .72).dx, p(.04, .72).dy)
      ..lineTo(p(.32, .59).dx, p(.32, .59).dy)
      ..lineTo(p(.39, .51).dx, p(.39, .51).dy)
      ..close();
    canvas.drawPath(tailWing, wingPaint);
    canvas.drawPath(tailWing, outline);

    final fuselage = Path()
      ..moveTo(p(.07, .51).dx, p(.07, .51).dy)
      ..quadraticBezierTo(
          p(.1, .4).dx, p(.1, .4).dy, p(.24, .4).dx, p(.24, .4).dy)
      ..lineTo(p(.77, .43).dx, p(.77, .43).dy)
      ..quadraticBezierTo(
          p(.91, .44).dx, p(.91, .44).dy, p(.99, .5).dx, p(.99, .5).dy)
      ..quadraticBezierTo(
          p(.92, .57).dx, p(.92, .57).dy, p(.77, .58).dx, p(.77, .58).dy)
      ..lineTo(p(.23, .59).dx, p(.23, .59).dy)
      ..quadraticBezierTo(
          p(.1, .59).dx, p(.1, .59).dy, p(.07, .51).dx, p(.07, .51).dy)
      ..close();
    canvas.drawPath(fuselage, bodyPaint);
    canvas.drawPath(fuselage, outline);

    // Blue cabin stripe, cockpit, and passenger windows.
    canvas.drawLine(
        p(.18, .55),
        p(.79, .55),
        Paint()
          ..color = const Color(0xff56a6d8)
          ..strokeWidth = 1.5);
    canvas.drawPath(
        Path()
          ..moveTo(p(.78, .45).dx, p(.78, .45).dy)
          ..lineTo(p(.88, .46).dx, p(.88, .46).dy)
          ..lineTo(p(.94, .49).dx, p(.94, .49).dy)
          ..lineTo(p(.79, .49).dx, p(.79, .49).dy)
          ..close(),
        bluePaint);
    for (var i = 0; i < 5; i++) {
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromCenter(
                  center: p(.34 + i * .075, .46), width: 2.2, height: 2.2),
              const Radius.circular(1)),
          bluePaint);
    }
    // A visible engine under the wing anchors the plane to the runway.
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTRB(
                p(.5, .73).dx, p(.5, .73).dy, p(.62, .81).dx, p(.62, .81).dy),
            const Radius.circular(3)),
        Paint()..color = const Color(0xff6f91aa));
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTRB(
                p(.5, .73).dx, p(.5, .73).dy, p(.62, .81).dx, p(.62, .81).dy),
            const Radius.circular(3)),
        outline);
  }

  @override
  bool shouldRepaint(covariant _ReviewAirplanePainter oldDelegate) => false;
}

// ---------------- Session 7: Real-Life Acceleration (animated, matches lesson card) ----------------

class _SessionSevenContent extends StatelessWidget {
  const _SessionSevenContent();

  static const _items = <_SessionItem>[
    _SessionItem(
        'Car',
        C.red,
        Icons.directions_car,
        'When a car starts moving and becomes faster, it accelerates.',
        'Kapag nagsimulang galaw ang kotse at naging mas mabilis, nakakabilis ito.'),
    _SessionItem(
        'Bus',
        C.blue,
        Icons.directions_bus,
        'When a bus slams down on its brakes, its velocity changes.',
        'Kapag pumutol nang bigla ang bus sa preno, nagbabago ang velocity nito.'),
    _SessionItem(
        'Bicycle',
        C.orange,
        Icons.pedal_bike,
        'When a cyclist pedals harder, the bicycle can increase its velocity.',
        'Kapag mas malakas ang pagpupadyak ng siklista, makakabilis ang bisikleta.'),
    _SessionItem(
        'Airplane',
        C.green,
        Icons.flight,
        'An airplane accelerates when it speeds up during takeoff.',
        'Nakakabilis ang eroplano kapag tumataas ang bilis nito sa paglilipad.'),
    _SessionItem(
        'Ball',
        C.purple,
        Icons.sports_soccer,
        'A kicked ball changes its velocity as it moves.',
        'Nagbabago ang velocity ng binuktot na bol kapag ito ay nagagalaw.'),
  ];

  @override
  Widget build(BuildContext context) {
    final tagalog = AppScope.of(context).tagalog;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const _SessionSevenBanner(),
      const SizedBox(height: 14),
      for (var i = 0; i < _items.length; i++)
        Reveal(
          index: i,
          child: _SessionSevenRow(
            name: _items[i].name,
            color: _items[i].color,
            icon: _items[i].icon,
            text: tagalog ? _items[i].tl : _items[i].en,
          ),
        ),
      const SizedBox(height: 16),
      Reveal(index: 5, child: const _KeyIdeaCard()),
      const SizedBox(height: 18),
      Reveal(
        index: 6,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _LearnSectionTitle(
              title: l10n(context, 'This can happen by:',
                  'Maaaring mangyari ito sa mga sumusunod:'),
              icon: Icons.change_circle_rounded,
              color: C.orange),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _SpeedChip(
                  icon: Icons.arrow_upward_rounded,
                  color: C.green,
                  label: l10n(
                      context, 'Increasing speed', 'Pagpapabilis ng bilis')),
              _SpeedChip(
                  icon: Icons.arrow_downward_rounded,
                  color: C.red,
                  label: l10n(
                      context, 'Decreasing speed', 'Pagpapabagal ng bilis')),
              _SpeedChip(
                  icon: Icons.change_circle_rounded,
                  color: C.blue,
                  label: l10n(context, 'Changing direction',
                      'Pagbabago ng direksiyon')),
            ],
          ),
        ]),
      ),
    ]);
  }
}

class _SessionItem {
  final String name;
  final Color color;
  final IconData icon;
  final String en;
  final String tl;
  const _SessionItem(this.name, this.color, this.icon, this.en, this.tl);
}

class _SessionSevenBanner extends StatelessWidget {
  const _SessionSevenBanner();

  @override
  Widget build(BuildContext context) {
    final tagalog = AppScope.of(context).tagalog;
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff0755ce), Color(0xff168df0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
              color: C.blue.withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 6)),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.menu_book_rounded, color: Colors.white, size: 30),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
                color: C.yellow, borderRadius: BorderRadius.circular(12)),
            child: Text(tagalog ? 'MATUTO' : 'LEARN',
                style: const TextStyle(
                    color: C.navy,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tagalog
                  ? 'Akselerasyon sa Tunay na Buhay'
                  : 'Real-Life Acceleration',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  height: 1.05),
            ),
          ),
        ]),
        const SizedBox(height: 10),
        Text(
          tagalog
              ? 'Nangyayari ang akselerasyon sa paligid natin.'
              : 'Acceleration happens everywhere around us.',
          style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9), fontSize: 15),
        ),
      ]),
    );
  }
}

class _SessionSevenRow extends StatelessWidget {
  final String name;
  final Color color;
  final IconData icon;
  final String text;
  const _SessionSevenRow(
      {required this.name,
      required this.color,
      required this.icon,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox.square(
        dimension: 76,
        child: Container(
          decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withValues(alpha: 0.45))),
          child: Center(
            child: Icon(icon, size: 34, color: color),
          ),
        ),
      ),
      const SizedBox(width: 14),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(10)),
            child: Text(name,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 15)),
          ),
          const SizedBox(height: 6),
          Text(text,
              style: const TextStyle(fontSize: 14.5, height: 1.4),
              maxLines: 4,
              overflow: TextOverflow.ellipsis),
        ]),
      ),
    ]);
  }
}

class _KeyIdeaCard extends StatelessWidget {
  const _KeyIdeaCard();

  @override
  Widget build(BuildContext context) {
    final tagalog = AppScope.of(context).tagalog;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 15),
      decoration: BoxDecoration(
        color: const Color(0xfffdeef0),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: C.red.withValues(alpha: 0.7)),
      ),
      child: Row(children: [
        const Icon(Icons.lightbulb_rounded, color: C.red, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l10n(context, 'Key Idea', 'Pangunahing Ideya'),
                style: const TextStyle(
                    color: C.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8)),
            const SizedBox(height: 5),
            Text(
              tagalog
                  ? 'May akselerasyon kapag palaging nagbabago ang velocity.'
                  : 'Acceleration happens whenever velocity changes.',
              style: TextStyle(
                  color: isDark(context) ? C.navy : null,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 1.3),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _SpeedChip extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  const _SpeedChip(
      {required this.icon, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.13),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.45))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(label,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w800, fontSize: 14)),
      ]),
    );
  }
}
