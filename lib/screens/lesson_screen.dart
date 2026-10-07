import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../data/content.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';

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
                l10n(context, 'Lesson ${lesson.id}', 'Aralin ${lesson.id}'))),
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
                      'Complete all $prerequisite topics to unlock this difficulty.',
                      'Tapusin ang lahat ng paksa sa antas na $prerequisite upang mabuksan ito.'),
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
            Text(l10n(context, 'Lesson ${lesson.id}', 'Aralin ${lesson.id}')),
        actions: [LanguageSwitchButton(state: s)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Reveal(
            child: Text(title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 14),
          Reveal(
              index: 1,
              child: MotionScene(motion: lesson.motion, color: lesson.color)),
          const SizedBox(height: 16),
          Reveal(
            index: 2,
            child: Text(lesson.bodyFor(s.tagalog),
                style: const TextStyle(fontSize: 16, height: 1.5)),
          ),
          if (lesson.formula != null) ...[
            const SizedBox(height: 14),
            Reveal(
              index: 3,
              child: AppCard(
                color: lesson.color.withValues(alpha: 0.15),
                child: Center(
                  child: Text(lesson.formula!,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
          if (lesson.exampleFor(s.tagalog) != null) ...[
            const SizedBox(height: 14),
            Reveal(
              index: 4,
              child: AppCard(
                child: Text(lesson.exampleFor(s.tagalog)!,
                    style: const TextStyle(fontSize: 15, height: 1.5)),
              ),
            ),
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
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: lesson.rememberFor(s.tagalog)),
                ])),
              ),
            ),
          ],
          const SizedBox(height: 24),
          Reveal(
            index: 5,
            child: BigButton(
              done
                  ? l10n(context, 'MARKED AS COMPLETE', 'NAKUMPLETO NA')
                  : l10n(context, 'MARK AS COMPLETE', 'MARKAHAN BILANG TAPOS'),
              icon: done ? Icons.check_circle : Icons.check_circle_outline,
              color: done ? C.green : lesson.color,
              onTap: () {
                s.toggleLesson(lesson.id);
                Navigator.of(context).pop(); // back to the Learn page
              },
            ),
          ),
        ],
      ),
    );
  }
}

// A looping animation: the car moves, and the dots show equal time steps.
// Dots spreading apart = speeding up, bunching up = slowing down.
class MotionScene extends StatefulWidget {
  final Motion motion;
  final Color color;
  const MotionScene({super.key, required this.motion, required this.color});

  @override
  State<MotionScene> createState() => _MotionSceneState();
}

class _MotionSceneState extends State<MotionScene>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  int _vehicleIndex = 0;

  static const _vehicles = <_VehicleOption>[
    _VehicleOption('Car', VehicleType.car, 'Kotse'),
    _VehicleOption('Bicycle', VehicleType.bicycle, 'Bisikleta'),
    _VehicleOption('Bus', VehicleType.bus, 'Bus'),
    _VehicleOption('Train', VehicleType.train, 'Tren'),
  ];

  @override
  void initState() {
    super.initState();
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
              style: const TextStyle(fontWeight: FontWeight.w600)),
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
