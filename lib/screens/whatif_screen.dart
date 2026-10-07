import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';

class WhatIfScreen extends StatefulWidget {
  const WhatIfScreen({super.key});

  @override
  State<WhatIfScreen> createState() => _WhatIfScreenState();
}

class _WhatIfScreenState extends State<WhatIfScreen>
    with SingleTickerProviderStateMixin {
  static const double vi = 10; // both cars start at 10 m/s
  static const double runTime = 4; // seconds per loop
  double a = 3;
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 4))
      ..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppScope.of(context).animation) {
      if (!_c.isAnimating) _c.repeat();
    } else {
      _c.stop();
      _c.value = 0.8;
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  double _v(double time) {
    final v = vi + a * time;
    return (a < 0 && v < 0) ? 0.0 : v;
  }

  double _d(double time) {
    final te = a < 0 ? math.min(time, vi / -a) : time;
    return vi * te + 0.5 * a * te * te;
  }

  Widget _lane(String label, double meters, Color carColor) {
    return LayoutBuilder(builder: (context, box) {
      const carW = 72.0;
      final frac = clamp01(meters / 100);
      return Container(
        height: 78,
        decoration: BoxDecoration(
          color: const Color(0xFF3A4252),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Stack(children: [
          Positioned(
            top: 6,
            left: 10,
            child: Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ),
          Positioned(
            left: 8 + (box.maxWidth - carW - 16) * frac,
            bottom: 6,
            child: CarWidget(width: carW, color: carColor),
          ),
        ]),
      );
    });
  }

  String _insight(bool tagalog) {
    if (tagalog) {
      if (a > 0)
        return 'Patuloy na bumibilis ang kotse. Tumataas ang bilis nito nang ${fmt(a)} m/s bawat segundo.';
      if (a < 0)
        return 'Bumabagal ang kotse. Bumababa ang bilis nito nang ${fmt(-a)} m/s bawat segundo.';
      return 'Walang akselerasyon: hindi nagbabago ang bilis kaya pare-pareho ang distansiyang nalalakbay bawat segundo.';
    }
    if (a > 0) {
      return 'The car keeps speeding up. Its velocity grows by ${fmt(a)} m/s every second.';
    }
    if (a < 0) {
      return 'The car slows down. Its velocity drops by ${fmt(-a)} m/s every second.';
    }
    return 'No acceleration: the velocity stays the same, so the car covers equal distances each second.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              l10n(context, 'What Happens If…?', 'Ano ang Mangyayari Kung…?'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
              l10n(context, 'What happens if you change the acceleration?',
                  'Ano ang mangyayari kapag binago mo ang akselerasyon?'),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          AppCard(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                  l10n(context, 'Acceleration: ${fmt(a)} m/s²',
                      'Akselerasyon: ${fmt(a)} m/s²'),
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              Slider(
                value: a,
                min: -5,
                max: 5,
                divisions: 10,
                label: '${fmt(a)} m/s²',
                onChanged: (v) => setState(() => a = v),
              ),
              Wrap(spacing: 8, children: [
                for (final preset in [3.0, 0.0, -2.0])
                  ChoiceChip(
                    label: Text('a = ${fmt(preset)}'),
                    selected: a == preset,
                    onSelected: (_) => setState(() => a = preset),
                  ),
              ]),
            ]),
          ),
          const SizedBox(height: 14),
          AnimatedBuilder(
            animation: _c,
            builder: (context, _) {
              final time = _c.value * runTime;
              return Column(children: [
                _lane(
                    l10n(context, 'Your car (a = ${fmt(a)} m/s²)',
                        'Sasakyan mo (a = ${fmt(a)} m/s²)'),
                    _d(time),
                    C.red),
                const SizedBox(height: 10),
                _lane(
                    l10n(context, 'Constant speed (a = 0)',
                        'Pare-parehong bilis (a = 0)'),
                    vi * time,
                    C.sky),
                const SizedBox(height: 10),
                Text(
                    l10n(
                        context,
                        'Time: ${fmt(time)} s      Your velocity: ${fmt(_v(time))} m/s',
                        'Oras: ${fmt(time)} s      Bilis mo: ${fmt(_v(time))} m/s'),
                    style: TextStyle(
                        color: subText(context), fontWeight: FontWeight.w600)),
              ]);
            },
          ),
          const SizedBox(height: 14),
          AppCard(
              child: Text(_insight(AppScope.of(context).tagalog),
                  style: const TextStyle(fontSize: 15, height: 1.4))),
          const SizedBox(height: 14),
          AppCard(
            color: C.yellow.withValues(alpha: 0.2),
            child: Row(children: [
              const Icon(Icons.lightbulb, color: C.yellow),
              const SizedBox(width: 10),
              Expanded(
                child: Text(l10n(
                    context,
                    'The greater the acceleration, the faster the velocity changes.',
                    'Kapag mas malaki ang akselerasyon, mas mabilis magbago ang bilis.')),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
