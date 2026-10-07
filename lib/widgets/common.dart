import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme.dart';

double clamp01(double v) => v < 0 ? 0.0 : (v > 1 ? 1.0 : v);

const Map<String, String> _tagalogUi = {
  'Learn': 'Matuto',
  'Explore': 'Mag-explore',
  'Practice': 'Magsanay',
  'Challenge': 'Hamon',
  'Difficulty': 'Antas',
  'Progress': 'Pag-unlad',
  'Learn Topics': 'Mga Paksa sa Pag-aaral',
  'Explore Topics': 'Tuklasin',
  'Settings': 'Mga Setting',
  'Review': 'Balikan',
  'Difficulties': 'Mga Antas',
  'Choose a Difficulty': 'Pumili ng Antas',
  'My Progress': 'Aking Pag-unlad',
  'Current Difficulty': 'Kasalukuyang Antas',
  'Difficulty Levels': 'Mga Antas ng Kahirapan',
  'Learning Progress': 'Pag-unlad sa Pag-aaral',
  'Lessons': 'Mga Aralin',
  'Problems solved': 'Mga Nalutas na Problema',
  'You are here': 'Nandito ka',
  'Complete all topics to unlock this difficulty.':
      'Tapusin ang lahat ng paksa upang mabuksan ang antas na ito.',
  'Acceleration Lab': 'Laboratoryo ng Akselerasyon',
  'What Happens If…?': 'Ano ang Mangyayari Kung…?',
  'Simulate a moving car': 'Gayahin ang galaw ng kotse',
  'Change acceleration and compare': 'Baguhin at paghambingin ang akselerasyon',
  'Solve acceleration problems': 'Lutasin ang mga problema sa akselerasyon',
  'Experiment with motion': 'Magsagawa ng eksperimento sa galaw',
  'Acceleration topics get more challenging at each level.':
      'Mas nagiging mahirap ang mga paksa sa bawat antas.',
  'Locked': 'Naka-lock',
  'Complete': 'Tapusin',
  'Finish': 'Tapusin',
  'Learn. Move. Accelerate!\n\nAn offline app for learning acceleration. Everything, including your progress, is stored on this device.':
      'Matuto. Gumalaw. Bumilis!\n\nIsang offline na app para matutuhan ang akselerasyon. Naka-save sa device na ito ang lahat, pati ang iyong pag-unlad.',
  'GO BACK': 'BUMALIK',
  'MARKED AS COMPLETE': 'NAKUMPLETO NA',
  'MARK AS COMPLETE': 'MARKAHAN BILANG TAPOS',
  'CONTINUE →': 'IPAGPATULOY →',
  'NEXT →': 'SUSUNOD →',
  'FINISH': 'TAPUSIN',
  'REVIEW': 'BALIKAN',
  'CHECK ANSWER': 'SURIIN ANG SAGOT',
  'NEXT PROBLEM →': 'SUSUNOD NA PROBLEMA →',
  'TRY AGAIN': 'SUBUKAN MULI',
  'REVIEW LESSON': 'BALIKAN ANG ARALIN',
  'BACK TO HOME': 'BUMALIK SA PANGUNAHING PAHINA',
  'Correct!': 'Tama!',
  'Not quite.': 'Hindi pa tama.',
  'Your Answer:': 'Iyong Sagot:',
  'Initial Velocity': 'Panimulang Bilis',
  'Acceleration': 'Akselerasyon',
  'Time': 'Oras',
  'Final Velocity': 'Huling Bilis',
  'Distance Traveled': 'Nilakbay na Distansiya',
  'Velocity vs Time': 'Bilis at Oras',
  'Pause': 'I-pause',
  'Reset': 'I-reset',
  'Problems solved:': 'Mga nalutas na problema:',
  'Acceleration Challenge': 'Hamon sa Akselerasyon',
  'CHALLENGE': 'HAMON',
  'Choose Game Mode:': 'Pumili ng Uri ng Laro:',
  'INDIVIDUAL': 'INDIBIDWAL',
  'Play on your own device': 'Maglaro sa sarili mong device',
  'PAIR': 'MAGKAPAREHA',
  'Share one device': 'Magbahagi sa isang device',
  'CLASSROOM': 'SILID-ARALAN',
  'Teacher projects the game\nTeams answer using cards':
      'Ipapakita ng guro ang laro\nSasagot ang mga grupo gamit ang card',
  'Player 1': 'Manlalaro 1',
  'Player 2': 'Manlalaro 2',
  'Team': 'Grupo',
  'PLAY AGAIN': 'MAGLARO MULI',
  'BACK TO MODES': 'BUMALIK SA MGA URI',
  'REVEAL ANSWER': 'IPAKITA ANG SAGOT',
  'SEE RESULTS': 'TINGNAN ANG RESULTA',
  'FINISH SESSION': 'TAPUSIN ANG SESYON',
  'Question': 'Tanong',
  'Quiz Result': 'Resulta ng Pagsusulit',
  'Score:': 'Iskor:',
  'Recommended Review:': 'Inirerekomendang Balikan:',
  'No review needed. You got every question right!':
      'Hindi na kailangang magbalik-aral. Tama ang lahat ng sagot mo!',
  'Type your answer as a number first.': 'Ilagay muna ang sagot bilang numero.',
  'Hint: use the formula  a = (vf − vi) / t':
      'Pahiwatig: gamitin ang pormulang a = (vf − vi) / t',
  'Sound': 'Tunog',
  'Animation': 'Animasyon',
  'Dark Mode': 'Madilim na Tema',
  'Text Size': 'Laki ng Teksto',
  'Small': 'Maliit',
  'Medium': 'Katamtaman',
  'Large': 'Malaki',
  'Reset Progress': 'I-reset ang Pag-unlad',
  'Reset progress?': 'I-reset ang pag-unlad?',
  'Cancel': 'Kanselahin',
  'About AccelLab': 'Tungkol sa AccelLab',
  'Language': 'Wika',
  'Choose a vehicle': 'Pumili ng sasakyan',
};

String l10n(BuildContext context, String english, [String? tagalog]) {
  if (!AppScope.of(context).tagalog) return english;
  return tagalog ?? _tagalogUi[english] ?? english;
}

class LanguageSwitchButton extends StatelessWidget {
  final AppState state;
  const LanguageSwitchButton({super.key, required this.state});

  @override
  Widget build(BuildContext context) => TextButton.icon(
        onPressed: () => state.setTagalog(!state.tagalog),
        icon: const Icon(Icons.translate_rounded),
        label: Text(state.tagalog ? 'English' : 'Tagalog'),
      );
}

String fmt(double v) =>
    v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

// ---------------- navigation ----------------
Route<T> appRoute<T>(BuildContext context, Widget page) {
  final anim = AppScope.of(context).animation;
  return PageRouteBuilder<T>(
    transitionDuration:
        anim ? const Duration(milliseconds: 380) : Duration.zero,
    reverseTransitionDuration:
        anim ? const Duration(milliseconds: 260) : Duration.zero,
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, a, __, child) {
      final curved = CurvedAnimation(parent: a, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position:
              Tween<Offset>(begin: const Offset(0.12, 0), end: Offset.zero)
                  .animate(curved),
          child: child,
        ),
      );
    },
  );
}

void go(BuildContext context, Widget page) {
  Navigator.of(context).push(appRoute<void>(context, page));
}

void goReplace(BuildContext context, Widget page) {
  Navigator.of(context).pushReplacement(appRoute<void>(context, page));
}

// ---------------- basic widgets ----------------
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color? color;
  final VoidCallback? onTap;
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final box = Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? cardColor(context),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
    if (onTap == null) return box;
    return GestureDetector(onTap: onTap, child: box);
  }
}

// Fades and slides a widget in. Use `index` to stagger a list of items.
class Reveal extends StatelessWidget {
  final int index;
  final Widget child;
  const Reveal({super.key, this.index = 0, required this.child});

  @override
  Widget build(BuildContext context) {
    if (!AppScope.of(context).animation) return child;
    final total = 380 + index * 90;
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: total),
      curve: Interval(index * 90 / total, 1, curve: Curves.easeOutCubic),
      builder: (_, v, ch) => Opacity(
        opacity: v,
        child: Transform.translate(offset: Offset(0, 26 * (1 - v)), child: ch),
      ),
      child: child,
    );
  }
}

class AnimatedBar extends StatelessWidget {
  final double value;
  final Color color;
  final double height;
  const AnimatedBar(
      {super.key, required this.value, this.color = C.green, this.height = 10});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: clamp01(value)),
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
        builder: (_, v, __) => LinearProgressIndicator(
          value: v,
          minHeight: height,
          color: color,
          backgroundColor: color.withValues(alpha: 0.18),
        ),
      ),
    );
  }
}

class PageHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> actions;
  const PageHeader(this.title,
      {super.key, this.subtitle, this.actions = const []});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(children: [
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            if (subtitle != null)
              Text(subtitle!, style: TextStyle(color: subText(context))),
          ]),
        ),
        ...actions,
      ]),
    );
  }
}

class BigButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color color;
  final IconData? icon;
  const BigButton(this.label,
      {super.key, this.onTap, this.color = C.blue, this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          disabledBackgroundColor: color.withValues(alpha: 0.35),
          disabledForegroundColor: Colors.white70,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: onTap,
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        ]),
      ),
    );
  }
}

class ValueStepper extends StatelessWidget {
  final String label;
  final double value;
  final String unit;
  final double min;
  final double max;
  final double step;
  final bool enabled;
  final ValueChanged<double> onChanged;
  const ValueStepper({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.min,
    required this.max,
    required this.onChanged,
    this.step = 1,
    this.enabled = true,
  });

  Widget _btn(IconData icon, bool on, VoidCallback cb) {
    return Material(
      color: on ? C.blue : Colors.grey.shade400,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: on ? cb : null,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: subText(context))),
        const SizedBox(height: 6),
        Row(children: [
          _btn(Icons.remove, enabled && value - step >= min - 1e-9,
              () => onChanged(value - step)),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: C.blue.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('${fmt(value)} $unit',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          _btn(Icons.add, enabled && value + step <= max + 1e-9,
              () => onChanged(value + step)),
        ]),
      ]),
    );
  }
}

// ---------------- 2D vehicle illustrations ----------------
enum VehicleType { car, bicycle, bus, train }

void _paintWheel(Canvas canvas, Offset c, double radius, {double spin = 0}) {
  canvas.drawCircle(c, radius, Paint()..color = const Color(0xFF1F2733));
  canvas.drawCircle(c, radius * 0.5, Paint()..color = const Color(0xFFC3CCD9));
  final spoke = Paint()
    ..color = const Color(0xFF6B778A)
    ..strokeWidth = radius * 0.14;
  final d = Offset(math.cos(spin), math.sin(spin)) * (radius * 0.62);
  canvas.drawLine(c - d, c + d, spoke);
  final e = Offset(-d.dy, d.dx);
  canvas.drawLine(c - e, c + e, spoke);
}

void paintCar(Canvas canvas, Rect r, Color color, {double spin = 0}) {
  final w = r.width, h = r.height;
  Offset p(double fx, double fy) => Offset(r.left + w * fx, r.top + h * fy);

  final fill = Paint()..color = color;
  final shade = Paint()..color = Color.lerp(color, Colors.black, 0.25)!;
  final glass = Paint()..color = const Color(0xFFCDE9FF);

  canvas.drawPath(
    Path()
      ..addPolygon(
          [p(0.2, 0.45), p(0.32, 0.08), p(0.68, 0.08), p(0.84, 0.45)], true),
    fill,
  );
  canvas.drawRRect(
    RRect.fromRectAndRadius(
        Rect.fromLTWH(r.left, r.top + h * 0.38, w, h * 0.44),
        Radius.circular(h * 0.18)),
    fill,
  );
  canvas.drawRRect(
    RRect.fromRectAndRadius(
        Rect.fromLTWH(r.left, r.top + h * 0.66, w, h * 0.16),
        Radius.circular(h * 0.08)),
    shade,
  );
  canvas.drawPath(
      Path()
        ..addPolygon(
            [p(0.27, 0.4), p(0.36, 0.16), p(0.49, 0.16), p(0.49, 0.4)], true),
      glass);
  canvas.drawPath(
      Path()
        ..addPolygon(
            [p(0.53, 0.4), p(0.53, 0.16), p(0.66, 0.16), p(0.76, 0.4)], true),
      glass);

  for (final fx in [0.25, 0.75]) {
    _paintWheel(canvas, p(fx, 0.82), h * 0.18, spin: spin);
  }
  canvas.drawCircle(
      p(0.965, 0.52), h * 0.05, Paint()..color = const Color(0xFFFFF0A8));
  canvas.drawCircle(
      p(0.03, 0.52), h * 0.04, Paint()..color = const Color(0xFFFF6B5E));
}

void paintBicycle(Canvas canvas, Rect r, {double spin = 0}) {
  final w = r.width, h = r.height;
  Offset p(double fx, double fy) => Offset(r.left + w * fx, r.top + h * fy);

  final frame = Paint()
    ..color = C.teal
    ..strokeWidth = h * 0.06
    ..strokeCap = StrokeCap.round;
  final seat = Paint()..color = const Color(0xFF2F3640);
  final handle = Paint()
    ..color = const Color(0xFF5C6778)
    ..strokeWidth = h * 0.05
    ..strokeCap = StrokeCap.round;

  _paintWheel(canvas, p(0.28, 0.78), h * 0.22, spin: spin);
  _paintWheel(canvas, p(0.72, 0.78), h * 0.22, spin: spin);

  canvas.drawLine(p(0.28, 0.78), p(0.52, 0.38), frame);
  canvas.drawLine(p(0.72, 0.78), p(0.52, 0.38), frame);
  canvas.drawLine(p(0.28, 0.78), p(0.72, 0.78), frame);
  canvas.drawLine(p(0.52, 0.38), p(0.62, 0.22), frame);
  canvas.drawLine(p(0.62, 0.22), p(0.78, 0.28), handle);
  canvas.drawLine(p(0.78, 0.28), p(0.82, 0.18), handle);
  canvas.drawRRect(
    RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: p(0.48, 0.30), width: w * 0.14, height: h * 0.06),
        Radius.circular(h * 0.03)),
    seat,
  );
  canvas.drawCircle(p(0.52, 0.38), h * 0.04, Paint()..color = C.orange);
}

void paintBus(Canvas canvas, Rect r, {double spin = 0}) {
  final w = r.width, h = r.height;
  Offset p(double fx, double fy) => Offset(r.left + w * fx, r.top + h * fy);

  final body = Paint()..color = C.yellow;
  final shade = Paint()..color = const Color(0xFFD99A2B);
  final glass = Paint()..color = const Color(0xFFCDE9FF);
  final trim = Paint()..color = const Color(0xFF2F3640);

  canvas.drawRRect(
    RRect.fromRectAndRadius(
        Rect.fromLTWH(r.left + w * 0.04, r.top + h * 0.18, w * 0.92, h * 0.52),
        Radius.circular(h * 0.08)),
    body,
  );
  canvas.drawRRect(
    RRect.fromRectAndRadius(
        Rect.fromLTWH(r.left + w * 0.04, r.top + h * 0.62, w * 0.92, h * 0.12),
        Radius.circular(h * 0.04)),
    shade,
  );
  for (final fx in [0.18, 0.34, 0.50, 0.66, 0.82]) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: p(fx, 0.38), width: w * 0.11, height: h * 0.22),
          Radius.circular(h * 0.03)),
      glass,
    );
  }
  trim.strokeWidth = h * 0.04;
  canvas.drawLine(p(0.04, 0.52), p(0.96, 0.52), trim);
  _paintWheel(canvas, p(0.22, 0.82), h * 0.16, spin: spin);
  _paintWheel(canvas, p(0.78, 0.82), h * 0.16, spin: spin);
  canvas.drawCircle(
      p(0.94, 0.48), h * 0.04, Paint()..color = const Color(0xFFFFF0A8));
}

void paintTrain(Canvas canvas, Rect r, {double spin = 0}) {
  final w = r.width, h = r.height;
  Offset p(double fx, double fy) => Offset(r.left + w * fx, r.top + h * fy);

  final body = Paint()..color = C.blue;
  final cab = Paint()..color = const Color(0xFF1565C0);
  final glass = Paint()..color = const Color(0xFFCDE9FF);
  final stack = Paint()..color = const Color(0xFF37474F);
  final stripe = Paint()..color = C.red;

  canvas.drawRRect(
    RRect.fromRectAndRadius(
        Rect.fromLTWH(r.left + w * 0.08, r.top + h * 0.28, w * 0.84, h * 0.42),
        Radius.circular(h * 0.06)),
    body,
  );
  canvas.drawPath(
    Path()
      ..moveTo(p(0.08, 0.70).dx, p(0.08, 0.70).dy)
      ..lineTo(p(0.22, 0.22).dx, p(0.22, 0.22).dy)
      ..lineTo(p(0.42, 0.28).dx, p(0.42, 0.28).dy)
      ..lineTo(p(0.42, 0.70).dx, p(0.42, 0.70).dy)
      ..close(),
    cab,
  );
  canvas.drawRRect(
    RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: p(0.28, 0.40), width: w * 0.10, height: h * 0.18),
        Radius.circular(h * 0.02)),
    glass,
  );
  canvas.drawRect(
      Rect.fromCenter(center: p(0.18, 0.18), width: w * 0.06, height: h * 0.16),
      stack);
  canvas.drawRect(
      Rect.fromLTWH(r.left + w * 0.46, r.top + h * 0.48, w * 0.40, h * 0.06),
      stripe);
  for (final fx in [0.58, 0.72, 0.86]) {
    _paintWheel(canvas, p(fx, 0.84), h * 0.10, spin: spin);
  }
}

void paintVehicle(Canvas canvas, Rect r, VehicleType type,
    {double spin = 0, Color? color}) {
  switch (type) {
    case VehicleType.car:
      paintCar(canvas, r, color ?? C.red, spin: spin);
    case VehicleType.bicycle:
      paintBicycle(canvas, r, spin: spin);
    case VehicleType.bus:
      paintBus(canvas, r, spin: spin);
    case VehicleType.train:
      paintTrain(canvas, r, spin: spin);
  }
}

class VehicleWidget extends StatelessWidget {
  final VehicleType type;
  final double width;
  final double spin;
  final Color? color;

  const VehicleWidget({
    super.key,
    required this.type,
    this.width = 64,
    this.spin = 0,
    this.color,
  });

  double get _aspectRatio {
    switch (type) {
      case VehicleType.bicycle:
        return 0.62;
      case VehicleType.bus:
        return 0.36;
      case VehicleType.train:
        return 0.44;
      default:
        return 0.42;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, width * _aspectRatio),
      painter: _VehiclePainter(type: type, spin: spin, color: color),
    );
  }
}

class _VehiclePainter extends CustomPainter {
  final VehicleType type;
  final double spin;
  final Color? color;

  _VehiclePainter({required this.type, required this.spin, this.color});

  @override
  void paint(Canvas canvas, Size size) =>
      paintVehicle(canvas, Offset.zero & size, type, spin: spin, color: color);

  @override
  bool shouldRepaint(_VehiclePainter old) =>
      old.type != type || old.spin != spin || old.color != color;
}

class CarWidget extends StatelessWidget {
  final double width;
  final Color color;
  const CarWidget({super.key, this.width = 120, this.color = C.red});

  @override
  Widget build(BuildContext context) {
    return VehicleWidget(type: VehicleType.car, width: width, color: color);
  }
}
