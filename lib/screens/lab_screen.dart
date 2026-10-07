import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';

class LabScreen extends StatefulWidget {
  const LabScreen({super.key});

  @override
  State<LabScreen> createState() => _LabScreenState();
}

class _LabScreenState extends State<LabScreen>
    with SingleTickerProviderStateMixin {
  double vi = 0;
  double a = 2;
  double t = 5;
  bool _running = false;
  bool _hasStarted = false;
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: Duration(seconds: t.round()));
    _c.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() => _running = false);
      }
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  // ----- physics -----
  double get _tStop => a < 0 ? vi / -a : double.infinity;

  double _vAt(double time) {
    final v = vi + a * time;
    return (a < 0 && v < 0) ? 0.0 : v;
  }

  double _dAt(double time) {
    final te = math.min(time, _tStop);
    return vi * te + 0.5 * a * te * te;
  }

  void _change(void Function() f) {
    setState(() {
      f();
      _running = false;
      _hasStarted = false;
      _c.stop();
      _c.duration = Duration(seconds: t.round());
      _c.reset();
    });
  }

  void _start() {
    final s = AppScope.of(context);
    s.simulatorUsed();
    s.click();
    if (_c.value >= 1) _c.reset();
    setState(() {
      _running = true;
      _hasStarted = true;
    });
    _c.forward();
  }

  void _pause() {
    _c.stop();
    setState(() => _running = false);
  }

  void _reset() {
    _c.stop();
    _c.reset();
    setState(() {
      _running = false;
      _hasStarted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final started = _c.value > 0 && _c.value < 1 && !_running;

    return Scaffold(
      appBar: AppBar(
          title: Text(l10n(
              context, 'Acceleration Lab', 'Laboratoryo ng Akselerasyon'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AnimatedBuilder(
            animation: _c,
            builder: (context, _) {
              final el = _c.value * t;
              final v = _vAt(el);
              final d = _dAt(el);
              final moving = _running && v > 0;
              return Column(children: [
                SizedBox(
                  height: 190,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Stack(children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: RoadPainter(
                            offset: d * 10,
                            tilt: moving
                                ? (a > 0 ? -0.035 : (a < 0 ? 0.035 : 0.0))
                                : 0.0,
                            spin: d * 10 / 10.5,
                            bounce: moving,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        right: 8,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.45),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'v = ${fmt(v)} m/s    a = ${fmt(a)} m/s²    t = ${fmt(el)} s',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
                const SizedBox(height: 14),
                Row(children: [
                  Expanded(
                      child: _stat(
                          context,
                          l10n(context, 'Final Velocity', 'Huling Bilis'),
                          '${fmt(v)} m/s')),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _stat(
                          context,
                          l10n(context, 'Distance Traveled',
                              'Nilakbay na Distansiya'),
                          '${fmt(d)} m')),
                ]),
                if (_hasStarted) ...[
                  const SizedBox(height: 14),
                  AppCard(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              l10n(
                                  context, 'Velocity vs Time', 'Bilis at Oras'),
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(
                              l10n(
                                  context,
                                  'The line updates as the simulation runs.',
                                  'Nagbabago ang linya habang tumatakbo ang simulation.'),
                              style: TextStyle(
                                  fontSize: 12, color: subText(context))),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 230,
                            width: double.infinity,
                            child: CustomPaint(
                              painter: LabGraphPainter(
                                initialVelocity: vi,
                                acceleration: a,
                                duration: t,
                                elapsed: el,
                                velocityAt: _vAt,
                                dark: isDark(context),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(spacing: 14, runSpacing: 4, children: [
                            _output(context, l10n(context, 'Time', 'Oras'),
                                '${fmt(el)} s'),
                            _output(context, l10n(context, 'Velocity', 'Bilis'),
                                '${fmt(v)} m/s'),
                            _output(
                                context,
                                l10n(context, 'Acceleration', 'Akselerasyon'),
                                '${fmt(a)} m/s²'),
                          ]),
                        ]),
                  ),
                ],
              ]);
            },
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(children: [
              ValueStepper(
                label: l10n(context, 'Initial Velocity', 'Panimulang Bilis'),
                value: vi,
                unit: 'm/s',
                min: 0,
                max: 30,
                enabled: !_running,
                onChanged: (v) => _change(() => vi = v),
              ),
              ValueStepper(
                label: l10n(context, 'Acceleration', 'Akselerasyon'),
                value: a,
                unit: 'm/s²',
                min: -10,
                max: 10,
                enabled: !_running,
                onChanged: (v) => _change(() => a = v),
              ),
              ValueStepper(
                label: l10n(context, 'Time', 'Oras'),
                value: t,
                unit: 's',
                min: 1,
                max: 20,
                enabled: !_running,
                onChanged: (v) => _change(() => t = v),
              ),
            ]),
          ),
          const SizedBox(height: 14),
          BigButton(
            started
                ? l10n(context, 'RESUME', 'IPAGPATULOY')
                : l10n(context, 'START SIMULATION', 'SIMULAHIN'),
            icon: Icons.play_arrow_rounded,
            color: C.green,
            onTap: _running ? null : _start,
          ),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _running ? _pause : null,
                icon: const Icon(Icons.pause_rounded),
                label: Text(l10n(context, 'Pause', 'I-pause')),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _reset,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(l10n(context, 'Reset', 'I-reset')),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _stat(BuildContext context, String label, String value) {
    return AppCard(
      child: Column(children: [
        Text(label, style: TextStyle(fontSize: 12, color: subText(context))),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ]),
    );
  }
}

Widget _output(BuildContext context, String label, String value) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$label: ',
            style: TextStyle(fontSize: 12, color: subText(context))),
        Text(value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );

class LabGraphPainter extends CustomPainter {
  final double initialVelocity;
  final double acceleration;
  final double duration;
  final double elapsed;
  final double Function(double) velocityAt;
  final bool dark;

  LabGraphPainter({
    required this.initialVelocity,
    required this.acceleration,
    required this.duration,
    required this.elapsed,
    required this.velocityAt,
    required this.dark,
  });

  void _label(Canvas canvas, String text, Offset position,
      {double anchorX = 0, double anchorY = 0}) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
            color: dark ? Colors.white60 : Colors.black54, fontSize: 10),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas,
        position - Offset(painter.width * anchorX, painter.height * anchorY));
  }

  @override
  void paint(Canvas canvas, Size size) {
    const left = 42.0, right = 10.0, top = 12.0, bottom = 30.0;
    final plot =
        Rect.fromLTRB(left, top, size.width - right, size.height - bottom);
    final endVelocity = velocityAt(duration);
    var minVelocity =
        math.min(0.0, math.min(initialVelocity, endVelocity)).toDouble();
    var maxVelocity =
        math.max(0.0, math.max(initialVelocity, endVelocity)).toDouble();
    if (maxVelocity - minVelocity < 1) maxVelocity = minVelocity + 1;
    final padding = (maxVelocity - minVelocity) * 0.1;
    minVelocity -= padding;
    maxVelocity += padding;

    Offset point(double time, double velocity) => Offset(
          plot.left + plot.width * time / duration,
          plot.bottom -
              plot.height *
                  (velocity - minVelocity) /
                  (maxVelocity - minVelocity),
        );

    final grid = Paint()
      ..color = dark ? Colors.white12 : Colors.black12
      ..strokeWidth = 1;
    for (int i = 0; i <= 4; i++) {
      final fraction = i / 4;
      final y = plot.bottom - plot.height * fraction;
      final velocity = minVelocity + (maxVelocity - minVelocity) * fraction;
      canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), grid);
      _label(canvas, fmt(velocity), Offset(plot.left - 6, y),
          anchorX: 1, anchorY: 0.5);
    }
    for (int i = 0; i <= 4; i++) {
      final fraction = i / 4;
      final x = plot.left + plot.width * fraction;
      canvas.drawLine(Offset(x, plot.top), Offset(x, plot.bottom), grid);
      _label(canvas, fmt(duration * fraction), Offset(x, plot.bottom + 5),
          anchorX: 0.5);
    }

    final axis = Paint()
      ..color = dark ? Colors.white54 : Colors.black45
      ..strokeWidth = 1.5;
    canvas.drawLine(plot.bottomLeft, plot.topLeft, axis);
    canvas.drawLine(plot.bottomLeft, plot.bottomRight, axis);
    _label(canvas, 'Time (s)', Offset(plot.right, size.height - 2),
        anchorX: 1, anchorY: 1);

    final line = Paint()
      ..color = C.purple
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final currentTime = elapsed.clamp(0.0, duration).toDouble();
    canvas.drawLine(point(0, velocityAt(0)),
        point(currentTime, velocityAt(currentTime)), line);
    canvas.drawCircle(point(currentTime, velocityAt(currentTime)), 5,
        Paint()..color = C.purple);
  }

  @override
  bool shouldRepaint(LabGraphPainter old) =>
      old.initialVelocity != initialVelocity ||
      old.acceleration != acceleration ||
      old.duration != duration ||
      old.elapsed != elapsed ||
      old.dark != dark;
}

class RoadPainter extends CustomPainter {
  final double offset;
  final double tilt;
  final double spin;
  final bool bounce;
  RoadPainter({
    required this.offset,
    required this.tilt,
    required this.spin,
    required this.bounce,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final full = Offset.zero & size;

    // sky
    canvas.drawRect(
      full,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF7CC4F2), Color(0xFFDFF1FF)],
        ).createShader(full),
    );
    canvas.drawCircle(Offset(w * 0.86, h * 0.2), 18,
        Paint()..color = const Color(0xFFFFE08A));

    // clouds drift slowly
    final cloud = Paint()..color = Colors.white.withValues(alpha: 0.85);
    for (int i = 0; i < 3; i++) {
      final cx = (i * 190.0 + 60 - offset * 0.05) % (w + 160) - 60;
      final cy = h * (0.14 + 0.09 * i);
      canvas.drawOval(
          Rect.fromCenter(center: Offset(cx, cy), width: 70, height: 22),
          cloud);
      canvas.drawOval(
          Rect.fromCenter(
              center: Offset(cx + 14, cy - 8), width: 40, height: 20),
          cloud);
    }

    // hills scroll slower than the road (parallax)
    final hill = Paint()..color = const Color(0xFF9AD3B0);
    final ho = (offset * 0.15) % 260;
    for (double x = -ho - 260; x < w; x += 260) {
      canvas.drawOval(Rect.fromLTWH(x, h * 0.42, 300, 110), hill);
    }

    // road
    final roadTop = h * 0.62;
    canvas.drawRect(Rect.fromLTWH(0, roadTop, w, h - roadTop),
        Paint()..color = const Color(0xFF3A4252));
    canvas.drawRect(Rect.fromLTWH(0, roadTop, w, 5),
        Paint()..color = const Color(0xFF7BC47F));
    final dash = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final o = offset % 70;
    for (double x = -o; x < w; x += 70) {
      canvas.drawLine(Offset(x, h * 0.86), Offset(x + 34, h * 0.86), dash);
    }

    // car
    const carW = 140.0;
    const carH = 58.0;
    final bob = bounce ? math.sin(offset * 0.35) * 1.2 : 0.0;
    final rect = Rect.fromLTWH(
        w / 2 - carW / 2, roadTop - carH * 0.55 + bob, carW, carH);
    canvas.save();
    canvas.translate(rect.center.dx, rect.center.dy);
    canvas.rotate(tilt);
    canvas.translate(-rect.center.dx, -rect.center.dy);
    paintCar(canvas, rect, C.red, spin: spin);
    canvas.restore();
  }

  @override
  bool shouldRepaint(RoadPainter old) => true;
}
