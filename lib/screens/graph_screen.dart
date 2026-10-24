import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/session_page_navigation.dart';

// SESSION 6 - EXPLORE: Acceleration Graph Simulator
// Set the initial velocity, acceleration, time and direction, press RUN, and
// watch the car move while the velocity-time graph and speedometer update.

const Color _pink = Color(0xFFE8336D);

double _cl(double v, double lo, double hi) => v < lo ? lo : (v > hi ? hi : v);

double _niceStep(double span, int maxTicks) {
  const steps = [
    10.0,
    20.0,
    25.0,
    50.0,
    100.0,
    200.0,
    500.0,
    1000.0,
    2000.0,
    5000.0
  ];
  for (final s in steps) {
    if (span / s <= maxTicks) return s;
  }
  return steps.last;
}

void _text(Canvas c, String s, Offset o,
    {double size = 9,
    Color color = Colors.black54,
    FontWeight weight = FontWeight.normal,
    double ax = 0,
    double ay = 0,
    Color? bg}) {
  final tp = TextPainter(
    text: TextSpan(
        text: s,
        style: TextStyle(color: color, fontSize: size, fontWeight: weight)),
    textDirection: TextDirection.ltr,
  )..layout();
  final off = o - Offset(tp.width * ax, tp.height * ay);
  if (bg != null) {
    c.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(off.dx - 2, off.dy - 1, tp.width + 4, tp.height + 2),
          const Radius.circular(3)),
      Paint()..color = bg,
    );
  }
  tp.paint(c, off);
}

void _dashed(Canvas c, Offset a, Offset b, Paint p,
    {double dash = 6, double gap = 4}) {
  final total = (b - a).distance;
  if (total == 0) return;
  final dir = (b - a) / total;
  double d = 0;
  while (d < total) {
    final e = math.min(d + dash, total);
    c.drawLine(a + dir * d, a + dir * e, p);
    d += dash + gap;
  }
}

class GraphScreen extends StatefulWidget {
  // The session (lesson) number shown in the header badge. Defaults to 6.
  final int sessionId;
  const GraphScreen({super.key, this.sessionId = 6});

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen>
    with SingleTickerProviderStateMixin {
  double vi = 0; // initial velocity (m/s)
  double a = 2; // acceleration (m/s²)
  double t = 5; // time (s)
  bool right = true; // direction: Right (+) or Left (−)
  final Set<int> _open = {};
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: Duration(seconds: t.round()));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  // Direction flips the sign of the motion.
  double get _s => right ? 1.0 : -1.0;
  double get _vi => (right || vi == 0) ? vi : -vi;
  double get _a => (right || a == 0) ? a : -a;
  double _v(double time) => _vi + _a * time;
  double _x(double time) => _vi * time + 0.5 * _a * time * time;

  void _change(VoidCallback f) {
    setState(() {
      f();
      _c.stop();
      _c.duration = Duration(seconds: t.round());
      _c.value = 0;
    });
  }

  void _run() {
    _c.stop();
    _c.duration = Duration(seconds: t.round());
    _c.forward(from: 0);
  }

  // ---------------------------------------------------------------- header
  PreferredSizeWidget _appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 64,
      titleSpacing: 12,
      title: Row(children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Icon(Icons.speed, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 8),
        const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AccelLab',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic)),
            Text('Learn. Move. Accelerate!',
                style: TextStyle(color: Colors.white70, fontSize: 9)),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text('SESSION ${widget.sessionId}',
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
        ),
      ]),
      actions: [
        IconButton(
          icon: const Icon(Icons.home_rounded, size: 30),
          onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
        ),
      ],
    );
  }

  Widget _banner() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF1B3F9E), Color(0xFF2E75D6)]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF5BA3F5), width: 3),
      ),
      child: Row(children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: C.yellow, width: 3),
          ),
          child: const Icon(Icons.search_rounded, color: C.blue, size: 30),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Text.rich(
            TextSpan(children: [
              TextSpan(
                  text: 'EXPLORE: ',
                  style: TextStyle(
                      color: C.yellow,
                      fontSize: 24,
                      fontWeight: FontWeight.w900)),
              TextSpan(
                  text: 'Acceleration Graph Simulator',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold)),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _instruction() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3C4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF2C94C), width: 2),
      ),
      child: const Text(
        'Adjust the values and click RUN to see how the car moves and how the velocity-time graph changes.',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 13),
      ),
    );
  }

  // -------------------------------------------------------------- controls
  Widget _controls() {
    return SizedBox(
      height: 124,
      child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(
          child: _SliderCard(
            title: 'Initial Velocity',
            unit: '(m/s)',
            value: vi,
            min: -20,
            max: 40,
            ticks: const [-20, 0, 20, 40],
            color: C.blue,
            onChanged: (v) => _change(() => vi = v.roundToDouble()),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _SliderCard(
            title: 'Acceleration',
            unit: '(m/s²)',
            value: a,
            min: -6,
            max: 6,
            ticks: const [-6, -4, -2, 0, 2, 4, 6],
            color: C.red,
            onChanged: (v) => _change(() => a = v.roundToDouble()),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _SliderCard(
            title: 'Time',
            unit: '(s)',
            value: t,
            min: 0,
            max: 10,
            ticks: const [0, 2, 4, 6, 8, 10],
            color: C.green,
            onChanged: (v) => _change(() => t = v.roundToDouble()),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(children: [
            _directionCard(),
            const SizedBox(height: 6),
            Expanded(child: _runButton()),
          ]),
        ),
      ]),
    );
  }

  Widget _directionCard() {
    Widget btn(String label, bool selected, VoidCallback onTap) {
      return Expanded(
        child: Material(
          color: selected ? C.blue : C.blue.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6),
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(label,
                      style: TextStyle(
                          color: selected ? Colors.white : C.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 10)),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: _cardDeco(context),
      child: Column(children: [
        const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('Direction',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
        ),
        const SizedBox(height: 4),
        Row(children: [
          btn('Right (+)', right, () => _change(() => right = true)),
          const SizedBox(width: 3),
          btn('Left (−)', !right, () => _change(() => right = false)),
        ]),
      ]),
    );
  }

  Widget _runButton() {
    return Material(
      color: C.green,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _run,
        child: const Center(
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.play_arrow_rounded, color: Colors.white, size: 26),
            SizedBox(width: 2),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('RUN',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 12)),
                Text('SIMULATION',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 8.5)),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------- panels
  Widget _carPanel(double el, bool dark) {
    final x = _x(el);
    final v = _v(el);
    // axis range for the whole run, so the scale stays steady
    double xmin = 0, xmax = 0;
    for (int i = 0; i <= 40; i++) {
      final px = _x(t * i / 40);
      xmin = math.min(xmin, px);
      xmax = math.max(xmax, px);
    }
    final lo0 = math.min(0.0, xmin);
    final hi0 = math.max(50.0, xmax);
    final step = _niceStep(hi0 - lo0, 6);
    final lo = (lo0 / step).floor() * step;
    final hi = (hi0 / step).ceil() * step;
    final dir = v > 0.01 ? 1.0 : (v < -0.01 ? -1.0 : _s);

    return _Panel(
      title: 'Car Motion',
      color: C.blue,
      height: 196,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CustomPaint(
          size: Size.infinite,
          painter: _ScenePainter(
            x: x,
            lo: lo,
            hi: hi,
            step: step,
            dir: dir,
            dark: dark,
          ),
        ),
      ),
    );
  }

  Widget _graphPanel(double el, bool dark) {
    return _Panel(
      title: 'Velocity-Time Graph',
      color: _pink,
      height: 196,
      child: CustomPaint(
        size: Size.infinite,
        painter: _VtPainter(vi: _vi, a: _a, t: t, el: el, dark: dark),
      ),
    );
  }

  Widget _row(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(children: [
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(label, style: const TextStyle(fontSize: 11)),
          ),
        ),
        const SizedBox(width: 4),
        Text(value,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: color)),
      ]),
    );
  }

  String _speedNote() {
    if (_a == 0 || _vi == 0) return '';
    final opposite = (_vi > 0) != (_a > 0);
    if (!opposite) return 'The car is speeding up.';
    final tStop = -_vi / _a;
    if (tStop >= t) return 'The car is slowing down.';
    return 'The car slows down, stops at ${fmt(tStop)} s, then moves the other way.';
  }

  Widget _resultsPanel() {
    final vf = _vi + _a * t;
    final aTxt = '${_a > 0 ? '+' : ''}${fmt(_a)} m/s²';
    Color tint;
    String line1;
    String key;
    if (_a > 0) {
      tint = C.green;
      line1 = "The car's velocity increases.\nThis is a ";
      key = 'positive acceleration.';
    } else if (_a < 0) {
      tint = C.orange;
      line1 = "The car's velocity decreases.\nThis is a ";
      key = 'negative acceleration.';
    } else {
      tint = C.blue;
      line1 = "The car's velocity stays constant.\nThis is ";
      key = 'zero acceleration.';
    }
    final note = _speedNote();

    return _Panel(
      title: 'Results',
      color: C.blue,
      height: 214,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _row('Initial Velocity (vi):', '${fmt(_vi)} m/s'),
        _row('Acceleration (a):', aTxt,
            color: _a > 0 ? C.red : (_a < 0 ? C.blue : null)),
        _row('Time (t):', '${fmt(t)} s'),
        _row('Final Velocity (vf):', '${fmt(vf)} m/s', color: C.blue),
        const SizedBox(height: 4),
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: tint.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: tint.withValues(alpha: 0.7)),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                        TextSpan(children: [
                          TextSpan(text: line1),
                          TextSpan(
                              text: key,
                              style: TextStyle(
                                  color: _a > 0
                                      ? C.red
                                      : (_a < 0 ? C.orange : C.blue),
                                  fontWeight: FontWeight.bold)),
                        ]),
                        style: const TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w600)),
                    if (note.isNotEmpty)
                      Text(note,
                          style: const TextStyle(
                              fontSize: 10, fontStyle: FontStyle.italic)),
                  ]),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _speedoPanel(double el, bool dark) {
    final value = _c.value == 0 ? _vi + _a * t : _v(el);
    return _Panel(
      title: 'Speedometer (Final Velocity)',
      color: C.blue,
      height: 214,
      child: Column(children: [
        Expanded(
          child: CustomPaint(
            size: Size.infinite,
            painter: _GaugePainter(value: value, dark: dark),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: C.blue, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text('${fmt(value)} m/s',
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ]),
    );
  }

  Widget _explore(bool dark) {
    const qs = [
      'What does an upward line mean?',
      'What does a flat line mean?',
      'What does a downward line mean?',
      'What happens to the graph when the acceleration becomes larger?',
    ];
    const ans = [
      'Velocity is increasing, so the acceleration is positive.',
      'Velocity is not changing, so the acceleration is zero.',
      'Velocity is decreasing, so the acceleration is negative.',
      'The line becomes steeper, because the velocity changes faster.',
    ];
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: dark ? cardColor(context) : const Color(0xFFFFF8DC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF2C94C), width: 3),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 36,
            height: 36,
            decoration:
                const BoxDecoration(color: C.yellow, shape: BoxShape.circle),
            child: const Icon(Icons.lightbulb, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 10),
          const Text('Explore and Answer',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ]),
        const SizedBox(height: 4),
        Text('Tap a question to see the answer.',
            style: TextStyle(
                fontSize: 11,
                fontStyle: FontStyle.italic,
                color: subText(context))),
        const SizedBox(height: 6),
        for (int i = 0; i < qs.length; i++) ...[
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => setState(() {
              if (!_open.remove(i)) _open.add(i);
            }),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                CircleAvatar(
                  radius: 11,
                  backgroundColor: C.blue,
                  child: Text('${i + 1}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(qs[i],
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                ),
                Icon(_open.contains(i) ? Icons.expand_less : Icons.expand_more,
                    color: subText(context)),
              ]),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            alignment: Alignment.topCenter,
            child: _open.contains(i)
                ? Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(left: 32, bottom: 6),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: C.blue.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(ans[i], style: const TextStyle(fontSize: 13)),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ]),
    );
  }

  // ----------------------------------------------------------------- build
  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    return Scaffold(
      backgroundColor: dark ? null : const Color(0xFFEAF3FF),
      appBar: _appBar(),
      bottomNavigationBar: SessionPageNavigationBar(
        sessionId: widget.sessionId,
        currentPage: SessionPage.explore,
      ),
      body: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          final el = _c.value * t;
          return ListView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
            children: [
              _banner(),
              const SizedBox(height: 10),
              _instruction(),
              const SizedBox(height: 10),
              _controls(),
              const SizedBox(height: 10),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(child: _carPanel(el, dark)),
                const SizedBox(width: 8),
                Expanded(child: _graphPanel(el, dark)),
              ]),
              const SizedBox(height: 10),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(child: _resultsPanel()),
                const SizedBox(width: 8),
                Expanded(child: _speedoPanel(el, dark)),
              ]),
              const SizedBox(height: 10),
              _explore(dark),
            ],
          );
        },
      ),
    );
  }
}

BoxDecoration _cardDeco(BuildContext context) => BoxDecoration(
      color: cardColor(context),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: C.blue.withValues(alpha: 0.35)),
    );

// A white card with a colored title strip, like in the design.
class _Panel extends StatelessWidget {
  final String title;
  final Color color;
  final double height;
  final Widget child;
  const _Panel(
      {required this.title,
      required this.color,
      required this.height,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: cardColor(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: [
        Container(
          width: double.infinity,
          color: color,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
          ),
        ),
        Expanded(
            child: Padding(padding: const EdgeInsets.all(6), child: child)),
      ]),
    );
  }
}

class _SliderCard extends StatelessWidget {
  final String title;
  final String unit;
  final double value;
  final double min;
  final double max;
  final List<int> ticks;
  final Color color;
  final ValueChanged<double> onChanged;
  const _SliderCard({
    required this.title,
    required this.unit,
    required this.value,
    required this.min,
    required this.max,
    required this.ticks,
    required this.color,
    required this.onChanged,
  });

  Widget _arrow(IconData icon, bool on, VoidCallback cb) {
    return InkWell(
      onTap: on ? cb : null,
      borderRadius: BorderRadius.circular(8),
      child: Icon(icon, size: 24, color: on ? color : Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    final v = _cl(value, min, max);
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 6, 4, 6),
      decoration: _cardDeco(context),
      child: Column(children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(unit,
              style: TextStyle(fontSize: 10, color: subText(context))),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 5,
            activeTrackColor: color,
            inactiveTrackColor: color.withValues(alpha: 0.25),
            thumbColor: color,
            overlayShape: SliderComponentShape.noOverlay,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
          ),
          child: SizedBox(
            height: 22,
            child: Slider(
              value: v,
              min: min,
              max: max,
              divisions: (max - min).round(),
              onChanged: onChanged,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final tk in ticks)
                Text('$tk', style: const TextStyle(fontSize: 7)),
            ],
          ),
        ),
        const Spacer(),
        Row(children: [
          _arrow(
              Icons.arrow_left, v > min, () => onChanged(_cl(v - 1, min, max))),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: color.withValues(alpha: 0.5)),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(fmt(v),
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          ),
          _arrow(Icons.arrow_right, v < max,
              () => onChanged(_cl(v + 1, min, max))),
        ]),
      ]),
    );
  }
}

// ------------------------------------------------------------------ painters

// Car on the road with a position axis (m) underneath.
class _ScenePainter extends CustomPainter {
  final double x, lo, hi, step, dir;
  final bool dark;
  _ScenePainter({
    required this.x,
    required this.lo,
    required this.hi,
    required this.step,
    required this.dir,
    required this.dark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    const axisH = 40.0;
    final sceneH = h - axisH;
    final scene = Rect.fromLTWH(0, 0, w, sceneH);

    canvas.drawRect(
      scene,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF8FD0FF), Color(0xFFE3F4FF)],
        ).createShader(scene),
    );
    // hills
    canvas.drawOval(
        Rect.fromLTWH(-w * 0.2, sceneH * 0.38, w * 0.8, sceneH * 0.5),
        Paint()..color = const Color(0xFFA5DCA5));
    canvas.drawOval(
        Rect.fromLTWH(w * 0.3, sceneH * 0.45, w * 0.9, sceneH * 0.45),
        Paint()..color = const Color(0xFF8FD08F));
    // trees
    final trunk = Paint()..color = const Color(0xFF7A5230);
    final leaf = Paint()..color = const Color(0xFF3E9B4F);
    for (final fx in [0.08, 0.32, 0.72, 0.92]) {
      final tx = w * fx;
      final base = sceneH * 0.62;
      canvas.drawRect(Rect.fromLTWH(tx - 2, base - 14, 4, 14), trunk);
      canvas.drawCircle(Offset(tx, base - 22), 11, leaf);
      canvas.drawCircle(Offset(tx - 6, base - 16), 8, leaf);
      canvas.drawCircle(Offset(tx + 6, base - 16), 8, leaf);
    }
    // road
    final roadTop = sceneH * 0.62;
    canvas.drawRect(Rect.fromLTWH(0, roadTop, w, sceneH - roadTop),
        Paint()..color = const Color(0xFF454E5C));
    canvas.drawRect(Rect.fromLTWH(0, roadTop, w, 4),
        Paint()..color = const Color(0xFF7BC47F));
    final dash = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    for (double dx = 6; dx < w; dx += 36) {
      canvas.drawLine(
          Offset(dx, sceneH * 0.86), Offset(dx + 18, sceneH * 0.86), dash);
    }

    // position -> pixel mapping (shared by the car and the axis)
    final carW = math.min(64.0, w * 0.42);
    final carH = carW * 0.42;
    final m = carW / 2 + 4;
    double px(double v) => m + (v - lo) / (hi - lo) * (w - 2 * m);
    final cx = px(x);

    canvas.save();
    if (dir < 0) {
      canvas.translate(cx, 0);
      canvas.scale(-1, 1);
      canvas.translate(-cx, 0);
    }
    paintCar(canvas,
        Rect.fromLTWH(cx - carW / 2, roadTop - carH * 0.55, carW, carH), C.red,
        spin: x * 0.4);
    canvas.restore();

    // axis
    final tc = dark ? Colors.white70 : Colors.black54;
    final axisY = sceneH + 12;
    final axisPaint = Paint()
      ..color = tc
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(px(lo), axisY), Offset(px(hi), axisY), axisPaint);
    for (double v = lo; v <= hi + 1e-9; v += step) {
      canvas.drawLine(
          Offset(px(v), axisY), Offset(px(v), axisY + 4), axisPaint);
      _text(canvas, fmt(v), Offset(px(v), axisY + 6),
          size: 8, color: tc, ax: 0.5);
    }
    // marker for the car's position
    canvas.drawPath(
      Path()
        ..moveTo(cx, axisY)
        ..lineTo(cx - 4, axisY - 8)
        ..lineTo(cx + 4, axisY - 8)
        ..close(),
      Paint()..color = C.red,
    );
    _text(canvas, 'Position (m)', Offset(w / 2, h - 12),
        size: 9, color: tc, ax: 0.5);
  }

  @override
  bool shouldRepaint(_ScenePainter old) => true;
}

// Velocity-time graph. The dashed line is the full run; the solid line is
// drawn up to the current moment of the simulation.
class _VtPainter extends CustomPainter {
  final double vi, a, t, el;
  final bool dark;
  _VtPainter(
      {required this.vi,
      required this.a,
      required this.t,
      required this.el,
      required this.dark});

  @override
  void paint(Canvas canvas, Size size) {
    final vf = vi + a * t;
    final started = el > 0;
    final lo0 = math.min(-20.0, math.min(vi, vf));
    final hi0 = math.max(40.0, math.max(vi, vf));
    final step = _niceStep(hi0 - lo0, 7);
    final lo = (lo0 / step).floor() * step;
    final hi = (hi0 / step).ceil() * step;

    const left = 30.0, right = 8.0, top = 16.0, bottom = 24.0;
    final plot =
        Rect.fromLTRB(left, top, size.width - right, size.height - bottom);
    Offset pt(double tt, double v) => Offset(plot.left + plot.width * tt / 10,
        plot.bottom - plot.height * (v - lo) / (hi - lo));

    final tc = dark ? Colors.white70 : Colors.black54;
    final grid = Paint()
      ..color = dark ? Colors.white12 : Colors.black12
      ..strokeWidth = 1;

    _text(canvas, 'Velocity (m/s)', const Offset(2, 0), size: 8, color: tc);
    for (double y = lo; y <= hi + 1e-9; y += step) {
      final p = pt(0, y);
      canvas.drawLine(Offset(plot.left, p.dy), Offset(plot.right, p.dy), grid);
      _text(canvas, fmt(y), Offset(plot.left - 4, p.dy),
          size: 8, color: tc, ax: 1, ay: 0.5);
    }
    final every = plot.width / 10 < 15 ? 2 : 1;
    for (int i = 0; i <= 10; i++) {
      final p = pt(i.toDouble(), lo);
      canvas.drawLine(Offset(p.dx, plot.top), Offset(p.dx, plot.bottom), grid);
      if (i % every == 0) {
        _text(canvas, '$i', Offset(p.dx, plot.bottom + 3),
            size: 8, color: tc, ax: 0.5);
      }
    }
    _text(canvas, 'Time (s)', Offset(plot.center.dx, size.height - 1),
        size: 8, color: tc, ax: 0.5, ay: 1);

    // axes: the time axis is drawn at v = 0
    final axis = Paint()
      ..color = dark ? Colors.white54 : Colors.black54
      ..strokeWidth = 1.8;
    canvas.drawLine(pt(0, 0), pt(10, 0), axis);
    canvas.drawLine(
        Offset(plot.left, plot.top), Offset(plot.left, plot.bottom), axis);

    // preview of the whole run
    _dashed(
      canvas,
      pt(0, vi),
      pt(t, vf),
      Paint()
        ..color = _pink.withValues(alpha: 0.45)
        ..strokeWidth = 2,
    );

    final curT = started ? el : t;
    final curV = vi + a * curT;
    final end = pt(curT, curV);
    if (started) {
      canvas.drawLine(
        pt(0, vi),
        end,
        Paint()
          ..color = _pink
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round,
      );
    }
    canvas.drawCircle(end, 4.5, Paint()..color = _pink);
    canvas.drawCircle(end, 2, Paint()..color = Colors.white);

    final label = '(${fmt(curT)} s, ${fmt(curV)} m/s)';
    final probe = TextPainter(
      text: TextSpan(
          text: label,
          style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    )..layout();
    double lx = end.dx + 5;
    if (lx + probe.width > size.width - 2) lx = end.dx - probe.width - 5;
    double ly = end.dy - probe.height - 5;
    if (ly < 2) ly = end.dy + 6;
    _text(canvas, label, Offset(lx, ly),
        size: 8.5,
        color: C.blue,
        weight: FontWeight.bold,
        bg: dark ? const Color(0xFF1A2440) : Colors.white);
  }

  @override
  bool shouldRepaint(_VtPainter old) => true;
}

// Speedometer from -20 to 40 m/s.
class _GaugePainter extends CustomPainter {
  final double value;
  final bool dark;
  _GaugePainter({required this.value, required this.dark});

  @override
  void paint(Canvas canvas, Size size) {
    const start = math.pi * 150 / 180;
    const sweep = math.pi * 240 / 180;
    double ang(double v) => start + sweep * (_cl(v, -20, 40) + 20) / 60;

    final c = Offset(size.width / 2, size.height * 0.6);
    final r =
        math.max(20.0, math.min(size.width / 2 - 22, size.height * 0.6 - 12));
    final rect = Rect.fromCircle(center: c, radius: r);

    void seg(double a, double b, Color col) {
      canvas.drawArc(
        rect,
        ang(a),
        ang(b) - ang(a),
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 11
          ..color = col,
      );
    }

    seg(-20, 0, const Color(0xFFB0B7C3));
    seg(0, 15, const Color(0xFF3BB273));
    seg(15, 28, const Color(0xFFF5B83D));
    seg(28, 40, const Color(0xFFF08A3C));

    final tc = dark ? Colors.white : Colors.black87;
    for (final v in [-20.0, 0.0, 20.0, 40.0]) {
      final a = ang(v);
      final p = c + Offset(math.cos(a), math.sin(a)) * (r + 13);
      _text(canvas, fmt(v), p,
          size: 9, color: tc, weight: FontWeight.bold, ax: 0.5, ay: 0.5);
    }

    final na = ang(value);
    canvas.drawLine(
      c,
      c + Offset(math.cos(na), math.sin(na)) * (r - 6),
      Paint()
        ..color = const Color(0xFF14306B)
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(c, 8, Paint()..color = const Color(0xFF14306B));
    canvas.drawCircle(c, 3, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(_GaugePainter old) => true;
}
