import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/common.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({super.key});

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  double a = 2;

  Widget _legend(String label, Color color) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(fontSize: 12)),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(l10n(context, 'Velocity vs Time', 'Bilis at Oras'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            child: Column(children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(l10n(context, 'Velocity (m/s)', 'Bilis (m/s)'),
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 8),
              // A new key restarts the drawing animation whenever `a` changes.
              TweenAnimationBuilder<double>(
                key: ValueKey(a),
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeOutCubic,
                builder: (_, p, __) => SizedBox(
                  height: 260,
                  width: double.infinity,
                  child: CustomPaint(
                      painter: GraphPainter(a: a, p: p, dark: dark)),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(spacing: 14, runSpacing: 4, children: [
                _legend('a = 0', C.blue),
                _legend('a = 1', C.green),
                _legend('a = 2', C.orange),
                _legend(
                    l10n(context, 'your line (a = ${fmt(a)})',
                        'iyong linya (a = ${fmt(a)})'),
                    C.purple),
              ]),
            ]),
          ),
          const SizedBox(height: 14),
          AppCard(
            child: ValueStepper(
              label: l10n(context, 'Acceleration', 'Akselerasyon'),
              value: a,
              unit: 'm/s²',
              min: 0,
              max: 4,
              onChanged: (v) => setState(() => a = v),
            ),
          ),
          const SizedBox(height: 14),
          AppCard(
            child: Text(
              l10n(
                  context,
                  'Starting from rest, v = a × t.\nAt t = 10 s, the velocity is ${fmt(a * 10)} m/s.',
                  'Mula sa pahinga, v = a × t.\nSa t = 10 s, ang bilis ay ${fmt(a * 10)} m/s.'),
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
          ),
          const SizedBox(height: 14),
          AppCard(
            color: C.yellow.withValues(alpha: 0.2),
            child: Row(children: [
              const Icon(Icons.lightbulb, color: C.yellow),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(l10n(
                      context,
                      'The steeper the line, the greater the acceleration.',
                      'Habang mas matarik ang linya, mas malaki ang akselerasyon.'))),
            ]),
          ),
        ],
      ),
    );
  }
}

class GraphPainter extends CustomPainter {
  final double a;
  final double p;
  final bool dark;
  GraphPainter({required this.a, required this.p, required this.dark});

  void _text(Canvas c, String s, Offset o, {double ax = 0, double ay = 0}) {
    final tp = TextPainter(
      text: TextSpan(
        text: s,
        style: TextStyle(
            color: dark ? Colors.white60 : Colors.black54, fontSize: 11),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(c, o - Offset(tp.width * ax, tp.height * ay));
  }

  @override
  void paint(Canvas canvas, Size size) {
    const left = 34.0, bottom = 26.0, right = 10.0, top = 8.0;
    final plot =
        Rect.fromLTRB(left, top, size.width - right, size.height - bottom);
    final grid = Paint()
      ..color = dark ? Colors.white12 : Colors.black12
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final y = plot.bottom - plot.height * i / 4;
      canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), grid);
      _text(canvas, '${i * 10}', Offset(plot.left - 6, y), ax: 1, ay: 0.5);
    }
    for (int i = 0; i <= 5; i++) {
      final x = plot.left + plot.width * i / 5;
      canvas.drawLine(Offset(x, plot.top), Offset(x, plot.bottom), grid);
      _text(canvas, '${i * 2}', Offset(x, plot.bottom + 5), ax: 0.5);
    }
    _text(canvas, 'Time (s)', Offset(plot.right, plot.bottom + 12), ax: 1);

    final axis = Paint()
      ..color = dark ? Colors.white54 : Colors.black45
      ..strokeWidth = 2;
    canvas.drawLine(plot.bottomLeft, plot.topLeft, axis);
    canvas.drawLine(plot.bottomLeft, plot.bottomRight, axis);

    Offset pt(double t, double v) => Offset(
        plot.left + plot.width * t / 10, plot.bottom - plot.height * v / 40);

    // reference lines
    final refs = <List<Object>>[
      [0.0, C.blue],
      [1.0, C.green],
      [2.0, C.orange],
    ];
    for (final r in refs) {
      final slope = r[0] as double;
      canvas.drawLine(
        pt(0, 0),
        pt(10, slope * 10),
        Paint()
          ..color = (r[1] as Color).withValues(alpha: 0.65)
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round,
      );
    }

    // the learner's line, drawn in progressively
    final end = pt(10 * p, a * 10 * p);
    canvas.drawLine(
      pt(0, 0),
      end,
      Paint()
        ..color = C.purple
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(end, 6, Paint()..color = C.purple);
    canvas.drawCircle(end, 3, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(GraphPainter old) =>
      old.a != a || old.p != p || old.dark != dark;
}
