import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/session_page_navigation.dart';
import 'individual_challenge_screen.dart';

class WhatIfScreen extends StatefulWidget {
  final int? sessionId;
  const WhatIfScreen({super.key, this.sessionId});

  @override
  State<WhatIfScreen> createState() => _WhatIfScreenState();
}

class _WhatIfScreenState extends State<WhatIfScreen>
    with TickerProviderStateMixin {
  static const double vi = 10; // baseline lane starts at 10 m/s
  static const double runTime = 4; // seconds per loop
  double a = 3;
  double _initialVelocity = 10;
  double _currentVehicleSpeed = 10;
  VehicleType _vehicleType = VehicleType.car;
  String _environment = 'City';
  String _direction = 'north';
  double _steering = 0;
  double _steeringStart = 0;
  String _speedStatus = 'steady';
  bool _directionChanged = false;
  bool _isStopped = false;
  bool _brakeApplied = false;
  double _stoppedRoadOffset = 0;
  late final AnimationController _c;
  late final AnimationController _turnController;

  @override
  void initState() {
    super.initState();
    if (widget.sessionId == 7) _environment = 'City Road';
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 4))
      ..repeat();
    _turnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      value: 1,
    );
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
    _turnController.dispose();
    super.dispose();
  }

  double _v(double time) {
    final v = _initialVelocity + a * time;
    return (widget.sessionId != 5 && a < 0 && v < 0) ? 0.0 : v;
  }

  double _d(double time) {
    final te = widget.sessionId == 5 || a >= 0 ? time : math.min(time, vi / -a);
    return _initialVelocity * te + 0.5 * a * te * te;
  }

  double _steeringAt(double progress) {
    final easedProgress = Curves.easeInOut.transform(progress);
    return _steeringStart + (_steering - _steeringStart) * easedProgress;
  }

  void _accelerateVehicle() => setState(() {
        _isStopped = false;
        _brakeApplied = false;
        _currentVehicleSpeed += 2;
        a = a < 0 ? 1 : (a + 1).clamp(-5, 5).toDouble();
        _speedStatus = 'increasing';
        _directionChanged = false;
      });

  void _brakeVehicle() => setState(() {
        if (_brakeApplied) {
          _stoppedRoadOffset = _c.value * .4;
          _isStopped = true;
          _currentVehicleSpeed = 0;
          a = 0;
          _speedStatus = 'stopped';
        } else {
          _currentVehicleSpeed *= .4;
          _brakeApplied = true;
          _isStopped = false;
          a = -2;
          _speedStatus = 'decreasing';
        }
        _directionChanged = false;
      });

  void _turn(String turn) => setState(() {
        final turningLeft = turn == 'left';
        final turningNorth = turn == 'north';
        final requestedSide = turningLeft ? -1.0 : 1.0;
        final currentPosition = _steeringAt(_turnController.value);
        _steeringStart = currentPosition;
        // Crossing from one side to the other stops at the center first.
        // A second tap continues to the requested side.
        _steering = turningNorth || currentPosition * requestedSide < -.05
            ? 0
            : requestedSide;
        _direction = turningNorth
            ? 'north'
            : _steering == 0
                ? 'north'
                : turningLeft
                    ? 'west'
                    : 'east';
        _turnController.forward(from: 0);
        _speedStatus = 'unchanged';
        _directionChanged = true;
      });

  Widget _sessionSevenExplore(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n(context, 'Session 7 · Explore', 'Sesyon 7 · Explore')),
      ),
      bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min, children: [
        SessionContinueBar(
          label: l10n(context, 'NEXT: QUIZ', 'SUSUNOD: PAGSUSULIT'),
          onTap: () => go(
            context,
            IndividualChallengeScreen(sessionId: 7, stageTitle: 'Quiz'),
          ),
        ),
        const SessionPageNavigationBar(
          sessionId: 7,
          currentPage: SessionPage.explore,
        ),
      ]),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFF0871E8), Color(0xFF11B5E8)]),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(children: [
              const Icon(Icons.explore_rounded, color: Colors.white, size: 25),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n(context, 'REAL-LIFE MOTION SIMULATOR',
                      'SIMULATOR NG TUNAY NA GALAW'),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 8),
          Text(
            l10n(
                context,
                'Control a vehicle and observe how acceleration changes its motion.',
                'Kontrolin ang sasakyan at obserbahan kung paano binabago ng akselerasyon ang galaw.'),
            textAlign: TextAlign.center,
            style: TextStyle(color: subText(context), fontSize: 12),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 7, 10, 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE9F5FF),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: C.blue.withValues(alpha: .25)),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l10n(context, 'Choose a situation', 'Pumili ng sitwasyon'),
                  style: const TextStyle(
                      color: C.navy,
                      fontSize: 12,
                      fontWeight: FontWeight.w900)),
              const SizedBox(height: 5),
              SizedBox(
                height: 66,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final place in [
                      'City Road',
                      'Highway',
                      'Airport',
                      'Bicycle Lane'
                    ])
                      _situationCard(context, place),
                  ],
                ),
              ),
            ]),
          ),
          const SizedBox(height: 10),
          AnimatedBuilder(
            animation: Listenable.merge([_c, _turnController]),
            builder: (context, _) {
              final time = _c.value * runTime;
              final velocity = _isStopped ? 0.0 : _currentVehicleSpeed;
              return Column(children: [
                SizedBox(
                  height: 198,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(17),
                    child: Stack(children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _SessionSevenScenePainter(
                            situation: _environment,
                            vehicle: _vehicleType,
                            roadOffset: _isStopped
                                ? _stoppedRoadOffset
                                : _brakeApplied
                                    ? _c.value * .4
                                    : _c.value,
                            steering: _steeringAt(_turnController.value),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 8,
                        bottom: 7,
                        child: Text(
                          l10n(context, _environment,
                              _situationTl(_environment)),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              shadows: [
                                Shadow(color: Colors.black87, blurRadius: 5)
                              ]),
                        ),
                      ),
                    ]),
                  ),
                ),
                const SizedBox(height: 6),
                Row(children: [
                  Expanded(
                    child: _sceneMetric(
                      Icons.speed_rounded,
                      l10n(context, 'SPEED', 'BILIS'),
                      '${fmt(velocity.abs())} m/s',
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: _sceneMetric(
                      _directionIcon,
                      l10n(context, 'VELOCITY', 'VELOCITY'),
                      '${fmt(velocity.abs())} m/s $_direction',
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: _sceneMetric(
                      Icons.trending_up_rounded,
                      l10n(context, 'ACCELERATION', 'AKSELERASYON'),
                      '${fmt(a)} m/s²',
                    ),
                  ),
                ]),
              ]);
            },
          ),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(
              child: _motionControl(
                l10n(context, 'ACCELERATE', 'BUMILIS'),
                Icons.bolt_rounded,
                C.green,
                _accelerateVehicle,
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: _motionControl(
                l10n(context, 'BRAKE', 'PRENO'),
                Icons.stop_circle_outlined,
                C.red,
                _brakeVehicle,
              ),
            ),
          ]),
          const SizedBox(height: 5),
          Row(children: [
            Expanded(
              child: _motionControl(
                l10n(context, 'TURN LEFT', 'KALIWA'),
                Icons.turn_left_rounded,
                C.blue,
                () => _turn('left'),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: _motionControl(
                l10n(context, 'TURN RIGHT', 'KANAN'),
                Icons.turn_right_rounded,
                C.orange,
                () => _turn('right'),
              ),
            ),
          ]),
          const SizedBox(height: 7),
          Row(children: [
            Expanded(
              child: _statusIndicator(
                icon: _speedStatus == 'increasing'
                    ? Icons.trending_up_rounded
                    : _speedStatus == 'decreasing'
                        ? Icons.trending_down_rounded
                        : _speedStatus == 'stopped'
                            ? Icons.pause_circle_outline_rounded
                            : Icons.horizontal_rule_rounded,
                label: l10n(context, 'SPEED', 'BILIS'),
                value: _speedStatus == 'increasing'
                    ? l10n(context, 'Increasing', 'Tumataas')
                    : _speedStatus == 'decreasing'
                        ? l10n(context, 'Decreasing', 'Bumababa')
                        : _speedStatus == 'unchanged'
                            ? l10n(
                                context, 'No speed change', 'Walang pagbabago')
                            : _speedStatus == 'stopped'
                                ? l10n(context, 'Stopped', 'Huminto')
                                : l10n(context, 'Steady', 'Hindi nagbabago'),
                color: _speedStatus == 'stopped'
                    ? C.red
                    : _speedStatus == 'decreasing'
                        ? C.orange
                        : C.green,
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Tooltip(
                message: l10n(
                    context, 'Tap to go north', 'I-tap para pumunta sa hilaga'),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => _turn('north'),
                  child: _statusIndicator(
                    icon: _directionIcon,
                    label: l10n(context, 'DIRECTION', 'DIREKSIYON'),
                    value:
                        '${_direction[0].toUpperCase()}${_direction.substring(1)} · ${_directionChanged ? l10n(context, 'changed', 'nagbago') : l10n(context, 'unchanged', 'hindi nagbago')}',
                    color: _directionChanged ? C.blue : C.sky,
                  ),
                ),
              ),
            ),
          ]),
          const SizedBox(height: 10),
          _exploreQuestions(context),
        ],
      ),
    );
  }

  Widget _situationCard(BuildContext context, String place) {
    final selected = _environment == place;
    final icon = switch (place) {
      'City Road' => Icons.location_city_rounded,
      'Highway' => Icons.add_road_rounded,
      'Airport' => Icons.flight_takeoff_rounded,
      _ => Icons.directions_bike_rounded,
    };
    return GestureDetector(
      onTap: () => setState(() {
        _environment = place;
        _vehicleType = switch (place) {
          'City Road' => VehicleType.car,
          'Highway' => VehicleType.bus,
          'Airport' => VehicleType.airplane,
          'Bicycle Lane' => VehicleType.bicycle,
          _ => VehicleType.car,
        };
        _direction = 'north';
        _steering = 0;
        _steeringStart = 0;
        _turnController
          ..stop()
          ..value = 1;
        _speedStatus = 'steady';
        _isStopped = false;
        _brakeApplied = false;
        _currentVehicleSpeed = 10;
        _directionChanged = false;
      }),
      child: Container(
        width: 76,
        margin: const EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
              color: selected ? C.orange : const Color(0xFFB7CAD9),
              width: selected ? 2 : 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: place == 'Bicycle Lane'
                      ? const [Color(0xFF83D4F6), Color(0xFF42A66E)]
                      : place == 'Airport'
                          ? const [Color(0xFF91D6F4), Color(0xFFD7E8F2)]
                          : const [Color(0xFF77CCF3), Color(0xFF72B96E)],
                ),
              ),
              child: Icon(icon,
                  color: place == 'Airport' ? Colors.white : Colors.white,
                  size: 25,
                  shadows: const [
                    Shadow(color: Colors.black45, blurRadius: 4)
                  ]),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 2),
            color: selected ? const Color(0xFFFFE4A3) : Colors.white,
            child: Text(
              l10n(context, place, _situationTl(place)),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: C.navy, fontSize: 8, fontWeight: FontWeight.w800),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _exploreQuestions(BuildContext context) {
    final questions = [
      l10n(context, 'What happens when you press accelerate?',
          'Ano ang nangyayari kapag pinindot ang accelerate?'),
      l10n(context, 'What happens when you press brake?',
          'Ano ang nangyayari kapag pinindot ang preno?'),
      l10n(context, 'What happens when the vehicle turns?',
          'Ano ang nangyayari kapag lumiko ang sasakyan?'),
      l10n(context, 'Why does turning involve a change in velocity?',
          'Bakit nagbabago ang velocity kapag lumiliko?'),
    ];
    const colors = [Color(0xFFE9448B), C.blue, C.green, C.orange];
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5FC),
        border: Border.all(color: const Color(0xFFED7CB6), width: 1.3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.lightbulb_rounded, color: C.yellow, size: 20),
          const SizedBox(width: 5),
          Text(l10n(context, 'Explore and Answer', 'Magsiyasat at Sumagot'),
              style: const TextStyle(
                  color: Color(0xFFB31B69),
                  fontSize: 14,
                  fontWeight: FontWeight.w900)),
        ]),
        const SizedBox(height: 4),
        for (var i = 0; i < questions.length; i++)
          Container(
            margin: const EdgeInsets.only(top: 3),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFF1C8DC)),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Row(children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: colors[i],
                child: Text('${i + 1}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w900)),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(questions[i],
                    style: const TextStyle(
                        color: C.navy,
                        fontSize: 10,
                        fontWeight: FontWeight.w700)),
              ),
            ]),
          ),
      ]),
    );
  }

  Widget _motionControl(
          String title, IconData icon, Color color, VoidCallback onTap) =>
      FilledButton.icon(
        onPressed: () {
          AppScope.of(context).click();
          onTap();
        },
        icon: Icon(icon, size: 20),
        label: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(title,
              maxLines: 1,
              style:
                  const TextStyle(fontSize: 11, fontWeight: FontWeight.w900)),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 11),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

  IconData get _directionIcon => switch (_direction) {
        'north' => Icons.north_rounded,
        'south' => Icons.south_rounded,
        'west' => Icons.west_rounded,
        'center' => Icons.filter_center_focus_rounded,
        _ => Icons.east_rounded,
      };

  Widget _statusIndicator({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final dark = isDark(context);
    final accent = dark ? Color.lerp(color, Colors.white, .52)! : color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: .45)),
      ),
      child: Row(children: [
        Icon(icon, color: accent, size: 19),
        const SizedBox(width: 5),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label,
                style: TextStyle(
                    color: accent, fontSize: 8, fontWeight: FontWeight.w900)),
            Text(value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: dark ? Colors.white : C.navy,
                    fontSize: 11,
                    fontWeight: FontWeight.w900)),
          ]),
        ),
      ]),
    );
  }

  Widget _sceneMetric(IconData icon, String label, String value) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF073B77),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 8)),
              Text(value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Color(0xFFFFE15A),
                      fontSize: 10,
                      fontWeight: FontWeight.w900)),
            ]),
          ),
        ]),
      );

  Widget _lane(String label, double meters, Color carColor) {
    return LayoutBuilder(builder: (context, box) {
      const carW = 72.0;
      final frac = clamp01(meters / 100);
      return Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _EnvironmentLanePainter(
                environment: _environment,
                offset: _c.value * 180,
              ),
            ),
          ),
          Positioned(
            top: 6,
            left: 10,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: .3),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                child: Text(label,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
              ),
            ),
          ),
          Positioned(
            left: 8 + (box.maxWidth - carW - 16) * frac,
            bottom: 5,
            child:
                VehicleWidget(type: _vehicleType, width: carW, color: carColor),
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
    if (widget.sessionId == 7) return _sessionSevenExplore(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(l10n(
              context,
              widget.sessionId == null
                  ? 'What Happens If…?'
                  : 'Session ${widget.sessionId} Motion Explorer',
              widget.sessionId == null
                  ? 'Ano ang Mangyayari Kung…?'
                  : 'Tagapaggalugad ng Galaw — Sesyon ${widget.sessionId}'))),
      bottomNavigationBar: widget.sessionId == null
          ? null
          : Column(mainAxisSize: MainAxisSize.min, children: [
              SessionContinueBar(
                label: l10n(context, 'NEXT: QUIZ', 'SUSUNOD: PAGSUSULIT'),
                onTap: () => go(
                    context,
                    IndividualChallengeScreen(
                        sessionId: widget.sessionId, stageTitle: 'Quiz')),
              ),
              SessionPageNavigationBar(
                sessionId: widget.sessionId!,
                currentPage: SessionPage.explore,
              ),
            ]),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
              l10n(context, 'What happens if you change the acceleration?',
                  'Ano ang mangyayari kapag binago mo ang akselerasyon?'),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          if (widget.sessionId == 7) ...[
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n(context, 'Choose a vehicle', 'Pumili ng sasakyan'),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold)),
                  Wrap(spacing: 8, children: [
                    for (final item in <(String, VehicleType)>[
                      ('Car', VehicleType.car),
                      ('Bus', VehicleType.bus),
                      ('Bicycle', VehicleType.bicycle),
                      ('Train', VehicleType.train),
                    ])
                      ChoiceChip(
                        label:
                            Text(l10n(context, item.$1, _vehicleTl(item.$1))),
                        selected: _vehicleType == item.$2,
                        onSelected: (_) =>
                            setState(() => _vehicleType = item.$2),
                      ),
                  ]),
                  Text(l10n(context, 'Environment', 'Kapaligiran'),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Wrap(spacing: 8, children: [
                    for (final place in ['City', 'Highway', 'Track'])
                      ChoiceChip(
                        label:
                            Text(l10n(context, place, _environmentTl(place))),
                        selected: _environment == place,
                        onSelected: (_) => setState(() => _environment = place),
                      ),
                  ]),
                  Text(l10n(context, 'Selected environment: $_environment',
                      'Napiling kapaligiran: ${_environmentTl(_environment)}')),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
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
          if (widget.sessionId == 5) ...[
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      l10n(context, 'Initial velocity (direction)',
                          'Panimulang velocity (direksiyon)'),
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  Slider(
                    value: _initialVelocity,
                    min: -20,
                    max: 20,
                    divisions: 40,
                    label: '${fmt(_initialVelocity)} m/s',
                    onChanged: (v) => setState(() => _initialVelocity = v),
                  ),
                  Text(l10n(
                      context,
                      'A negative sign means motion in the chosen negative direction.',
                      'Ang negatibong tanda ay galaw sa piniling negatibong direksiyon.')),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          AnimatedBuilder(
            animation: _c,
            builder: (context, _) {
              final time = _c.value * runTime;
              return Column(children: [
                _lane(
                    l10n(context, 'Your vehicle (a = ${fmt(a)} m/s²)',
                        'Sasakyan mo (a = ${fmt(a)} m/s²)'),
                    widget.sessionId == 5 ? _d(time) + 50 : _d(time),
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

class _SessionSevenScenePainter extends CustomPainter {
  final String situation;
  final VehicleType vehicle;
  final double roadOffset;
  final double steering;

  const _SessionSevenScenePainter({
    required this.situation,
    required this.vehicle,
    required this.roadOffset,
    required this.steering,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final airport = situation == 'Airport';
    final highway = situation == 'Highway';
    final bikeLane = situation == 'Bicycle Lane';
    final sky = Rect.fromLTWH(0, 0, w, h);

    canvas.drawRect(
      sky,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF43B9F5), Color(0xFFC8EEFF)],
        ).createShader(sky),
    );
    canvas.drawCircle(
        Offset(w * .82, h * .16), 15, Paint()..color = const Color(0xFFFFF0A4));

    // Distant city and terrain establish depth behind the road.
    final hills = Paint()..color = const Color(0xFF63B979);
    for (var x = -55.0; x < w + 50; x += 90) {
      canvas.drawOval(Rect.fromLTWH(x, h * .39, 125, h * .28), hills);
    }
    if (!airport) _drawPerspectiveBuildings(canvas, size, highway: highway);

    if (airport) {
      _drawAirportTerminal(canvas, size);
    } else if (highway) {
      _drawHighwaySign(canvas, size);
    }
    _drawSceneTrees(canvas, size);

    // Perspective road narrows at the horizon; the moving dashes sell motion.
    final horizon = Offset(w * .5, h * .48);
    final leftBottom = bikeLane ? w * .08 : w * .02;
    final rightBottom = bikeLane ? w * .92 : w * .98;
    final road = Path()
      ..moveTo(w * .46, horizon.dy)
      ..lineTo(w * .54, horizon.dy)
      ..lineTo(rightBottom, h)
      ..lineTo(leftBottom, h)
      ..close();
    canvas.drawPath(
      road,
      Paint()
        ..color = bikeLane ? const Color(0xFF3D5652) : const Color(0xFF384452),
    );

    final shoulder = Paint()
      ..color = airport || bikeLane ? Colors.white : const Color(0xFFECE8CC)
      ..strokeWidth = 3;
    canvas.drawLine(
        Offset(w * .46, horizon.dy), Offset(leftBottom, h), shoulder);
    canvas.drawLine(
        Offset(w * .54, horizon.dy), Offset(rightBottom, h), shoulder);
    if (airport) {
      _drawRunwayMarkings(canvas, size);
    }

    final roadScroll = roadOffset * 38;
    for (var i = 0; i < 5; i++) {
      final p = ((i * .22 + roadScroll / h) % 1).clamp(0.0, 1.0);
      final y = horizon.dy + (h - horizon.dy) * p;
      final width = airport ? 2.5 + p * 9 : 2.0 + p * 6;
      final dashHeight = airport ? 5.0 + p * 18 : 3.0 + p * 13;
      final dashes = Paint()..color = Colors.white70;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: Offset(w * .5, y), width: width, height: dashHeight),
          const Radius.circular(3),
        ),
        dashes,
      );
    }

    if (!bikeLane && !airport) _drawPerspectiveRailings(canvas, size);
    _drawRearVehicle(canvas, size, steering, vehicle);
  }

  void _drawRunwayMarkings(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final edge = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5;
    canvas.drawLine(Offset(w * .46, h * .49), Offset(w * .09, h), edge);
    canvas.drawLine(Offset(w * .54, h * .49), Offset(w * .91, h), edge);

    // Threshold bars widen toward the viewer to reinforce runway perspective.
    final bars = Paint()..color = Colors.white;
    for (var i = 0; i < 6; i++) {
      final x = w * (.29 + i * .084);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: Offset(x, h * .955), width: 2.0 + i % 2, height: h * .09),
          const Radius.circular(2),
        ),
        bars,
      );
    }

    // Amber and white lights mark both runway edges.
    for (var i = 1; i <= 6; i++) {
      final t = i / 7;
      final y = h * (.51 + t * .45);
      final halfWidth = w * (.05 + t * .39);
      final radius = 1.2 + t * 1.2;
      final light = Paint()
        ..color = i.isEven ? const Color(0xFFFFE88A) : const Color(0xFFEAF8FF);
      canvas.drawCircle(Offset(w * .5 - halfWidth, y), radius, light);
      canvas.drawCircle(Offset(w * .5 + halfWidth, y), radius, light);
    }

    final runwayNumber = TextPainter(
      text: const TextSpan(
        text: '27',
        style: TextStyle(
            color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w900),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    runwayNumber.paint(
        canvas, Offset(w * .5 - runwayNumber.width / 2, h * .69));
  }

  void _drawSceneTrees(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    for (var i = 0; i < 8; i++) {
      final p = .24 + i * .08;
      final y = h * (.46 + p * .24);
      final spread = 7 + p * 32;
      final xLeft = w * .46 - spread;
      final xRight = w * .54 + spread;
      for (final x in [xLeft, xRight]) {
        final trunk = Paint()..color = const Color(0xFF76543C);
        final leaves = Paint()
          ..color =
              i.isEven ? const Color(0xFF238B50) : const Color(0xFF3CA45D);
        final radius = 2.0 + p * 7;
        canvas.drawRect(
            Rect.fromLTWH(x - radius * .18, y, radius * .36, radius * 1.25),
            trunk);
        canvas.drawCircle(Offset(x, y - radius * .45), radius, leaves);
        canvas.drawCircle(Offset(x - radius * .55, y), radius * .68, leaves);
        canvas.drawCircle(Offset(x + radius * .55, y), radius * .68, leaves);
      }
    }
  }

  void _drawPerspectiveBuildings(Canvas canvas, Size size,
      {required bool highway}) {
    final w = size.width;
    final h = size.height;
    const facades = [
      Color(0xFF4383AF),
      Color(0xFF5C9BBC),
      Color(0xFF779EB5),
      Color(0xFF3F719B),
      Color(0xFF8BAFC2),
    ];
    final windows = Paint()
      ..color = const Color(0xFFDDF4FF).withValues(alpha: .9);

    for (final side in [-1.0, 1.0]) {
      for (var i = 0; i < 7; i++) {
        // Buildings grow toward the viewer and stay outside the road edges.
        final depth = (i + 1) / 8;
        final roadProgress = depth * .76;
        final roadEdgeX = w * (.5 + side * (.04 + .46 * roadProgress));
        final baseY = h * (.5 + depth * .2);
        final buildingW = (highway ? 14.0 : 16.0) + depth * 21;
        final buildingH = (highway ? 15.0 : 25.0) + depth * 45;
        final sideDepth = 3.0 + depth * 8;
        final x =
            side < 0 ? roadEdgeX - buildingW - sideDepth - 3 : roadEdgeX + 3;
        final top = baseY - buildingH;
        final face = Rect.fromLTWH(x, top, buildingW, buildingH);
        final baseColor =
            highway ? const Color(0xFF789D8B) : facades[i % facades.length];
        final frontPaint = Paint()..color = baseColor;
        final sidePaint = Paint()
          ..color =
              Color.lerp(baseColor, const Color(0xFF142C47), .28) ?? baseColor;
        final roofPaint = Paint()
          ..color = Color.lerp(baseColor, Colors.white, .2) ?? baseColor;

        final sideFace = Path();
        final roof = Path();
        if (side < 0) {
          sideFace
            ..moveTo(face.right, top)
            ..lineTo(face.right + sideDepth, top - sideDepth * .45)
            ..lineTo(face.right + sideDepth, baseY - sideDepth * .45)
            ..lineTo(face.right, baseY)
            ..close();
          roof
            ..moveTo(face.left, top)
            ..lineTo(face.right, top)
            ..lineTo(face.right + sideDepth, top - sideDepth * .45)
            ..lineTo(face.left + sideDepth, top - sideDepth * .45)
            ..close();
        } else {
          sideFace
            ..moveTo(face.left, top)
            ..lineTo(face.left - sideDepth, top - sideDepth * .45)
            ..lineTo(face.left - sideDepth, baseY - sideDepth * .45)
            ..lineTo(face.left, baseY)
            ..close();
          roof
            ..moveTo(face.left, top)
            ..lineTo(face.right, top)
            ..lineTo(face.right - sideDepth, top - sideDepth * .45)
            ..lineTo(face.left - sideDepth, top - sideDepth * .45)
            ..close();
        }
        canvas.drawPath(sideFace, sidePaint);
        canvas.drawPath(roof, roofPaint);
        canvas.drawRect(face, frontPaint);

        if (!highway) {
          final windowW = math.max(1.5, depth * 3.2);
          final windowH = math.max(2.0, depth * 4.2);
          final spacingX = math.max(3.5, depth * 7.0);
          final spacingY = math.max(5.0, depth * 9.0);
          for (var wy = top + spacingY * .6;
              wy + windowH < baseY - spacingY * .35;
              wy += spacingY) {
            for (var wx = x + spacingX * .55;
                wx + windowW < x + buildingW - spacingX * .25;
                wx += spacingX) {
              canvas.drawRect(Rect.fromLTWH(wx, wy, windowW, windowH), windows);
            }
          }
        }
      }
    }
  }

  void _drawPerspectiveRailings(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final rail = Paint()
      ..color = const Color(0xFFDCE7E9)
      ..strokeWidth = 2;
    for (final side in [-1.0, 1.0]) {
      final vanish = Offset(w * (.5 + side * .05), h * .49);
      final edge = Offset(w * (.5 + side * .48), h * .89);
      canvas.drawLine(vanish, edge, rail);
      for (var i = 1; i <= 5; i++) {
        final t = i / 6;
        final y = vanish.dy + (edge.dy - vanish.dy) * t;
        final x = vanish.dx + (edge.dx - vanish.dx) * t;
        final postHeight = 3 + t * 7;
        canvas.drawLine(Offset(x, y - postHeight), Offset(x, y + 2), rail);
      }
    }
  }

  void _drawRearVehicle(
      Canvas canvas, Size size, double turn, VehicleType type) {
    final w = size.width;
    final h = size.height;
    // Keep the vehicle between the road edges while making each steering
    // action visibly move it across the lane.
    final shift = turn * size.width * .24;
    final center = Offset(w * .5 + shift, h * .84);
    if (type == VehicleType.airplane) {
      _drawFirstPersonAirplane(canvas, size, turn);
      return;
    }
    if (type == VehicleType.bicycle) {
      _drawFirstPersonBicycle(canvas, size, turn);
      return;
    }

    final isLarge = type == VehicleType.bus || type == VehicleType.train;
    final bodyW = switch (type) {
      VehicleType.bus => 108.0,
      VehicleType.train => 120.0,
      VehicleType.autoRickshaw => 78.0,
      _ => 91.0,
    };
    final bodyH = isLarge ? 63.0 : 52.0;
    final body = Rect.fromCenter(
        center: Offset(center.dx, center.dy + 7), width: bodyW, height: bodyH);
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(center.dx, h * .96), width: bodyW * 1.12, height: 12),
      Paint()..color = Colors.black.withValues(alpha: .42),
    );
    final tire = Paint()..color = const Color(0xFF202A37);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(body.left - 4, body.top + bodyH * .56, 9, bodyH * .4),
            const Radius.circular(4)),
        tire);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(
                body.right - 5, body.top + bodyH * .56, 9, bodyH * .4),
            const Radius.circular(4)),
        tire);

    final vehicleColors = switch (type) {
      VehicleType.bus => const [
          Color(0xFFFFD768),
          Color(0xFFF09A26),
          Color(0xFFB95A24)
        ],
      VehicleType.train => const [
          Color(0xFFB8E6F5),
          Color(0xFF5599C6),
          Color(0xFF285A86)
        ],
      VehicleType.autoRickshaw => const [
          Color(0xFF62D7A6),
          Color(0xFF168A63),
          Color(0xFF075C44)
        ],
      _ => const [Color(0xFFFF6C62), Color(0xFFCF2638), Color(0xFF8C1829)],
    };
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: vehicleColors,
      ).createShader(body);
    final shape = isLarge
        ? (Path()
          ..addRRect(RRect.fromRectAndRadius(
              Rect.fromLTWH(body.left, body.top, body.width, body.height),
              const Radius.circular(7))))
        : Path()
      ..moveTo(body.left, body.bottom)
      ..lineTo(body.left + bodyW * .08, body.top + bodyH * .27)
      ..quadraticBezierTo(center.dx, body.top - bodyH * .08,
          body.right - bodyW * .08, body.top + bodyH * .27)
      ..lineTo(body.right, body.bottom)
      ..close();
    canvas.drawPath(shape, paint);

    final window = Path()
      ..moveTo(body.left + bodyW * .2, body.top + bodyH * .32)
      ..quadraticBezierTo(center.dx, body.top + bodyH * .04,
          body.right - bodyW * .2, body.top + bodyH * .32)
      ..lineTo(body.right - bodyW * .24, body.top + bodyH * .56)
      ..lineTo(body.left + bodyW * .24, body.top + bodyH * .56)
      ..close();
    canvas.drawPath(window, Paint()..color = const Color(0xFFB9E8FA));
    canvas.drawLine(
      Offset(center.dx, body.top + bodyH * .23),
      Offset(center.dx, body.top + bodyH * .55),
      Paint()
        ..color = const Color(0xFF657A8C)
        ..strokeWidth = 2,
    );
    final lamp = Paint()..color = const Color(0xFFFFE5A0);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(body.left + 5, body.top + bodyH * .68, 12, 6),
            const Radius.circular(3)),
        lamp);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(body.right - 17, body.top + bodyH * .68, 12, 6),
            const Radius.circular(3)),
        lamp);
    if (type == VehicleType.train) {
      canvas.drawLine(
          Offset(body.left + 4, body.bottom - 2),
          Offset(body.right - 4, body.bottom - 2),
          Paint()
            ..color = const Color(0xFFE9F1F4)
            ..strokeWidth = 3);
    }
  }

  void _drawFirstPersonBicycle(Canvas canvas, Size size, double steering) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w * .5, h * .98);
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(steering * .055);
    canvas.translate(-center.dx, -center.dy);

    final stem = Paint()
      ..color = const Color(0xFF25384A)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
        Offset(center.dx, h * .84), Offset(center.dx, h * .99), stem);
    final handlebar = Paint()
      ..color = const Color(0xFF202D3A)
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final bar = Path()
      ..moveTo(w * .25, h * .78)
      ..lineTo(w * .36, h * .78)
      ..quadraticBezierTo(w * .41, h * .78, w * .43, h * .83)
      ..quadraticBezierTo(w * .5, h * .88, w * .57, h * .83)
      ..quadraticBezierTo(w * .59, h * .78, w * .64, h * .78)
      ..lineTo(w * .75, h * .78);
    canvas.drawPath(bar, handlebar);

    final grip = Paint()
      ..color = const Color(0xFF101923)
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * .25, h * .78), Offset(w * .34, h * .78), grip);
    canvas.drawLine(Offset(w * .66, h * .78), Offset(w * .75, h * .78), grip);

    // Small gloved hands rest on each grip to make the rider's viewpoint clear.
    final glove = Paint()..color = const Color(0xFF284C66);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(w * .34, h * .79), width: w * .065, height: h * .09),
        glove);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(w * .66, h * .79), width: w * .065, height: h * .09),
        glove);

    final brake = Paint()
      ..color = const Color(0xFFB6C7D4)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * .34, h * .77), Offset(w * .39, h * .83), brake);
    canvas.drawLine(Offset(w * .66, h * .77), Offset(w * .61, h * .83), brake);
    canvas.restore();
  }

  void _drawFirstPersonAirplane(Canvas canvas, Size size, double steering) {
    final w = size.width;
    final h = size.height;

    // Cockpit dashboard fills the foreground while leaving the runway visible.
    final dashboard = Path()
      ..moveTo(0, h * .84)
      ..quadraticBezierTo(w * .5, h * .72, w, h * .84)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(
      dashboard,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF40566B), Color(0xFF182A3B)],
        ).createShader(Rect.fromLTWH(0, h * .72, w, h * .28)),
    );
    canvas.drawPath(
      dashboard,
      Paint()
        ..color = const Color(0xFF9FB6C4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    for (final x in [w * .16, w * .84]) {
      canvas.drawCircle(
        Offset(x, h * .92),
        10,
        Paint()..color = const Color(0xFF0D1D2B),
      );
      canvas.drawCircle(
        Offset(x, h * .92),
        6,
        Paint()
          ..color = const Color(0xFF64D6EC)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
      canvas.drawLine(
        Offset(x - 3, h * .92),
        Offset(x + 3, h * .92),
        Paint()
          ..color = const Color(0xFFFFD66B)
          ..strokeWidth = 1.5,
      );
    }

    final yokeCenter = Offset(w * .5, h * .89);
    canvas.save();
    canvas.translate(yokeCenter.dx, yokeCenter.dy);
    canvas.rotate(steering * .08);
    canvas.translate(-yokeCenter.dx, -yokeCenter.dy);
    final yoke = Paint()
      ..color = const Color(0xFF172532)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final yokePath = Path()
      ..moveTo(w * .5, h * .91)
      ..lineTo(w * .5, h * .83)
      ..quadraticBezierTo(w * .5, h * .79, w * .44, h * .79)
      ..lineTo(w * .39, h * .80)
      ..moveTo(w * .5, h * .83)
      ..quadraticBezierTo(w * .5, h * .79, w * .56, h * .79)
      ..lineTo(w * .61, h * .80);
    canvas.drawPath(yokePath, yoke);
    canvas.drawCircle(yokeCenter, 6, Paint()..color = const Color(0xFF18B7B0));
    canvas.restore();
  }

  void _drawRunwayAirplane(Canvas canvas, Offset center) {
    final scale = 1.0;
    final fuselage = Paint()..color = const Color(0xFFE8F3FB);
    final wing = Paint()..color = const Color(0xFFB7D0E1);
    final blue = Paint()..color = const Color(0xFF2581B8);
    final shape = Path()
      ..moveTo(center.dx, center.dy - 42 * scale)
      ..quadraticBezierTo(
          center.dx + 7, center.dy - 35, center.dx + 8, center.dy - 18)
      ..lineTo(center.dx + 45, center.dy - 3)
      ..lineTo(center.dx + 49, center.dy + 5)
      ..lineTo(center.dx + 10, center.dy + 1)
      ..lineTo(center.dx + 10, center.dy + 29)
      ..lineTo(center.dx + 23, center.dy + 38)
      ..lineTo(center.dx + 22, center.dy + 43)
      ..lineTo(center.dx + 2, center.dy + 36)
      ..lineTo(center.dx - 2, center.dy + 36)
      ..lineTo(center.dx - 22, center.dy + 43)
      ..lineTo(center.dx - 23, center.dy + 38)
      ..lineTo(center.dx - 10, center.dy + 29)
      ..lineTo(center.dx - 10, center.dy + 1)
      ..lineTo(center.dx - 49, center.dy + 5)
      ..lineTo(center.dx - 45, center.dy - 3)
      ..lineTo(center.dx - 8, center.dy - 18)
      ..quadraticBezierTo(
          center.dx - 7, center.dy - 35, center.dx, center.dy - 42 * scale)
      ..close();
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(center.dx, center.dy + 43), width: 94, height: 10),
      Paint()..color = Colors.black.withValues(alpha: .32),
    );
    canvas.drawPath(shape, wing);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(center.dx, center.dy - 2), width: 15, height: 72),
        const Radius.circular(8),
      ),
      fuselage,
    );
    canvas.drawCircle(Offset(center.dx, center.dy - 30), 3, blue);
    canvas.drawCircle(Offset(center.dx - 10, center.dy + 1), 5, blue);
    canvas.drawCircle(Offset(center.dx + 10, center.dy + 1), 5, blue);
  }

  void _drawAirportTerminal(Canvas canvas, Size size) {
    final h = size.height;
    final terminal =
        Rect.fromLTWH(size.width * .55, h * .37, size.width * .43, h * .2);
    canvas.drawRect(terminal, Paint()..color = const Color(0xFFEAF3F5));
    canvas.drawRect(
        Rect.fromLTWH(terminal.left, terminal.top, terminal.width, 7),
        Paint()..color = const Color(0xFF54758D));
    for (var x = terminal.left + 9; x < terminal.right - 5; x += 18) {
      canvas.drawRect(
          Rect.fromLTWH(x, terminal.top + 11, 11, terminal.height - 17),
          Paint()..color = const Color(0xFF85CBE5));
    }
    canvas.drawRect(Rect.fromLTWH(size.width * .78, h * .26, 3, h * .11),
        Paint()..color = const Color(0xFF53697D));
  }

  void _drawHighwaySign(Canvas canvas, Size size) {
    final pole = Paint()
      ..color = const Color(0xFF596B78)
      ..strokeWidth = 3;
    final left = size.width * .73;
    canvas.drawLine(
        Offset(left, size.height * .23), Offset(left, size.height * .5), pole);
    final sign = RRect.fromRectAndRadius(
      Rect.fromLTWH(left - 17, size.height * .23, 53, 24),
      const Radius.circular(4),
    );
    canvas.drawRRect(sign, Paint()..color = const Color(0xFF19734A));
    canvas.drawRRect(
      sign,
      Paint()
        ..color = const Color(0xFFE4F5E9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'HIGHWAY',
        style: TextStyle(
            color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 48);
    textPainter.paint(canvas, Offset(left - 14, size.height * .28));
  }

  @override
  bool shouldRepaint(_SessionSevenScenePainter oldDelegate) =>
      oldDelegate.situation != situation ||
      oldDelegate.vehicle != vehicle ||
      oldDelegate.roadOffset != roadOffset ||
      oldDelegate.steering != steering;
}

class _EnvironmentLanePainter extends CustomPainter {
  final String environment;
  final double offset;

  const _EnvironmentLanePainter(
      {required this.environment, required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final track = environment == 'Track';
    final highway = environment == 'Highway';
    final background = Rect.fromLTWH(0, 0, w, h);

    canvas.drawRect(
      background,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: track
              ? const [Color(0xFFB7D7FA), Color(0xFFE9F2FF)]
              : highway
                  ? const [Color(0xFF8CD4F4), Color(0xFFD7F4E5)]
                  : const [Color(0xFF8BCDF5), Color(0xFFE1F4FF)],
        ).createShader(background),
    );

    // Distant hills frame the skyline and give every environment depth.
    final hillPaint = Paint()
      ..color = track
          ? const Color(0xFF87B9A0)
          : highway
              ? const Color(0xFF71B889)
              : const Color(0xFF9CCB9B);
    final hillShift = offset * .12 % 100;
    for (var x = -110.0 - hillShift; x < w + 100; x += 100) {
      canvas.drawOval(
        Rect.fromLTWH(x, h * .34, 140, h * .35),
        hillPaint,
      );
    }

    if (track) {
      _drawGrandstand(canvas, size);
    } else {
      _drawBuildings(canvas, size, offset, highway: highway);
    }
    _drawTrees(canvas, size, offset, highway: highway);
    _drawRailing(canvas, size, offset, track: track, highway: highway);
    _drawRoad(canvas, size, offset, track: track);
  }

  void _drawBuildings(Canvas canvas, Size size, double shift,
      {required bool highway}) {
    final w = size.width;
    final h = size.height;
    final colors = highway
        ? const [Color(0xFF789C83), Color(0xFF91AD8E), Color(0xFF668D78)]
        : const [Color(0xFF7299B6), Color(0xFF89A9C0), Color(0xFF6388A6)];
    var x = -(shift * .22 % 48) - 40.0;
    var i = 0;
    while (x < w + 50) {
      final buildingW = highway ? 24.0 + (i % 3) * 5 : 24.0 + (i % 4) * 7;
      final buildingH = highway ? 17.0 + (i % 3) * 5 : 23.0 + (i % 5) * 6;
      final top = h * .55 - buildingH;
      final rect = Rect.fromLTWH(x, top, buildingW, buildingH);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(2)),
        Paint()..color = colors[i % colors.length],
      );
      if (!highway) {
        final window = Paint()
          ..color = const Color(0xFFFFE8A3).withValues(alpha: .8);
        for (var wx = x + 5.0; wx < x + buildingW - 3; wx += 9) {
          for (var wy = top + 5; wy < h * .54; wy += 10) {
            canvas.drawRect(Rect.fromLTWH(wx, wy, 3, 4), window);
          }
        }
      }
      x += buildingW + (highway ? 18 : 7);
      i++;
    }
  }

  void _drawGrandstand(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final stand = Paint()..color = const Color(0xFF718BA8);
    final seats = Paint()..color = const Color(0xFFB4C7DC);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, h * .27, w, h * .3),
        const Radius.circular(4),
      ),
      stand,
    );
    for (var row = 0; row < 3; row++) {
      final y = h * (.32 + row * .075);
      canvas.drawLine(Offset(0, y), Offset(w, y), seats..strokeWidth = 2);
      for (var x = 8.0 + row * 13; x < w; x += 38) {
        canvas.drawCircle(Offset(x, y - 4), 2.5, seats);
      }
    }
    // Color panels make the stadium stand read clearly at phone scale.
    for (var i = 0; i < 5; i++) {
      final color =
          i.isEven ? const Color(0xFFE8F3FF) : const Color(0xFFDA5C58);
      canvas.drawRect(
        Rect.fromLTWH(i * (w / 5), h * .52, w / 5 - 2, h * .04),
        Paint()..color = color,
      );
    }
  }

  void _drawTrees(Canvas canvas, Size size, double shift,
      {required bool highway}) {
    final h = size.height;
    final spacing = highway ? 52.0 : 76.0;
    final scroll = shift * (highway ? .35 : .2) % spacing;
    for (var x = -spacing - scroll; x < size.width + spacing; x += spacing) {
      final treeY = h * (highway ? .52 : .55);
      final trunk = Paint()..color = const Color(0xFF78553D);
      final leaves = Paint()
        ..color = highway ? const Color(0xFF39855B) : const Color(0xFF3F9862);
      canvas.drawRect(Rect.fromLTWH(x - 2, treeY - 1, 4, h * .1), trunk);
      canvas.drawCircle(Offset(x, treeY - 7), highway ? 9 : 8, leaves);
      canvas.drawCircle(Offset(x - 6, treeY - 3), 6, leaves);
      canvas.drawCircle(Offset(x + 6, treeY - 3), 6, leaves);
    }
  }

  void _drawRailing(Canvas canvas, Size size, double shift,
      {required bool track, required bool highway}) {
    final y = size.height * .62;
    final railColor = track
        ? const Color(0xFFF6F8FC)
        : highway
            ? const Color(0xFFD7E3E7)
            : const Color(0xFFE8F2F7);
    final rail = Paint()
      ..color = railColor
      ..strokeWidth = 2.5;
    final post = Paint()
      ..color = track ? const Color(0xFF536A85) : const Color(0xFF8B9FAA)
      ..strokeWidth = 2;
    canvas.drawLine(Offset.zero.translate(0, y), Offset(size.width, y), rail);
    canvas.drawLine(
        Offset(0, y + 6), Offset(size.width, y + 6), rail..strokeWidth = 1.5);
    final spacing = 26.0;
    final start = -(shift * .7 % spacing);
    for (var x = start; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, y - 2), Offset(x, y + 11), post);
    }
  }

  void _drawRoad(Canvas canvas, Size size, double shift,
      {required bool track}) {
    final h = size.height;
    final top = h * .69;
    canvas.drawRect(
      Rect.fromLTWH(0, top, size.width, h - top),
      Paint()
        ..color = track ? const Color(0xFF414954) : const Color(0xFF394553),
    );
    canvas.drawRect(
      Rect.fromLTWH(0, top, size.width, 3),
      Paint()
        ..color = track ? const Color(0xFFF5F7FA) : const Color(0xFFF3D77B),
    );
    final dash = Paint()
      ..color = Colors.white.withValues(alpha: .9)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    final dashShift = shift % 52;
    for (var x = -dashShift; x < size.width; x += 52) {
      canvas.drawLine(Offset(x, h * .9), Offset(x + 22, h * .9), dash);
    }
  }

  @override
  bool shouldRepaint(_EnvironmentLanePainter oldDelegate) =>
      oldDelegate.environment != environment || oldDelegate.offset != offset;
}

String _vehicleTl(String vehicle) =>
    const {
      'Car': 'Kotse',
      'Bus': 'Bus',
      'Bicycle': 'Bisikleta',
      'Train': 'Tren',
      'Airplane': 'Eroplano',
    }[vehicle] ??
    vehicle;

String _environmentTl(String environment) =>
    const {
      'City': 'Lungsod',
      'Highway': 'Highway',
      'Track': 'Pista',
    }[environment] ??
    environment;

String _situationTl(String situation) =>
    const {
      'City Road': 'Kalsada sa lungsod',
      'Highway': 'Highway',
      'Airport': 'Paliparan',
      'Bicycle Lane': 'Daan ng bisikleta',
    }[situation] ??
    situation;
