import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/session_page_navigation.dart';
import 'individual_challenge_screen.dart';

class LabScreen extends StatefulWidget {
  final int? sessionId;
  const LabScreen({super.key, this.sessionId});

  @override
  State<LabScreen> createState() => _LabScreenState();
}

class _LabScreenState extends State<LabScreen>
    with SingleTickerProviderStateMixin {
  double vi = 0;
  double a = 2;
  double t = 5;
  double vf = 20;
  bool _running = false;
  bool _hasStarted = false;
  bool _calculated = false;
  late final AnimationController _c;

  double get _acceleration =>
      widget.sessionId == 4 || widget.sessionId == 8 ? (vf - vi) / t : a;

  @override
  void initState() {
    super.initState();
    if (widget.sessionId == 4) {
      vi = 5;
      vf = 25;
      t = 4;
    } else if (widget.sessionId == 8) {
      vi = 5;
      vf = 25;
      t = 5;
    }
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
  double get _tStop =>
      _acceleration < 0 ? vi / -_acceleration : double.infinity;

  double _vAt(double time) {
    final v = vi + _acceleration * time;
    return (_acceleration < 0 && v < 0) ? 0.0 : v;
  }

  double _dAt(double time) {
    final te = math.min(time, _tStop);
    return vi * te + 0.5 * _acceleration * te * te;
  }

  void _change(void Function() f) {
    setState(() {
      f();
      _running = false;
      _hasStarted = false;
      _calculated = false;
      _c.stop();
      _c.duration = Duration(milliseconds: (t * 1000).round());
      _c.reset();
    });
  }

  void _start() {
    final s = AppScope.of(context);
    s.simulatorUsed();
    s.click();
    if (_c.value >= 1) _c.reset();
    final animate = s.animation;
    setState(() {
      _running = animate;
      _hasStarted = true;
    });
    if (animate) {
      _c.forward();
    } else {
      _c.value = 1;
    }
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

  void _calculate() {
    AppScope.of(context).click();
    setState(() => _calculated = true);
  }

  Widget _sessionBottomBar({
    required String label,
    required bool enabled,
    required VoidCallback onTap,
  }) =>
      Column(mainAxisSize: MainAxisSize.min, children: [
        SessionContinueBar(label: label, enabled: enabled, onTap: onTap),
        SessionPageNavigationBar(
          sessionId: widget.sessionId!,
          currentPage: SessionPage.explore,
        ),
      ]);

  @override
  Widget build(BuildContext context) {
    if (widget.sessionId == 4) return _buildSessionFourExplore(context);
    if (widget.sessionId == 8) return _buildSessionEightExplore(context);
    final started = _c.value > 0 && _c.value < 1 && !_running;

    return Scaffold(
      appBar: AppBar(
          title: Text(l10n(
              context,
              widget.sessionId == null
                  ? 'Acceleration Lab'
                  : 'Session ${widget.sessionId} Acceleration Lab',
              widget.sessionId == null
                  ? 'Laboratoryo ng Akselerasyon'
                  : 'Sesyon ${widget.sessionId}: Laboratoryo ng Akselerasyon'))),
      bottomNavigationBar: widget.sessionId == null
          ? null
          : _sessionBottomBar(
              label: l10n(context, 'NEXT: QUIZ', 'SUSUNOD: PAGSUSULIT'),
              enabled: _hasStarted,
              onTap: () => go(
                  context,
                  IndividualChallengeScreen(
                      sessionId: widget.sessionId, stageTitle: 'Quiz')),
            ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (widget.sessionId == 1) ...[
            _SessionOneExploreIntro(tagalog: AppScope.of(context).tagalog),
            const SizedBox(height: 12),
          ],
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
                                ? (_acceleration > 0
                                    ? -0.035
                                    : (_acceleration < 0 ? 0.035 : 0.0))
                                : 0.0,
                            spin: d * 10 / 10.5,
                            bounce: moving,
                            vehicle: widget.sessionId == 1
                                ? VehicleType.autoRickshaw
                                : VehicleType.car,
                          ),
                        ),
                      ),
                      if (widget.sessionId == 1)
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 190 * .62 -
                              58 * .55 +
                              (moving ? math.sin(d * 3.5) * 1.2 : 0),
                          child: Center(
                            child: Transform.rotate(
                              angle: moving
                                  ? (_acceleration > 0
                                      ? -0.035
                                      : (_acceleration < 0 ? 0.035 : 0.0))
                                  : 0.0,
                              child: const RickshawIllustration(width: 140),
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
                              'v = ${fmt(v)} m/s    a = ${fmt(_acceleration)} m/s²    t = ${fmt(el)} s',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                      if (widget.sessionId == 1)
                        Positioned(
                          right: 8,
                          bottom: 8,
                          child: _Speedometer(value: v),
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
                if (widget.sessionId == 1) ...[
                  const SizedBox(height: 10),
                  AppCard(
                    padding: const EdgeInsets.all(12),
                    color: C.sky.withValues(alpha: .12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Vf = Vi + a × t',
                            style: TextStyle(
                                color: C.blue,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Wrap(spacing: 12, runSpacing: 4, children: [
                          _output(
                              context,
                              l10n(context, 'Current velocity',
                                  'Kasalukuyang velocity'),
                              '${fmt(v)} m/s'),
                          _output(
                              context,
                              l10n(context, 'Acceleration', 'Akselerasyon'),
                              '${fmt(_acceleration)} m/s²'),
                          _output(context, l10n(context, 'Time', 'Oras'),
                              '${fmt(el)} s'),
                        ]),
                      ],
                    ),
                  ),
                ],
                if (_hasStarted && widget.sessionId != 1) ...[
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
                                acceleration: _acceleration,
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
                                '${fmt(_acceleration)} m/s²'),
                          ]),
                          if (widget.sessionId == 8)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                'a = (vf − vi) / t = (${fmt(vf)} − ${fmt(vi)}) / ${fmt(t)} = ${fmt(_acceleration)} m/s²',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                        ]),
                  ),
                ],
              ]);
            },
          ),
          const SizedBox(height: 16),
          if (widget.sessionId == 1)
            _SessionOneControls(
              vi: vi,
              acceleration: a,
              time: t,
              enabled: !_running,
              onVi: (value) => _change(() => vi = value),
              onAcceleration: (value) => _change(() => a = value),
              onTime: (value) => _change(() => t = value),
            )
          else
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
                if (widget.sessionId == 8)
                  ValueStepper(
                    label: l10n(context, 'Final Velocity', 'Huling Bilis'),
                    value: vf,
                    unit: 'm/s',
                    min: 0,
                    max: 40,
                    enabled: !_running,
                    onChanged: (v) => _change(() => vf = v),
                  )
                else
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
          if (widget.sessionId == 1) ...[
            const SizedBox(height: 12),
            _GuidedQuestions(tagalog: AppScope.of(context).tagalog),
          ],
        ],
      ),
    );
  }

  Widget _buildSessionFourExplore(BuildContext context) {
    final tagalog = AppScope.of(context).tagalog;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            l10n(context, 'Session 4 · Explore', 'Sesyon 4 · Mag-explore')),
      ),
      bottomNavigationBar: _sessionBottomBar(
        label: l10n(context, 'NEXT: QUIZ', 'SUSUNOD: PAGSUSULIT'),
        enabled: _hasStarted,
        onTap: () => go(
            context,
            IndividualChallengeScreen(
                sessionId: widget.sessionId, stageTitle: 'Quiz')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _FormulaExploreBanner(tagalog: tagalog),
          const SizedBox(height: 8),
          Text(
            l10n(
                context,
                'Adjust the values, run the car, and observe how the motion changes.',
                'Baguhin ang mga halaga, paandarin ang kotse, at obserbahan ang pagbabago ng galaw.'),
            textAlign: TextAlign.center,
            style: TextStyle(color: subText(context), fontSize: 12),
          ),
          const SizedBox(height: 8),
          AnimatedBuilder(
            animation: _c,
            builder: (context, _) {
              final elapsed = _c.value * t;
              return _FormulaCarTrack(
                elapsed: elapsed,
                velocity: _vAt(elapsed),
                acceleration: _acceleration,
                distance: _dAt(elapsed),
              );
            },
          ),
          const SizedBox(height: 8),
          LayoutBuilder(builder: (context, constraints) {
            const gap = 6.0;
            final width = (constraints.maxWidth - 2 * gap) / 3;
            return Wrap(spacing: gap, runSpacing: gap, children: [
              _FormulaExploreSlider(
                width: width,
                label: l10n(context, 'Initial velocity (vi)',
                    'Panimulang velocity (vi)'),
                value: vi,
                unit: 'm/s',
                color: C.blue,
                min: 0,
                max: 50,
                enabled: !_running,
                onChanged: (v) => _change(() => vi = v),
              ),
              _FormulaExploreSlider(
                width: width,
                label: l10n(
                    context, 'Final velocity (vf)', 'Panghuling velocity (vf)'),
                value: vf,
                unit: 'm/s',
                color: C.blue,
                min: 0,
                max: 50,
                enabled: !_running,
                onChanged: (v) => _change(() => vf = v),
              ),
              _FormulaExploreSlider(
                width: width,
                label: l10n(context, 'Time (t)', 'Oras (t)'),
                value: t,
                unit: 's',
                color: C.blue,
                min: 1,
                max: 20,
                enabled: !_running,
                onChanged: (v) => _change(() => t = v),
              ),
            ]);
          }),
          const SizedBox(height: 8),
          LayoutBuilder(builder: (context, constraints) {
            const gap = 6.0;
            final width = (constraints.maxWidth - 2 * gap) / 3;
            return Row(children: [
              SizedBox(
                  width: width,
                  child: _formulaActionButton(
                    label: l10n(
                        context,
                        _running
                            ? 'RUNNING'
                            : (_hasStarted ? 'RESUME' : 'RUN SIMULATION'),
                        _running
                            ? 'TUMATAKBO'
                            : (_hasStarted ? 'IPAGPATULOY' : 'SIMULAHIN')),
                    icon: Icons.play_arrow_rounded,
                    color: C.green,
                    onPressed: _running ? null : _start,
                  )),
              const SizedBox(width: gap),
              SizedBox(
                  width: width,
                  child: _formulaActionButton(
                    label: l10n(context, 'RESET CAR', 'I-RESET ANG KOTSE'),
                    icon: Icons.refresh_rounded,
                    color: C.blue,
                    onPressed: _reset,
                  )),
              const SizedBox(width: gap),
              SizedBox(
                  width: width,
                  child: _formulaActionButton(
                    label: l10n(context, 'CALCULATE', 'KUWENTAHIN'),
                    icon: Icons.calculate_rounded,
                    color: C.yellow,
                    foreground: C.navy,
                    onPressed: _calculate,
                  )),
            ]);
          }),
          const SizedBox(height: 8),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              flex: 6,
              child: _FormulaResultCard(
                title: l10n(context, 'Formula', 'Pormula'),
                color: C.yellow,
                body: 'a = (vf − vi) ÷ t',
                detail: _calculated
                    ? 'a = (${fmt(vf)} − ${fmt(vi)}) ÷ ${fmt(t)}'
                    : l10n(context, 'Change in velocity ÷ time',
                        'Pagbabago ng velocity ÷ oras'),
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              flex: 4,
              child: _FormulaResultCard(
                title: l10n(context, 'Acceleration', 'Akselerasyon'),
                color: C.green,
                body: '${fmt(_acceleration)} m/s²',
                detail: _calculated
                    ? l10n(context, 'Calculated result', 'Kinalkulang sagot')
                    : l10n(
                        context, 'Press Calculate', 'Pindutin ang Kuwentahin'),
              ),
            ),
          ]),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: C.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              l10n(context, 'HOW TO PLAY', 'PAANO GAMITIN'),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 7),
          LayoutBuilder(builder: (context, constraints) {
            final columns = constraints.maxWidth >= 600 ? 4 : 2;
            const gap = 6.0;
            final width =
                (constraints.maxWidth - (columns - 1) * gap) / columns;
            return Wrap(spacing: gap, runSpacing: gap, children: [
              _HowToPlayTile(
                  width: width,
                  number: '1',
                  title: l10n(context, 'Set values', 'Itakda ang values'),
                  text: l10n(
                      context,
                      'Choose initial and final velocity, then time.',
                      'Piliin ang simula at huling velocity, saka ang oras.')),
              _HowToPlayTile(
                  width: width,
                  number: '2',
                  title: l10n(context, 'Run simulation', 'Patakbuhin'),
                  text: l10n(
                      context,
                      'Tap Run Simulation to watch the car move.',
                      'Pindutin ang Simulahin upang makita ang kotse.')),
              _HowToPlayTile(
                  width: width,
                  number: '3',
                  title: l10n(context, 'Calculate', 'Kuwentahin'),
                  text: l10n(context, 'Use Calculate to find the acceleration.',
                      'Pindutin ang Kuwentahin upang malaman ang akselerasyon.')),
              _HowToPlayTile(
                  width: width,
                  number: '4',
                  title:
                      l10n(context, 'Try different values', 'Subukan ang iba'),
                  text: l10n(
                      context,
                      'Change values and observe how motion changes.',
                      'Baguhin ang values at obserbahan ang galaw.')),
            ]);
          }),
        ],
      ),
    );
  }

  Widget _buildSessionEightExplore(BuildContext context) {
    final tagalog = AppScope.of(context).tagalog;
    final simulationComplete =
        _hasStarted && _c.status == AnimationStatus.completed;
    return Scaffold(
      appBar: AppBar(
          title: Text(
              l10n(context, 'Session 8 · Explore', 'Sesyon 8 · Mag-explore'))),
      bottomNavigationBar: _sessionBottomBar(
        label: l10n(context, 'NEXT: PRACTICE', 'SUSUNOD: PAGSASANAY'),
        enabled: _hasStarted,
        onTap: () => go(context, const SessionEightPracticeScreen()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _AccelerationGraphExploreBanner(tagalog: tagalog),
          const SizedBox(height: 7),
          Text(
            l10n(
                context,
                'Change the values and watch how velocity, acceleration, and the graph change.',
                'Baguhin ang values at panoorin ang pagbabago ng velocity, akselerasyon, at graph.'),
            textAlign: TextAlign.center,
            style: TextStyle(color: subText(context), fontSize: 11),
          ),
          const SizedBox(height: 8),
          LayoutBuilder(builder: (context, constraints) {
            final inputWidth = (constraints.maxWidth - 8) * .43;
            final trackWidth = constraints.maxWidth - inputWidth - 8;
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                width: inputWidth,
                child: AppCard(
                  padding: const EdgeInsets.all(7),
                  color: C.blue.withValues(alpha: .08),
                  child: Column(children: [
                    _SessionEightInput(
                      label: l10n(
                          context, 'Initial velocity', 'Panimulang velocity'),
                      value: vi,
                      unit: 'm/s',
                      min: 0,
                      max: 100000,
                      color: C.green,
                      enabled: !_running,
                      onChanged: (value) => _change(() => vi = value),
                    ),
                    _SessionEightInput(
                      label: l10n(
                          context, 'Final velocity', 'Panghuling velocity'),
                      value: vf,
                      unit: 'm/s',
                      min: 0,
                      max: 100000,
                      color: C.red,
                      enabled: !_running,
                      onChanged: (value) => _change(() => vf = value),
                    ),
                    _SessionEightInput(
                      label: l10n(context, 'Time', 'Oras'),
                      value: t,
                      unit: 's',
                      min: 1,
                      max: 3600,
                      color: C.orange,
                      enabled: !_running,
                      onChanged: (value) => _change(() => t = value),
                    ),
                  ]),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: trackWidth,
                child: AnimatedBuilder(
                  animation: _c,
                  builder: (context, _) => Column(children: [
                    _SessionEightMotionTrack(
                      label: l10n(
                          context, 'Initial velocity', 'Panimulang velocity'),
                      value: vi,
                      tint: C.red,
                      progress: _c.value * .45,
                    ),
                    const SizedBox(height: 7),
                    _SessionEightMotionTrack(
                      label: l10n(
                          context, 'Final velocity', 'Panghuling velocity'),
                      value: _hasStarted ? _vAt(_c.value * t) : vf,
                      tint: C.red,
                      progress: _c.value,
                    ),
                  ]),
                ),
              ),
            ]);
          }),
          const SizedBox(height: 8),
          LayoutBuilder(builder: (context, constraints) {
            const gap = 7.0;
            final width = (constraints.maxWidth - 2 * gap) / 3;
            return Row(children: [
              SizedBox(
                  width: width,
                  child: _formulaActionButton(
                    label: l10n(context, _running ? 'RUNNING' : 'RUN',
                        _running ? 'TUMATAKBO' : 'SIMULAHIN'),
                    icon: Icons.play_arrow_rounded,
                    color: C.green,
                    onPressed: _running ? null : _start,
                  )),
              const SizedBox(width: gap),
              SizedBox(
                  width: width,
                  child: _formulaActionButton(
                    label: l10n(context, 'PAUSE', 'I-PAUSE'),
                    icon: Icons.pause_rounded,
                    color: C.blue,
                    onPressed: _running ? _pause : null,
                  )),
              const SizedBox(width: gap),
              SizedBox(
                  width: width,
                  child: _formulaActionButton(
                    label: l10n(context, 'RESET', 'I-RESET'),
                    icon: Icons.refresh_rounded,
                    color: C.red,
                    onPressed: _reset,
                  )),
            ]);
          }),
          const SizedBox(height: 8),
          AppCard(
            padding: const EdgeInsets.all(11),
            color: C.yellow.withValues(alpha: .13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    l10n(context, 'EXAMPLE CALCULATION',
                        'HALIMBAWANG PAGKUWENTA'),
                    style: const TextStyle(
                        color: C.navy,
                        fontSize: 12,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 5),
                Text('a = (vf − vi) ÷ t',
                    style: const TextStyle(
                        color: C.navy,
                        fontSize: 16,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                const Text('Δv = 20 − 15 = 5 m/s',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700)),
                const Text('a = 5 ÷ 10 = 0.5 m/s²',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          if (simulationComplete) ...[
            const SizedBox(height: 8),
            AppCard(
              padding: const EdgeInsets.all(10),
              color: C.green.withValues(alpha: .1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.fact_check_rounded,
                        color: C.green, size: 19),
                    const SizedBox(width: 6),
                    Text(l10n(context, 'RESULTS', 'MGA RESULTA'),
                        style: const TextStyle(
                            color: C.green,
                            fontSize: 13,
                            fontWeight: FontWeight.w900)),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(
                      child: _output(
                        context,
                        l10n(context, 'Acceleration', 'Akselerasyon'),
                        '${fmt(_acceleration)} m/s²',
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _output(
                        context,
                        l10n(context, 'Direction', 'Direksiyon'),
                        l10n(context, 'Forward', 'Pasulong'),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ],
          const SizedBox(height: 8),
          AppCard(
            padding: const EdgeInsets.all(10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.show_chart_rounded, color: C.purple, size: 20),
                const SizedBox(width: 6),
                Expanded(
                    child: Text(
                        l10n(context, 'Velocity–Time Graph',
                            'Graph ng Velocity–Time'),
                        style: const TextStyle(
                            fontWeight: FontWeight.w900, color: C.purple))),
              ]),
              SizedBox(
                height: 180,
                width: double.infinity,
                child: AnimatedBuilder(
                  animation: _c,
                  builder: (context, _) => CustomPaint(
                    painter: LabGraphPainter(
                      initialVelocity: vi,
                      acceleration: _acceleration,
                      duration: t,
                      elapsed: _hasStarted ? _c.value * t : t,
                      velocityAt: _vAt,
                      dark: isDark(context),
                    ),
                  ),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 8),
          AppCard(
            padding: const EdgeInsets.all(11),
            color: C.orange.withValues(alpha: .1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.lightbulb_rounded,
                      color: C.orange, size: 19),
                  const SizedBox(width: 6),
                  Text(l10n(context, 'WHAT TO DISCOVER', 'TUKLASIN'),
                      style: const TextStyle(
                          color: C.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.w900)),
                ]),
                const SizedBox(height: 6),
                _ExploreNote(
                    text: l10n(
                  context,
                  'Adjust the three values and observe how the car and graph change. A greater velocity change in the same time means greater acceleration; the same change over more time means smaller acceleration.',
                  'Baguhin ang tatlong value at obserbahan ang kotse at graph. Mas malaking pagbabago ng velocity sa parehong oras ay nangangahulugan ng mas malaking akselerasyon; kung mas matagal ang parehong pagbabago, mas maliit ang akselerasyon.',
                )),
                _ExploreNote(
                    text: l10n(
                  context,
                  'Try increasing, decreasing, and constant velocity. Compare the calculation with the graph: acceleration is the slope of a velocity–time graph.',
                  'Subukan ang tumataas, bumababa, at hindi nagbabagong velocity. Ihambing ang kuwenta sa graph: ang akselerasyon ang slope ng velocity–time graph.',
                )),
                _ExploreNote(
                    text: l10n(
                  context,
                  'A change in direction is also acceleration, even when speed stays constant.',
                  'Akselerasyon din ang pagbabago ng direksiyon kahit hindi nagbabago ang bilis.',
                )),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _formulaActionButton(
          {required String label,
          required IconData icon,
          required Color color,
          Color foreground = Colors.white,
          required VoidCallback? onPressed}) =>
      FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: foreground,
          minimumSize: const Size(0, 42),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        icon: Icon(icon, size: 17),
        label: Text(label,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 10, fontWeight: FontWeight.w900)),
      );

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

class _MasteryProblem {
  final String title, prompt;
  final double initialVelocity, finalVelocity, seconds, answer;
  final Color color;
  final VehicleType vehicle;

  const _MasteryProblem({
    required this.title,
    required this.prompt,
    required this.initialVelocity,
    required this.finalVelocity,
    required this.seconds,
    required this.answer,
    required this.color,
    required this.vehicle,
  });
}

class SessionEightPracticeScreen extends StatefulWidget {
  const SessionEightPracticeScreen({super.key});

  @override
  State<SessionEightPracticeScreen> createState() =>
      _SessionEightPracticeScreenState();
}

class _SessionEightPracticeScreenState
    extends State<SessionEightPracticeScreen> {
  static const _problems = <_MasteryProblem>[
    _MasteryProblem(
      title: 'Car speeding up',
      prompt: 'A car changes from 5 m/s to 20 m/s in 5 seconds.',
      initialVelocity: 5,
      finalVelocity: 20,
      seconds: 5,
      answer: 3,
      color: C.red,
      vehicle: VehicleType.car,
    ),
    _MasteryProblem(
      title: 'Motorcycle slowing down',
      prompt: 'A motorcycle changes from 30 m/s to 10 m/s in 4 seconds.',
      initialVelocity: 30,
      finalVelocity: 10,
      seconds: 4,
      answer: -5,
      color: C.blue,
      vehicle: VehicleType.motorcycle,
    ),
    _MasteryProblem(
      title: 'Constant velocity',
      prompt: 'A bicycle moves at a constant velocity of 10 m/s.',
      initialVelocity: 10,
      finalVelocity: 10,
      seconds: 1,
      answer: 0,
      color: C.green,
      vehicle: VehicleType.bicycle,
    ),
    _MasteryProblem(
      title: 'Airplane taking off',
      prompt: 'An airplane changes from 0 m/s to 70 m/s in 10 seconds.',
      initialVelocity: 0,
      finalVelocity: 70,
      seconds: 10,
      answer: 7,
      color: C.purple,
      vehicle: VehicleType.airplane,
    ),
    _MasteryProblem(
      title: 'Bus slowing down',
      prompt: 'A bus changes from 25 m/s to 5 m/s in 4 seconds.',
      initialVelocity: 25,
      finalVelocity: 5,
      seconds: 4,
      answer: -5,
      color: C.orange,
      vehicle: VehicleType.bus,
    ),
  ];

  late final _solutions =
      List.generate(_problems.length, (_) => TextEditingController());
  late final _answers =
      List.generate(_problems.length, (_) => TextEditingController());
  final List<bool?> _correct = List<bool?>.filled(_problems.length, null);

  @override
  void dispose() {
    for (final controller in [..._solutions, ..._answers]) {
      controller.dispose();
    }
    super.dispose();
  }

  void _check(int index) {
    final solution = _solutions[index].text.trim();
    final answer = double.tryParse(_answers[index].text.trim());
    setState(() {
      _correct[index] = solution.isNotEmpty &&
          answer != null &&
          (answer - _problems[index].answer).abs() < .01;
    });
    AppScope.of(context).click();
  }

  @override
  Widget build(BuildContext context) {
    final allCorrect = _correct.every((answer) => answer == true);
    return Scaffold(
      appBar: AppBar(
        title: Text(
            l10n(context, 'Session 8 · Practice', 'Sesyon 8 · Pagsasanay')),
      ),
      bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min, children: [
        SessionContinueBar(
          label: l10n(context, 'NEXT: QUIZ', 'SUSUNOD: PAGSUSULIT'),
          enabled: allCorrect,
          onTap: () => go(
            context,
            IndividualChallengeScreen(sessionId: 8, stageTitle: 'Quiz'),
          ),
        ),
        const SessionPageNavigationBar(
          sessionId: 8,
          currentPage: SessionPage.practice,
        ),
      ]),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 11),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xff0755ce), Color(0xff168df0)]),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(children: [
              const Icon(Icons.assignment_rounded, color: C.yellow, size: 23),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  l10n(context, 'PRACTICE: ACCELERATION MASTERY',
                      'PAGSASANAY: PAGIGING DALUBHASA SA AKSELERASYON'),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 5),
          Text(
            l10n(
                context,
                'Solve each problem. Show your steps and enter the final answer with its unit.',
                'Sagutan ang bawat problema. Ipakita ang mga hakbang at ilagay ang huling sagot kasama ang yunit.'),
            textAlign: TextAlign.center,
            style: TextStyle(color: subText(context), fontSize: 11),
          ),
          const SizedBox(height: 7),
          for (var i = 0; i < _problems.length; i++) ...[
            _buildProblem(context, i, _problems[i]),
            if (i < _problems.length - 1) const SizedBox(height: 7),
          ],
        ],
      ),
    );
  }

  Widget _buildProblem(
      BuildContext context, int index, _MasteryProblem problem) {
    final feedback = _correct[index];
    final dark = isDark(context);
    return AppCard(
      padding: const EdgeInsets.all(9),
      color: problem.color.withValues(alpha: .07),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: problem.color,
            child: Text('${index + 1}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w900)),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(problem.title,
                style: TextStyle(
                    color: problem.color,
                    fontSize: 12,
                    fontWeight: FontWeight.w900)),
          ),
          VehicleWidget(
            type: problem.vehicle,
            width: problem.vehicle == VehicleType.motorcycle ? 68 : 54,
            color: problem.color,
          ),
        ]),
        const SizedBox(height: 4),
        Text(problem.prompt,
            style: const TextStyle(fontSize: 12, height: 1.25)),
        const SizedBox(height: 7),
        TextField(
          controller: _solutions[index],
          cursorColor: C.blue,
          style: TextStyle(color: dark ? C.navy : null),
          minLines: 1,
          maxLines: 2,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            isDense: true,
            labelText: l10n(context, 'Solution', 'Solusyon'),
            hintText: 'a = (vf − vi) ÷ t',
            labelStyle: TextStyle(color: dark ? C.navy : null),
            floatingLabelStyle: TextStyle(color: dark ? C.navy : null),
            hintStyle: TextStyle(color: dark ? const Color(0xff64748b) : null),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide:
                    BorderSide(color: problem.color.withValues(alpha: .4))),
          ),
        ),
        const SizedBox(height: 6),
        Row(children: [
          Expanded(
            child: TextField(
              controller: _answers[index],
              cursorColor: C.blue,
              style: TextStyle(color: dark ? C.navy : null),
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true, signed: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]')),
              ],
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                isDense: true,
                labelText: l10n(context, 'Final answer', 'Huling sagot'),
                suffixText: 'm/s²',
                labelStyle: TextStyle(color: dark ? C.navy : null),
                floatingLabelStyle: TextStyle(color: dark ? C.navy : null),
                suffixStyle: TextStyle(color: dark ? C.navy : null),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide:
                        BorderSide(color: problem.color.withValues(alpha: .4))),
              ),
              onChanged: (_) {
                if (_correct[index] != null) {
                  setState(() => _correct[index] = null);
                }
              },
            ),
          ),
          const SizedBox(width: 7),
          FilledButton(
            onPressed: () => _check(index),
            style: FilledButton.styleFrom(
                backgroundColor: problem.color,
                minimumSize: const Size(0, 42),
                padding: const EdgeInsets.symmetric(horizontal: 10)),
            child: Text(l10n(context, 'CHECK', 'SURIIN'),
                style:
                    const TextStyle(fontSize: 10, fontWeight: FontWeight.w900)),
          ),
        ]),
        if (feedback != null) ...[
          const SizedBox(height: 5),
          Row(children: [
            Icon(feedback ? Icons.check_circle : Icons.cancel,
                color: feedback ? C.green : C.red, size: 17),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                feedback
                    ? l10n(context, 'Correct!', 'Tama!')
                    : l10n(
                        context,
                        'Not quite. Use a = (vf − vi) ÷ t and include your steps.',
                        'Hindi pa. Gamitin ang a = (vf − vi) ÷ t at ilagay ang mga hakbang.'),
                style: TextStyle(
                    color: feedback ? C.green : C.red,
                    fontSize: 11,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ]),
        ],
      ]),
    );
  }
}

class _FormulaExploreBanner extends StatelessWidget {
  final bool tagalog;
  const _FormulaExploreBanner({required this.tagalog});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xff0755ce), Color(0xff168df0)]),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(children: [
          const Icon(Icons.travel_explore_rounded,
              color: Colors.white, size: 23),
          const SizedBox(width: 6),
          Text(tagalog ? 'MAG-EXPLORE:' : 'EXPLORE:',
              style: const TextStyle(
                  color: C.yellow, fontSize: 16, fontWeight: FontWeight.w900)),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              tagalog
                  ? 'SIMULATOR NG PORMULA NG AKSELERASYON'
                  : 'ACCELERATION FORMULA SIMULATOR',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w900),
            ),
          ),
        ]),
      );
}

class _AccelerationGraphExploreBanner extends StatelessWidget {
  final bool tagalog;
  const _AccelerationGraphExploreBanner({required this.tagalog});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 9),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xff0755ce), Color(0xff168df0)]),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(children: [
          const Icon(Icons.travel_explore_rounded,
              color: Colors.white, size: 26),
          const SizedBox(width: 7),
          Text(tagalog ? 'MAG-EXPLORE:' : 'EXPLORE:',
              style: const TextStyle(
                  color: C.yellow, fontSize: 16, fontWeight: FontWeight.w900)),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              tagalog ? 'LABORATORYO NG AKSELERASYON' : 'ACCELERATION LAB',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w900),
            ),
          ),
        ]),
      );
}

class _ExploreNote extends StatelessWidget {
  final String text;
  const _ExploreNote({required this.text});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(Icons.circle, color: C.orange, size: 6),
          ),
          const SizedBox(width: 7),
          Expanded(
            child:
                Text(text, style: const TextStyle(fontSize: 11, height: 1.3)),
          ),
        ]),
      );
}

class _SessionEightInput extends StatefulWidget {
  final String label, unit;
  final double value, min, max;
  final Color color;
  final bool enabled;
  final ValueChanged<double> onChanged;
  const _SessionEightInput({
    required this.label,
    required this.value,
    required this.unit,
    required this.min,
    required this.max,
    required this.color,
    required this.enabled,
    required this.onChanged,
  });

  @override
  State<_SessionEightInput> createState() => _SessionEightInputState();
}

class _SessionEightInputState extends State<_SessionEightInput> {
  late final TextEditingController _controller =
      TextEditingController(text: fmt(widget.value));
  late final FocusNode _focusNode = FocusNode();

  void _commit(String text) {
    final parsed = double.tryParse(text.trim());
    if (parsed != null &&
        parsed.isFinite &&
        parsed >= widget.min &&
        parsed <= widget.max) {
      widget.onChanged(parsed);
      _controller.text = fmt(parsed);
    } else {
      _controller.text = fmt(widget.value);
    }
    _focusNode.unfocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(Icons.edit_rounded, color: widget.color, size: 14),
            const SizedBox(width: 3),
            Expanded(
              child: Text(widget.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: widget.color,
                      fontSize: 9,
                      fontWeight: FontWeight.w900)),
            ),
          ]),
          const SizedBox(height: 3),
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            enabled: widget.enabled,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            decoration: InputDecoration(
              isDense: true,
              suffixText: widget.unit,
              suffixStyle: const TextStyle(fontSize: 9),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide:
                      BorderSide(color: widget.color.withValues(alpha: .4))),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide:
                      BorderSide(color: widget.color.withValues(alpha: .4))),
            ),
            onChanged: (text) {
              final parsed = double.tryParse(text.trim());
              if (parsed != null &&
                  parsed.isFinite &&
                  parsed >= widget.min &&
                  parsed <= widget.max) {
                widget.onChanged(parsed);
              }
            },
            onSubmitted: _commit,
            onEditingComplete: () => _commit(_controller.text),
          ),
        ]),
      );
}

class _SessionEightMotionTrack extends StatelessWidget {
  final String label;
  final double value, progress;
  final Color tint;
  const _SessionEightMotionTrack({
    required this.label,
    required this.value,
    required this.tint,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 105,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: LayoutBuilder(builder: (context, constraints) {
            const carWidth = 62.0;
            final travel = math.max(0.0, constraints.maxWidth - carWidth - 12);
            return Stack(children: [
              const Positioned.fill(
                  child: CustomPaint(painter: _ExploreTrackPainter())),
              Positioned(
                left: 6 + travel * progress.clamp(0.0, 1.0),
                bottom: 7,
                child: Transform.translate(
                  offset: Offset(0, -2 * math.sin(progress * math.pi * 8)),
                  child: const CarWidget(width: carWidth, color: C.red),
                ),
              ),
              Positioned(
                left: 5,
                top: 5,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .92),
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(label,
                      style: TextStyle(
                          color: tint,
                          fontSize: 8,
                          fontWeight: FontWeight.w900)),
                ),
              ),
              Positioned(
                right: 5,
                top: 5,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .92),
                      borderRadius: BorderRadius.circular(8)),
                  child: Text('${fmt(value)} m/s',
                      style: const TextStyle(
                          color: C.navy,
                          fontSize: 9,
                          fontWeight: FontWeight.w900)),
                ),
              ),
            ]);
          }),
        ),
      );
}

class _ExploreTrackPainter extends CustomPainter {
  const _ExploreTrackPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final sky = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(
        sky,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff8bd1f5), Color(0xffe7f6ff)],
          ).createShader(sky));
    final roadTop = size.height * .62;
    canvas.drawRect(
        Rect.fromLTWH(0, roadTop, size.width, size.height - roadTop),
        Paint()..color = const Color(0xff3a4655));
    canvas.drawLine(
        Offset(0, roadTop),
        Offset(size.width, roadTop),
        Paint()
          ..color = const Color(0xfff7f3d8)
          ..strokeWidth = 2);
    final dash = Paint()
      ..color = Colors.white.withValues(alpha: .85)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final centerY = roadTop + (size.height - roadTop) * .7;
    for (var x = 5.0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, centerY), Offset(x + 12, centerY), dash);
    }
    final greenery = Paint()..color = const Color(0xff75c78a);
    canvas.drawOval(
        Rect.fromLTWH(-size.width * .12, roadTop - 20, size.width * .55, 40),
        greenery);
    canvas.drawOval(
        Rect.fromLTWH(size.width * .56, roadTop - 20, size.width * .6, 40),
        greenery);
  }

  @override
  bool shouldRepaint(covariant _ExploreTrackPainter oldDelegate) => false;
}

class _FormulaCarTrack extends StatelessWidget {
  final double elapsed;
  final double velocity;
  final double acceleration;
  final double distance;
  const _FormulaCarTrack(
      {required this.elapsed,
      required this.velocity,
      required this.acceleration,
      required this.distance});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 116,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(children: [
            Positioned.fill(
              child: CustomPaint(
                painter: RoadPainter(
                  offset: distance * 8,
                  tilt: acceleration > 0
                      ? -.025
                      : acceleration < 0
                          ? .025
                          : 0,
                  spin: distance * .7,
                  bounce: velocity > 0 && elapsed > 0,
                  vehicle: VehicleType.car,
                ),
              ),
            ),
            Positioned(
              top: 7,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                    color: C.navy.withValues(alpha: .9),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  '${l10n(context, 'Time', 'Oras')}: ${fmt(elapsed)} s',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ),
            Positioned(
              left: 8,
              bottom: 5,
              child: Text(
                '${fmt(velocity)} m/s',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    shadows: [Shadow(color: Colors.black, blurRadius: 4)]),
              ),
            ),
          ]),
        ),
      );
}

class _FormulaExploreSlider extends StatelessWidget {
  final double width;
  final String label;
  final double value;
  final String unit;
  final Color color;
  final double min;
  final double max;
  final bool enabled;
  final ValueChanged<double> onChanged;
  const _FormulaExploreSlider(
      {required this.width,
      required this.label,
      required this.value,
      required this.unit,
      required this.color,
      required this.min,
      required this.max,
      required this.enabled,
      required this.onChanged});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        child: AppCard(
          padding: const EdgeInsets.fromLTRB(6, 7, 6, 5),
          color: color.withValues(alpha: .1),
          child: Column(children: [
            Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: color, fontSize: 9, fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                constraints: const BoxConstraints(minWidth: 34),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6)),
                child: Text(fmt(value),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, fontSize: 12)),
              ),
              const SizedBox(width: 3),
              Text(unit,
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.w700)),
            ]),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: color,
                thumbColor: color,
                trackHeight: 3,
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              ),
              child: Slider(
                value: value.clamp(min, max).toDouble(),
                min: min,
                max: max,
                divisions: (max - min).round(),
                onChanged: enabled ? onChanged : null,
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(fmt(min),
                  style: TextStyle(color: subText(context), fontSize: 8)),
              Text(fmt(max),
                  style: TextStyle(color: subText(context), fontSize: 8)),
            ]),
          ]),
        ),
      );
}

class _FormulaResultCard extends StatelessWidget {
  final String title;
  final Color color;
  final String body;
  final String detail;
  const _FormulaResultCard(
      {required this.title,
      required this.color,
      required this.body,
      required this.detail});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: color.withValues(alpha: .16),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: .65))),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: color == C.yellow ? C.navy : color,
                  fontSize: 11,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 3),
          FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(body,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w900))),
          const SizedBox(height: 2),
          Text(detail,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: subText(context), fontSize: 9)),
        ]),
      );
}

class _HowToPlayTile extends StatelessWidget {
  final double width;
  final String number;
  final String title;
  final String text;
  const _HowToPlayTile(
      {required this.width,
      required this.number,
      required this.title,
      required this.text});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        child: AppCard(
          padding: const EdgeInsets.all(8),
          color: const Color(0xffeef8ff),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              CircleAvatar(
                  radius: 11,
                  backgroundColor: C.blue,
                  child: Text(number,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w900))),
              const SizedBox(width: 5),
              Expanded(
                  child: Text(title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w900))),
            ]),
            const SizedBox(height: 5),
            Text(text, style: const TextStyle(fontSize: 9, height: 1.25)),
          ]),
        ),
      );
}

class _SessionOneExploreIntro extends StatelessWidget {
  final bool tagalog;
  const _SessionOneExploreIntro({required this.tagalog});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
                color: C.blue, borderRadius: BorderRadius.circular(14)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.science_rounded, color: Colors.white, size: 17),
              const SizedBox(width: 6),
              Text(l10n(context, 'EXPLORE', 'MAG-EXPLORE'),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ]),
          ),
          const SizedBox(height: 8),
          Text(
              l10n(context, 'Acceleration Simulator',
                  'Simulator ng Akselerasyon'),
              style:
                  const TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
          const SizedBox(height: 3),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
                child: Text(
                    l10n(
                        context,
                        'Adjust the values and watch how the auto rickshaw moves as its velocity changes.',
                        'Baguhin ang mga value at panoorin ang auto-rickshaw habang nagbabago ang velocity nito.'),
                    style: TextStyle(color: subText(context), height: 1.3))),
            const SizedBox(width: 8),
            Container(
              width: 116,
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                  color: C.yellow.withValues(alpha: .18),
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n(context, 'Try this!', 'Subukan!'),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 3),
                    Text(
                        l10n(
                            context,
                            'Increase acceleration, set it to zero, then try a negative value.',
                            'Lakihan ang akselerasyon, gawin itong zero, at subukan ang negatibong value.'),
                        style: const TextStyle(fontSize: 10, height: 1.25)),
                  ]),
            ),
          ]),
        ],
      );
}

class _SessionOneControls extends StatelessWidget {
  final double vi;
  final double acceleration;
  final double time;
  final bool enabled;
  final ValueChanged<double> onVi;
  final ValueChanged<double> onAcceleration;
  final ValueChanged<double> onTime;
  const _SessionOneControls({
    required this.vi,
    required this.acceleration,
    required this.time,
    required this.enabled,
    required this.onVi,
    required this.onAcceleration,
    required this.onTime,
  });

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final width = (constraints.maxWidth - 16) / 3;
          return Wrap(spacing: 8, children: [
            _LabControlTile(
                width: width,
                label: 'vi',
                unit: 'm/s',
                value: vi,
                color: C.blue,
                enabled: enabled,
                min: 0,
                max: 30,
                onChanged: onVi),
            _LabControlTile(
                width: width,
                label: 'a',
                unit: 'm/s²',
                value: acceleration,
                color: C.purple,
                enabled: enabled,
                min: -10,
                max: 10,
                onChanged: onAcceleration),
            _LabControlTile(
                width: width,
                label: 't',
                unit: 's',
                value: time,
                color: C.green,
                enabled: enabled,
                min: 1,
                max: 20,
                onChanged: onTime),
          ]);
        },
      );
}

class _LabControlTile extends StatelessWidget {
  final double width;
  final String label;
  final String unit;
  final double value;
  final Color color;
  final bool enabled;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  const _LabControlTile({
    required this.width,
    required this.label,
    required this.unit,
    required this.value,
    required this.color,
    required this.enabled,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        child: AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          color: color.withValues(alpha: .1),
          child: Column(children: [
            Text('$label (${unit})',
                maxLines: 1,
                style: TextStyle(
                    color: color, fontSize: 11, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('${fmt(value)} $unit',
                maxLines: 1,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                onPressed: enabled && value > min
                    ? () => onChanged((value - 1).clamp(min, max).toDouble())
                    : null,
                icon: const Icon(Icons.remove_circle_outline, size: 18),
                color: color,
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                onPressed: enabled && value < max
                    ? () => onChanged((value + 1).clamp(min, max).toDouble())
                    : null,
                icon: const Icon(Icons.add_circle_outline, size: 18),
                color: color,
              ),
            ]),
          ]),
        ),
      );
}

class _Speedometer extends StatelessWidget {
  final double value;
  const _Speedometer({required this.value});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 82,
        height: 82,
        child: Stack(alignment: Alignment.center, children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: clamp01(value / 30),
              strokeWidth: 6,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(C.green),
            ),
          ),
          Container(
            width: 68,
            height: 68,
            decoration: const BoxDecoration(
                color: Color(0xff13243e), shape: BoxShape.circle),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('${fmt(value)} m/s',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
              const Text('VELOCITY',
                  style: TextStyle(color: Colors.white70, fontSize: 8)),
            ]),
          ),
        ]),
      );
}

class _GuidedQuestions extends StatelessWidget {
  final bool tagalog;
  const _GuidedQuestions({required this.tagalog});

  @override
  Widget build(BuildContext context) {
    final items = tagalog
        ? const [
            (
              'Ano ang mangyayari kapag tumaas ang akselerasyon?',
              'Mas mabilis na tumataas ang velocity bawat segundo.'
            ),
            (
              'Ano ang mangyayari kapag zero ang akselerasyon?',
              'Mananatiling pareho ang velocity.'
            ),
            (
              'Ano ang ipinapakita ng negatibong akselerasyon?',
              'Bumababa ang velocity sa positibong direksiyon; mahalaga pa rin ang direksiyon ng galaw.'
            ),
            (
              'Paano nagbabago ang velocity ng auto-rickshaw?',
              'Nagbabago ito ayon sa panimulang velocity, akselerasyon, at oras: vf = vi + a × t.'
            ),
          ]
        : const [
            (
              'What happens when acceleration increases?',
              'Velocity changes more each second.'
            ),
            (
              'What happens when acceleration is zero?',
              'Velocity stays constant.'
            ),
            (
              'What does negative acceleration show?',
              'Velocity decreases in the positive direction; motion direction still matters.'
            ),
            (
              'How does the auto rickshaw velocity change?',
              'It depends on initial velocity, acceleration, and time: vf = vi + a × t.'
            ),
          ];
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 8, 5, 2),
          child: Text(
              l10n(context, 'GUIDED EXPLORATION QUESTIONS',
                  'MGA GABAY NA TANONG'),
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        for (final item in items)
          Material(
            color: Colors.transparent,
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 4),
              childrenPadding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
              title: Text(item.$1, style: const TextStyle(fontSize: 13)),
              children: [
                Text(item.$2, style: TextStyle(color: subText(context)))
              ],
            ),
          ),
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
  final VehicleType vehicle;
  RoadPainter({
    required this.offset,
    required this.tilt,
    required this.spin,
    required this.bounce,
    this.vehicle = VehicleType.car,
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
    if (vehicle != VehicleType.autoRickshaw) {
      paintVehicle(canvas, rect, vehicle, spin: spin, color: C.red);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(RoadPainter old) => true;
}
