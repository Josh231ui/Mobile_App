import 'dart:math' as math;
import 'package:flutter/material.dart';

enum Environment { city, highway, track }

class EnvironmentBackground extends StatelessWidget {
  final Environment environment;
  final double distance; // meters traveled so far

  const EnvironmentBackground({
    super.key,
    required this.environment,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CustomPaint(
        painter: _EnvPainter(environment, distance),
        size: Size.infinite,
      ),
    );
  }
}

class _EnvPainter extends CustomPainter {
  final Environment env;
  final double distance;
  _EnvPainter(this.env, this.distance);

  static const double pxPerMeter = 12; // raise for a stronger sense of speed

  double _rand(int k) => ((math.sin(k * 12.9898) * 43758.5453) % 1).abs();

  // Repeats a draw call across the width, scrolling left as offset grows
  void _repeat(Size size, double spacing, double offset,
      void Function(double x, int k) draw) {
    final first = (offset / spacing).floor();
    final shift = offset - first * spacing;
    for (int i = -1; i * spacing - shift < size.width + spacing; i++) {
      draw(i * spacing - shift, first + i);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final off = distance * pxPerMeter;
    final groundY = size.height * 0.72;

    switch (env) {
      case Environment.city:
        _city(canvas, size, off, groundY);
        break;
      case Environment.highway:
        _highway(canvas, size, off, groundY);
        break;
      case Environment.track:
        _track(canvas, size, off, groundY);
        break;
    }
  }

  // ---------- helpers ----------
  void _sky(Canvas c, Size s, Color top, Color bottom) {
    final rect = Offset.zero & s;
    c.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [top, bottom],
        ).createShader(rect),
    );
  }

  void _tree(Canvas c, double x, double baseY, double h) {
    c.drawRect(Rect.fromLTWH(x - 2, baseY - h * 0.35, 4, h * 0.35),
        Paint()..color = const Color(0xFF6D4C41));
    final leaf = Paint()..color = const Color(0xFF2E7D32);
    c.drawCircle(Offset(x, baseY - h * 0.6), h * 0.28, leaf);
    c.drawCircle(Offset(x - h * 0.16, baseY - h * 0.5), h * 0.2, leaf);
    c.drawCircle(Offset(x + h * 0.16, baseY - h * 0.5), h * 0.2, leaf);
  }

  void _railing(Canvas c, Size s, double off, double baseY,
      {Color color = const Color(0xFFB0BEC5), double height = 14}) {
    final rail = Paint()
      ..color = color
      ..strokeWidth = 2;
    c.drawLine(Offset(0, baseY - height), Offset(s.width, baseY - height), rail);
    c.drawLine(
        Offset(0, baseY - height / 2), Offset(s.width, baseY - height / 2), rail);
    _repeat(s, 22, off, (x, k) {
      c.drawRect(Rect.fromLTWH(x - 1.5, baseY - height, 3, height),
          Paint()..color = color);
    });
  }

  void _building(Canvas c, double x, double baseY, double w, double h,
      Color color, bool windows) {
    c.drawRect(Rect.fromLTWH(x, baseY - h, w, h), Paint()..color = color);
    if (!windows) return;
    final win = Paint()..color = const Color(0xFFFFF59D);
    for (double wy = baseY - h + 8; wy < baseY - 12; wy += 14) {
      for (double wx = x + 6; wx < x + w - 8; wx += 12) {
        c.drawRect(Rect.fromLTWH(wx, wy, 6, 8), win);
      }
    }
  }

  void _roadDashes(Canvas c, Size s, double off, double y) {
    _repeat(s, 50, off, (x, k) {
      c.drawRect(Rect.fromLTWH(x, y, 26, 3), Paint()..color = Colors.white70);
    });
  }

  // ---------- environments ----------
  void _city(Canvas c, Size s, double off, double gy) {
    _sky(c, s, const Color(0xFF90CAF9), const Color(0xFFE3F2FD));

    // far buildings (slow)
    _repeat(s, 60, off * 0.3, (x, k) {
      final h = 35 + _rand(k) * 40;
      _building(c, x, gy, 48, h, const Color(0xFF90A4AE), false);
    });
    // near buildings (medium)
    _repeat(s, 80, off * 0.6, (x, k) {
      final h = 45 + _rand(k + 50) * 45;
      _building(c, x, gy, 62, h, const Color(0xFF607D8B), true);
    });

    // sidewalk, trees, railing
    c.drawRect(Rect.fromLTWH(0, gy, s.width, 8),
        Paint()..color = const Color(0xFFCFD8DC));
    _repeat(s, 110, off * 0.9, (x, k) => _tree(c, x, gy + 2, 34));
    _railing(c, s, off, gy + 8);

    // road
    c.drawRect(Rect.fromLTWH(0, gy + 8, s.width, s.height - gy - 8),
        Paint()..color = const Color(0xFF37474F));
    _roadDashes(c, s, off, gy + (s.height - gy) * 0.6);
  }

  void _highway(Canvas c, Size s, double off, double gy) {
    _sky(c, s, const Color(0xFF81D4FA), const Color(0xFFE1F5FE));

    // distant hills
    final hill = Paint()..color = const Color(0xFF81C784);
    final path = Path()..moveTo(0, gy);
    for (double x = 0; x <= s.width; x += 10) {
      path.lineTo(
          x, gy - 18 - 10 * math.sin((x + off * 0.1) / 40));
    }
    path
      ..lineTo(s.width, gy)
      ..close();
    c.drawPath(path, hill);

    // grass strip with trees
    c.drawRect(Rect.fromLTWH(0, gy - 6, s.width, 14),
        Paint()..color = const Color(0xFF66BB6A));
    _repeat(s, 70, off * 0.7, (x, k) => _tree(c, x, gy, 30 + _rand(k) * 14));

    // guardrail (metal, in front of the trees)
    _railing(c, s, off, gy + 10, color: const Color(0xFFCFD8DC), height: 12);

    // asphalt
    c.drawRect(Rect.fromLTWH(0, gy + 10, s.width, s.height - gy - 10),
        Paint()..color = const Color(0xFF455A64));
    _roadDashes(c, s, off, gy + (s.height - gy) * 0.55);
  }

  void _track(Canvas c, Size s, double off, double gy) {
    _sky(c, s, const Color(0xFFB3E5FC), const Color(0xFFF1F8E9));

    // stands / bleachers far back
    _repeat(s, 90, off * 0.25, (x, k) {
      c.drawRect(Rect.fromLTWH(x, gy - 40, 80, 24),
          Paint()..color = const Color(0xFF8D6E63));
      c.drawRect(Rect.fromLTWH(x, gy - 40, 80, 5),
          Paint()..color = const Color(0xFFD7CCC8));
    });

    // grass + trees
    c.drawRect(Rect.fromLTWH(0, gy - 16, s.width, 24),
        Paint()..color = const Color(0xFF7CB342));
    _repeat(s, 95, off * 0.6, (x, k) => _tree(c, x, gy - 4, 32));

    // white railing along the track
    _railing(c, s, off, gy + 6, color: Colors.white, height: 12);

    // red running track with lane lines
    c.drawRect(Rect.fromLTWH(0, gy + 6, s.width, s.height - gy - 6),
        Paint()..color = const Color(0xFFD84315));
    final lane = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5;
    final laneY = gy + (s.height - gy) * 0.55;
    c.drawLine(Offset(0, laneY), Offset(s.width, laneY), lane);
    _repeat(s, 120, off, (x, k) {
      c.drawRect(Rect.fromLTWH(x, gy + 6, 3, s.height - gy - 6),
          Paint()..color = Colors.white70);
    });
  }

  @override
  bool shouldRepaint(_EnvPainter old) =>
      old.distance != distance || old.env != env;
}