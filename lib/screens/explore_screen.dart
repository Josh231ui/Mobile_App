import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/common.dart';

// ---------------- Explore: Real-Life Motion Simulator (pseudo-3D prototype) ----------------

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

enum _SceneKind { city, highway, busStop, airport, bikeLane }

class _ExploreScreenState extends State<ExploreScreen>
    with SingleTickerProviderStateMixin {
  int _selected = 0;
  double _speed = 0; // m/s, 0-30
  late final AnimationController _c;

  static final _situations = <_Situation>[
    _Situation(
        'City Road', 'Daan sa Lungsod', Icons.directions_car, C.blue, _SceneKind.city),
    _Situation(
        'Highway', 'Pantalan', Icons.route, C.green, _SceneKind.highway),
    _Situation('Bus Stop', 'Bahay-Bahay ng Bus', Icons.directions_bus, C.orange,
        _SceneKind.busStop),
    _Situation('Airport', 'Paliparan', Icons.flight, C.purple, _SceneKind.airport),
    _Situation('Bicycle Lane', 'Landasang Bisikleta', Icons.directions_bike,
        C.teal, _SceneKind.bikeLane),
  ];

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 40))
      ..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _accelerate() => setState(() => _speed = (_speed + 2).clamp(0.0, 30.0));
  void _brake() => setState(() => _speed = (_speed - 3).clamp(0.0, 30.0));
  void _turnLeft() => setState(() {});
  void _turnRight() => setState(() {});

  double get _laneScroll => (_c.value * _speed * 0.12) % 1.0;
  double get _tilt => -0.12 + (_speed / 30.0) * 0.28;

  _Situation get _sit => _situations[_selected];

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);
    return Scaffold(
      appBar: canPop
          ? AppBar(
              title: Text(l10n(context, 'Explore', 'Mag-explore')),
            )
          : null,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        children: [
          Reveal(
              child: PageHeader(
            l10n(context, 'Explore', 'Mag-explore'),
            subtitle: l10n(
                context, 'Real-Life Motion Simulator', 'Simulador ng Galaw sa Tunay na Buhay'),
          )),
          const SizedBox(height: 8),
          Text(l10n(context, 'Choose a situation:', 'Pumili ng sitwasyon:'),
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
          const SizedBox(height: 8),
          SizedBox(
            height: 78,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _situations.length,
              itemBuilder: (_, i) {
                final s = _situations[i];
                final active = i == _selected;
                return GestureDetector(
                  onTap: () => setState(() => _selected = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 110,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: active
                          ? s.color.withValues(alpha: 0.15)
                          : cardColor(context),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: active ? s.color : Colors.transparent,
                          width: 2),
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Icon(s.icon,
                          color: active ? s.color : subText(context),
                          size: 28),
                      const SizedBox(height: 4),
                      Text(s.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: active ? s.color : subText(context),
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          )),
                    ]),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          // ---- pseudo-3D road scene with per-environment background ----
          Container(
            height: 250,
            child: Stack(children: [
              _RoadScene(kind: _sit.kind, speed: _speed, scroll: _laneScroll),
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Center(
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.003)
                      ..rotateX(_tilt),
                    alignment: Alignment.center,
                    child: CarWidget(width: 110, color: _sit.color),
                  ),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 12),
          // ---- readouts ----
          Row(children: [
            _Readout('Speed', '${_speed.toStringAsFixed(0)} m/s', C.blue,
                Icons.speed),
            const SizedBox(width: 10),
            _Readout('Velocity',
                '${_speed.toStringAsFixed(0)} m/s east', C.green,
                Icons.navigation),
            const SizedBox(width: 10),
            _Readout('Acceleration',
                _speed > 0 ? '2 m/s²' : '0 m/s²', C.orange,
                Icons.show_chart),
          ]),
          const SizedBox(height: 12),
          // ---- action buttons ----
          Row(children: [
            Expanded(
                child: _Action('ACCELERATE', C.green, Icons.arrow_upward,
                    _accelerate)),
            const SizedBox(width: 8),
            Expanded(
                child: _Action('BRAKE', C.red, Icons.arrow_downward, _brake)),
            const SizedBox(width: 8),
            Expanded(child: _Action('TURN LEFT', C.blue,
                Icons.arrow_back_rounded, _turnLeft)),
            const SizedBox(width: 8),
            Expanded(child: _Action('TURN RIGHT', C.orange,
                Icons.arrow_forward_rounded, _turnRight)),
          ]),
          const SizedBox(height: 16),
          Reveal(child: PageHeader(l10n(context, 'Explore and Answer', 'Magsagawa at Sumagot'),
              subtitle: l10n(context, 'What happens in each situation?',
                  'Anong mangyayari sa bawat sitwasyon?'))),
          const SizedBox(height: 8),
          ...List.generate(4, (i) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Reveal(
              index: i,
              child: AppCard(
                padding: const EdgeInsets.all(12),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  CircleAvatar(
                      radius: 12,
                      backgroundColor: C.blue,
                      child: Text('${i + 1}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold))),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Text(_questions[i],
                          style: const TextStyle(fontSize: 14, height: 1.4))),
                ]),
              ),
            ),
          )),
        ],
      ),
    );
  }

  static const _questions = [
    'What happens when you press accelerate?',
    'What happens when you press brake?',
    'What happens when the vehicle turns?',
    'Why does turning involve a change in velocity?',
  ];
}

class _Situation {
  final String title;
  final String titleTl;
  final IconData icon;
  final Color color;
  final _SceneKind kind;
  const _Situation(this.title, this.titleTl, this.icon, this.color, this.kind);
}

class _Readout extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  const _Readout(this.label, this.value, this.color, this.icon);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Column(children: [
          Row(children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.w800)),
          ]),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }
}

class _Action extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;
  const _Action(this.label, this.color, this.icon, this.onTap);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onTap,
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 20),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }
}

class _RoadScene extends StatelessWidget {
  final _SceneKind kind;
  final double speed;
  final double scroll;
  const _RoadScene({
    required this.kind,
    required this.speed,
    required this.scroll,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, 250),
      painter: _RoadPainter(kind: kind, speed: speed, scroll: scroll),
    );
  }
}

class _RoadPainter extends CustomPainter {
  final _SceneKind kind;
  final double speed;
  final double scroll;
  const _RoadPainter({
    required this.kind,
    required this.speed,
    required this.scroll,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final horizon = h * 0.38;

    // ===== Layer 1: Sky =====
    _drawSky(canvas, w, h);

    // ===== Layer 2: Distant background (only above horizon) =====
    switch (kind) {
      case _SceneKind.city:
        _drawCityBackground(canvas, w, h, horizon);
        break;
      case _SceneKind.highway:
        _drawHighwayBackground(canvas, w, h, horizon);
        break;
      case _SceneKind.busStop:
        _drawBusStopBackground(canvas, w, h, horizon);
        break;
      case _SceneKind.airport:
        _drawAirportBackground(canvas, w, h, horizon);
        break;
      case _SceneKind.bikeLane:
        _drawBikeLaneBackground(canvas, w, h, horizon);
        break;
    }

    // ===== Layer 3: Ground / grass =====
    final grass = Paint()..color = _groundColor(kind);
    canvas.drawRect(Rect.fromLTWH(0, horizon, w, h - horizon), grass);

    // ===== Layer 4: Road trapezoid (perspective) =====
    final road = Paint()..color = _roadColor(kind);
    final roadPath = Path()
      ..moveTo(0, h)
      ..lineTo(w, h)
      ..lineTo(w * 0.62, horizon)
      ..lineTo(w * 0.38, horizon)
      ..close();
    canvas.drawPath(roadPath, road);

    // ===== Layer 5: Center lane markings - dashed, animated toward viewer =====
    final line = Paint()
      ..color = _lineColor(kind)
      ..strokeCap = StrokeCap.round;

    final laneCount = 14;
    for (var i = 0; i < laneCount; i++) {
      final t = ((i / laneCount) + scroll) % 1.0;
      if (t < 0.03) continue;

      final halfW = _lerp(w * 0.10, w * 0.40, t);
      final y = _lerp(horizon, h, t);
      final dashLen = _lerp(5, 24, t);
      final gap = _lerp(3, 14, t);
      final segLen = dashLen + gap;
      final phase = (scroll * 120 + i * 16) % segLen;
      var xpos = -phase;
      while (xpos < halfW * 2.2) {
        final dx1 = w / 2 - halfW + xpos;
        final dx2 = dx1 + dashLen;
        if (dx2 > w / 2 - halfW && dx1 < w / 2 + halfW) {
          canvas.drawLine(
            Offset(dx1.clamp(w / 2 - halfW, w / 2 + halfW), y),
            Offset(dx2.clamp(w / 2 - halfW, w / 2 + halfW), y),
            line
              ..strokeWidth = _lerp(2, 6, t),
          );
        }
        xpos += segLen;
      }
    }

    // ===== Layer 6: Road borders =====
    final border = Paint()
      ..color = _lineColor(kind)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final borderPath = Path()
      ..moveTo(w * 0.38, horizon)
      ..lineTo(0, h)
      ..moveTo(w * 0.62, horizon)
      ..lineTo(w, h);
    canvas.drawPath(borderPath, border);

    // ===== Layer 7: Roadside scenery (on top of road) =====
    _drawRoadside(canvas, w, h, horizon, kind, scroll);
  }

  @override
  bool shouldRepaint(covariant _RoadPainter old) =>
      old.kind != kind || old.speed != speed || old.scroll != scroll;

  // ================= per-environment drawing helpers =================

  void _drawSky(Canvas canvas, double w, double h) {
    final top = _skyTop(kind);
    final bottom = _skyBottom(kind);
    final sky = Paint()
      ..shader = LinearGradient(
        colors: [top, bottom],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Offset.zero & Size(w, h));
    canvas.drawRect(Offset.zero & Size(w, h), sky);

    // Sun
    final sun = Paint()..color = const Color(0xFFFFF08B);
    canvas.drawCircle(Offset(w * 0.82, h * 0.14), h * 0.06, sun);

    // Clouds
    final cloud = Paint()..color = Colors.white.withValues(alpha: 0.5);
    final cx = (scroll * w * 0.5) % (w + 100) - 50;
    for (var i = 0; i < 3; i++) {
      final x = (cx + i * 110) % (w + 100) - 50;
      final y = h * (0.09 + i * 0.07);
      canvas.drawOval(Rect.fromLTWH(x, y, w * 0.13, h * 0.06), cloud);
      canvas.drawOval(
          Rect.fromLTWH(x + w * 0.05, y - h * 0.015, w * 0.11, h * 0.05), cloud);
    }
  }

  Color _skyTop(_SceneKind k) {
    switch (k) {
      case _SceneKind.city:
        return const Color(0xFF4A90D9);
      case _SceneKind.highway:
        return const Color(0xFF5DADE2);
      case _SceneKind.busStop:
        return const Color(0xFF4A90D9);
      case _SceneKind.airport:
        return const Color(0xFF7FB3D5);
      case _SceneKind.bikeLane:
        return const Color(0xFF5DADE2);
    }
  }

  Color _skyBottom(_SceneKind k) {
    switch (k) {
      case _SceneKind.city:
        return const Color(0xFFB8D4E8);
      case _SceneKind.highway:
        return const Color(0xFF85C1E9);
      case _SceneKind.busStop:
        return const Color(0xFFB8D4E8);
      case _SceneKind.airport:
        return const Color(0xFFD6EAF8);
      case _SceneKind.bikeLane:
        return const Color(0xFF85C1E9);
    }
  }

  Color _groundColor(_SceneKind k) {
    switch (k) {
      case _SceneKind.city:
        return const Color(0xFF9E9E9E);
      case _SceneKind.highway:
        return const Color(0xFF7CB342);
      case _SceneKind.busStop:
        return const Color(0xFFBDBDBD);
      case _SceneKind.airport:
        return const Color(0xFF4CAF50);
      case _SceneKind.bikeLane:
        return const Color(0xFF66BB6A);
    }
  }

  Color _roadColor(_SceneKind k) {
    switch (k) {
      case _SceneKind.city:
        return const Color(0xFF424242);
      case _SceneKind.highway:
        return const Color(0xFF616161);
      case _SceneKind.busStop:
        return const Color(0xFF757575);
      case _SceneKind.airport:
        return const Color(0xFF78909C);
      case _SceneKind.bikeLane:
        return const Color(0xFF9E9E9E);
    }
  }

  Color _lineColor(_SceneKind k) {
    switch (k) {
      case _SceneKind.city:
        return const Color(0xFFFFEB3B);
      case _SceneKind.highway:
        return const Color(0xFFFFD54F);
      case _SceneKind.busStop:
        return const Color(0xFFFFEB3B);
      case _SceneKind.airport:
        return const Color(0xFFFFFFFF);
      case _SceneKind.bikeLane:
        return const Color(0xFFFFD54F);
    }
  }

  // ---------------- distant backgrounds (above horizon only) ----------------

  void _drawCityBackground(Canvas canvas, double w, double h, double horizon) {
    final building = Paint()..color = const Color(0xFF37474F);
    final windowOn = Paint()..color = const Color(0xFFFFECB3);
    final windowOff = Paint()..color = const Color(0xFF546E7A);

    // Skyscrapers rising from the horizon line into the sky
    final heights = [0.42, 0.58, 0.35, 0.50, 0.62, 0.40];
    final xs = [0.00, 0.15, 0.30, 0.50, 0.70, 0.85];
    for (var i = 0; i < xs.length; i++) {
      final x = w * xs[i];
      final bw = w * 0.10;
      final bh = (horizon) * heights[i]; // height measured upward from horizon
      canvas.drawRect(
          Rect.fromLTWH(x, horizon - bh, bw, bh), building);
      // Windows grid
      final cols = (bw / 7).floor();
      final rows = (bh / 11).floor();
      for (var ry = 0; ry < rows; ry++) {
        for (var rx = 0; rx < cols; rx++) {
          final wx = x + 3 + rx * 7;
          final wy = horizon - bh + 4 + ry * 11;
          if (wx + 4 < x + bw && wy + 4 < horizon) {
            canvas.drawRect(
                Rect.fromLTWH(wx, wy, 4, 4),
                (rx + ry) % 3 == 0 ? windowOn : windowOff);
          }
        }
      }
    }
  }

  void _drawHighwayBackground(Canvas canvas, double w, double h, double horizon) {
    final mountain = Paint()..color = const Color(0xFF78909C);
    final mountainFar = Paint()..color = const Color(0xFF90A4AE);
    final sign = Paint()..color = const Color(0xFF2E7D32);

    // Distant mountains behind the road
    final mpath = Path();
    mpath.moveTo(0, horizon);
    for (var i = 0; i <= 6; i++) {
      final x = w * i / 6;
      final y = horizon - math.sin(i * 1.9) * h * 0.14;
      if (i == 0) mpath.moveTo(x, y);
      else mpath.lineTo(x, y);
    }
    mpath.lineTo(w, horizon);
    mpath.close();
    canvas.drawPath(mpath, mountainFar);

    // Closer mountains
    final mpath2 = Path();
    mpath2.moveTo(0, horizon);
    for (var i = 0; i <= 5; i++) {
      final x = w * i / 5;
      final y = horizon - math.sin(i * 2.3 + 1) * h * 0.09;
      if (i == 0) mpath2.moveTo(x, y);
      else mpath2.lineTo(x, y);
    }
    mpath2.lineTo(w, horizon);
    mpath2.close();
    canvas.drawPath(mpath2, mountain);

    // Overhead highway sign (drawn large, clearly visible)
    final sx = w * 0.50;
    final sy = horizon - h * 0.10;
    final sw = w * 0.26;
    final sh = h * 0.075;
    final white = Paint()..color = Colors.white;
    canvas.drawRRect(
        RRect.fromLTRBR(sx, sy, sx + sw, sy + sh, Radius.circular(6)), sign);
    // Sign text bars
    canvas.drawRect(
        Rect.fromLTWH(sx + sw * 0.12, sy + sh * 0.28, sw * 0.20, sh * 0.22),
        white);
    canvas.drawRect(
        Rect.fromLTWH(sx + sw * 0.42, sy + sh * 0.28, sw * 0.14, sh * 0.22),
        white);
    canvas.drawRect(
        Rect.fromLTWH(sx + sw * 0.66, sy + sh * 0.28, sw * 0.10, sh * 0.22),
        white);
  }

  void _drawBusStopBackground(Canvas canvas, double w, double h, double horizon) {
    final shelter = Paint()..color = const Color(0xFF455A64);
    final glass = Paint()..color = Colors.white.withValues(alpha: 0.75);
    final building = Paint()..color = const Color(0xFF546E7A);
    final bench = Paint()..color = const Color(0xFF37474F);

    // Bus shelter on the left side at the roadside
    final sx = w * 0.04;
    final sw = w * 0.20;
    final sh = h * 0.11;
    canvas.drawRRect(
        RRect.fromLTRBR(sx, horizon - sh, sx + sw, horizon, Radius.circular(8)),
        shelter);
    canvas.drawRRect(
        RRect.fromLTRBR(
            sx + 4, horizon - sh + 4, sx + sw - 4, horizon - 4, Radius.circular(6)),
        glass);

    // Bench inside shelter
    canvas.drawRect(
        Rect.fromLTWH(sx + 6, horizon - 5, sw * 0.5, h * 0.025), bench);

    // Distant buildings behind
    canvas.drawRect(
        Rect.fromLTWH(w * 0.55, horizon - h * 0.06, w * 0.30, h * 0.06), building);
    canvas.drawRect(
        Rect.fromLTWH(w * 0.86, horizon - h * 0.045, w * 0.12, h * 0.045), building);
  }

  void _drawAirportBackground(Canvas canvas, double w, double h, double horizon) {
    final terminal = Paint()..color = const Color(0xFF78909C);
    final tower = Paint()..color = const Color(0xFF546E7A);
    final glass = Paint()..color = Colors.white.withValues(alpha: 0.7);

    // Airport terminal building (long, low, behind horizon)
    final tx = w * 0.08;
    final tw = w * 0.56;
    final th = h * 0.075;
    canvas.drawRRect(
        RRect.fromLTRBR(tx, horizon - th, tx + tw, horizon, Radius.circular(6)),
        terminal);
    // Terminal windows
    for (var i = 0; i < 7; i++) {
      canvas.drawRect(
          Rect.fromLTWH(tx + 12 + i * 0.075 * w, horizon - th + 8, w * 0.025, h * 0.02),
          glass);
    }

    // Control tower on the right
    final cx = w * 0.70;
    final cw = w * 0.07;
    final ch = h * 0.11;
    canvas.drawRRect(
        RRect.fromLTRBR(cx, horizon - ch, cx + cw, horizon, Radius.circular(4)),
        tower);
    canvas.drawRect(
        Rect.fromLTWH(cx - cw * 0.25, horizon - ch + ch * 0.55, cw * 1.5, h * 0.025),
        glass);
  }

  void _drawBikeLaneBackground(Canvas canvas, double w, double h, double horizon) {
    final tree = Paint()..color = const Color(0xFF2E7D32);
    final leaf = Paint()..color = const Color(0xFF4CAF50);
    final flower = Paint()..color = const Color(0xFFFF4081);

    // Park-like trees along the roadside, bases at horizon
    for (var i = 0; i < 6; i++) {
      final x = w * (0.03 + i * 0.16);
      final scale = 0.75 + (i % 3) * 0.12;
      final trunkH = h * 0.055 * scale;
      // trunk
      canvas.drawRect(
          Rect.fromLTWH(x - 2, horizon - trunkH, 4, trunkH), tree);
      // leafy top (above horizon into sky)
      canvas.drawCircle(Offset(x, horizon - trunkH - 2), h * 0.055 * scale, leaf);
    }

    // Flowers along the horizon line
    for (var i = 0; i < 10; i++) {
      final x = w * (0.05 + i * 0.10);
      canvas.drawCircle(Offset(x, horizon + 2), 3, flower);
    }
  }

  // ---------------- roadside scenery (on top of road) ----------------

  void _drawRoadside(
      Canvas canvas, double w, double h, double horizon, _SceneKind k,
      double scroll) {
    switch (k) {
      case _SceneKind.city:
        // Street lamps along both sides of the road
        final lamp = Paint()..color = const Color(0xFF424242);
        final glow = Paint()..color = const Color(0xFFFFCC80);
        for (var i = 0; i < 5; i++) {
          final t = ((i / 5) + scroll * 0.3) % 1.0;
          final x = w * 0.02 + (w * 0.92 * t) % (w * 0.92);
          if (x < w * 0.38 || x > w * 0.62) {
            final y = _lerp(horizon, h, t);
            canvas.drawLine(Offset(x, h), Offset(x, y - 10), lamp..strokeWidth = 2.5);
            canvas.drawCircle(Offset(x, y - 12), 7, glow);
          }
        }
        break;
      case _SceneKind.highway:
        // Guardrail posts along road edges
        final post = Paint()..color = const Color(0xFF455A64);
        for (var i = 0; i < 7; i++) {
          final t = ((i / 7) + scroll * 0.25) % 1.0;
          final edgeX = i % 2 == 0 ? w * 0.38 : w * 0.62;
          final y = _lerp(horizon, h, t);
          canvas.drawRect(
              Rect.fromLTWH(edgeX - 2, y - 14, 4, 14), post);
          // guardrail beam
          if (i > 0) {
            final pt = ((i - 1) / 7 + scroll * 0.25) % 1.0;
            final py = _lerp(horizon, h, pt);
            canvas.drawLine(
                Offset(i % 2 == 0 ? w * 0.38 : w * 0.62, y - 7),
                Offset(i % 2 == 0 ? w * 0.38 : w * 0.62, py - 7),
                post..strokeWidth = 2.5);
          }
        }
        break;
      case _SceneKind.busStop:
        // Sidewalk texture along edges
        final walk = Paint()..color = const Color(0xFF9E9E9E)..strokeWidth = 1.5;
        for (var i = 0; i < w ~/ 18; i++) {
          final x = i * 18.0;
          canvas.drawLine(Offset(x, h), Offset(x + 9, h), walk);
          canvas.drawLine(Offset(w - x, h), Offset(w - x - 9, h), walk);
        }
        break;
      case _SceneKind.airport:
        // Runway edge lights
        final light = Paint()..color = Colors.yellow;
        for (var i = 0; i < 6; i++) {
          final t = ((i / 6) + scroll * 0.3) % 1.0;
          final edgeX = i % 2 == 0 ? w * 0.38 : w * 0.62;
          final y = _lerp(horizon, h, t);
          canvas.drawCircle(Offset(edgeX, y - 5), 4, light);
        }
        break;
      case _SceneKind.bikeLane:
        // Trees + flowers along roadside edges
        final tree = Paint()..color = const Color(0xFF1B5E20);
        final leaf = Paint()..color = const Color(0xFF4CAF50);
        for (var i = 0; i < 6; i++) {
          final t = ((i / 6) + scroll * 0.2) % 1.0;
          final edgeX = i % 2 == 0 ? w * 0.02 : w - w * 0.06;
          final scale = 0.8 + (i % 2) * 0.15;
          final trunkH = h * 0.05 * scale;
          final y = _lerp(horizon, h, t);
          canvas.drawRect(
              Rect.fromLTWH(edgeX - 2, y - trunkH, 4, trunkH), tree);
          canvas.drawCircle(
              Offset(edgeX, y - trunkH - 2), h * 0.045 * scale, leaf);
        }
        break;
    }
  }

  static double _lerp(double a, double b, double t) => a + (b - a) * t;
}
