import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _c;
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2600))
      ..forward();
    _pulse = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1100))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    _pulse.dispose();
    super.dispose();
  }

  double _seg(double t, double a, double b, [Curve curve = Curves.easeOut]) =>
      curve.transform(clamp01((t - a) / (b - a)));

  Widget _speedLines() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final w in [90.0, 60.0, 76.0])
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            width: w,
            height: 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              gradient: const LinearGradient(
                colors: [Color(0x00FFFFFF), Color(0xCCFFFFFF)],
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B1F4B), Color(0xFF14409A), Color(0xFF1E88E5)],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: Listenable.merge([_c, _pulse]),
            builder: (context, _) {
              final t = _c.value;
              final logo = _seg(t, 0.0, 0.45, Curves.elasticOut);
              final tag = _seg(t, 0.3, 0.6);
              final car = _seg(t, 0.25, 0.85, Curves.easeOutCubic);
              final gauge = _seg(t, 0.1, 0.9, Curves.easeInOut);
              final btn = _seg(t, 0.75, 1.0);

              return Column(children: [
                const Spacer(flex: 2),
                Opacity(
                  opacity: clamp01(logo),
                  child: Transform.scale(
                    scale: 0.6 + 0.4 * logo,
                    child: const Text.rich(
                      TextSpan(children: [
                        TextSpan(
                            text: 'Accel',
                            style: TextStyle(color: Colors.white)),
                        TextSpan(
                            text: 'Lab', style: TextStyle(color: C.yellow)),
                      ]),
                      style: TextStyle(
                        fontSize: 54,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Opacity(
                  opacity: tag,
                  child: Text(
                    l10n(context, 'Learn. Move. Accelerate!',
                        'Matuto. Gumalaw. Bumilis!'),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 260,
                  width: double.infinity,
                  child: LayoutBuilder(builder: (context, box) {
                    final carW = math.min(230.0, box.maxWidth * 0.7);
                    final x = -carW + ((box.maxWidth - carW) / 2 + carW) * car;
                    return Stack(children: [
                      Positioned.fill(
                          child: CustomPaint(painter: _GaugePainter(gauge))),
                      Positioned(
                        left: x - 100,
                        bottom: 34,
                        child: Opacity(
                            opacity: clamp01(1 - car), child: _speedLines()),
                      ),
                      Positioned(
                          left: x, bottom: 20, child: CarWidget(width: carW)),
                    ]);
                  }),
                ),
                const Spacer(),
                Opacity(
                  opacity: btn,
                  child: Transform.scale(
                    scale: 1 + 0.04 * _pulse.value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: C.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                          onPressed: () => goReplace(context, const Shell()),
                          child: Text(
                              l10n(context, 'START LEARNING',
                                  'SIMULAN ANG PAG-AARAL'),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1)),
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
              ]);
            },
          ),
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double p;
  _GaugePainter(this.p);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.62);
    const r = 120.0;
    final rect = Rect.fromCircle(center: center, radius: r);
    const start = math.pi * 0.8;
    const sweep = math.pi * 1.4;

    canvas.drawArc(
      rect,
      start,
      sweep,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..color = Colors.white.withValues(alpha: 0.10),
    );
    canvas.drawArc(
      rect,
      start,
      sweep * p,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round
        ..shader = const SweepGradient(
          startAngle: start,
          endAngle: start + sweep,
          colors: [C.sky, C.teal, C.yellow, C.orange],
        ).createShader(rect),
    );

    final ang = start + sweep * p;
    canvas.drawLine(
      center,
      center + Offset(math.cos(ang), math.sin(ang)) * (r - 22),
      Paint()
        ..color = Colors.white
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(center, 8, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(_GaugePainter old) => old.p != p;
}
