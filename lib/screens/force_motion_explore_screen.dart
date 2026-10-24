import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/environment_background.dart';
import '../widgets/session_page_navigation.dart';
import 'individual_challenge_screen.dart';

/// Session 2 explores how direction and net force change velocity.
/// Session 3 focuses on Newton's Second Law and the mass/force relationship.
class ForceMotionExploreScreen extends StatefulWidget {
  final int sessionId;
  const ForceMotionExploreScreen({super.key, required this.sessionId});

  @override
  State<ForceMotionExploreScreen> createState() =>
      _ForceMotionExploreScreenState();
}

class _ForceMotionExploreScreenState extends State<ForceMotionExploreScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  double velocity = 8;
  double force = 4;
  double mass = 4;
  double time = 5;
  double _leftForce = 40;
  double _rightForce = 100;
  String direction = 'East';
  bool _hasRun = false;

  bool get _forces => widget.sessionId == 3;
  double get acceleration => force / mass;
  double get netForce => _rightForce - _leftForce;
  double get forceAcceleration => netForce / mass;
  String get forceDirection => netForce > 0.01
      ? 'Right'
      : netForce < -0.01
          ? 'Left'
          : 'Balanced';
  double get finalVelocity =>
      math.max(0, velocity + acceleration * time).toDouble();

  @override
  void initState() {
    super.initState();
    if (widget.sessionId == 3) mass = 500;
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _run() {
    final state = AppScope.of(context);
    state.simulatorUsed();
    state.click();
    setState(() => _hasRun = true);
    if (state.animation) {
      _controller.forward(from: 0);
    } else {
      _controller.value = 1;
    }
  }

  void _startForceSimulation() {
    final state = AppScope.of(context);
    state.simulatorUsed();
    state.click();
    setState(() => _hasRun = true);
    if (state.animation) {
      _controller.forward(from: _controller.value >= 1 ? 0 : null);
    } else {
      _controller.value = 1;
    }
  }

  void _pauseForceSimulation() {
    _controller.stop();
    AppScope.of(context).click();
    setState(() {});
  }

  void _resetForceSimulation() {
    _controller.stop();
    _controller.value = 0;
    setState(() {
      _leftForce = 40;
      _rightForce = 100;
      mass = 500;
      _hasRun = false;
    });
    AppScope.of(context).click();
  }

  void _setForceScenario(int index) {
    const scenarios = <(double, double, double)>[
      (40, 160, 500),
      (40, 100, 800),
      (100, 100, 500),
      (160, 100, 500),
    ];
    final scenario = scenarios[index];
    _controller.stop();
    _controller.value = 0;
    setState(() {
      _leftForce = scenario.$1;
      _rightForce = scenario.$2;
      mass = scenario.$3;
    });
    AppScope.of(context).click();
  }

  @override
  Widget build(BuildContext context) {
    if (_forces) return _buildForceExplore(context);
    if (widget.sessionId == 2) return _buildSessionTwoExplore(context);
    final tagalog = AppScope.of(context).tagalog;
    final vehicle = _forces ? VehicleType.car : VehicleType.bus;
    return Scaffold(
      appBar: AppBar(
        title: Text(_forces
            ? l10n(
                context, 'Net Force Explorer', 'Paggalugad sa Netong Puwersa')
            : l10n(context, 'Tagbina Motion Explorer',
                'Paggalugad sa Galaw sa Tagbina')),
      ),
      bottomNavigationBar: _sessionBottomBar(
        context,
        label: l10n(context, 'NEXT: QUIZ', 'SUSUNOD: PAGSUSULIT'),
        enabled: _hasRun,
        onTap: () => go(
            context,
            IndividualChallengeScreen(
                sessionId: widget.sessionId, stageTitle: 'Quiz')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            _forces
                ? l10n(
                    context,
                    'Change force and mass. Watch how the net force changes acceleration.',
                    'Baguhin ang puwersa at masa. Pansinin kung paano naaapektuhan ng netong puwersa ang akselerasyon.')
                : l10n(
                    context,
                    'Adjust speed, direction, net force, and time to explore a Bachelor Tours bus journey.',
                    'Baguhin ang speed, direksiyon, netong puwersa, at oras upang siyasatin ang biyahe ng Bachelor Tours bus.'),
            style: TextStyle(color: subText(context), height: 1.4),
          ),
          const SizedBox(height: 12),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final progress = Curves.easeInOut.transform(_controller.value);
              final v = velocity + (finalVelocity - velocity) * progress;
              return AppCard(
                child: Column(children: [
                  SizedBox(
                    height: 150,
                    child: LayoutBuilder(builder: (context, box) {
                      final x = 12 + (box.maxWidth - 92) * progress;
                      return Stack(children: [
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: const Color(0xFFE3F2FD),
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 24,
                          height: 36,
                          child: Container(color: const Color(0xFF374151)),
                        ),
                        Positioned(
                          left: x,
                          bottom: 28,
                          child: VehicleWidget(
                              type: vehicle, width: 76, spin: progress * 18),
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Text(
                            '${fmt(v)} m/s  ${_arrow(direction)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Positioned(
                          bottom: 4,
                          right: 8,
                          child: Text(
                              tagalog ? 'Kalsada sa Tagbina' : 'Tagbina road',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 11)),
                        ),
                      ]);
                    }),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 6,
                    children: [
                      _result(
                          context,
                          l10n(context, 'Acceleration', 'Akselerasyon'),
                          '${fmt(acceleration)} m/s²'),
                      _result(
                          context,
                          l10n(context, 'Final velocity', 'Huling velocity'),
                          '${fmt(finalVelocity)} m/s'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'vf = vi + at = ${fmt(velocity)} + (${fmt(acceleration)} × ${fmt(time)}) = ${fmt(finalVelocity)} m/s',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ]),
              );
            },
          ),
          if (!_forces) ...[
            const SizedBox(height: 10),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => _sessionTwoGraph(
                context,
                tagalog,
                Curves.easeInOut.transform(_controller.value),
              ),
            ),
          ],
          const SizedBox(height: 12),
          if (!_forces) ...[
            _slider(
                context,
                l10n(context, 'Starting speed', 'Panimulang speed'),
                velocity,
                0,
                30,
                'm/s',
                (v) => setState(() => velocity = v)),
            Text(l10n(context, 'Direction', 'Direksiyon'),
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Wrap(spacing: 8, children: [
              for (final d in ['West', 'North', 'East', 'South'])
                ChoiceChip(
                    label: Text(_directionLabel(d, tagalog)),
                    selected: direction == d,
                    onSelected: (_) => setState(() => direction = d))
            ]),
          ] else ...[
            _slider(context, l10n(context, 'Mass', 'Masa'), mass, 1, 20, 'kg',
                (v) => setState(() => mass = v)),
          ],
          _slider(context, l10n(context, 'Net force', 'Netong puwersa'), force,
              -10, 10, 'N', (v) => setState(() => force = v)),
          _slider(context, l10n(context, 'Time', 'Oras'), time, 0, 10, 's',
              (v) => setState(() => time = v)),
          const SizedBox(height: 8),
          BigButton(l10n(context, 'RUN SIMULATION', 'SIMULAHIN'),
              onTap: _run, color: C.green),
        ],
      ),
    );
  }

  Widget _sessionBottomBar(BuildContext context,
          {required String label,
          required bool enabled,
          required VoidCallback onTap}) =>
      Column(mainAxisSize: MainAxisSize.min, children: [
        SessionContinueBar(label: label, enabled: enabled, onTap: onTap),
        SessionPageNavigationBar(
            sessionId: widget.sessionId, currentPage: SessionPage.explore),
      ]);

  Widget _buildSessionTwoExplore(BuildContext context) {
    final tagalog = AppScope.of(context).tagalog;
    final motionLabel = acceleration > 0.05
        ? l10n(context, 'ACCELERATING', 'BUMIBILIS')
        : acceleration < -0.05
            ? l10n(context, 'SLOWING DOWN', 'BUMABAGAL')
            : l10n(context, 'CONSTANT SPEED', 'PARE-PAREHONG BILIS');
    final motionColor = acceleration > 0.05
        ? C.green
        : acceleration < -0.05
            ? C.orange
            : C.blue;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n(context, 'Session 2 · Explore', 'Sesyon 2 · Explore')),
      ),
      bottomNavigationBar: _sessionBottomBar(
        context,
        label: l10n(context, 'NEXT: QUIZ', 'SUSUNOD: PAGSUSULIT'),
        enabled: _hasRun,
        onTap: () => go(
          context,
          IndividualChallengeScreen(
              sessionId: widget.sessionId, stageTitle: 'Quiz'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xff0754cb), Color(0xff168df0)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.explore_rounded,
                    color: Colors.white, size: 22),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    l10n(context, 'EXPLORE: How Does Motion Change?',
                        'EXPLORE: Paano Nagbabago ang Galaw?'),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                const Icon(Icons.lightbulb_rounded, color: C.yellow),
              ]),
              const SizedBox(height: 5),
              Text(
                l10n(
                    context,
                    'Adjust the controls, then watch the Bachelor Express bus respond.',
                    'Baguhin ang controls at panoorin ang tugon ng Bachelor Express bus.'),
                style: const TextStyle(
                    color: Colors.white, fontSize: 12, height: 1.25),
              ),
            ]),
          ),
          const SizedBox(height: 9),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final progress = Curves.easeInOut.transform(_controller.value);
              final speed =
                  math.max(0.0, velocity + acceleration * time * progress);
              return AppCard(
                padding: const EdgeInsets.all(7),
                child: Column(children: [
                  SizedBox(
                    height: 166,
                    child: LayoutBuilder(builder: (context, box) {
                      final maxLeft = math.max(0.0, box.maxWidth - 146);
                      final left = 8 + maxLeft * progress;
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(children: [
                          Positioned.fill(
                            child: EnvironmentBackground(
                              environment: Environment.highway,
                              distance: progress * speed * time,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 9, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: .9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${fmt(speed)} m/s  ${_arrow(direction)}',
                                style: const TextStyle(
                                    color: C.navy,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 12),
                              ),
                            ),
                          ),
                          Positioned(
                            left: left,
                            bottom: 8,
                            child: Transform.rotate(
                              angle: math.sin(progress * math.pi * 2) * .012,
                              child: const _BachelorExpressBus(),
                            ),
                          ),
                          Positioned(
                            right: 8,
                            bottom: 5,
                            child: Text(
                              tagalog ? 'Kalsada sa Tagbina' : 'Tagbina road',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  shadows: [Shadow(blurRadius: 4)]),
                            ),
                          ),
                        ]),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(
                      child: _transportButton(
                        context,
                        label: l10n(context, 'START', 'SIMULAHIN'),
                        icon: Icons.play_arrow_rounded,
                        color: C.green,
                        onTap: _run,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: _transportButton(
                        context,
                        label: l10n(context, 'PAUSE', 'I-PAUSE'),
                        icon: Icons.pause_rounded,
                        color: C.blue,
                        onTap: _pauseForceSimulation,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: _transportButton(
                        context,
                        label: l10n(context, 'RESET', 'I-RESET'),
                        icon: Icons.refresh_rounded,
                        color: C.red,
                        onTap: _resetSessionTwo,
                      ),
                    ),
                  ]),
                ]),
              );
            },
          ),
          const SizedBox(height: 9),
          LayoutBuilder(builder: (context, constraints) {
            final columns = constraints.maxWidth >= 620 ? 4 : 2;
            const gap = 7.0;
            final width =
                (constraints.maxWidth - gap * (columns - 1)) / columns;
            final panels = <Widget>[
              _motionControlCard(
                context,
                title: l10n(context, 'SPEED', 'BILIS'),
                icon: Icons.speed_rounded,
                color: C.blue,
                value: '${fmt(velocity)} m/s',
                child: Slider(
                  value: velocity,
                  min: 0,
                  max: 30,
                  divisions: 60,
                  onChanged: (value) => setState(() => velocity = value),
                ),
              ),
              _motionControlCard(
                context,
                title: l10n(context, 'DIRECTION', 'DIREKSIYON'),
                icon: Icons.explore_rounded,
                color: C.teal,
                value: _directionLabel(direction, tagalog),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 3,
                  runSpacing: 1,
                  children: [
                    for (final item in [
                      ('West', Icons.arrow_back_rounded),
                      ('North', Icons.arrow_upward_rounded),
                      ('East', Icons.arrow_forward_rounded),
                      ('South', Icons.arrow_downward_rounded),
                    ])
                      _directionButton(context, item.$1, item.$2, tagalog),
                  ],
                ),
              ),
              _motionControlCard(
                context,
                title: l10n(context, 'NET FORCE', 'NETONG PUWERSA'),
                icon: Icons.bolt_rounded,
                color: C.purple,
                value: '${fmt(force)} N',
                child: Column(children: [
                  Slider(
                    value: force,
                    min: -10,
                    max: 10,
                    divisions: 40,
                    onChanged: (value) => setState(() => force = value),
                  ),
                  Text(
                    l10n(context, 'Positive speeds up · Negative slows down',
                        'Positibo: bumibilis · Negatibo: bumabagal'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: subText(context), fontSize: 9, height: 1.1),
                  ),
                ]),
              ),
              _motionControlCard(
                context,
                title: l10n(context, 'TIME', 'ORAS'),
                icon: Icons.timer_rounded,
                color: C.green,
                value: '${fmt(time)} s',
                child: Slider(
                  value: time,
                  min: 0,
                  max: 10,
                  divisions: 20,
                  onChanged: (value) => setState(() => time = value),
                ),
              ),
            ];
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final panel in panels) SizedBox(width: width, child: panel)
              ],
            );
          }),
          const SizedBox(height: 9),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final liveSpeed = math.max(
                0.0,
                velocity +
                    acceleration *
                        time *
                        Curves.easeInOut.transform(_controller.value),
              );
              return AppCard(
                padding: const EdgeInsets.all(12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.analytics_rounded, color: C.blue),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            l10n(context, 'REAL-TIME INFORMATION',
                                'IMPORMASYON NG GALAW'),
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9, vertical: 5),
                          decoration: BoxDecoration(
                            color: motionColor,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(motionLabel,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900)),
                        ),
                      ]),
                      const Divider(height: 15),
                      _motionInfoRow(context, l10n(context, 'Speed', 'Bilis'),
                          '${fmt(liveSpeed)} m/s'),
                      _motionInfoRow(
                          context,
                          l10n(context, 'Direction', 'Direksiyon'),
                          _directionLabel(direction, tagalog)),
                      _motionInfoRow(
                          context,
                          l10n(context, 'Velocity', 'Velocity'),
                          '${fmt(liveSpeed)} m/s ${_directionLabel(direction, tagalog)}'),
                      _motionInfoRow(
                          context,
                          l10n(context, 'Acceleration', 'Akselerasyon'),
                          '${fmt(acceleration)} m/s²'),
                      _motionInfoRow(
                          context,
                          l10n(context, 'Net Force', 'Netong Puwersa'),
                          '${fmt(force)} N'),
                      const SizedBox(height: 7),
                      Text(
                        l10n(
                            context,
                            'a = Fnet ÷ m = ${fmt(force)} N ÷ ${fmt(mass)} kg = ${fmt(acceleration)} m/s². After ${fmt(time)} s, the bus reaches ${fmt(finalVelocity)} m/s.',
                            'a = Fnet ÷ m = ${fmt(force)} N ÷ ${fmt(mass)} kg = ${fmt(acceleration)} m/s². Pagkalipas ng ${fmt(time)} s, aabot ang bus sa ${fmt(finalVelocity)} m/s.'),
                        style: TextStyle(
                            color: subText(context), fontSize: 11, height: 1.3),
                      ),
                    ]),
              );
            },
          ),
          const SizedBox(height: 8),
          Text(
            l10n(
                context,
                'Explore! Change the values and watch how the Bachelor Express bus responds.',
                'Mag-explore! Baguhin ang values at panoorin ang tugon ng Bachelor Express bus.'),
            textAlign: TextAlign.center,
            style: TextStyle(color: subText(context), fontSize: 11),
          ),
        ],
      ),
    );
  }

  void _resetSessionTwo() {
    _controller.stop();
    _controller.value = 0;
    setState(() {
      velocity = 8;
      force = 4;
      mass = 4;
      time = 5;
      direction = 'East';
      _hasRun = false;
    });
    AppScope.of(context).click();
  }

  Widget _motionControlCard(BuildContext context,
          {required String title,
          required IconData icon,
          required Color color,
          required String value,
          required Widget child}) =>
      AppCard(
        padding: const EdgeInsets.fromLTRB(9, 8, 9, 4),
        color: color.withValues(alpha: .09),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Icon(icon, color: color, size: 17),
            const SizedBox(width: 4),
            Expanded(
              child: Text(title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.w900, fontSize: 10)),
            ),
          ]),
          const SizedBox(height: 3),
          Text(value,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
          child,
        ]),
      );

  Widget _directionButton(
      BuildContext context, String value, IconData icon, bool tagalog) {
    final selected = direction == value;
    final label = _directionLabel(value, tagalog);
    return SizedBox(
      width: 55,
      height: 38,
      child: FilledButton(
        onPressed: () => setState(() => direction = value),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          backgroundColor: selected ? C.blue : cardColor(context),
          foregroundColor: selected ? Colors.white : C.blue,
          side: BorderSide(color: C.blue.withValues(alpha: .35)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 14),
          const SizedBox(width: 2),
          Flexible(
            child: Text(label,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 9, fontWeight: FontWeight.w800)),
          ),
        ]),
      ),
    );
  }

  Widget _motionInfoRow(BuildContext context, String label, String value) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(children: [
          Icon(Icons.circle, color: C.blue.withValues(alpha: .8), size: 7),
          const SizedBox(width: 7),
          Expanded(
              child: Text(label,
                  style: TextStyle(color: subText(context), fontSize: 12))),
          Text(value,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
        ]),
      );

  Widget _sessionTwoGraph(BuildContext context, bool tagalog, double progress) {
    final currentSpeed =
        math.max(0.0, velocity + acceleration * time * progress);
    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          const Icon(Icons.show_chart_rounded, color: C.blue),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              l10n(context, 'Speed vs. Time', 'Speed at Oras'),
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
            ),
          ),
          Text('${fmt(currentSpeed)} m/s ${_arrow(direction)}',
              style:
                  const TextStyle(color: C.blue, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 3),
        Text(
          l10n(
              context,
              'The line shows how speed changes during the selected time.',
              'Ipinapakita ng linya kung paano nagbabago ang speed sa napiling oras.'),
          style: TextStyle(color: subText(context), fontSize: 12),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 190,
          width: double.infinity,
          child: CustomPaint(
            painter: _SessionTwoSpeedGraphPainter(
              initialSpeed: velocity,
              acceleration: acceleration,
              duration: time,
              progress: progress,
              dark: isDark(context),
              tagalog: tagalog,
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildForceExplore(BuildContext context) {
    final tagalog = AppScope.of(context).tagalog;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            l10n(context, 'Session 3 · Explore', 'Sesyon 3 · Mag-explore')),
      ),
      bottomNavigationBar: _sessionBottomBar(
        context,
        label: l10n(context, 'NEXT: QUIZ', 'SUSUNOD: PAGSUSULIT'),
        enabled: _hasRun,
        onTap: () => go(
            context,
            IndividualChallengeScreen(
                sessionId: widget.sessionId, stageTitle: 'Quiz')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          _ForceExploreBanner(tagalog: tagalog),
          const SizedBox(height: 10),
          Text(
            l10n(
                context,
                'Adjust the forces and mass. Predict what will happen, then start the simulation and explain the result.',
                'Baguhin ang mga puwersa at masa. Hulaan ang mangyayari, simulan ang simulation, at ipaliwanag ang resulta.'),
            style: TextStyle(color: subText(context), height: 1.35),
          ),
          const SizedBox(height: 10),
          LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth >= 760) {
              return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _forceControls(context, tagalog)),
                    const SizedBox(width: 10),
                    Expanded(child: _forceSimulationPanel(context, tagalog)),
                  ]);
            }
            return Column(children: [
              _forceControls(context, tagalog),
              const SizedBox(height: 10),
              _forceSimulationPanel(context, tagalog),
            ]);
          }),
          const SizedBox(height: 12),
          _ForceSectionTitle(
            title: l10n(context, 'TRY DIFFERENT SCENARIOS',
                'SUBUKAN ANG MGA SITWASYON'),
            icon: Icons.lightbulb_rounded,
            color: C.purple,
          ),
          const SizedBox(height: 7),
          Text(
              l10n(
                  context,
                  'Tap a scenario to set it up. Predict first, press Start, then explain what changed.',
                  'Pumili ng sitwasyon. Manghula muna, pindutin ang Simulan, at ipaliwanag ang nagbago.'),
              style: TextStyle(
                  color: subText(context), fontSize: 12, height: 1.3)),
          const SizedBox(height: 7),
          LayoutBuilder(builder: (context, constraints) {
            final columns = constraints.maxWidth >= 760
                ? 4
                : constraints.maxWidth >= 420
                    ? 2
                    : 1;
            const gap = 7.0;
            final width =
                (constraints.maxWidth - gap * (columns - 1)) / columns;
            final titles = [
              l10n(context, 'Increase right force',
                  'Dagdagan ang puwersang pakanan'),
              l10n(context, 'Increase the mass', 'Dagdagan ang masa'),
              l10n(context, 'Make forces equal', 'Pantayin ang mga puwersa'),
              l10n(context, 'Make left force larger',
                  'Palakihin ang puwersang pakaliwa'),
            ];
            final questions = [
              l10n(context, 'What happens to acceleration?',
                  'Ano ang mangyayari sa akselerasyon?'),
              l10n(context, 'What happens to acceleration?',
                  'Ano ang mangyayari sa akselerasyon?'),
              l10n(context, 'What happens to the car?',
                  'Ano ang mangyayari sa kotse?'),
              l10n(context, 'Which way will it accelerate?',
                  'Saan ito bibilis?'),
            ];
            return Wrap(spacing: gap, runSpacing: gap, children: [
              for (var i = 0; i < titles.length; i++)
                _ForceScenarioCard(
                  width: width,
                  index: i + 1,
                  title: titles[i],
                  question: questions[i],
                  left: i == 2
                      ? 100
                      : i == 3
                          ? 160
                          : 40,
                  right: i == 0
                      ? 160
                      : i == 2
                          ? 100
                          : 100,
                  onTap: () => _setForceScenario(i),
                ),
            ]);
          }),
        ],
      ),
    );
  }

  Widget _forceControls(BuildContext context, bool tagalog) =>
      Column(children: [
        _forceSlider(
            context,
            l10n(context, 'Force to the right', 'Puwersang pakanan'),
            _rightForce,
            C.red,
            Icons.arrow_forward_rounded,
            (v) => setState(() => _rightForce = v)),
        const SizedBox(height: 7),
        _forceSlider(
            context,
            l10n(context, 'Force to the left', 'Puwersang pakaliwa'),
            _leftForce,
            C.blue,
            Icons.arrow_back_rounded,
            (v) => setState(() => _leftForce = v)),
        const SizedBox(height: 7),
        _forceSlider(context, l10n(context, 'Mass', 'Masa'), mass, C.green,
            Icons.scale_rounded, (v) => setState(() => mass = v),
            unit: 'kg', min: 100, max: 1000, divisions: 18),
      ]);

  Widget _forceSimulationPanel(BuildContext context, bool tagalog) => AppCard(
        padding: const EdgeInsets.all(10),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => _ForceCarScene(
              progress: Curves.easeInOut.transform(_controller.value),
              leftForce: _leftForce,
              rightForce: _rightForce,
              acceleration: forceAcceleration,
              direction: forceDirection,
              tagalog: tagalog,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
              spacing: 6,
              runSpacing: 6,
              alignment: WrapAlignment.center,
              children: [
                _forceResult(
                    context,
                    l10n(context, 'Net force', 'Netong puwersa'),
                    '${fmt(netForce.abs())} N',
                    forceDirection == 'Left' ? C.blue : C.red),
                _forceResult(
                    context,
                    l10n(context, 'Acceleration', 'Akselerasyon'),
                    '${fmt(forceAcceleration.abs())} m/s²',
                    C.teal),
                _forceResult(
                    context,
                    l10n(context, 'Direction', 'Direksiyon'),
                    l10n(
                        context,
                        forceDirection == 'Balanced'
                            ? 'Balanced'
                            : 'To the ${forceDirection.toLowerCase()}',
                        forceDirection == 'Balanced'
                            ? 'Balanseng puwersa'
                            : forceDirection == 'Left'
                                ? 'Pakaliwa'
                                : 'Pakanan'),
                    C.purple),
              ]),
          const SizedBox(height: 8),
          Text(
              'a = Fnet ÷ m = ${fmt(netForce.abs())} N ÷ ${fmt(mass)} kg = ${fmt(forceAcceleration.abs())} m/s²',
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 9),
          Row(children: [
            Expanded(
                child: _transportButton(context,
                    label: l10n(context, 'START', 'SIMULAHIN'),
                    icon: Icons.play_arrow_rounded,
                    color: C.green,
                    onTap: _startForceSimulation)),
            const SizedBox(width: 6),
            Expanded(
                child: _transportButton(context,
                    label: l10n(context, 'PAUSE', 'I-PAUSE'),
                    icon: Icons.pause_rounded,
                    color: C.blue,
                    onTap: _pauseForceSimulation)),
            const SizedBox(width: 6),
            Expanded(
                child: _transportButton(context,
                    label: l10n(context, 'RESET', 'I-RESET'),
                    icon: Icons.refresh_rounded,
                    color: C.red,
                    onTap: _resetForceSimulation)),
          ]),
        ]),
      );

  Widget _forceSlider(BuildContext context, String label, double value,
          Color color, IconData icon, ValueChanged<double> onChanged,
          {String unit = 'N',
          double min = 0,
          double max = 200,
          int divisions = 40}) =>
      AppCard(
        padding: const EdgeInsets.fromLTRB(11, 8, 11, 3),
        color: color.withValues(alpha: .09),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(icon, color: color, size: 19),
            const SizedBox(width: 5),
            Expanded(
                child: Text(label,
                    style:
                        TextStyle(color: color, fontWeight: FontWeight.w800))),
            Text('${fmt(value)} $unit',
                style: const TextStyle(fontWeight: FontWeight.w900)),
          ]),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
                activeTrackColor: color,
                thumbColor: color,
                overlayColor: color.withValues(alpha: .16)),
            child: Slider(
                value: value.clamp(min, max).toDouble(),
                min: min,
                max: max,
                divisions: divisions,
                onChanged: onChanged),
          ),
        ]),
      );

  Widget _forceResult(
          BuildContext context, String label, String value, Color color) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
        decoration: BoxDecoration(
            color: color.withValues(alpha: .11),
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: color.withValues(alpha: .35))),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(label,
              style: TextStyle(
                  fontSize: 10, color: color, fontWeight: FontWeight.w700)),
          Text(value,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
        ]),
      );

  Widget _transportButton(BuildContext context,
          {required String label,
          required IconData icon,
          required Color color,
          required VoidCallback onTap}) =>
      FilledButton(
        style: FilledButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 9),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
        onPressed: onTap,
        child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(icon, size: 18),
              const SizedBox(width: 3),
              Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w900, fontSize: 11)),
            ])),
      );

  Widget _slider(BuildContext context, String label, double value, double min,
          double max, String unit, ValueChanged<double> onChanged) =>
      AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('$label: ${fmt(value)} $unit',
              style: const TextStyle(fontWeight: FontWeight.w600)),
          Slider(
              value: value.clamp(min, max).toDouble(),
              min: min,
              max: max,
              divisions: ((max - min) * 2).round(),
              onChanged: onChanged),
        ]),
      );

  Widget _result(BuildContext context, String label, String value) =>
      Chip(label: Text('$label: $value'));
}

class _ForceExploreBanner extends StatelessWidget {
  final bool tagalog;
  const _ForceExploreBanner({required this.tagalog});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xff0754cb), Color(0xff168df0)]),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: C.blue.withValues(alpha: .2),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: C.yellow, borderRadius: BorderRadius.circular(10)),
                child: Text(tagalog ? 'MAG-EXPLORE' : 'EXPLORE',
                    style: const TextStyle(
                        color: C.navy, fontWeight: FontWeight.w900))),
            const SizedBox(width: 8),
            Expanded(
                child: Text(
                    tagalog
                        ? 'Netong Puwersa at Akselerasyon'
                        : 'Net Force Causes Acceleration',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        height: 1.1))),
            const Icon(Icons.flag_rounded, color: C.yellow, size: 26),
          ]),
          const SizedBox(height: 8),
          Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                  color: const Color(0xfffff3c9),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                  tagalog
                      ? 'Baguhin ang puwersa at masa. Pansinin ang pagbabago sa akselerasyon ng kotse.'
                      : 'Adjust the forces and mass. Observe how the car’s acceleration changes.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: C.navy,
                      fontWeight: FontWeight.w700,
                      fontSize: 12))),
        ]),
      );
}

class _BachelorExpressBus extends StatelessWidget {
  const _BachelorExpressBus();

  @override
  Widget build(BuildContext context) => const SizedBox(
        width: 138,
        height: 64,
        child: CustomPaint(painter: _BachelorExpressBusPainter()),
      );
}

class _BachelorExpressBusPainter extends CustomPainter {
  const _BachelorExpressBusPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 138;
    final sy = size.height / 64;
    canvas.save();
    canvas.scale(sx, sy);

    final shadow = Paint()..color = const Color(0x44000000);
    canvas.drawOval(const Rect.fromLTWH(12, 52, 116, 8), shadow);

    final bodyPaint = Paint()..color = const Color(0xFFFFC928);
    final body = Path()
      ..moveTo(8, 10)
      ..lineTo(109, 10)
      ..quadraticBezierTo(123, 10, 129, 21)
      ..lineTo(134, 44)
      ..quadraticBezierTo(135, 49, 129, 50)
      ..lineTo(8, 50)
      ..quadraticBezierTo(3, 50, 3, 45)
      ..lineTo(3, 17)
      ..quadraticBezierTo(3, 10, 8, 10)
      ..close();
    canvas.drawPath(body, bodyPaint);

    // A row of broad coach windows, like the tour bus in the reference.
    final glass = Paint()..color = const Color(0xFFB8E8F2);
    for (var i = 0; i < 5; i++) {
      final x = 11.0 + i * 19;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(x, 15, 15, 16), const Radius.circular(2.5)),
        glass,
      );
      canvas.drawLine(
        Offset(x + 2, 17),
        Offset(x + 2, 29),
        Paint()
          ..color = Colors.white.withValues(alpha: .55)
          ..strokeWidth = 1.2,
      );
    }

    // Front windshield and destination board.
    final windshield = Path()
      ..moveTo(109, 14)
      ..lineTo(117, 14)
      ..quadraticBezierTo(122, 14, 124, 20)
      ..lineTo(128, 34)
      ..lineTo(109, 34)
      ..close();
    canvas.drawPath(windshield, Paint()..color = const Color(0xFF284D67));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          const Rect.fromLTWH(15, 11, 27, 3), const Radius.circular(1.5)),
      Paint()..color = const Color(0xFF31546B),
    );

    // Bright lower stripe and fleet name.
    canvas.drawRect(
        const Rect.fromLTWH(5, 35, 120, 3), Paint()..color = Colors.white);
    final name = TextPainter(
      text: const TextSpan(
        text: 'BACHELOR EXPRESS',
        style: TextStyle(
          color: Color(0xFF123B65),
          fontSize: 6.1,
          fontWeight: FontWeight.w900,
          letterSpacing: .1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 91);
    name.paint(canvas, const Offset(38, 39));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
          const Rect.fromLTWH(124, 38, 9, 5), const Radius.circular(2)),
      Paint()..color = const Color(0xFFFFF1A8),
    );

    for (final x in [25.0, 116.0]) {
      canvas.drawCircle(
          Offset(x, 50), 10, Paint()..color = const Color(0xFF243444));
      canvas.drawCircle(
          Offset(x, 50), 5.2, Paint()..color = const Color(0xFFB8C6D2));
      canvas.drawCircle(
          Offset(x, 50), 2.2, Paint()..color = const Color(0xFF516779));
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BachelorExpressBusPainter oldDelegate) => false;
}

class _SessionTwoSpeedGraphPainter extends CustomPainter {
  final double initialSpeed;
  final double acceleration;
  final double duration;
  final double progress;
  final bool dark;
  final bool tagalog;

  const _SessionTwoSpeedGraphPainter({
    required this.initialSpeed,
    required this.acceleration,
    required this.duration,
    required this.progress,
    required this.dark,
    required this.tagalog,
  });

  void _drawText(Canvas canvas, String value, Offset at,
      {double anchorX = 0, double anchorY = 0}) {
    final painter = TextPainter(
      text: TextSpan(
        text: value,
        style: TextStyle(
          color: dark ? Colors.white60 : Colors.black54,
          fontSize: 10,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
        canvas, at - Offset(painter.width * anchorX, painter.height * anchorY));
  }

  @override
  void paint(Canvas canvas, Size size) {
    const left = 39.0;
    const top = 10.0;
    const right = 10.0;
    const bottom = 27.0;
    final plot =
        Rect.fromLTRB(left, top, size.width - right, size.height - bottom);
    if (plot.width <= 0 || plot.height <= 0) return;

    final endingSpeed = math.max(0, initialSpeed + acceleration * duration);
    final highestSpeed = math.max(initialSpeed, endingSpeed);
    final speedMax =
        math.max(10.0, ((highestSpeed / 10).ceil() * 10).toDouble());
    final timeMax = math.max(duration, 1.0);
    Offset point(double t, double speed) => Offset(
          plot.left + plot.width * t / timeMax,
          plot.bottom - plot.height * speed / speedMax,
        );

    final grid = Paint()
      ..color = dark ? Colors.white12 : Colors.black12
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i++) {
      final speed = speedMax * i / 4;
      final y = plot.bottom - plot.height * i / 4;
      canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), grid);
      _drawText(canvas, fmt(speed), Offset(plot.left - 6, y),
          anchorX: 1, anchorY: .5);
    }
    for (var i = 0; i <= 2; i++) {
      final fraction = i / 2;
      final x = plot.left + plot.width * fraction;
      canvas.drawLine(Offset(x, plot.top), Offset(x, plot.bottom), grid);
      _drawText(canvas, fmt(duration * fraction), Offset(x, plot.bottom + 5),
          anchorX: .5);
    }

    final axis = Paint()
      ..color = dark ? Colors.white54 : Colors.black45
      ..strokeWidth = 1.6;
    canvas.drawLine(plot.bottomLeft, plot.topLeft, axis);
    canvas.drawLine(plot.bottomLeft, plot.bottomRight, axis);
    _drawText(canvas, tagalog ? 'Oras (s)' : 'Time (s)',
        Offset(plot.right, size.height - 1),
        anchorX: 1, anchorY: 1);
    _drawText(
        canvas, tagalog ? 'Bilis (m/s)' : 'Speed (m/s)', Offset(plot.left, 1));

    final graphPaint = Paint()
      ..color = C.purple
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final graph = Path();
    final steps = duration == 0 ? 1 : 40;
    for (var i = 0; i <= steps; i++) {
      final t = duration * i / steps;
      final speed = math.max(0.0, initialSpeed + acceleration * t);
      final p = point(t, speed);
      if (i == 0) {
        graph.moveTo(p.dx, p.dy);
      } else {
        graph.lineTo(p.dx, p.dy);
      }
    }
    canvas.drawPath(graph, graphPaint);

    final currentTime = duration * progress;
    final currentSpeed =
        math.max(0.0, initialSpeed + acceleration * currentTime);
    final marker = point(currentTime, currentSpeed);
    canvas.drawCircle(marker, 6, Paint()..color = C.purple);
    canvas.drawCircle(marker, 2.5, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _SessionTwoSpeedGraphPainter oldDelegate) =>
      oldDelegate.initialSpeed != initialSpeed ||
      oldDelegate.acceleration != acceleration ||
      oldDelegate.duration != duration ||
      oldDelegate.progress != progress ||
      oldDelegate.dark != dark ||
      oldDelegate.tagalog != tagalog;
}

class _ForceSectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  const _ForceSectionTitle(
      {required this.title, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 6),
          Expanded(
              child: Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 12))),
        ]),
      );
}

class _ForceCarScene extends StatelessWidget {
  final double progress;
  final double leftForce;
  final double rightForce;
  final double acceleration;
  final String direction;
  final bool tagalog;
  const _ForceCarScene(
      {required this.progress,
      required this.leftForce,
      required this.rightForce,
      required this.acceleration,
      required this.direction,
      required this.tagalog});

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, box) {
        final accelerationScale = (acceleration.abs() / .4).clamp(0.0, 1.0);
        final maxTravel = direction == 'Balanced'
            ? 0.0
            : box.maxWidth * .32 * accelerationScale;
        final signedTravel = direction == 'Left' ? -maxTravel : maxTravel;
        final left = ((box.maxWidth - 112) / 2 + signedTravel * progress)
            .clamp(0.0, box.maxWidth - 112)
            .toDouble();
        return SizedBox(
            height: 156,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(children: [
                const Positioned.fill(
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                      Color(0xffb7e7ff),
                      Color(0xffe6f8ff)
                    ])))),
                Positioned(
                    left: 0,
                    right: 0,
                    bottom: 19,
                    height: 35,
                    child: Container(color: const Color(0xff35415a))),
                Positioned(
                    left: 0,
                    right: 0,
                    bottom: 33,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                            6,
                            (_) => Container(
                                width: 25,
                                height: 3,
                                color: Colors.white.withValues(alpha: .85))))),
                const Positioned(
                    left: 0,
                    right: 0,
                    bottom: 54,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.location_city_rounded,
                              color: Color(0xff58ad75), size: 30),
                          Icon(Icons.park_rounded,
                              color: Color(0xff31a867), size: 35),
                          Icon(Icons.location_city_rounded,
                              color: Color(0xff58ad75), size: 26),
                        ])),
                Positioned(
                    left: 8,
                    top: 8,
                    width: box.maxWidth * .43,
                    child: _ForceVector(
                        force: leftForce, pointsLeft: true, color: C.blue)),
                Positioned(
                    right: 8,
                    top: 8,
                    width: box.maxWidth * .43,
                    child: _ForceVector(
                        force: rightForce, pointsLeft: false, color: C.red)),
                Positioned(
                    left: left,
                    bottom: 23,
                    child: const CarWidget(width: 112, color: C.red)),
                Positioned(
                    left: 0,
                    right: 0,
                    bottom: 1,
                    child: Text(
                        tagalog ? 'KOTSE SA KALSADA' : 'CAR ON THE ROAD',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 9,
                            fontWeight: FontWeight.w700))),
              ]),
            ));
      });
}

class _ForceVector extends StatelessWidget {
  final double force;
  final bool pointsLeft;
  final Color color;
  const _ForceVector(
      {required this.force, required this.pointsLeft, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .82),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withValues(alpha: .45))),
        child: Column(children: [
          Text('${fmt(force)} N',
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w900, fontSize: 11)),
          Row(children: [
            if (pointsLeft)
              Icon(Icons.arrow_back_rounded, color: color, size: 19),
            Expanded(
                child: Container(
                    height: 5,
                    decoration: BoxDecoration(
                        color: color.withValues(alpha: .72),
                        borderRadius: BorderRadius.circular(5)))),
            if (!pointsLeft)
              Icon(Icons.arrow_forward_rounded, color: color, size: 19),
          ]),
        ]),
      );
}

class _ForceScenarioCard extends StatelessWidget {
  final double width;
  final int index;
  final String title;
  final String question;
  final double left;
  final double right;
  final VoidCallback onTap;
  const _ForceScenarioCard(
      {required this.width,
      required this.index,
      required this.title,
      required this.question,
      required this.left,
      required this.right,
      required this.onTap});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        child: AppCard(
          onTap: onTap,
          padding: const EdgeInsets.all(9),
          color: const Color(0xffeef9ff),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              CircleAvatar(
                  radius: 11,
                  backgroundColor: C.navy,
                  child: Text('$index',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold))),
              const SizedBox(width: 5),
              Expanded(
                  child: Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w900, fontSize: 11))),
            ]),
            const SizedBox(height: 5),
            Row(children: [
              const Icon(Icons.arrow_back_rounded, color: C.blue, size: 19),
              Text('${fmt(left)} N',
                  style: const TextStyle(
                      color: C.blue,
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
              const Spacer(),
              const Icon(Icons.arrow_forward_rounded, color: C.red, size: 19),
              Text('${fmt(right)} N',
                  style: const TextStyle(
                      color: C.red, fontSize: 10, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 4),
            Text(question,
                style: TextStyle(
                    color: subText(context), fontSize: 10, height: 1.2)),
          ]),
        ),
      );
}

String _arrow(String direction) =>
    const {'West': '←', 'North': '↑', 'East': '→', 'South': '↓'}[direction]!;
String _directionLabel(String direction, bool tagalog) => tagalog
    ? const {
        'West': 'Kanluran ←',
        'North': 'Hilaga ↑',
        'East': 'Silangan →',
        'South': 'Timog ↓'
      }[direction]!
    : '$direction ${_arrow(direction)}';
